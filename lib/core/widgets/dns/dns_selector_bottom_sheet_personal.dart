import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/extention_sized.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/models/dns_model.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/dns/add_dns_text_field.dart';
import 'package:netshift/core/widgets/common/custom_button.dart';
import 'package:netshift/core/widgets/dns/delete_dns_alert_dialog.dart';
import 'package:netshift/core/widgets/common/dis.dart';
import 'package:netshift/core/widgets/dns/dns_list_item_personal.dart';

class DNSSelectorBottomSheetPersonal extends StatelessWidget {
  DNSSelectorBottomSheetPersonal({super.key});
  final TextEditingController dnsNameController = TextEditingController();
  final TextEditingController primaryDnsController = TextEditingController();
  final TextEditingController secondaryDnsController = TextEditingController();
  final NetshiftEngineController netshiftEngineController = Get.find();
  final SingleDnsPingController dnsPingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dis(
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.7,
        minChildSize: 0.3,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.dnsSelectorSheetPersonal,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                _DnsSelectorHeader(onClose: () => Navigator.pop(context)),
                Expanded(
                  child: Obx(
                    () => netshiftEngineController.dnsListPersonal.isNotEmpty
                        ? ListView.builder(
                            controller: scrollController,
                            itemCount:
                                netshiftEngineController.dnsListPersonal.length,
                            itemBuilder: (context, index) {
                              final dns = netshiftEngineController
                                  .dnsListPersonal[index];
                              return DnsListItemPersonal(
                                dns: dns,
                                onTap: () {
                                  netshiftEngineController.selectedDns.value =
                                      dns;
                                  dnsPingController.pingPrimaryDns();
                                  dnsPingController.pingSecondaryDns();
                                  netshiftEngineController
                                      .saveSelectedDnsValue();
                                  Navigator.pop(context);
                                },
                                onEdit: () =>
                                    _showEditDnsBottomSheet(context, dns),
                                onDelete: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => DeleteDNSAlertDialog(
                                      netshiftEngineController:
                                          netshiftEngineController,
                                      dns: dns,
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : const _EmptyDnsState(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDnsBottomSheet(BuildContext context, DnsModel dns) {
    dnsNameController.text = dns.name;
    primaryDnsController.text = dns.primaryDNS;
    secondaryDnsController.text = dns.secondaryDNS;
    showModalBottomSheet(
      context: context,
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        reverseDuration: const Duration(milliseconds: 300),
        reverseCurve: Curves.fastOutSlowIn,
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: double.infinity,
            height: ScreenSize.height * 0.4,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AddDNSTextField(
                  label: "DNS Name",
                  suffixIcon: const Icon(Icons.data_object_sharp),
                  controller: dnsNameController,
                ),
                AddDNSTextField(
                  label: "Primary DNS",
                  suffixIcon: const Icon(Icons.dns_outlined),
                  controller: primaryDnsController,
                ),
                AddDNSTextField(
                  label: "Secondary DNS",
                  suffixIcon: const Icon(Icons.dns_outlined),
                  controller: secondaryDnsController,
                ),
                CustomButton(
                  text: "Edit DNS",
                  onTap: () {
                    netshiftEngineController.editDns(
                      dns,
                      dnsNameController.text,
                      primaryDnsController.text,
                      secondaryDnsController.text,
                    );
                    dnsPingController.pingPrimaryDns();
                    dnsPingController.pingSecondaryDns();
                    netshiftEngineController.savePersonalDns();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DnsSelectorHeader extends StatelessWidget {
  const _DnsSelectorHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select DNS',
            style: TextStyle(
              color: AppColors.dnsSelectorSheetPersonalAppBarText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close,
              color: AppColors.dnsSelectorSheetPersonalCloseIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDnsState extends StatelessWidget {
  const _EmptyDnsState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.svg.trash, height: ScreenSize.height * 0.3),
        12.height,
        Text(
          "No DNS Added Yet!",
          style: TextStyle(
            color: AppColors.dnsSelectorSheetPersonalNoDnsAddedText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

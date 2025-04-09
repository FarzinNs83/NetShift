import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netshift/core/resources/media_query_size.dart';
import 'package:netshift/controller/netshift_engine_controller.dart';
import 'package:netshift/controller/single_dns_ping_controller.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/add_dns_text_field.dart';
import 'package:netshift/core/widgets/custom_button.dart';

class AddDnsBottomSheet extends StatefulWidget {
  const AddDnsBottomSheet({super.key});

  @override
  State<AddDnsBottomSheet> createState() => _AddDnsBottomSheetState();
}

class _AddDnsBottomSheetState extends State<AddDnsBottomSheet> {
  final TextEditingController dnsNameController = TextEditingController();

  final TextEditingController primaryDnsController = TextEditingController();

  final TextEditingController secondaryDnsController = TextEditingController();

  NetshiftEngineController netshiftEngineController =
      Get.put(NetshiftEngineController());
  SingleDnsPingController dnsPingController = Get.put(SingleDnsPingController());

  @override
  void dispose() {
    dnsNameController.dispose();
    primaryDnsController.dispose();
    secondaryDnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        width: double.infinity,
        height: ScreenSize.height * 0.4,
        decoration: BoxDecoration(
          color:
              AppColors.dnsSelectionCustomFloatingAddDnsActionButtonBackground,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AddDNSTextField(
              label: "DNS Name",
              suffixIcon: const Icon(
                Icons.data_object_sharp,
              ),
              controller: dnsNameController,
            ),
            AddDNSTextField(
              label: "Primary DNS",
              suffixIcon: const Icon(
                Icons.dns_outlined,
              ),
              controller: primaryDnsController,
            ),
            AddDNSTextField(
              label: "Secondary DNS",
              suffixIcon: const Icon(
                Icons.dns_outlined,
              ),
              controller: secondaryDnsController,
            ),
            CustomButton(
              text: "Add DNS",
              onTap: () {
                netshiftEngineController.addDNS(
                  dnsNameController.text,
                  primaryDnsController.text,
                  secondaryDnsController.text,
                );
                netshiftEngineController.savePersonalDns();
                dnsPingController.pingPrimaryDns();
                dnsPingController.pingSecondaryDns();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netshift/gen/assets.gen.dart';
import 'package:netshift/core/resources/app_colors.dart';
import 'package:netshift/core/widgets/common/app_bar.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: "NetShift",
      fontFamily: 'Calistoga',
      fontSize: 24,
      fontWeight: FontWeight.w600,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            onPressed: () {},
            style: ButtonStyle(
              side: const WidgetStatePropertyAll(BorderSide.none),
              backgroundColor: WidgetStatePropertyAll(AppColors.iconAppBar),
            ),
            child: SvgPicture.asset(Assets.svg.crown),
          ),
        ),
      ],
    );
  }
}

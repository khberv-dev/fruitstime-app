import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';

class BubbleIcon extends StatelessWidget {
  final Color color;
  final String iconPath;

  const BubbleIcon({super.key, required this.color, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Container(
        width: 128,
        height: 128,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withAlpha(80),
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 48,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }
}

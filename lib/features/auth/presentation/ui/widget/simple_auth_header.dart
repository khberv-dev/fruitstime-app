import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleAuthHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackClick;

  const SimpleAuthHeader({super.key, required this.title, required this.onBackClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: onBackClick, icon: SvgPicture.asset('assets/icons/arrow_left.svg')),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
          ),
          SizedBox(),
        ],
      ),
    );
  }
}

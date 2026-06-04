import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddCartButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddCartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        'assets/icons/cart.svg',
        width: 20,
        colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
      ),
      style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
    );
  }
}

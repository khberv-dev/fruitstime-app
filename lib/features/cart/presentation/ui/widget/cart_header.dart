import 'package:flutter/material.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Savat",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

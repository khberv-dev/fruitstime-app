import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';

class GotoCartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GotoCartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        fixedSize: Size(148, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.round)),
      ),
      child: Text("Savatga o'tish"),
    );
  }
}

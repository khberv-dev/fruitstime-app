import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/domain/entity/user_entity.dart';

class ProfileCard extends StatelessWidget {
  final UserEntity user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadius.round),
          ),
          child: Text(
            user.firstName[0],
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          user.firstName,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../constants/assets_path.dart';

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    super.key,
    this.size,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 60.0,
      height: size ?? 60.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(
            ImagePath.profile,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

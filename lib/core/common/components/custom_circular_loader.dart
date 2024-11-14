import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../config/sizing/sizing_config.dart';
import '../../../config/themes/app_color.dart';

class CustomCircularLoader extends StatelessWidget {
  const CustomCircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: AppColor.accent,
      size: SizingConfig.heightMultiplier * 2.0,
    );
  }
}

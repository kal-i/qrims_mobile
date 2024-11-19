import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../config/themes/app_color.dart';

class QrContainer extends StatelessWidget {
  const QrContainer({super.key, required this.data,});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: 180.0,
      height: 180.0,
      decoration: BoxDecoration(
        // border: Border.all(
        //   color: Theme.of(context).dividerColor,
        //   width: 0.4,
        // ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkPrimary.withOpacity(0.25),
            blurRadius: 4.0,
            spreadRadius: 0.0,
            offset: const Offset(0.0, 4.0),
          )
        ],
        color: Theme.of(context).primaryColor,
      ),
      child: QrImageView(
        data: data,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.circle,
          color: AppColor.darkPrimary,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.circle,
          color: AppColor.darkPrimary,
        ),
      ),
    );
  }
}

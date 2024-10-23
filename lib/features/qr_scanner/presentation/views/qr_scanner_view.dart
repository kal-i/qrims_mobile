import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:dio/dio.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/themes/app_color.dart';


class QrScannerView extends StatefulWidget {
  const QrScannerView({super.key});

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView>
    with WidgetsBindingObserver {
  late final MobileScannerController _controller;
  StreamSubscription<Object?>? _subscription;

  final ValueNotifier<String?> _encryptedId = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
    );

    // add lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // listen to barcode events
    _subscription = _controller.barcodes.listen(_handleBarcode);

    // start the scanner
    unawaited(_controller.start());
  }

  void _handleBarcode(BarcodeCapture capture) async {
    final encryptedId = capture.barcodes.first.rawValue;

    print(capture.barcodes.first.rawValue);
    final response = await Dio().get('http://192.168.1.8:8080/items/encrypted_id/$encryptedId');
  }

  void _fetchEncryptedIdInformation() {
    if (_encryptedId.value != null && _encryptedId.value!.isNotEmpty) {
      //context.go();
    }
    //final response = await Dio().get('http://192.168.1.8:8080/items/encrypted_id/$encryptedId');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!_controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = _controller.barcodes.listen(_handleBarcode);

        unawaited(_controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(_controller.stop());
    }
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    // Finally, dispose of the controller.
    await _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _overlayWindow(),
    );
  }

  Widget _overlayWindow() {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 250.0,
      height: 250.0,
    );

    return Stack(
      children: [
        // blur
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Theme.of(context)
                  .primaryColor
                  .withOpacity(.1), // Optional semi-transparent overlay
            ),
          ),
        ),

        // Layer 3: Centered scanner window with no blur
        Center(
          child: Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                fit: BoxFit.contain,
                controller: _controller,
                scanWindow: scanWindow,
              ),
              ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, value, child) {
                  if (!value.isInitialized ||
                      !value.isRunning ||
                      value.error != null) {
                    return const SizedBox();
                  }

                  return CustomPaint(
                    painter: ScannerOverlay(scanWindow: scanWindow),
                  );
                },
              ),
            ],
          ),
        ),

        // Layer 4: Header with back button and flash toggle
        Positioned(
          top: 70,
          left: 10,
          right: 10,
          child: _headerActionsRow(),
        ),

        // Layer 5: Bottom product information display (after scanning)
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: _scannedQrDataContainer(),
        ),
      ],
    );
  }

  Widget _headerActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const BackButton(),
        IconButton(
          onPressed: _controller.toggleTorch,
          icon: const Icon(
            HugeIcons.strokeRoundedFlash,
            size: 24.0,
          ),
        ),
      ],
    );
  }

  Widget _scannedQrDataContainer() {
    return Container(
      padding: EdgeInsets.all(10.0),
      height: 80.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppColor.lightBackground,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _encryptedId,
                      builder: (context, encryptedId, child) {
                        return Text(encryptedId ?? '');
                      }
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedDelete01,
                        size: 20.0,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5.0), child: Text('|'),),
                      // const SizedBox(
                      //   width: 10.0,
                      //   child: Text('|'),
                      // ),
                      Icon(
                        HugeIcons.strokeRoundedCopy01,
                        size: 20.0,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
              padding: EdgeInsets.all(5.0),
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppColor.darkPrimary,
              ),
              child: Icon(
                HugeIcons.strokeRoundedSent,
                size: 32.0,
              ),),
        ],
      ),
    );
  }

  Widget _scanner() {
    return MobileScanner(
      controller: _controller,
      onDetect: _handleBarcode,
    );
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'repo.dart';
import 'resources.dart';


class QRViewRead extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewReadState();
}

class _QRViewReadState extends State<QRViewRead> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    controller?.pauseCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (result != null)
                Text(saveTempResult(result.code.toString()),
                     softWrap: true,
                     maxLines: 5
                )
              else
                Text(Strings.readQR),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      child: FutureBuilder(
                        future: controller?.getFlashStatus(),
                        builder: (context, snapshot) {
                          return Text('Вспышка: ${flashStatus(snapshot.data)}');
                        },
                      )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller?.flipCamera();
                        setState(() {});
                      },
                      child: FutureBuilder(
                        future: controller?.getCameraInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Text(
                             'Камера: ${describeEnum(snapshot.data)}');
                          } else {
                            return Text(Strings.loading);
                          }
                        },
                      )
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      SnackBar(content: Text(Strings.noPermission));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  String saveTempResult(String code) {
    final repo = QRepo();
    repo.setUrlCode(code);
    return code;
  }
}

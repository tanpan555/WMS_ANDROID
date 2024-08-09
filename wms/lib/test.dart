import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class test extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<test> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  final TextEditingController _textController3 = TextEditingController();
  final TextEditingController _textController4 = TextEditingController();
  final TextEditingController _textController5 = TextEditingController();
  final TextEditingController _textController6 = TextEditingController();
  bool isCameraOpen = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrViewController?.pauseCamera();
    }
    qrViewController?.resumeCamera();
  }

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              if (isCameraOpen)
                Container(
                  width: 200,
                  height: 200,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                )
              else
                Center(
                  child: Text(
                    'กดปุ่มเปิดกล้อง',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Scanned Data',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'test2',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'test3',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'test4',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'test5',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'test6',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCameraOpen = !isCameraOpen;
                    });
                    if (!isCameraOpen && qrViewController != null) {
                      qrViewController!.dispose();
                      qrViewController = null;
                    }
                  },
                  child: Text(isCameraOpen ? 'ปิดกล้อง' : 'เปิดกล้อง'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrViewController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _textController.text = scanData.code ?? '';
      });
    });
  }
}

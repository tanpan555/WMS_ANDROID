import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms/verify.dart';

class testBarcode extends StatefulWidget {
    final String poReceiveNo;
  final String? poPONO;

testBarcode({required this.poReceiveNo, this.poPONO});


  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<testBarcode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  final TextEditingController BarcodeText = TextEditingController();
  final TextEditingController locatorText = TextEditingController();
  final TextEditingController LotNumber = TextEditingController();
  final TextEditingController Quantity = TextEditingController();
  final TextEditingController CurrentLocator = TextEditingController();
  final TextEditingController LOT_QTY = TextEditingController();
  final TextEditingController LOT_UNIT = TextEditingController();
  bool isCameraOpen = false;

  List<dynamic> locatorCodes = [];
  List<dynamic> data = [];
  String? selectedlocatorCode;

  Future<void> fetchlocatorCodes() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/locator'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched data: $jsonData');

        setState(() {
          locatorCodes = jsonData['items'];
          print(locatorCodes);
          if (data.isNotEmpty) {
            selectedlocatorCode = locatorCodes[0]['location_code'];
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> chk_bar() async {
    try {
      // final response = await http.get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/chk_barcode/WM-D01-2408086/2408130310'));
      final response = await http.get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/chk_barcode/${widget.poReceiveNo}/${BarcodeText.text}'));
  print(widget.poReceiveNo);
    print(BarcodeText.text);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          data = jsonData['items'] ?? [];
          LotNumber.text = jsonData['lot_number'] ?? '';
        Quantity.text = jsonData['quantity'] ?? '';
        CurrentLocator.text = jsonData['curr_loc'] ?? '';
        LOT_QTY.text = jsonData['bal_qty'] ?? '';
        LOT_QTY.text = jsonData['bal_lot'] ?? '';
        print(response.statusCode);
        print(responseBody);
        print(data);

        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

   Future<void> chk_loc() async {
    try {
      final response = await http.get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/chk_loc/${widget.poReceiveNo}/${BarcodeText.text}/$selectedlocatorCode'));
  print(widget.poReceiveNo);
    print(BarcodeText);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          data = jsonData['items'] ?? [];
        print(response.statusCode);
        print(responseBody);
        print(data);

        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  fetchlocatorCodes();
  }


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
  BarcodeText.dispose();
  locatorText.dispose();
  LotNumber.dispose();
  Quantity.dispose();
  CurrentLocator.dispose();
  LOT_QTY.dispose();
  LOT_UNIT.dispose();
  super.dispose();
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Barcode Page'),
    ),
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
                  controller: BarcodeText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'BarcodeText',
                  ),
                ),
              ),
              Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedlocatorCode,
                        hint: Text('select locator'),
                        items: locatorCodes.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['location_code'],
                            child: Text(item['location_code'] ?? 'No code'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedlocatorCode = value;
                             print(selectedlocatorCode);
                             chk_loc();
                          });
                        },
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: LotNumber,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'LotNumber',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: Quantity,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quantity',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: CurrentLocator,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CurrentLocator',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: LOT_QTY,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'LOT_QTY',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: LOT_UNIT,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'LOT_UNIT',
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
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.poReceiveNo),
              ),
               Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.poPONO ?? 'No PO PONO provided'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
        onPressed: () {
          chk_bar();
          Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Verify(poReceiveNo: widget.poReceiveNo, poPONO: widget.poPONO),
      ),
    );

        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: Text(
          'NEXT',
          style: TextStyle(color: Colors.white),
        ),
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
        BarcodeText.text = scanData.code ?? '';
      });
    });
  }
}

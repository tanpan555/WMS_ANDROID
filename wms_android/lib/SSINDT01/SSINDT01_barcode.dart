import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/custom_appbar.dart';
// import 'package:wms_android/custom_drawer.dart';
import 'SSINDT01_verify.dart';

class Ssindt01Barcode extends StatefulWidget {
  final String poReceiveNo;
  final String? poPONO;

  Ssindt01Barcode({required this.poReceiveNo, this.poPONO});

  @override
  _Ssindt01BarcodeState createState() => _Ssindt01BarcodeState();
}

class _Ssindt01BarcodeState extends State<Ssindt01Barcode> {
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
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/c/chk_barcode/${widget.poReceiveNo}/${BarcodeText.text}'));
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
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/c/chk_loc/${widget.poReceiveNo}/${BarcodeText.text}/$selectedlocatorCode'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ'), // Use the CustomAppBar
      // drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: Size(10, 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'ย้อนกลับ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 245),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: Size(10, 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Ssindt01Gridconfirm(),
                      //   ),
                      // ); // Code for Next button
                    },
                    child: const Text(
                      'ถัดไป',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: _buildFormFields(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Set desired fraction of screen width
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.yellow[200], // Light yellow background
              border: Border.all(
                  color: Colors.black,
                  width: 2.0), // Black border with width 2.0
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                '${widget.poReceiveNo}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28, // Adjust the font size as needed
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Barcode',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 61, 61, 61),
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 50, // Adjust width and height as needed
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1, // Adjust height for vertical alignment
              ),
              controller: BarcodeText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'BarcodeText',
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Locator',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 61, 61, 61),
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 50, // Adjust width and height as needed
            child: DropdownButtonFormField<String>(
              value: selectedlocatorCode,
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
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Locator',
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          // Additional text fields

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50, // Adjust width and height as needed
            child: TextField(
              controller: LotNumber,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'LotNumber',
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50, // Adjust width and height as needed
            child: TextField(
              controller: Quantity,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity',
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50, // Adjust width and height as needed
            child: TextField(
              controller: CurrentLocator,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CurrentLocator',
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50, // Adjust width and height as needed
            child: TextField(
              controller: LOT_QTY,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'LOT_QTY',
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50, // Adjust width and height as needed
            child: TextField(
              controller: LOT_UNIT,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'LOT_UNIT',
              ),
            ),
          ),
          const SizedBox(height: 16.0),
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
          // const SizedBox(height: 16.0),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(widget.poReceiveNo),
          // ),
          // const SizedBox(height: 16.0),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(widget.poPONO ?? 'No PO PONO provided'),
          // ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                chk_bar();
                //       Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => Verify(poReceiveNo: widget.poReceiveNo, poPONO: widget.poPONO),
                //   ),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'FETCH DATA',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                chk_bar();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Ssindt01Verify(
                        poReceiveNo: widget.poReceiveNo, poPONO: widget.poPONO),
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
    );
  }
}

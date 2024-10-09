import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT04_VERIFY.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wms_android/main.dart';
import '../styles.dart';
import 'package:intl/intl.dart';

class SSFGDT04_SCANBARCODE extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจาก lov
  final String po_doc_no;
  final String po_doc_type;
  final String setqc;

  const SSFGDT04_SCANBARCODE({
    super.key,
    required this.pWareCode,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.setqc,
  });

  @override
  _SSFGDT04_SCANBARCODEState createState() => _SSFGDT04_SCANBARCODEState();
}

class _SSFGDT04_SCANBARCODEState extends State<SSFGDT04_SCANBARCODE> {
  String currentSessionID = '';
  String? selectedLocator;
  List<Map<String, dynamic>> locatorBarcodeItems =
      []; // Replace with your locator values
  List<Map<String, dynamic>> barCodeItems = [];
  TextEditingController _searchController = TextEditingController();
  TextEditingController _locatorBarcodeController = TextEditingController();
  TextEditingController _barCodeCotroller = TextEditingController();
  TextEditingController _lotNumberController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _currLotController = TextEditingController();
  TextEditingController _balLotController = TextEditingController();
  TextEditingController _balQtyController = TextEditingController();

  final NumberFormat numberFormat = NumberFormat('#,###');

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final FocusNode barcodeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
    print('pWareCode: ${widget.pWareCode}');

    print(_locatorBarcodeController.text);
    if (_locatorBarcodeController.text == 'null') {
      _locatorBarcodeController.text = '';
    }
    fetchlocatorItems();
  }

  Future<void> fetchlocatorItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_4_LOCATOR_BARCODE/${gb.P_ERP_OU_CODE}/${gb.P_WARE_CODE}'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      if (mounted) {
        setState(() {
          locatorBarcodeItems =
              List<Map<String, dynamic>>.from(data['items'] ?? []);
        });
      }
    } else {
      throw Exception('Failed to load STAFF_CODE items');
    }
  }

  void _scanQRCode() async {
  await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    ),
  ));
}

void _onQRViewCreated(QRViewController controller) {
  controller.scannedDataStream.listen((scanData) {
    if (mounted) {
      setState(() {
        _barCodeCotroller.text = scanData.code!;
        fetchBarcodeData();
      });
    }
    controller.dispose();
    Navigator.of(context).pop();
  });
}

  String? pBarcode;
  String? lotNumber; // po_lot_number,
  String? quantity; // po_quantity,
  String? currLot; // po_curr_loc,
  String? balLot; // po_bal_lot,
  String? balQty; // po_bal_qty,
  String? po_status; // po_status,
  String? po_message; // po_message

  Future<void> fetchBarcodeData() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_4_scan_validate_NonePObar/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/$pBarcode';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> barCodeItems =
            jsonDecode(utf8.decode(response.bodyBytes));

        print('API Response: $barCodeItems');
        if (mounted) {
          setState(() {
            po_status = barCodeItems['po_status'] ?? '';
            po_message = barCodeItems['po_message'] ?? '';
            _lotNumberController.text = barCodeItems['po_lot_number'] ?? '';
            double quantity =
                double.tryParse(barCodeItems['po_quantity'] ?? '0') ?? 0;
            _quantityController.text = numberFormat.format(quantity);
            _currLotController.text = barCodeItems['po_curr_loc'] ?? '';
            _balLotController.text = barCodeItems['po_bal_lot'] ?? '';
            double balQty =
                double.tryParse(barCodeItems['po_bal_qty'] ?? '0') ?? 0;
            _balQtyController.text = numberFormat.format(balQty);
          });
        }
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? p_dest_location;
  String? poStatus;
  String? poMessage;

  Future<void> scan_INmove_Location(String? lcbarcode) async {
    const url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_4_scan_INmove_location';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_doc_no': widget.po_doc_no,
      'p_barcode': pBarcode,
      'p_dest_location': lcbarcode,
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
    });

    print('headers : $headers');
    print('body : $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            p_dest_location = responseData['p_dest_location'];
            poStatus = responseData['po_status'];
            poMessage = responseData['po_message'];
          });
        }

        // print('po_last_move: $po_last_move');
        print('po_doc_no : ${widget.po_doc_no}');
        print('p_dest_location: $p_dest_location');
        print('po_status : $poStatus');
        print('po_message : $poMessage');

        // ตรวจสอบสถานะ po_status เพื่อแสดง popup หรือเคลียร์ข้อมูลตามที่คุณต้องการ
        if (poStatus == '0') {
          // แสดง popup แจ้งเตือนและเคลียร์ค่าที่หน้าจอ
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.notification_important, // ไอคอนแจ้งเตือน
                      color: Colors.red, // สีแดง
                      size: 30,
                    ),
                    SizedBox(width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
                    Text('แจ้งเตือน'),
                  ],
                ),
                content: Text('Update Locator Complete. $poMessage'),
                actions: [
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text('ตกลง',
                        style: TextStyle(
                          fontSize: 16, // ปรับขนาดตัวหนังสือตามต้องการ
                          color: Colors
                              .black, // สามารถเปลี่ยนสีตัวหนังสือได้ที่นี่
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                      clearScreen(); // ฟังก์ชันสำหรับเคลียร์ค่าที่หน้าจอ
                    },
                  ),
                ],
              );
            },
          );
        } else if (poStatus == '1') {
          // แสดง popup แจ้งเตือนกรณีไม่ผ่าน
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.notification_important, // ไอคอนแจ้งเตือน
                      color: Colors.red, // สีแดง
                      size: 30,
                    ),
                    SizedBox(width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
                    Text('แจ้งเตือน'),
                  ],
                ),
                content: Text('$poMessage'),
                actions: [
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text('ตกลง',
                        style: TextStyle(
                          fontSize: 16, // ปรับขนาดตัวหนังสือตามต้องการ
                          color: Colors
                              .black, // สามารถเปลี่ยนสีตัวหนังสือได้ที่นี่
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void clearScreen() {
    setState(() {
      _barCodeCotroller.clear();
      // ถ้าจำเป็นต้องรีเซ็ต selectedLocator ด้วย
      _locatorBarcodeController.clear();
      selectedLocator = null;
      _searchController.clear();
      _barCodeCotroller.clear();
      _lotNumberController.clear();
      _quantityController.clear();
      _currLotController.clear();
      _balLotController.clear();
      _balQtyController.clear();
    });
    FocusScope.of(context).requestFocus(barcodeFocusNode);
    // เคลียร์ค่าที่จำเป็นในหน้าจออื่นๆ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      // endDrawer:CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SSFGDT04_VERIFY(
                            po_doc_no: widget.po_doc_no, // ส่งค่า po_doc_no
                            po_doc_type:
                                widget.po_doc_type, // ส่งค่า po_doc_type
                            pWareCode: widget.pWareCode,
                            setqc: widget
                                .setqc, // mo_do_no: _moDoNoController.text ?? '',
                          ),
                        ),
                      );
                      // เพิ่มโค้ดสำหรับการทำงานของปุ่มถัดไปที่นี่
                    },
                    style: AppStyles.NextButtonStyle(),
                    child: Image.asset(
                      'assets/images/right.png', // เปลี่ยนเป็นเส้นทางของรูปภาพของคุณ
                      width: 20, // ปรับขนาดตามที่ต้องการ
                      height: 20, // ปรับขนาดตามที่ต้องการ
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
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }

  Widget _buildFormFields() {
    return Container(
      // padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              borderRadius:
                  BorderRadius.circular(8), // Rounded corners (optional)
            ),
            child: Text(
              widget.po_doc_no,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          // Text with background color
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 80),
            decoration: BoxDecoration(
              color: Colors.lightBlue[100], // Background color for the text
              borderRadius:
                  BorderRadius.circular(8), // Rounded corners (optional)
            ),
            child: Text(
              widget.setqc, // Text ที่ต้องการแสดง
              style: const TextStyle(
                color: Colors.black, // Text color
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 5),

          // Barcode //
          Padding(
  padding: const EdgeInsets.symmetric(vertical: 8),
  child: TextField(
    decoration: const InputDecoration(
      labelText: 'Barcode',
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.black),
      border: InputBorder.none,
    ),
    controller: _barCodeCotroller,
    focusNode: barcodeFocusNode, // Attach the focus node
    autofocus: true, // Automatically focus on the TextField when the screen loads.
    onSubmitted: (value) async {
      setState(() {
        pBarcode = value; // Assign the entered barcode to pBarcode
      });

      await fetchBarcodeData(); // Wait for the data fetching process

      if (po_status == '1') {
        // Show a popup if the status is '1'
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.notification_important,
                    color: Colors.red,
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text('แจ้งเตือน'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$po_message'),
                ],
              ),
              actions: [
                TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: Text(
                    'ตกลง',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    },
  ),
),

          // const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            height: 300, // Adjust the height as needed
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Locator',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close popup
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Search Field
                                TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'ค้นหา...',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (query) {
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: locatorBarcodeItems
                                            .where((item) {
                                              final lcbarcodeString =
                                                  item['lcbarcode'].toString();
                                              final locationCode =
                                                  item['location_code']
                                                      .toString();
                                              final locationName =
                                                  item['location_name']
                                                      .toString();
                                              final searchQuery =
                                                  _searchController.text.trim();
                                              final searchQueryInt =
                                                  int.tryParse(searchQuery);
                                              final lcbarcodeInt =
                                                  int.tryParse(lcbarcodeString);

                                              return (searchQueryInt != null &&
                                                      lcbarcodeInt != null &&
                                                      lcbarcodeInt ==
                                                          searchQueryInt) ||
                                                  lcbarcodeString
                                                      .contains(searchQuery) ||
                                                  locationCode
                                                      .contains(searchQuery) ||
                                                  locationName
                                                      .contains(searchQuery);
                                            })
                                            .toList()
                                            .length +
                                        1, // +1 for the "-- No Value Set --" option
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        // Add the special case for "-- No Value Set --"
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: const Text(
                                            '-- No Value Set --',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selectedLocator !=
                                                  null; // Set to null
                                              _locatorBarcodeController.clear();
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      }

                                      // Filter and display other locator items
                                      final filteredItems =
                                          locatorBarcodeItems.where((item) {
                                        final lcbarcodeString =
                                            item['lcbarcode'].toString();
                                        final locationCode =
                                            item['location_code'].toString();
                                        final locationName =
                                            item['location_name'].toString();
                                        final searchQuery =
                                            _searchController.text.trim();
                                        final searchQueryInt =
                                            int.tryParse(searchQuery);
                                        final lcbarcodeInt =
                                            int.tryParse(lcbarcodeString);

                                        return (searchQueryInt != null &&
                                                lcbarcodeInt != null &&
                                                lcbarcodeInt ==
                                                    searchQueryInt) ||
                                            lcbarcodeString
                                                .contains(searchQuery) ||
                                            locationCode
                                                .contains(searchQuery) ||
                                            locationName.contains(searchQuery);
                                      }).toList();

                                      final item = filteredItems[index -
                                          1]; // Adjust index due to added option
                                      final lcbarcode =
                                          item['lcbarcode'].toString();
                                      final locationCode =
                                          item['location_code'].toString();
                                      final locationName =
                                          item['location_name'].toString();

                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '$lcbarcode\n',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '$locationCode $locationName',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedLocator = lcbarcode;
                                            _locatorBarcodeController.text =
                                                lcbarcode;
                                            fetchlocatorItems();
                                            // Call the API after setting the selected locator
                                          });
                                          Navigator.of(context).pop();
                                          scan_INmove_Location(lcbarcode);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Locator',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 113, 113, 113),
                    ),
                  ),
                  controller: _locatorBarcodeController.text.isNotEmpty
                      ? _locatorBarcodeController
                      : TextEditingController(
                          text: selectedLocator ?? '-- No Value Set --'),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Lot Number //
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: AbsorbPointer(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Lot Number',
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: const TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                controller: _lotNumberController,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          //Quantity//
          // if (pBarcode != null && pBarcode!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: AbsorbPointer(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: const TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                controller: _quantityController,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          //Current Locator//
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: AbsorbPointer(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Current Locator',
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelStyle: const TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                controller: _currLotController,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          //จำนวนล็อต/รายการรอจัดเก็บ//
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: AbsorbPointer(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'จำนวนล็อต/รายการรอจัดเก็บ',
                  filled: true,
                  fillColor: Colors.yellow[200],
                  labelStyle: const TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                controller: _balLotController,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          //จำนวน (หน่วยสต๊อก) รอจัดเก็บ//
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: AbsorbPointer(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'จำนวน (หน่วยสต๊อก) รอจัดเก็บ',
                  filled: true,
                  fillColor: Colors.yellow[200],
                  labelStyle: const TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                controller: _balQtyController,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

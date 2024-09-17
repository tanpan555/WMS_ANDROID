import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT04_SCREEN_5.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wms_android/main.dart';

class SSFGDT04_SCANBARCODE extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจาก lov
  final String po_doc_no;
  final String po_doc_type;
  final String setqc;

  SSFGDT04_SCANBARCODE({
    Key? key,
    required this.pWareCode,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.setqc,
  }) : super(key: key);

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

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // เพิ่ม Controller สำหรับการค้นหา

  // @override
  // void initState() {
  //   super.initState();
  //   fetchlocatorItems();
  // }
  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
    print('BARCODE  =============================');
    print('pWareCode: ${widget.pWareCode}');
    print('$pBarcode');

    print(_locatorBarcodeController.text);
    if (_locatorBarcodeController.text == 'null') {
      _locatorBarcodeController.text = '';
    }
    fetchlocatorItems();

    // print(widget.selectedwhCode);
  }

  Future<void> fetchlocatorItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_4_LOCATOR_BARCODE/${gb.P_ERP_OU_CODE}/${gb.P_WARE_CODE}'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      setState(() {
        locatorBarcodeItems =
            List<Map<String, dynamic>>.from(data['items'] ?? []);
      });
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
      setState(() {
        _barCodeCotroller.text = scanData.code!;
        fetchBarcodeData();
      });
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
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_4_scan_validate_NonePObar/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/$pBarcode'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> barCodeItems =
          jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        po_status = barCodeItems['po_status'];
        po_message = barCodeItems['po_message'];
        _lotNumberController.text = barCodeItems['po_lot_number'] ?? '';
        _quantityController.text = barCodeItems['po_quantity'] ?? '';
        _currLotController.text = barCodeItems['po_curr_loc'] ?? '';
        _balLotController.text = barCodeItems['po_bal_lot'] ?? '';
        _balQtyController.text = barCodeItems['po_bal_qty'] ?? '';
      });
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  String? po_doc_no;
  // String? p_barcode;
  String? p_dest_location;

  // Future<void> scan_INmove_Location() async {
  //   final url =
  //       'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_4_scan_INmove_location';

  //   final headers = {
  //     'Content-Type': 'application/json',
  //   };
  //   print(po_doc_no);
  //   print(gb.P_OU_CODE);
  //   print(gb.P_ERP_OU_CODE);
  //   print(gb.APP_SESSION);
  //   print(gb.APP_USER);

  //   final body = jsonEncode({
  //     'p_doc_no': po_doc_no,
  //     'p_barcode': pBarcode,
  //     'p_dest_location': p_dest_location,
  //     'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
  //   });

  //   print('headers : $headers Type : ${headers.runtimeType}');
  //   print('body : $body Type : ${body.runtimeType}');

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: body,
  //     );

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = jsonDecode(response.body);
  //       setState(() {
  //         po_doc_no = responseData['po_doc_no'];
  //         // po_doc_type = responseData['po_doc_type'];
  //         po_status = responseData['po_status'];
  //         po_message = responseData['po_message'];

  //         print('po_doc_no : $po_doc_no Type : ${po_doc_no.runtimeType}');
  //         // print('po_doc_type : $po_doc_type Type : ${po_doc_type.runtimeType}');
  //         print('poStatus : $po_status Type : ${po_status.runtimeType}');
  //         print('poMessage : $po_message Type : ${po_message.runtimeType}');
  //       });
  //     } else {
  //       print('Failed to post data. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
  String? poMessage;

  Future<void> scan_INmove_Location() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_4_scan_INmove_location';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_doc_no': po_doc_no,
      'p_barcode': pBarcode,
      'p_dest_location': p_dest_location,
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
        setState(() {
          po_doc_no = responseData['po_doc_no'];
          po_status = responseData['po_status'];
          poMessage = responseData['po_message'];
        });

        print('po_doc_no : $po_doc_no');
        print('po_status : $po_status');
        print('po_message : $poMessage');

        // ตรวจสอบสถานะ po_status เพื่อแสดง popup หรือเคลียร์ข้อมูลตามที่คุณต้องการ
        if (po_status == 0) {
          // แสดง popup แจ้งเตือนและเคลียร์ค่าที่หน้าจอ
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('$poMessage'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      clearScreen(); // ฟังก์ชันสำหรับเคลียร์ค่าที่หน้าจอ
                    },
                  ),
                ],
              );
            },
          );
        } else if (po_status == 1) {
          // แสดง popup แจ้งเตือนกรณีไม่ผ่าน
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('$poMessage'),
                actions: [
                  TextButton(
                    child: Text('OK'),
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
    _locatorBarcodeController.clear();
    _searchController.clear();
    // เคลียร์ค่าที่จำเป็นในหน้าจออื่นๆ
  }

  // http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_4_scan_INmove_location

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SSFGDT04_Screen_5(
                            po_doc_no: widget.po_doc_no, // ส่งค่า po_doc_no
                            po_doc_type:
                                widget.po_doc_type, // ส่งค่า po_doc_type
                            pWareCode: widget.pWareCode,
                            setqc: widget.setqc,
                            //                 // p_ref_no: _refNoController.text ?? '',
                            //                 // mo_do_no: _moDoNoController.text ?? '',
                          ),
                        ),
                      );
                      // await fetchData();
                      // เพิ่มโค้ดสำหรับการทำงานของปุ่มถัดไปที่นี่
                    },
                    child: Image.asset(
                      'assets/images/right.png', // เปลี่ยนเป็นเส้นทางของรูปภาพของคุณ
                      width: 20, // ปรับขนาดตามที่ต้องการ
                      height: 20, // ปรับขนาดตามที่ต้องการ
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(60, 40),
                      padding: const EdgeInsets.all(0),
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
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _buildFormFields() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              borderRadius:
                  BorderRadius.circular(8), // Rounded corners (optional)
            ),
            child: Text(
              '${widget.po_doc_no}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          SizedBox(height: 10),
          // Text with background color
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 80),
            decoration: BoxDecoration(
              color: Colors.lightBlue[100], // Background color for the text
              borderRadius:
                  BorderRadius.circular(8), // Rounded corners (optional)
            ),
            child: Text(
              '${widget.setqc}', // Text ที่ต้องการแสดง
              style: TextStyle(
                color: Colors.black, // Text color
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 5),

          // Barcode //
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Barcode',
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
              controller: _barCodeCotroller,
              onSubmitted: (value) async {
                setState(() {
                  pBarcode = value; // Assign the entered barcode to pBarcode
                });

                // Wait for the data fetching process to complete
                await fetchBarcodeData();

                // Check the status after fetching the barcode data
                if (po_status == '0') {
                  // Display data as usual
                } else if (po_status == '1') {
                  // Show popup if status is not 0
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('คำเตือน'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(po_message ?? 'No message available'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
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
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                                    Text(
                                      'Locator',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
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
                                  decoration: InputDecoration(
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
                                          title: Text(
                                            '-- No Value Set --',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selectedLocator =
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
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '$locationCode $locationName',
                                                style: TextStyle(
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
                                          scan_INmove_Location();
                                          if (po_status == '0') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  // title: Text('Notice'),
                                                  content: Text('$poMessage'),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        // Clear screen or do other actions
                                                        // _clearScreen();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else if (po_status == '1') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('แจ้งเตือน'),
                                                  content: Text('$poMessage'),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
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
                  decoration: InputDecoration(
                    labelText: 'Locator',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.list,
                      color: Colors.black,
                    ),
                  ),
                  controller: _locatorBarcodeController.text.isNotEmpty
                      ? _locatorBarcodeController
                      : TextEditingController(
                          text: pBarcode != null ? '-- No Value Set --' : ''),
                ),
              ),
            ),
          ),

          // const SizedBox(height: 5),
          // Additional text fields
          // Lot Number //
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Lot Number',
                filled: true,
                fillColor: Colors.grey[300],
                labelStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
              controller: _lotNumberController,
            ),
          ),

          //Quantity//
          if (pBarcode != null && pBarcode!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: po_status == '1'
                  ? SizedBox
                      .shrink() // Do not display anything if po_status is '1'
                  : TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        filled: true,
                        fillColor: Colors.grey[300],
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: TextEditingController(
                        text: _quantityController.text.isNotEmpty
                            ? _quantityController.text
                            : 'NaN',
                      ),
                    ),
            ),

          //Current Locator//
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Current Locator',
                filled: true,
                fillColor: Colors.grey[300],
                labelStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
              controller: _currLotController,
            ),
          ),

          //จำนวนล็อต/รายการรอจัดเก็บ//
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'จำนวนล็อต/รายการรอจัดเก็บ',
                filled: true,
                fillColor: Colors.yellow[200],
                labelStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
              controller: _balLotController,
            ),
          ),

          //จำนวน (หน่วยสต๊อก) รอจัดเก็บ//
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'จำนวน (หน่วยสต๊อก) รอจัดเก็บ',
                filled: true,
                fillColor: Colors.yellow[200],
                labelStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
              controller: _balQtyController,
            ),
          ),
        ],
      ),
    );
  }
}

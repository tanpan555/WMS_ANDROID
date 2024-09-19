import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGD17_VERIFY.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:wms_android/styles.dart';

class SSFGDT17_BARCODE extends StatefulWidget {
  final String po_doc_no;
  final String? po_doc_type;
  final String? LocCode;

  final String? selectedwhCode;
  final String? selectedLocCode;
  final String? whOUTCode;
  final String? LocOUTCode;

  final String? pWareCode;
  final String? pWareName;

  SSFGDT17_BARCODE(
      {required this.po_doc_no,
      this.po_doc_type,
      this.LocCode,
      this.selectedwhCode,
      this.selectedLocCode,
      this.whOUTCode,
      this.LocOUTCode, this.pWareCode, this.pWareName});

  @override
  _SSFGDT17_BARCODEState createState() => _SSFGDT17_BARCODEState();
}

class _SSFGDT17_BARCODEState extends State<SSFGDT17_BARCODE> {
  String currentSessionID = '';

  late final TextEditingController DOC_NO =
      TextEditingController(text: widget.po_doc_no);
  late final TextEditingController BARCODE = TextEditingController();

  late final TextEditingController LOCATOR_FROM =
      TextEditingController(text: widget.LocCode ?? ' ');

  late final TextEditingController ITEM_CODE = TextEditingController();

  late final TextEditingController LOT_NUMBER = TextEditingController();
  late final TextEditingController QUANTITY = TextEditingController();
  late final TextEditingController LOCATOR_TO = TextEditingController();
  late final TextEditingController BAL_LOT = TextEditingController();
  late final TextEditingController BAL_QTY = TextEditingController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final ERP_OU_CODE = gb.P_ERP_OU_CODE;
  final P_OU_CODE = gb.P_OU_CODE;
  final APP_USER = gb.APP_USER;

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
    print('BARCODE  =============================');
    print('pWareCode: ${widget.pWareCode}');
    print('pWareName: ${widget.pWareName}');
    print(widget.LocCode);
    if (widget.LocCode == 'null') {
      LOCATOR_FROM.text = '';
    }
    fetchLocationCodes();

    print(widget.selectedwhCode);
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
        BARCODE.text = scanData.code!;
        fetchBarcodeData();
      });
      controller.dispose();
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    DOC_NO.dispose();
    BARCODE.dispose();
    LOCATOR_FROM.dispose();
    ITEM_CODE.dispose();
    LOT_NUMBER.dispose();
    QUANTITY.dispose();
    LOCATOR_TO.dispose();
    BAL_LOT.dispose();
    BAL_QTY.dispose();
    super.dispose();
  }

  List<dynamic> locCode = [];
  String? selectedLocCode;
  Future<void> fetchLocationCodes() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/LOCATOR_LOV/$ERP_OU_CODE/${widget.selectedwhCode}'));
      print('$ERP_OU_CODE ${widget.selectedwhCode}');

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched Loc data: $jsonData');

        setState(() {
          locCode = jsonData['items'];
          if (locCode.isNotEmpty) {
            selectedLocCode = widget.LocCode;
          }
        });

        for (var item in locCode) {
          print('r value: ${item['r']}');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? p_lot_number;
  String? p_quantity;
  String? p_curr_ware;
  String? p_curr_loc;
  String? p_bal_lot;
  String? p_bal_qty;
  String? p_item_code;
  String? p_control_lot;
  String? po_status;
  String? po_message;

  void fetchBarcodeData() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT17/scan_validate_xferBarcode/'
        '$ERP_OU_CODE/'
        '${widget.po_doc_no}/${BARCODE.text}/${widget.selectedwhCode}/$selectedLocCode/${widget.whOUTCode}/${widget.LocOUTCode}/$APP_USER');

    print('Request URL: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          p_lot_number = data['p_lot_number'];
          p_quantity = data['p_quantity'];
          p_curr_ware = data['p_curr_ware'];
          p_curr_loc = data['p_curr_loc'];
          p_bal_lot = data['p_bal_lot'];
          p_bal_qty = data['p_bal_qty'];
          p_item_code = data['p_item_code'];
          p_control_lot = data['p_control_lot'];
          po_status = data['po_status'];
          po_message = data['po_message'];

          // Update text fields with fetched data
          LOT_NUMBER.text = p_lot_number ?? '';
          QUANTITY.text = p_quantity ?? '';
          LOCATOR_TO.text = p_curr_ware ?? '';
          BAL_LOT.text = p_bal_lot ?? '';
          BAL_QTY.text = p_bal_qty ?? '';
          ITEM_CODE.text = p_item_code ?? '';
        });
      } else {
        print('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showLocatorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เปลี่ยน Locator'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownSearch<Map<String, dynamic>>(
                  items: locCode
                      .map((item) => item as Map<String, dynamic>)
                      .toList(),
                  selectedItem: locCode.isNotEmpty ? locCode.first : null,
                  itemAsString: (item) => item['r'] ?? '',
                  onChanged: (value) {
                    setState(() {
                      selectedLocCode = value?['r'];
                    });
                  },
                  dropdownBuilder: (context, item) {
                    if (item == null) {
                      return Text('เลือก Location ต้นทาง');
                    }
                    return ListTile(
                      title: Text(item['r'] ?? ''),
                      subtitle: Text(item['location_name'] ?? ''),
                    );
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "เลือก Location ต้นทาง",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "ค้นหาตำแหน่ง",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 250,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  LOCATOR_FROM.text = selectedLocCode ?? '';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? poStatus;
  String? poMessage;

  Future<void> chk_validateSave() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/validateSave_confXfer_WMS/${widget.po_doc_no}/${gb.P_ERP_OU_CODE}'));
      print(widget.po_doc_no);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          poStatus = jsonData['po_status'];
          poMessage = jsonData['po_message'];
          print(response.statusCode);
          print(jsonData);
          print(poStatus);
          print(poMessage);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: const CustomAppBar(title: 'Move Locator',),
      body: Column(
        children: [
          const SizedBox(height: 8.0),
          Row(
            children: [
                  const Spacer(),
                  ElevatedButton(
  style: AppStyles.NextButtonStyle(),
  onPressed: () async {
    await chk_validateSave();
    if (poStatus == '0') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SSFGD17_VERIFY(
            po_doc_no: widget.po_doc_no,
            po_doc_type: widget.po_doc_type,
            selectedwhCode: widget.selectedwhCode,
            pWareCode: widget.pWareCode,
            pWareName: widget.pWareName,
          ),
        ),
      );
    }
  },
  child: Image.asset(
    'assets/images/right.png',
    width: 20.0,
    height: 20.0,
  ),
),
                const SizedBox(width: 8.0),
                
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  _buildTextField(DOC_NO, 'เลขที่เอกสาร', readOnly: true),
                  _buildTextField(BARCODE, 'Barcode', readOnly: false),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color.fromARGB(255, 72, 199, 85),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   child: const Text(
                  //     'Submit',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   onPressed: fetchBarcodeData,
                  // ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   child: const Text(
                  //     'Open Camera',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   onPressed: _scanQRCode,
                  // ),
                  _buildTextField(LOCATOR_FROM, 'Locator ต้นทาง',
                      readOnly: true),
                  _buildTextField(ITEM_CODE, 'Item Code', readOnly: true),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'เปลี่ยน',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _showLocatorDialog(context);
                    },
                  ),
                  _buildTextField(LOT_NUMBER, 'Lot Number'),
                  _buildTextField(QUANTITY, 'Quantity'),
                  _buildTextField(LOCATOR_TO, 'Locator ปลายทาง',
                      readOnly: true),
                  _buildYellowTextField(BAL_LOT, 'รวมรายการโอน', readOnly: true),
                  _buildYellowTextField(BAL_QTY, 'รวมจำนวนโอน', readOnly: true),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

    Widget _buildYellowTextField(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: readOnly ? const Color.fromARGB(255, 251,251,123) : Colors.white,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : Colors.white,
          border: InputBorder.none,
        ),
        onChanged: (text) {
    fetchBarcodeData();
  },
      ),
    );
  }
}

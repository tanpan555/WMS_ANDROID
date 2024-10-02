import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGD17_VERIFY.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_BARCODE.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_FORM.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/styles.dart';

class SSFGDT31_BARCODE extends StatefulWidget {
  final String po_doc_no;
  final String po_doc_type;
  final String pWareCode;
  final String v_ref_doc_no;
  final String v_ref_type;

  SSFGDT31_BARCODE({
    Key? key,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.pWareCode,
    required this.v_ref_doc_no,
    required this.v_ref_type,
  }) : super(key: key);

  @override
  _SSFGDT31_BARCODEState createState() => _SSFGDT31_BARCODEState();
}

class _SSFGDT31_BARCODEState extends State<SSFGDT31_BARCODE> {
  late final TextEditingController BARCODE = TextEditingController();
  late final TextEditingController LOC_IN = TextEditingController();
  late final TextEditingController ITEM_CODE = TextEditingController();
  late final TextEditingController LOT_NUMBER = TextEditingController();
  late final TextEditingController Quantity = TextEditingController();
  late final TextEditingController CUR_LOC = TextEditingController();
  late final TextEditingController LOT_QTY = TextEditingController();
  late final TextEditingController LOT_UNIT = TextEditingController();

  String? Barcode;

  @override
  void initState() {
    super.initState();

    // Add a listener to the BARCODE controller to fetch barcode status when it changes
    // BARCODE.addListener(() {
    //   Barcode = BARCODE.text;
    //   print('BARCODE changed: ${BARCODE.text}');
    //   if (Barcode != null && Barcode!.isNotEmpty) {
    //     fetchBarcodeStatus();  // Call fetchBarcodeStatus when BARCODE changes
    //   }
    // });

    print('+++++++++');
    print("po_doc_no: ${widget.po_doc_no}");
    print("po_doc_type: ${widget.po_doc_type}");
    print("v_ref_doc_no: ${widget.v_ref_doc_no}");
    print('v_ref_type: ${widget.v_ref_type}');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    BARCODE.dispose();
    LOC_IN.dispose();
    ITEM_CODE.dispose();
    LOT_NUMBER.dispose();
    Quantity.dispose();
    CUR_LOC.dispose();
    LOT_QTY.dispose();
    LOT_UNIT.dispose();
    super.dispose();
  }

  String? poBarcodeStatus;
  String? poBarcodeMessage;
  String? po_valid;
  String? po_item_code;
  String? po_comb;
  String? po_control_lot;
  String? po_lot_number;
  String? po_quantity;
  String? po_curr_ware;
  String? po_curr_loc;
  String? po_bal_lot;
  String? po_bal_qty;

  Future<void> fetchBarcodeStatus() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/scan_validate_Receive/${widget.po_doc_no}/${BARCODE.text}/${widget.po_doc_type}/${widget.v_ref_doc_no}/${widget.po_doc_no}/${gb.P_ERP_OU_CODE}/${gb.APP_USER}';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          poBarcodeStatus = responseBody['po_status'];
          poBarcodeMessage = responseBody['po_message'];

          po_valid = responseBody['po_valid'];
          po_item_code = responseBody['po_item_code'];
          po_comb = responseBody['po_comb'];
          po_control_lot = responseBody['po_control_lot'];

          po_lot_number = responseBody['po_lot_number'];
          po_quantity = responseBody['po_quantity'];
          po_curr_ware = responseBody['po_curr_ware'];
          po_curr_loc = responseBody['po_curr_loc'];
          po_bal_lot = responseBody['po_bal_lot'];
          po_bal_qty = responseBody['po_bal_qty'];

          ITEM_CODE.text = po_item_code ?? ''; // Item Code
          LOT_NUMBER.text = po_lot_number ?? ''; // Lot Number
          // Quantity.text = po_quantity ?? '';  // Quantity

          CUR_LOC.text = po_curr_loc ?? ''; // Current Locator

          LOT_QTY.text = po_bal_lot ?? ''; // รวมรายการจ่าย
          LOT_UNIT.text = po_bal_qty ?? ''; // รวมจำนวนจ่าย

          print('po_status: $poBarcodeStatus');
          print('po_message: $poBarcodeMessage');
          print('po_item_code: $po_item_code');
          print('po_lot_number: $po_lot_number');
          print('po_quantity: $po_quantity');
          print('po_curr_loc: $po_curr_loc');
          print('po_bal_lot: $po_bal_lot');
          print('po_bal_qty: $po_bal_qty');
          // Cur_loc_code.text = LCBARCODE ?? '';
          get_LCBARCODE();
          // fetchLocCurrStatus();
        });
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      setState(() {
        poBarcodeStatus = 'Error';
        poBarcodeMessage = e.toString();
      });
    }
  }

  String? p_erp_ou_code;
  String? p_doc_no_post;
  String? p_barcode;

  String? p_item_code;
  String? p_lot_no;
  String? p_qty;

  String? p_warehouse;
  String? p_locator;

  String? poStatus;
  String? poMessage;

  Future<void> sendPostRequest() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/receive_addLine_detail';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_doc_no': widget.po_doc_no,
      'p_barcode': BARCODE.text,
      'p_item_code': ITEM_CODE.text,
      'p_lot_no': LOT_NUMBER.text,
      'p_qty': Quantity.text,
      'p_warehouse': LOC_IN.text,
      'p_locator': CUR_LOC.text,
      'p_doc_type': widget.po_doc_type,
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      'APP_USER': gb.APP_USER,
    });

    print('headers : $headers Type : ${headers.runtimeType}');
    print('body : $body Type : ${body.runtimeType}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          p_erp_ou_code = responseData['p_erp_ou_code'];
          p_doc_no_post = responseData['p_doc_no'];
          p_barcode = responseData['p_barcode'];

          p_item_code = responseData['p_item_code'];
          p_lot_no = responseData['p_lot_no'];
          p_qty = responseData['p_qty'];

          p_warehouse = responseData['p_warehouse'];
          p_locator = responseData['p_locator'];

          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];

          print(
              'p_erp_ou_code : $p_erp_ou_code Type : ${p_erp_ou_code.runtimeType}');
          print(
              'p_doc_no_post : $p_doc_no_post Type : ${p_doc_no_post.runtimeType}');
          print('p_barcode : $p_barcode Type : ${p_barcode.runtimeType}');

          print('p_item_code : $p_item_code Type : ${p_item_code.runtimeType}');
          print('p_lot_no : $p_lot_no Type : ${p_lot_no.runtimeType}');
          print('p_qty : $p_qty Type : ${p_qty.runtimeType}');

          print('p_warehouse : $p_warehouse Type : ${p_warehouse.runtimeType}');
          print('p_locator : $p_locator Type : ${p_locator.runtimeType}');

          print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
          print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
        });
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? po_loc_status;
  String? po__loc_message;
  String? ret;
  String? p_doc_no;
  String? p_loc;

  Future<void> fetchLocInStatus() async {
    final locValue = P_LOC.text.isNotEmpty ? P_LOC.text : 'null';
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/xfer_valLoc_from/${widget.po_doc_no}/$locValue/${gb.P_ERP_OU_CODE}/${widget.pWareCode}';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          p_doc_no = responseBody['p_doc_no'];
          p_loc = responseBody['p_loc'];
          po_loc_status = responseBody['po_status'];
          po__loc_message = responseBody['po_message'];
          ret = responseBody['ret'];

          print('p_doc_no: $p_doc_no');
          print('p_loc: $p_loc');
          print('po_loc_status: $po_loc_status');
          print('po__loc_message: $po__loc_message');
          print('ret: $ret');

          if (po_loc_status == '0') {
            LOC_IN.text = ret ?? '';
          }
        });
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      setState(() {
        poBarcodeStatus = 'Error';
        poBarcodeMessage = e.toString();
      });
    }
  }

  String? xfer_status;
  String? xfer_message;

  Future<void> xfer_valOnhand() async {
    final QuantityValue = Quantity.text.isNotEmpty ? Quantity.text : 'null';
    final ITEM_CODEValue = ITEM_CODE.text.isNotEmpty ? ITEM_CODE.text : 'null';
    final LOC_INValue = LOC_IN.text.isNotEmpty ? LOC_IN.text : 'null';
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/xfer_valOnhand/${widget.po_doc_no}/${LOC_INValue}/${ITEM_CODEValue}/${QuantityValue}/${gb.P_ERP_OU_CODE}/${widget.pWareCode}';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          xfer_status = responseBody['po_status'];
          xfer_message = responseBody['po_message'];

          print('xfer_status: $xfer_status');
          print('xfer_message: $xfer_message');
        });
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      setState(() {
        xfer_status = 'Error';
        xfer_message = e.toString();
      });
    }
  }

  String? p_doc_no_curr;
  String? p_loc_curr;
  String? po_loc_status_curr;
  String? po__loc_message_curr;
  String? ret_curr;

  Future<void> fetchLocCurrStatus() async {
    final locValue = Cur_loc_code.text.isNotEmpty ? Cur_loc_code.text : 'null';
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/xfer_valLoc_from/${widget.po_doc_no}/$locValue/${gb.P_ERP_OU_CODE}/${widget.pWareCode}';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          p_doc_no_curr = responseBody['p_doc_no'];
          p_loc_curr = responseBody['p_loc'];
          po_loc_status_curr = responseBody['po_status'];
          po__loc_message_curr = responseBody['po_message'];
          ret_curr = responseBody['ret'];

          print('p_doc_no_curr: $p_doc_no_curr');
          print('p_loc_curr: $p_loc_curr');
          print('po_loc_status_curr: $po_loc_status_curr');
          print('po__loc_message_curr: $po__loc_message_curr');
          print('ret_curr: $ret_curr');

          // if(po_loc_status_curr == '0'){
          CUR_LOC.text = ret_curr ?? '';
          // }
        });
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      setState(() {
        poBarcodeStatus = 'Error';
        poBarcodeMessage = e.toString();
      });
    }
  }

  String? LCBARCODE;

  Future<void> get_LCBARCODE() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/get_LCBARCODE/${gb.P_ERP_OU_CODE}/${CUR_LOC.text}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'] ?? [];
        print(items);

        if (items.isNotEmpty) {
          setState(() {
            // Assign the first item's lcbarcode value to LCBARCODE
            LCBARCODE = items[0]['lcbarcode'] ?? 'null';
            print('LCBARCODE: $LCBARCODE');
          });
        } else {
          print('No items found.');
          setState(() {
            LCBARCODE = '';
          });
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  late final TextEditingController Cur_loc_code =
      TextEditingController(text: LCBARCODE);
  Future<void> _openCurrLocatorDialog() async {
    final BuildContext dialogContext = context;
    showDialog(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Select Locator'),
          content: Container(
            // height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: Cur_loc_code,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Locator ปลายทาง',
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await fetchLocCurrStatus();

                if (po_loc_status_curr == '1') {
                  if (dialogContext.mounted) {
                    showDialog(
                      context: dialogContext,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('คำเตือน'),
                          content: Text('$po__loc_message_curr'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  late final TextEditingController P_LOC = TextEditingController();

  Future<void> _openLocatorDialog() async {
    final BuildContext dialogContext = context;

    showDialog(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Select Locator'),
          content: Container(
            // height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: P_LOC,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Current Locator',
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await fetchLocInStatus();

                if (po_loc_status == '1') {
                  if (dialogContext.mounted) {
                    showDialog(
                      context: dialogContext,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('คำเตือน'),
                          content: Text('$po__loc_message'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Scan รับ'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 4,),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.yellow[200],
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  '${widget.po_doc_no}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildBarcodeTextField(
                    BARCODE,
                    'Barcode',
                    readOnly: false,
                    onSubmitted: (value) {
                      Barcode = value;
                      print('BARCODE changed: $Barcode');
                      if (Barcode != null && Barcode!.isNotEmpty) {
                        fetchBarcodeStatus();
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: _openLocatorDialog,
                    child: AbsorbPointer(
                      child: _buildTextField(LOC_IN, 'Locator รับ',
                          readOnly: false),
                    ),
                  ),
                  _buildTextField(ITEM_CODE, 'Item Code', readOnly: true),
                  _buildTextField(LOT_NUMBER, 'Lot Number', readOnly: false),
                  _buildQuantityTextField(
                    Quantity,
                    'Quantity',
                    readOnly: false,
                    onSubmitted: (value) async {
                      await xfer_valOnhand();
                      if (xfer_status == '0') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('คำเตือน'),
                              content: Text(
                                  'ต้องการยืนยันการสร้างรายการรับ หรือไม่ ?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ยกเลิก'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await sendPostRequest();
                                    if (poStatus == '0') {
                                      Navigator.of(context).pop(true);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('คำเตือน'),
                                            content: Text(poMessage ??
                                                'No message provided'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Text('ยืนยัน'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: _openCurrLocatorDialog,
                    child: AbsorbPointer(
                      child: _buildTextField(CUR_LOC, 'Current Locator',
                          readOnly: false),
                    ),
                  ),
                  _buildTextField(LOT_QTY, 'รวมรายการับ', readOnly: true),
                  _buildTextField(LOT_UNIT, 'รวมจำนวนรับ', readOnly: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _buildBarcodeTextField(TextEditingController controller, String label,
      {bool readOnly = false, void Function(String)? onSubmitted}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : Colors.white,
          border: InputBorder.none,
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }

  Widget _buildQuantityTextField(TextEditingController controller, String label,
      {bool readOnly = false, void Function(String)? onSubmitted}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : Colors.white,
          border: InputBorder.none,
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : Colors.white,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

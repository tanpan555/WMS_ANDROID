import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;

class Ssfgdt09lBarcode extends StatefulWidget {
  final String pWareCode;
  final String pErpOuCode;
  final String pOuCode;
  final String pAttr1;
  final String pAppUser;
  final String pDocNo;
  final String pDocType;
  final String pMoDoNO;
  Ssfgdt09lBarcode({
    required this.pWareCode,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAttr1,
    required this.pAppUser,
    required this.pDocNo,
    required this.pDocType,
    required this.pMoDoNO,
    Key? key,
  }) : super(key: key);
  @override
  _Ssfgdt09lBarcodeState createState() => _Ssfgdt09lBarcodeState();
}

class _Ssfgdt09lBarcodeState extends State<Ssfgdt09lBarcode> {
  String barCode = '';
  String locatorForm = '';
  String itemCode = '';
  String lotNo = '';
  String quantity = '';
  String locatorTo = '';
  String lotQty = '';
  String lotUnit = '';

  String statusFetchDataBarcode = '';
  String messageFetchDataBarcode = '';
  String valIDFetchDataBarcode = '';

  FocusNode _barcodeFocusNode = FocusNode();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController locatorFormController = TextEditingController();
  TextEditingController itemCodeController = TextEditingController();
  TextEditingController lotNoController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController locatorToController = TextEditingController();
  TextEditingController lotQtyController = TextEditingController();
  TextEditingController lotUnitController = TextEditingController();

  @override
  void dispose() {
    _barcodeFocusNode.dispose();
    barcodeController.dispose();
    locatorFormController.dispose();
    itemCodeController.dispose();
    lotNoController.dispose();
    quantityController.dispose();
    lotQtyController.dispose();
    lotUnitController.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  void initState() {
    super.initState();
    // เพิ่ม Listener ให้กับ FocusNode ของ barcodeController
    // เพิ่ม Listener ให้กับ FocusNode ของ barcodeController
    _barcodeFocusNode.addListener(() {
      if (!_barcodeFocusNode.hasFocus) {
        // เมื่อสูญเสียโฟกัสจาก barcodeController ให้ทำการอัปเดตค่า lotNo
        setState(() {
          barCode = barcodeController.text;

          if (barCode.contains(' ')) {
            List<String> parts = barCode.split(' ');
            lotNo = parts.sublist(1).join(' ');
            lotNoController.text = lotNo; // อัปเดตค่าของ lotNoController

            // lotNo.isNotEmpty ? fetchData() : setState(() {});
          } else {
            lotNo = barCode;
            lotNoController.text = lotNo; // อัปเดตค่าของ lotNoController

            //  lotNo.isNotEmpty ? fetchData() : setState(() {});
          }
        });
      }
    });

    // Listener สำหรับ lotNoController เพื่ออัปเดต lotNo ทุกครั้งที่มีการเปลี่ยนแปลง
    lotNoController.addListener(() {
      setState(() {
        lotNo = lotNoController.text; // ใช้ค่าสุดท้ายจาก lotNoController

        //  lotNo.isNotEmpty ? fetchData() : setState(() {});
      });
    });
  }

  Future<void> fetchData() async {
    print('lotNo : $lotNo type : ${lotNo.runtimeType}');
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_3_SubmitData';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_erp_ou_code': widget.pErpOuCode,
      'p_doc_no': widget.pDocNo,
      'p_schid': widget.pMoDoNO,
      'p_lot_no': lotNo,
      'p_app_user': globals.APP_USER,
    });
    print('Request body: $body');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataBarcode = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataBarcode : $dataBarcode type : ${dataBarcode.runtimeType}');
        setState(() {
          statusFetchDataBarcode = dataBarcode['po_status'];
          messageFetchDataBarcode = dataBarcode['po_message'];
          valIDFetchDataBarcode = dataBarcode['po_valid'];

          if (statusFetchDataBarcode == '0') {
            itemCode = dataBarcode['po_item_code'];
            lotNo = dataBarcode['po_lot_number'];
            quantity = dataBarcode['po_quantity'];
            locatorTo = dataBarcode['po_curr_loc'];
            lotQty = dataBarcode['po_bal_lot']; // ====== รวมรายการจ่าย
            lotUnit = dataBarcode['po_bal_qty']; //--- รวมจำนวนจ่าย

            itemCodeController.text = itemCode;
            lotNoController.text = lotNo;
            quantityController.text = quantity;
            locatorToController.text = locatorTo;
            lotQtyController.text = lotQty;
            lotUnitController.text = lotUnit;
          }
          if (statusFetchDataBarcode == '1' || valIDFetchDataBarcode == 'N') {
            messageFetchDataBarcode = dataBarcode['po_item_code'];
            lotNo = dataBarcode['po_lot_number'];
            quantity = dataBarcode['po_quantity'];
            locatorTo = dataBarcode['po_curr_loc'];
            lotQty = dataBarcode['po_bal_lot']; // ====== รวมรายการจ่าย
            lotUnit = dataBarcode['po_bal_qty']; //--- รวมจำนวนจ่าย

            itemCodeController.text = itemCode;
            lotNoController.text = lotNo;
            quantityController.text = quantity;
            locatorToController.text = locatorTo;
            lotQtyController.text = lotQty;
            lotUnitController.text = lotUnit;

            // showDialogconfirm();
          }
          if (statusFetchDataBarcode == '1' || valIDFetchDataBarcode != 'N') {
            showDialogAlertMessage(context, messageFetchDataBarcode);
          }
        });
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'Scan จ่ายสินค้า'),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Column(children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      print('barCode : $barCode Type : ${barCode.runtimeType}');
                      print(
                          'barcodeController : $barcodeController Type : ${barcodeController.runtimeType}');
                      print('lotNo : $lotNo Type : ${lotNo.runtimeType}');
                      print(
                          'lotNoController : $lotNoController Type : ${lotNoController.runtimeType}');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    minimumSize: const Size(10, 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: const Text(
                    'Check DATA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow[200], // พื้นหลังสีเหลืองอ่อน
                      border: Border.all(
                        color: Colors.black, // ขอบสีดำ
                        width: 2.0, // ความกว้างของขอบ 2.0
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0), // เพิ่มมุมโค้งให้กับ Container
                    ),
                    child: Center(
                      child: Text(
                        widget.pDocNo,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // ปรับขนาดตัวอักษรตามที่ต้องการ
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow[200], // พื้นหลังสีเหลืองอ่อน
                      border: Border.all(
                        color: Colors.black, // ขอบสีดำ
                        width: 2.0, // ความกว้างของขอบ 2.0
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0), // เพิ่มมุมโค้งให้กับ Container
                    ),
                    child: Center(
                      child: Text(
                        widget.pMoDoNO,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // ปรับขนาดตัวอักษรตามที่ต้องการ
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: barcodeController,
              focusNode: _barcodeFocusNode,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Barcode',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: locatorFormController,
              readOnly: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Locator ตัดจ่าย',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: itemCodeController,
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[300],
                labelText: 'Item Code',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: lotNoController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Lot Number',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                lotNo.isNotEmpty ? fetchData() : setState(() {});
              },
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Quantity',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      quantity = value;
                    },
                  );
                }),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: locatorToController,
              readOnly: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Current Locator',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: lotQtyController,
              readOnly: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9.]')), // อนุญาตเฉพาะตัวเลขและจุดทศนิยม
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.yellow[200],
                labelText: 'รวมรายการจ่าย',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: lotUnitController,
              readOnly: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9.]')), // อนุญาตเฉพาะตัวเลขและจุดทศนิยม
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.yellow[200],
                labelText: 'รวมจำนวนจ่าย',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------
          ]))),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showDialogAlertMessage(
    BuildContext context,
    String messageDelete,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'แจ้งแตือน',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  Text(
                    messageDelete,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          barCode = '';
                          locatorForm = '';
                          itemCode = '';
                          lotNo = '';
                          quantity = '';
                          locatorTo = '';
                          lotQty = '';
                          lotUnit = '';

                          statusFetchDataBarcode = '';
                          messageFetchDataBarcode = '';
                          valIDFetchDataBarcode = '';

                          barcodeController.clear();
                          locatorFormController.clear();
                          itemCodeController.clear();
                          lotNoController.clear();
                          quantityController.clear();
                          locatorToController.clear();
                          lotQtyController.clear();
                          lotUnitController.clear();

                          FocusScope.of(context)
                              .requestFocus(_barcodeFocusNode);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ย้อนกลับ'),
                      ),
                    ],
                  )
                ])),
          ),
        );
      },
    );
  }

  void showDialogcomfirmMessage(
    BuildContext context,
    String messageDelete,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              // Icon(
              //   Icons.notification_important,
              //   color: Colors.red,
              // ),
              // SizedBox(width: 10),
              Text(
                'แจ้งแตือน',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  const Text(
                    'รายการไม่ตรงกับระบบการจอง ต้องการยืนยัน ?',
                    // style:  TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          barCode = '';
                          locatorForm = '';
                          itemCode = '';
                          lotNo = '';
                          quantity = '';
                          locatorTo = '';
                          lotQty = '';
                          lotUnit = '';

                          statusFetchDataBarcode = '';
                          messageFetchDataBarcode = '';
                          valIDFetchDataBarcode = '';

                          barcodeController.clear();
                          locatorFormController.clear();
                          itemCodeController.clear();
                          lotNoController.clear();
                          quantityController.clear();
                          locatorToController.clear();
                          lotQtyController.clear();
                          lotUnitController.clear();

                          FocusScope.of(context)
                              .requestFocus(_barcodeFocusNode);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ย้อนกลับ'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ยืนยัน'),
                      ),
                    ],
                  )
                ])),
          ),
        );
      },
    );
  }
}

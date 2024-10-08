import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT09L_reason.dart';

class Ssfgdt09lBarcode extends StatefulWidget {
  final String pWareCode;
  final String pErpOuCode;
  final String pOuCode;
  final String pAttr1;
  final String pAppUser;
  final String pDocNo;
  final String pDocType;
  final String pDocDate;
  final String pMoDoNO;
  Ssfgdt09lBarcode({
    required this.pWareCode,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAttr1,
    required this.pAppUser,
    required this.pDocNo,
    required this.pDocType,
    required this.pDocDate,
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

  String locatorFormChk = '';
  String locatorToChk = '';
  String poRet = '';
  String statusChkLocatorForm = '';
  String messageChkLocatorForm = '';

  String statusChkQuantity = '';
  String messageChkQuantity = '';

  String statusSubmitAddline = '';
  String messageSubmitAddline = '';

  bool chkShowDialogcomfirmMessage = false;

  FocusNode _barcodeFocusNode = FocusNode();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController locatorFormController = TextEditingController();
  TextEditingController itemCodeController = TextEditingController();
  TextEditingController lotNoController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController locatorToController = TextEditingController();
  TextEditingController lotQtyController = TextEditingController();
  TextEditingController lotUnitController = TextEditingController();

  TextEditingController locatorFormChkController = TextEditingController();
  TextEditingController locatorToChkController = TextEditingController();

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
    locatorFormChkController.dispose();
    locatorToChkController.dispose();
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_barcodeFocusNode);
    });

    _barcodeFocusNode.addListener(() {
      if (!_barcodeFocusNode.hasFocus) {
        if (mounted) {
          setState(() {
            if (barCode.contains(' ')) {
              List<String> parts = barCode.split(' ');
              lotNo = parts.sublist(1).join(' ');
              lotNoController.text = lotNo;
            } else {
              lotNo = barCode;
              lotNoController.text = lotNo;
            }
          });
        }
      }
    });

    lotNoController.addListener(() {
      if (mounted) {
        setState(() {
          if (barCode != '' && lotNo != '') {
            fetchData();
          }
        });
      }
    });

    quantityController.addListener(() {
      if (mounted) {
        setState(() {
          if (barCode != '' &&
              lotNo != '' &&
              quantity != '' &&
              statusFetchDataBarcode == '0') {
            chkQuantity();
          }
        });
      }
    });
  }

  Future<void> fetchData() async {
    print('lotNo : $lotNo type : ${lotNo.runtimeType}');
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_ScanBarcode';

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
        if (mounted) {
          setState(() {
            statusFetchDataBarcode = dataBarcode['po_status'];
            messageFetchDataBarcode = dataBarcode['po_message'];
            valIDFetchDataBarcode = dataBarcode['po_valid'];
            print(
                'statusFetchDataBarcode : $statusFetchDataBarcode Type : ${statusFetchDataBarcode.runtimeType}');
            print(
                'messageFetchDataBarcode : $messageFetchDataBarcode Type : ${messageFetchDataBarcode.runtimeType}');
            print(
                'valIDFetchDataBarcode : $valIDFetchDataBarcode Type : ${valIDFetchDataBarcode.runtimeType}');
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
            if (statusFetchDataBarcode == '1' && valIDFetchDataBarcode == 'N') {
              changeData(
                dataBarcode['po_item_code'] ?? '',
                dataBarcode['po_lot_number'] ?? '',
                dataBarcode['po_quantity'] ?? '',
                dataBarcode['po_curr_loc'] ?? '',
                dataBarcode['po_bal_lot'] ?? '',
                dataBarcode['po_bal_qty'] ?? '',
              );
              // itemCode = dataBarcode['po_item_code'];
              // lotNo = dataBarcode['po_lot_number'];
              // quantity = dataBarcode['po_quantity'];
              // locatorTo = dataBarcode['po_curr_loc'];
              // lotQty = dataBarcode['po_bal_lot']; // ====== รวมรายการจ่าย
              // lotUnit = dataBarcode['po_bal_qty']; //--- รวมจำนวนจ่าย

              // itemCodeController.text = itemCode;
              // lotNoController.text = lotNo;
              // quantityController.text = quantity;
              // locatorToController.text = locatorTo;
              // lotQtyController.text = lotQty;
              // lotUnitController.text = lotUnit;

              // showDialogcomfirmMessage(context);
            }
            if (statusFetchDataBarcode == '1' && valIDFetchDataBarcode != 'N') {
              if (messageFetchDataBarcode !=
                  'ข้อมูลไม่ถูกต้อง รายการจ่ายซ้ำ !!!') {
                showDialogAlertMessage(context, messageFetchDataBarcode);
              }
            }
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void changeData(
    String poItemCode,
    String poLotNumber,
    String poQuantity,
    String poCurrLoc,
    String poBalLot,
    String poBalQty,
  ) {
    if (mounted) {
      setState(() {
        itemCode = poItemCode;
        lotNo = poLotNumber;
        quantity = poQuantity;
        locatorTo = poCurrLoc;
        lotQty = poBalLot; // ====== รวมรายการจ่าย
        lotUnit = poBalQty; //--- รวมจำนวนจ่าย

        itemCodeController.text = itemCode;
        lotNoController.text = lotNo;
        quantityController.text = quantity;
        locatorToController.text = locatorTo;
        lotQtyController.text = lotQty;
        lotUnitController.text = lotUnit;

        if (chkShowDialogcomfirmMessage == false) {
          showDialogcomfirmMessage();
        }
      });
    }
  }

  Future<void> chkQuantity() async {
    print('pErpOuCode : ${widget.pErpOuCode}');
    print('pDocNo : ${widget.pDocNo}');
    print('pWareCode : ${widget.pWareCode}');
    print('locatorForm : $locatorForm');
    print('itemCode : $itemCode');
    print('lotNo : $lotNo');
    print('quantity : $quantity');
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_ChkQuantity';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'pErpOuCode': widget.pErpOuCode,
      'pDocNo': widget.pDocNo,
      'pWareCode': widget.pWareCode,
      'pFormLocation': locatorForm.isNotEmpty ? locatorForm : 'null',
      'pItemCode': itemCode.isNotEmpty ? itemCode : 'null',
      'pLotNo': lotNo.isNotEmpty ? lotNo : 'null',
      'pNewQty': quantity.isNotEmpty ? quantity : 'null',
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
        final Map<String, dynamic> dataChkQuantity = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print(
            'dataChkQuantity : $dataChkQuantity type : ${dataChkQuantity.runtimeType}');
        if (mounted) {
          setState(() {
            statusChkQuantity = dataChkQuantity['po_status'];
            messageChkQuantity = dataChkQuantity['po_message'];
            print('messageChkQuantity : $messageChkQuantity');
            if (statusChkQuantity == '0') {
              String textMessage =
                  'ต้องการยืนยันการสร้างรายการเบิกจ่าย หรือไม่ ?';
              showDialogcomfirmAddLine(context, textMessage);
            }
            if (statusChkQuantity == '1') {
              showDialogAlert(context, messageChkQuantity);
            }
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> chkLocatorForm(String textInput, String textForm) async {
    print('textInput : $textInput');
    print('textForm : $textForm');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_ChkLocatorForm/${widget.pErpOuCode}/${widget.pWareCode}/${widget.pDocNo}/$textInput'));

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataChkLocatorForm = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print(
            'dataChkLocatorForm : $dataChkLocatorForm type : ${dataChkLocatorForm.runtimeType}');
        if (mounted) {
          setState(() {
            poRet = dataChkLocatorForm['po_ret'];
            statusChkLocatorForm = dataChkLocatorForm['po_status'];
            messageChkLocatorForm = dataChkLocatorForm['po_message'];

            print('poRet : $poRet');
            print('statusChkLocatorForm : $statusChkLocatorForm');
            print('messageChkLocatorForm : $messageChkLocatorForm');

            if (statusChkLocatorForm == '0') {
              if (textForm == 'F') {
                locatorForm = poRet;
                locatorFormController.text = poRet;

                if (locatorForm.isNotEmpty) {
                  Navigator.of(context).pop();
                  locatorFormChk = '';
                  locatorFormChkController.clear();
                }
              }
              if (textForm == 'T') {
                locatorTo = poRet;
                locatorToController.text = poRet;

                if (locatorTo.isNotEmpty) {
                  Navigator.of(context).pop();
                  locatorToChk = '';
                  locatorToChkController.clear();
                }
              }
              // Navigator.of(context).pop();
            }
            if (statusChkLocatorForm == '1') {
              showDialogAlert(context, messageChkLocatorForm);
              locatorFormChk = '';
              locatorToChk = '';
              locatorFormChkController.clear();
              locatorToChkController.clear();
            }
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('ดึงข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> submitAddLine() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_AddLine';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'pErpOuCode': widget.pErpOuCode,
      'pDocNo': widget.pDocNo,
      'pBarcode': barCode,
      'pItemCode': itemCode,
      'pLotNo': lotNo,
      'pQty': quantity,
      'pReason': 'null',
      'pRemark': 'null',
      'pPdLocation': 'null',
      'pReplaceLot': 'null',
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
        final Map<String, dynamic> dataSubmit = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataSubmit : $dataSubmit type : ${dataSubmit.runtimeType}');
        if (mounted) {
          setState(() {
            statusSubmitAddline = dataSubmit['po_status'];
            messageSubmitAddline = dataSubmit['po_message'];

            if (statusSubmitAddline == '0') {
              if (mounted) {
                setState(() {
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

                  FocusScope.of(context).requestFocus(_barcodeFocusNode);
                });
              }
            }
            if (statusSubmitAddline == '1') {
              showDialogAlert(context, messageSubmitAddline);
            }
          });
        }
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
            // const SizedBox(height: 20),
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
              onChanged: (value) {
                barCode = value;
                // if (!_barcodeFocusNode.hasFocus) {
                //   setState(() {
                //     // barCode = barcodeController.text;
                //     if (barCode.contains(' ')) {
                //       List<String> parts = barCode.split(' ');
                //       lotNo = parts.sublist(1).join(' ');
                //       lotNoController.text = lotNo;
                //     } else {
                //       lotNo = barCode;
                //       lotNoController.text = lotNo;
                //     }
                //   });
                // }
              },
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
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: locatorFormController,
              readOnly: true,
              onTap: () => showDialogLocatorForm(context),
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
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            GestureDetector(
              child: AbsorbPointer(
                child: TextFormField(
                  controller: itemCodeController,
                  readOnly: true,
                  minLines: 1,
                  maxLines: 3,
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
              ),
            ),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: lotNoController,
              onChanged: (value) {
                lotNo = value;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Lot Number',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
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

                      if (quantity != '') {
                        chkQuantity();
                      }
                    },
                  );
                }),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: locatorToController,
              readOnly: true,
              onTap: () => showDialogLocatorTo(context),
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
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            GestureDetector(
              child: AbsorbPointer(
                child: TextFormField(
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
              ),
            ),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            GestureDetector(
              child: AbsorbPointer(
                child: TextFormField(
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
              ),
            ),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
          ]))),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showDialogAlertMessage(
    ///เรียกฝช้โดย API chk status barcode
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
                'แจ้งเตือน',
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
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // ปิด popup
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

                          _barcodeFocusNode.requestFocus();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ตกลง'),
                      ),
                    ],
                  )
                ])),
          ),
        );
      },
    );
  }

  void showDialogAlert(
    BuildContext context,
    String messageAlert,
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
                'แจ้งเตือน',
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
                    messageAlert,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ตกลง'),
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
      // BuildContext context,
      // String messageDelete,
      ) {
    print('11111111111111111111111111111111');
    print('pErpOuCode : ${widget.pErpOuCode}');
    print('pDocNo : ${widget.pDocNo}');
    if (chkShowDialogcomfirmMessage == false) {
      chkShowDialogcomfirmMessage = true;
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
                    'แจ้งเตือน',
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
                    ])),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                        chkShowDialogcomfirmMessage = false;
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

                        _barcodeFocusNode.requestFocus();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Ssfgdt09lReason(
                                    pOuCode: widget.pOuCode,
                                    pErpOuCode: widget.pErpOuCode,
                                    pDocNo: widget.pDocNo,
                                    pMoDoNO: widget.pMoDoNO,
                                    pItemCode: itemCode,
                                    pQty: quantity,
                                    pBarcode: barCode,
                                    pLotNo: lotNo,
                                  )),
                        ).then((value) {
                          // เมื่อกลับมาหน้าเดิม เรียก fetchData
                          Navigator.of(context).pop();
                          chkShowDialogcomfirmMessage = false;
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

                          _barcodeFocusNode.requestFocus();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ]);
        },
      );
    }
  }

  void showDialogcomfirmAddLine(
    BuildContext context,
    String textMessage,
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
                  'แจ้งเตือน',
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
                      textMessage,
                      // style:  TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                  ])),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      submitAddLine();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text('OK'),
                  ),
                ],
              )
            ]);
      },
    );
  }

  void showDialogLocatorForm(
    BuildContext context,
    // String messageDelete,
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
                  'Locator',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: locatorFormChkController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Current Locator',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          locatorFormChk = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            locatorFormChkController.clear();
                            locatorFormChk = '';
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text('Cancel'),
                        ),
                        //---------------------------------------------------
                        ElevatedButton(
                          onPressed: () {
                            String textForm = 'F';
                            if (locatorFormChk != '') {
                              chkLocatorForm(locatorFormChk, textForm);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text('OK'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: []);
      },
    );
  }

  void showDialogLocatorTo(
    BuildContext context,
    // String messageDelete,
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
                  'Locator',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: locatorToChkController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Locator ปลายทาง',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          locatorToChk = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            locatorToChkController.clear();
                            locatorToChk = '';
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text('Cancel'),
                        ),
                        //---------------------------------------------------
                        ElevatedButton(
                          onPressed: () {
                            String textForm = 'T';
                            if (locatorToChk != '') {
                              chkLocatorForm(locatorToChk, textForm);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text('OK'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: []);
      },
    );
  }
}

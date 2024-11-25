import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
// import 'package:wms_android/icon.dart';
import 'package:wms_android/styles.dart';
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
  String quantityDisplay = '';
  String locatorTo = '';
  String controlLot = '';
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

  String previousValue = '';
  String dataLocatorForSaveDataForm = '';
  String dataLocatorForSaveDataTo = '';

  bool chkShowDialogcomfirmMessage = false;
  // ------------------------------
  bool checkDis = false;
  bool checkDislocatorF = false;
  bool checkDislocatorT = false;
  // ------------------------------

  FocusNode barcodeFocusNode = FocusNode();
  FocusNode lotNumberFocusNode = FocusNode();
  FocusNode quantityFocusNode = FocusNode();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController locatorFormController = TextEditingController();
  TextEditingController itemCodeController = TextEditingController();
  TextEditingController lotNoController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController quantityDisPlayController = TextEditingController();
  TextEditingController locatorToController = TextEditingController();
  TextEditingController lotQtyController = TextEditingController();
  TextEditingController lotUnitController = TextEditingController();

  TextEditingController locatorFormChkController = TextEditingController();
  TextEditingController locatorToChkController = TextEditingController();

  @override
  void dispose() {
    quantityFocusNode.dispose();
    lotNumberFocusNode.dispose();
    barcodeFocusNode.dispose();
    barcodeController.dispose();
    locatorFormController.dispose();
    itemCodeController.dispose();
    lotNoController.dispose();
    quantityController.dispose();
    quantityDisPlayController.dispose();
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
      FocusScope.of(context).requestFocus(barcodeFocusNode);
    });

    // barcodeFocusNode.addListener(() {
    //   if (!barcodeFocusNode.hasFocus) {
    //     if (mounted) {
    //       setState(() {
    //         if (barCode.contains(' ')) {
    //           List<String> parts = barCode.split(' ');
    //           lotNo = parts.sublist(1).join(' ');
    //           lotNoController.text = lotNo;
    //         } else {
    //           lotNo = barCode;
    //           lotNoController.text = lotNo;
    //         }

    //         // if (barCode.isNotEmpty && lotNo.isNotEmpty) {
    //         //   fetchData();
    //         // }
    //       });
    //     }
    //   }
    // });

    // lotNumberFocusNode.addListener(() {
    //   if (!lotNumberFocusNode.hasFocus) {
    //     if (mounted) {
    //       setState(() {
    //         if (barCode.isNotEmpty && lotNo.isNotEmpty) {
    //           fetchData();
    //         }
    //       });
    //     }
    //   }
    // });

    quantityFocusNode.addListener(() {
      if (!quantityFocusNode.hasFocus) {
        if (mounted) {
          setState(() {
            if (quantity.isNotEmpty && barCode.isNotEmpty && lotNo.isNotEmpty) {
              chkQuantity();
            }
            // if (barCode != '' &&
            //     lotNo != '' &&
            //     quantity != '' &&
            //     statusFetchDataBarcode == '0') {
            //   chkQuantity();
            // }
          });
        }
      }
    });
  }

  Future<void> fetchData() async {
    print('lotNo : $lotNo type : ${lotNo.runtimeType}');
    final url =
        '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_ScanBarcode';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_erp_ou_code': globals.P_ERP_OU_CODE,
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

            if (dataBarcode['po_status'] == '1' &&
                dataBarcode['po_valid'] != 'N') {
              showDialogAlertMessage(context, messageFetchDataBarcode);
            } else if (dataBarcode['po_status'] == '1' &&
                dataBarcode['po_valid'] == 'N') {
              changeData(
                dataBarcode['po_item_code'] ?? '',
                dataBarcode['po_lot_number'] ?? '',
                dataBarcode['po_quantity'] ?? '',
                dataBarcode['po_curr_loc'] ?? '',
                dataBarcode['po_bal_lot'] ?? '',
                dataBarcode['po_bal_qty'] ?? '',
              );
            } else if (dataBarcode['po_status'] == '0') {
              itemCode = dataBarcode['po_item_code'];
              lotNo = dataBarcode['po_lot_number'];
              quantity = dataBarcode['po_quantity'];
              int? quantityNUM =
                  int.tryParse(dataBarcode['po_quantity'] ?? '0');
              quantityDisplay =
                  NumberFormat('#,###,###,###,###,###').format(quantityNUM);

              locatorTo = dataBarcode['po_curr_loc'];
              controlLot = dataBarcode['po_control_lot'];
              lotQty = dataBarcode['po_bal_lot']; // ====== รวมรายการจ่าย
              lotUnit = dataBarcode['po_bal_qty']; //--- รวมจำนวนจ่าย

              itemCodeController.text = itemCode;
              lotNoController.text = lotNo;
              quantityController.text = dataBarcode['po_quantity'];
              quantityDisPlayController.text = quantityDisplay;
              locatorToController.text = locatorTo;
              lotQtyController.text = lotQty == '' ? '0' : lotQty;
              lotUnitController.text = lotUnit == '' ? '0' : lotUnit;

              chkQuantity();

              print('controlLot : $controlLot');
            }
            print(
                'statusFetchDataBarcode : $statusFetchDataBarcode Type : ${statusFetchDataBarcode.runtimeType}');
            print(
                'messageFetchDataBarcode : $messageFetchDataBarcode Type : ${messageFetchDataBarcode.runtimeType}');
            print(
                'valIDFetchDataBarcode : $valIDFetchDataBarcode Type : ${valIDFetchDataBarcode.runtimeType}');
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
          showDialogcomfirmMessage(context);
        }
      });
    }
  }

  Future<void> chkQuantity() async {
    print('pErpOuCode : ${globals.P_ERP_OU_CODE}');
    print('pDocNo : ${widget.pDocNo}');
    print('pWareCode : ${widget.pWareCode}');
    print('locatorForm : $locatorForm');
    print('itemCode : $itemCode');
    print('lotNo : $lotNo');
    print('quantity : $quantity');
    print(
        'EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE');
    final url =
        '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_ChkQuantity';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'pErpOuCode': globals.P_ERP_OU_CODE,
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
            print('statusChkQuantity : $statusChkQuantity');
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
          '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_ChkLocatorForm/${globals.P_ERP_OU_CODE}/${widget.pWareCode}/${widget.pDocNo}/${textInput.isNotEmpty ? textInput : 'mull'}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataChkLocatorForm =
            jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'dataChkLocatorForm : $dataChkLocatorForm type : ${dataChkLocatorForm.runtimeType}');
        if (mounted) {
          setState(() {
            poRet = dataChkLocatorForm['po_ret'];
            statusChkLocatorForm = dataChkLocatorForm['po_status'];
            messageChkLocatorForm = dataChkLocatorForm['po_message'];

            print('poRet : $poRet');
            print(
                'statusChkLocatorForm : $statusChkLocatorForm type : ${statusChkLocatorForm.runtimeType}');
            print('messageChkLocatorForm : $messageChkLocatorForm');

            if (statusChkLocatorForm == '1') {
              showDialogAlert(context, messageChkLocatorForm);
            } else if (statusChkLocatorForm == '0') {
              if (textForm == 'F') {
                locatorForm = poRet;
                locatorFormController.text = poRet;
                dataLocatorForSaveDataForm = textInput;

                if (locatorForm.isNotEmpty) {
                  Navigator.of(context).pop();
                  Future.delayed(Duration(milliseconds: 200), () {
                    FocusScope.of(context).requestFocus(lotNumberFocusNode);
                  });
                }
              }
              if (textForm == 'T') {
                locatorTo = poRet;
                locatorToController.text = poRet;
                dataLocatorForSaveDataTo = textInput;

                if (locatorTo.isNotEmpty) {
                  Navigator.of(context).pop();
                }
              }
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

  Future<void> selectLocatorBarcode(String locatorName, String textForm) async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_SelectLocatorBarcode/${globals.P_ERP_OU_CODE}/$locatorName'));

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataChkLocatorName = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print(
            'dataChkLocatorName : $dataChkLocatorName type : ${dataChkLocatorName.runtimeType}');
        if (mounted) {
          setState(() {
            if (dataChkLocatorName['po_status'] == '1') {
              showDialogAlert(context, dataChkLocatorName['po_message']);
            } else if (dataChkLocatorName['po_status'] == '0') {
              if (textForm == 'F') {
                locatorFormChk = dataChkLocatorName['po_locator_barcode'];
                locatorFormChkController.text =
                    dataChkLocatorName['po_locator_barcode'];
              }
              if (textForm == 'T') {
                locatorToChk = dataChkLocatorName['po_locator_barcode'];
                locatorToChkController.text =
                    dataChkLocatorName['po_locator_barcode'];
              }
            }
            print('locator po_status : ${dataChkLocatorName['po_status']}');
            print('locatorFormChk : $locatorFormChk');
            print('locatorFormChkController : $locatorFormChkController');
            print('locatorToChk : $locatorToChk');
            print('locatorToChkController : $locatorToChkController');
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
    final url = '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_AddLine';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'pErpOuCode': globals.P_ERP_OU_CODE,
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
                  // Navigator.of(context).pop();

                  barCode = '';
                  locatorForm = '';
                  itemCode = '';
                  lotNo = '';
                  quantity = '';
                  quantityDisplay = '';
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
                  quantityDisPlayController.clear();
                  locatorToController.clear();
                  lotQtyController.clear();
                  lotUnitController.clear();

                  FocusScope.of(context).requestFocus(barcodeFocusNode);
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
      appBar: CustomAppBar(title: 'Scan จ่ายสินค้า', showExitWarning: false),
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
                      color: Colors.lightBlue[100], // พื้นหลังสีเหลืองอ่อน
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
            const SizedBox(height: 10),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: barcodeController,
              focusNode: barcodeFocusNode,
              onFieldSubmitted: (value) {
                barCode = value;
                setState(() {
                  if (barCode.contains(' ')) {
                    List<String> parts = barCode.split(' ');
                    lotNo = parts.sublist(1).join(' ');
                    lotNoController.text = lotNo;
                  } else {
                    lotNo = barCode;
                    lotNoController.text = lotNo;
                  }

                  // if (barCode.isNotEmpty && lotNo.isNotEmpty) {
                  //   fetchData();
                  // }
                });
                if (barCode.isNotEmpty && lotNo.isNotEmpty) {
                  fetchData();
                }
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
              onTap: checkDis
                  ? null
                  : () async {
                      setState(() {
                        checkDis = true;
                      });
                      if (locatorForm.isNotEmpty) {
                        await selectLocatorBarcode(locatorForm, 'F');
                        showDialogLocatorForm();
                      } else {
                        showDialogLocatorForm();
                      }
                    },
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
              focusNode: lotNumberFocusNode,
              onFieldSubmitted: (value) {
                lotNo = value;
                if (barCode.isNotEmpty && lotNo.isNotEmpty) {
                  fetchData();
                }
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
            controlLot == 'Y'
                ? GestureDetector(
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: quantityDisPlayController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[300],
                          labelText: 'Quantity',
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  )
                : TextFormField(
                    controller: quantityDisPlayController,
                    focusNode: quantityFocusNode,
                    keyboardType: TextInputType.number,
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
                          quantityDisplay = value;
                          String result = value.replaceAll(',', '');
                          quantity = result;
                          quantityController.text = result;
                          if (quantity.isNotEmpty &&
                              barCode.isNotEmpty &&
                              lotNo.isNotEmpty) {
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
              onTap: () async {
                if (locatorTo.isNotEmpty) {
                  await selectLocatorBarcode(locatorTo, 'T');
                }
                showDialogLocatorTo();
              },
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
      bottomNavigationBar: BottomBar(
        currentPage: 'show',
      ),
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
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text(messageDelete),
          onClose: () {
            Navigator.of(context).pop();
            barCode = '';
            locatorForm = '';
            locatorFormChk = '';
            itemCode = '';
            lotNo = '';
            quantity = '';
            quantityDisplay = '';
            locatorTo = '';
            locatorToChk = '';
            lotQty = '';
            lotUnit = '';

            statusFetchDataBarcode = '';
            messageFetchDataBarcode = '';
            valIDFetchDataBarcode = '';

            barcodeController.clear();
            locatorFormController.clear();
            locatorFormChkController.clear();
            itemCodeController.clear();
            lotNoController.clear();
            quantityController.clear();
            quantityDisPlayController.clear();
            locatorToController.clear();
            locatorToChkController.clear();
            lotQtyController.clear();
            lotUnitController.clear();

            barcodeFocusNode.requestFocus();
          },
          onConfirm: () {
            Navigator.of(context).pop();

            barCode = '';
            locatorForm = '';
            locatorFormChk = '';
            itemCode = '';
            lotNo = '';
            quantity = '';
            quantityDisplay = '';
            locatorTo = '';
            locatorToChk = '';
            lotQty = '';
            lotUnit = '';

            statusFetchDataBarcode = '';
            messageFetchDataBarcode = '';
            valIDFetchDataBarcode = '';

            barcodeController.clear();
            locatorFormController.clear();
            locatorFormChkController.clear();
            itemCodeController.clear();
            lotNoController.clear();
            quantityController.clear();
            quantityDisPlayController.clear();
            locatorToController.clear();
            locatorToChkController.clear();
            lotQtyController.clear();
            lotUnitController.clear();

            barcodeFocusNode.requestFocus();
          },
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
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text(messageAlert),
          onClose: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showDialogcomfirmMessage(
    BuildContext context,
    // String messageAlert,
  ) {
    if (chkShowDialogcomfirmMessage == false) {
      chkShowDialogcomfirmMessage = true;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogStyles.alertMessageCheckDialog(
            context: context,
            content: Text('รายการไม่ตรงกับระบบการจอง ต้องการยืนยัน ?'),
            onClose: () {
              chkShowDialogcomfirmMessage = false;
              Navigator.of(context).pop();

              barCode = '';
              locatorForm = '';
              locatorFormChk = '';
              itemCode = '';
              lotNo = '';
              quantity = '';
              quantityDisplay = '';
              locatorTo = '';
              locatorToChk = '';
              lotQty = '';
              lotUnit = '';

              statusFetchDataBarcode = '';
              messageFetchDataBarcode = '';
              valIDFetchDataBarcode = '';

              barcodeController.clear();
              locatorFormController.clear();
              locatorFormChkController.clear();
              itemCodeController.clear();
              lotNoController.clear();
              quantityController.clear();
              quantityDisPlayController.clear();
              locatorToController.clear();
              locatorToChkController.clear();
              lotQtyController.clear();
              lotUnitController.clear();

              barcodeFocusNode.requestFocus();
            },
            onConfirm: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Ssfgdt09lReason(
                          pOuCode: widget.pOuCode,
                          pErpOuCode: globals.P_ERP_OU_CODE,
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
                locatorFormChk = '';
                itemCode = '';
                lotNo = '';
                quantity = '';
                quantityDisplay = '';
                locatorTo = '';
                locatorToChk = '';
                lotQty = '';
                lotUnit = '';

                statusFetchDataBarcode = '';
                messageFetchDataBarcode = '';
                valIDFetchDataBarcode = '';

                barcodeController.clear();
                locatorFormController.clear();
                locatorFormChkController.clear();
                itemCodeController.clear();
                lotNoController.clear();
                quantityController.clear();
                quantityDisPlayController.clear();
                locatorToController.clear();
                locatorToChkController.clear();
                lotQtyController.clear();
                lotUnitController.clear();

                barcodeFocusNode.requestFocus();
              });
            },
          );
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageCheckDialog(
          context: context,
          content: Text(textMessage),
          onClose: () {
            statusFetchDataBarcode = '';
            Navigator.of(context).pop();
          },
          onConfirm: () {
            Navigator.of(context).pop(true);
          },
        );
      },
    ).then((value) {
      if (value == true) {
        Future.delayed(const Duration(milliseconds: 100), () {
          submitAddLine();
        });
      } else if (value == false) {
        //
      } else if (value == null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          showDialogLocatorForm();
        });
      }
    });
  }

  void showDialogLocatorForm() {
    if (mounted) {
      setState(() {
        checkDis = false;
      });
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.displayTextFormField(
          context: context,
          onCloseDialog: () {
            Navigator.of(context).pop();
            setState(() {
              locatorFormChk = '';
              locatorFormChkController.clear();
            });
          },
          onConfirmDialog: checkDislocatorF
              ? null
              : () {
                  () async {
                    setState(() {
                      checkDislocatorF = true;
                    });
                    String textForm = 'F';
                    await chkLocatorForm(locatorFormChk, textForm);
                    setState(() {
                      checkDislocatorF = false;
                    });
                  }();
                },
          onChanged: (value) {
            setState(() {
              locatorFormChk = value;
            });
          },
          controller: locatorFormChkController,
          headTextDialog: 'Locator ตัดจ่าย',
          labelText: 'Current Locator',
        );
      },
    );
  }

  void showDialogLocatorTo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.displayTextFormField(
          context: context,
          onCloseDialog: () {
            Navigator.of(context).pop();
            setState(() {
              locatorToChk = '';
              locatorToChkController.clear();
            });
          },
          onConfirmDialog: checkDislocatorT
              ? null
              : () {
                  () async {
                    setState(() {
                      checkDislocatorT = true;
                    });
                    String textForm = 'T';
                    chkLocatorForm(locatorToChk, textForm);
                    setState(() {
                      checkDislocatorT = false;
                    });
                  }();
                },
          onChanged: (value) {
            setState(() {
              locatorToChk = value;
            });
          },
          controller: locatorToChkController,
          headTextDialog: 'Current Locator',
          labelText: 'Locator ปลายทาง',
        );
      },
    );
  }
}

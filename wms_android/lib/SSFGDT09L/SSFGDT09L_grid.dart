import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT09L_barcode.dart';
import 'SSFGDT09L_picking_slip.dart';
import 'SSFGDT09L_verify.dart';

class Ssfgdt09lGrid extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final String pAttr1;
  final String docNo;
  final String docType;
  final String moDoNo;
  // final String refNo;
  final String pErpOuCode;
  final String pOuCode;
  final String pAppUser;
  final String statusCase;
  Ssfgdt09lGrid({
    Key? key,
    required this.pWareCode,
    required this.pAttr1,
    required this.docNo,
    required this.docType,
    required this.moDoNo,
    // required this.refNo,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAppUser,
    required this.statusCase,
  }) : super(key: key);
  @override
  _Ssfgdt09lGridState createState() => _Ssfgdt09lGridState();
}

class _Ssfgdt09lGridState extends State<Ssfgdt09lGrid> {
  //
  List<dynamic> dataCard = [];

  String deleteStatus = '';
  String deleteMessage = '';
  String deleteCardAllStatus = '';
  String deleteCardAllMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_SelectDataGrid/${widget.pOuCode}/${widget.pErpOuCode}/${widget.docType}/${widget.docNo}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        setState(() {
          dataCard =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataCard : $dataCard');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data : $e');
    }
  }

  Future<void> updatePackQty(
      int packQty, String itemCode, String packCode, String rowID) async {
    print('packQty in updatePackQty: $packQty type : ${packQty.runtimeType}');
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_UpdatePackQty';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'pack_qty': packQty,
      'item_code': itemCode,
      'pack_code': packCode,
      'rowid': rowID,
    });
    print('Request body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          // fetchData();
        });
        print('Success: $responseData');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(' Error: $e');
    }
  }

  Future<void> deleteCard(String pSeq, String pItemCode) async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_deleteCardGrid';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'pErpOuCode': globals.P_ERP_OU_CODE,
      'pDocType': widget.docType,
      'pDocNo': widget.docNo,
      'pSeq': pSeq,
      'pItemCode': pItemCode,
      'pAppUser': globals.APP_USER,
    });
    print('Request body: $body');

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataDelete = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataDelete : $dataDelete type : ${dataDelete.runtimeType}');
        setState(() {
          deleteStatus = dataDelete['po_status'];
          deleteMessage = dataDelete['po_message'];

          if (deleteStatus == '1') {
            showDialogMessageDelete(context, deleteMessage);
          }
          if (deleteStatus == '0') {
            setState(() async {
              Navigator.of(context).pop();
              await fetchData();
            });
          }
        });
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('ลบข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteCardAll() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_DeleteCardAll';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_erp_ou_code': globals.P_ERP_OU_CODE,
      'p_doc_type': widget.docType,
      'p_doc_no': widget.docNo,
      'p_app_user': globals.APP_USER,
    });
    print('Request body: $body');

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataDelete = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataDelete : $dataDelete type : ${dataDelete.runtimeType}');
        setState(() {
          deleteCardAllStatus = dataDelete['po_status'];
          deleteCardAllMessage = dataDelete['po_message'];

          if (deleteCardAllStatus == '1') {
            showDialogMessageDelete(context, deleteCardAllMessage);
          }
          if (deleteCardAllStatus == '0') {
            setState(() {
              print('delete allllllllllllllllllllllll');
              Navigator.of(context).pop();
              fetchData();
            });
          }
        });
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('ลบข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error Delete ALl: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // การเรียกใช้งาน
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Ssfgdt09lPickingSlip(
                                pErpOuCode: widget.pErpOuCode,
                                pOuCode: widget.pOuCode,
                                pMoDoNO: widget.moDoNo,
                              )),
                    ).then((value) async {
                      // เมื่อกลับมาหน้าเดิม เรียก fetchData
                      await fetchData();
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
                    'Picking Slip',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // --------------------------------------------------------------------
                // const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    iconSize: 20.0,
                    icon: Image.asset(
                      'assets/images/right.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Ssfgdt09lVerify(
                                  pErpOuCode: widget.pErpOuCode,
                                  pOuCode: widget.pOuCode,
                                  docNo: widget.docNo,
                                  docType: widget.docType,
                                  moDoNo: widget.moDoNo,
                                )),
                      ).then((value) async {
                        // เมื่อกลับมาหน้าเดิม เรียก fetchData
                        await fetchData();
                        await fetchData();
                        print('11111111111111111111111111');
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // --------------------------------------------------------------------
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
                        '${widget.docNo}',
                        style: TextStyle(
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
                        widget.moDoNo,
                        style: TextStyle(
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
            // --------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Ssfgdt09lBarcode(
                                pWareCode: widget.pWareCode,
                                pErpOuCode: widget.pErpOuCode,
                                pOuCode: widget.pOuCode,
                                pAttr1: widget.pAttr1,
                                pAppUser: widget.pAppUser,
                                pDocNo: widget.docNo,
                                pDocType: widget.docType,
                                pMoDoNO: widget.moDoNo,
                              )),
                    ).then((value) async {
                      // เมื่อกลับมาหน้าเดิม เรียก fetchData
                      await fetchData();
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
                    '+Create',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // --------------------------------------------------------------------
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      String messageDelete =
                          'ต้องการลบรายการในหน้าจอนี้ทั้งหมดหรือไม่ ?';
                      String dataTest = 'test';
                      showDialogComfirmDelete(
                        context,
                        dataTest,
                        dataTest,
                        messageDelete,
                      );
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
                    '+Clear All',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // --------------------------------------------------------------------
              ],
            ),
            //  Container(
            // height: MediaQuery.of(context).size.height * 0.8,
            // width: MediaQuery.of(context).size.width * 0.8,
            // height: 300,
            // width: 300,
            // child:
            Expanded(
              child: ListView(
                // shrinkWrap: true,
                // children: dataCardForTest.map((item) {
                // สำหรับ test
                children: dataCard.map((item) {
                  // Color cardColor;
                  // String statusText;
                  // String iconImageYorN;

                  // switch (item['card_status_desc']) {
                  //   case 'ปกติ':
                  //     cardColor = Color.fromRGBO(146, 208, 80, 1.0);
                  //     statusText = 'ปกติ';
                  //     break;
                  //   case 'ยืนยันการจ่าย' || 'ยืนยันการรับ':
                  //     cardColor = Color.fromRGBO(146, 208, 80, 1.0);
                  //     statusText = 'ยืนยันการรับ';
                  //     break;
                  //   case 'ยกเลิก':
                  //     cardColor = Color.fromRGBO(208, 206, 206, 1.0);
                  //     statusText = 'ยกเลิก';
                  //     break;
                  //   case 'ระหว่างบันทึก':
                  //     cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                  //     statusText = 'ระหว่างบันทึก';
                  //     break;
                  //   case 'อ้างอิงแล้ว':
                  //     cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                  //     statusText = 'อ้างอิงแล้ว';
                  //     break;
                  //   default:
                  //     cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                  //     statusText = 'Unknown';
                  // }

                  // switch (item['qc_yn']) {
                  //   case 'Y':
                  //     iconImageYorN = 'assets/images/rt_machine_on.png';
                  //     break;
                  //   case 'N':
                  //     iconImageYorN = 'assets/images/rt_machine_off.png';
                  //     break;
                  //   default:
                  //     iconImageYorN = 'assets/images/rt_machine_off.png';
                  // }

                  return Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Color.fromRGBO(204, 235, 252, 1.0),
                    child: InkWell(
                      onTap: () {
                        // checkStatusCard(item['po_no'] ?? '',
                        //     item['p_doc_no'] ?? '', item['p_doc_type'] ?? '');

                        // print(
                        //     'po_no in Card : ${item['po_no']} Type : ${item['po_no'].runtimeType}');
                        // print(
                        //     'p_doc_no in Card : ${item['p_doc_no']} Type : ${item['p_doc_no'].runtimeType}');
                        // print(
                        //     'p_doc_type in Card : ${item['p_doc_type']} Type : ${item['p_doc_type'].runtimeType}');
                      },
                      borderRadius: BorderRadius.circular(15.0),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // InkWell(
                                //   onTap: () {},
                                //   child: Container(
                                //     width: 100,
                                //     height: 40,
                                //     // color: cardColor, // เปลี่ยนสีพื้นหลังที่นี่
                                //     child: Image.asset(
                                //       'assets/images/printer.png',
                                //       fit: BoxFit.contain,
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 20.0),
                                Text(
                                  'Item : ${item['item_code'] ?? ''}',
                                  style: TextStyle(color: Colors.black),
                                ),

                                SizedBox(height: 4.0),
                                Text(
                                  'Lot No : ${item['lots_no'] ?? ''}',
                                  style: TextStyle(color: Colors.black),
                                ),

                                SizedBox(height: 4.0),
                                // -------------------------------------------------------------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'จำนวนที่จ่าย : ${NumberFormat('#,###,###,###,###,###').format(item['pack_qty'] ?? '')}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Pack : ${item['pack_code'] ?? ''}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                // -------------------------------------------------------------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Locator : ${item['location_code'] ?? ''}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'PD Location : ${item['pd_location'] ?? ''}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                // -------------------------------------------------------------
                                Text(
                                  'Reason : ${item['reason_mismatch'] ?? ''}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(height: 4.0),
                                // -------------------------------------------------------------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'ใช้แทนจุด : ${item['attribute3'] ?? ''}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Replace Lot# : ${item['attribute4'] ?? ''} ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                // -------------------------------------------------------------
                                // Text(
                                //   'No : ${item['seq']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Item : ${item['item_code']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Lot No : ${item['lots_no']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'จำนวนที่จ่าย : ${item['pack_qty']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Pack : ${item['pack_code']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Locator : ${item['location_code']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'PD Location : ${item['pd_location']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Reason : ${item['reason_mismatch']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'ใช้แทนจุด : ${item['attribute3']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Replace Lot# : ${item['attribute4']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Item Desc : ${item['nb_item_name']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Pack Desc : ${item['nb_pack_name']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),

                                SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          String messageDelete =
                                              'ต้องการลบรายการหรือไม่ ?';

                                          showDialogComfirmDelete(
                                            context,
                                            item['seq'].toString(),
                                            item['item_code'] ?? '',
                                            messageDelete,
                                          );
                                        });
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        // color: cardColor, // เปลี่ยนสีพื้นหลังที่นี่
                                        child: Image.asset(
                                          'assets/images/bin.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDetailsDialog(
                                          context,
                                          item['pack_qty'],
                                          item['nb_item_name'] ?? '',
                                          item['nb_pack_name'] ?? '',
                                          item['item_code'] ?? '',
                                          item['pack_code'] ?? '',
                                          item['rowid'] ?? '',
                                        );
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        // color: cardColor, // เปลี่ยนสีพื้นหลังที่นี่
                                        child: Image.asset(
                                          'assets/images/edit (1).png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // ),
            // --------------------------------------------------------------------
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showDetailsDialog(BuildContext context, int packQty, String nbItemName,
      String nbPackName, String itemCode, String packCode, String rowID) {
    String formattedSysQty =
        NumberFormat('#,###,###,###,###,###').format(packQty);
    TextEditingController packQtyController =
        TextEditingController(text: formattedSysQty.toString());
    TextEditingController nbItemNameController =
        TextEditingController(text: nbItemName.toString());
    TextEditingController nbPackNameController =
        TextEditingController(text: nbPackName.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('รายละเอียด'), // หัวเรื่องของ Dialog
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // จัดชิดซ้าย
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: packQtyController,
                    // readOnly: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'จำนวนที่จ่าย',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: nbItemNameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Item Desc',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: nbPackNameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Pack Desc',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ย้อนกลับ'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog เมื่อกดปุ่มนี้
              },
            ),
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () async {
                int updatedPackQty =
                    int.tryParse(packQtyController.text) ?? packQty;

                Navigator.of(context).pop();
                await updatePackQty(updatedPackQty, itemCode, packCode, rowID);
                await fetchData();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogComfirmDelete(BuildContext context, String pSeq,
      String pItemCode, String messageDelete) {
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
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    messageDelete,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        child: const Text('ย้อนกลับ'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (messageDelete == 'ต้องการลบรายการหรือไม่ ?') {
                            print('case Delete One');
                            deleteCard(pSeq, pItemCode);
                          }
                          if (messageDelete ==
                              'ต้องการลบรายการในหน้าจอนี้ทั้งหมดหรือไม่ ?') {
                            print('case Delete All');
                            deleteCardAll();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ยืนยัน'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showDialogMessageDelete(
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
              child: Column(
                children: [
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
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ย้อนกลับ'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

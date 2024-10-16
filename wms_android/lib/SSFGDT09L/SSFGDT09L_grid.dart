import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/styles.dart';
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
  final String docDate;
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
    required this.docDate,
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

  bool isLoading = false;

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
    isLoading = true;
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_SelectDataGrid/${widget.pOuCode}/${widget.pErpOuCode}/${widget.docType}/${widget.docNo}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');
        if (mounted) {
          setState(() {
            dataCard =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            isLoading = false;
          });
        }
        print('dataCard : $dataCard');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
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
        if (mounted) {
          setState(() {
            // fetchData();
          });
        }
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
        if (mounted) {
          setState(() {
            deleteStatus = dataDelete['po_status'];
            deleteMessage = dataDelete['po_message'];

            if (deleteStatus == '1') {
              showDialogMessageDelete(context, deleteMessage);
            }
            if (deleteStatus == '0') {
              if (mounted) {
                setState(() async {
                  Navigator.of(context).pop();
                  await fetchData();
                });
              }
            }
          });
        }
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
        if (mounted) {
          setState(() {
            deleteCardAllStatus = dataDelete['po_status'];
            deleteCardAllMessage = dataDelete['po_message'];

            if (deleteCardAllStatus == '1') {
              showDialogMessageDelete(context, deleteCardAllMessage);
            }
            if (deleteCardAllStatus == '0') {
              if (mounted) {
                setState(() {
                  print('delete allllllllllllllllllllllll');
                  Navigator.of(context).pop();
                  fetchData();
                });
              }
            }
          });
        }
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
      appBar: CustomAppBar(title: 'เบิกจ่าย', showExitWarning: false),
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
                                pDocNo: widget.docNo,
                              )),
                    ).then((value) async {
                      // เมื่อกลับมาหน้าเดิม เรียก fetchData
                      await fetchData();
                    });
                  },
                  style: AppStyles.cancelButtonStyle(),
                  child: Text(
                    'Picking Slip',
                    style: AppStyles.CancelbuttonTextStyle(),
                  ),
                ),
                // --------------------------------------------------------------------
                // const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Ssfgdt09lVerify(
                                pErpOuCode: widget.pErpOuCode,
                                pOuCode: widget.pOuCode,
                                docNo: widget.docNo,
                                docType: widget.docType,
                                docDate: widget.docDate,
                                moDoNo: widget.moDoNo,
                                pWareCode: widget.pWareCode,
                              )),
                    ).then((value) async {
                      // เมื่อกลับมาหน้าเดิม เรียก fetchData
                      await fetchData();
                      await fetchData();
                      print('11111111111111111111111111');
                    });
                  },
                  style: AppStyles.NextButtonStyle(),
                  child: Image.asset(
                    'assets/images/right.png', // ใส่ภาพจากไฟล์ asset
                    width: 25, // กำหนดขนาดภาพ
                    height: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------
            Expanded(
              child: ListView(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                const SizedBox(height: 8),
                // --------------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                                    pDocDate: widget.docDate,
                                    pMoDoNO: widget.moDoNo,
                                  )),
                        ).then((value) async {
                          // เมื่อกลับมาหน้าเดิม เรียก fetchData
                          await fetchData();
                        });
                      },
                      style: AppStyles.createButtonStyle(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white,
                              width: 3), // White border for the circle
                        ),
                        padding: const EdgeInsets.all(
                            2), // Padding to make the circle
                        child: const Icon(
                          Icons.add, // Plus icon inside the circle
                          color: Colors.white, // White plus icon
                          size: 24, // Icon size
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // --------------------------------------------------------------------
                    ElevatedButton(
                      onPressed: () {
                        if (dataCard.isNotEmpty) {
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
                        }
                      },
                      style: AppStyles.ClearButtonStyle(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white,
                              width: 3), // White border for the circle
                        ),
                        padding: const EdgeInsets.all(
                            2), // Padding to make the circle
                        child: const Icon(
                          Icons.delete, // Plus icon inside the circle
                          color: Colors.white, // White plus icon
                          size: 24, // Icon size
                        ),
                      ),
                    ),
                    // --------------------------------------------------------------------
                  ],
                ),
                const SizedBox(height: 8),
                // ข้อมูลที่ต้องการแสดงใน ListView
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // เพื่อให้ทำงานร่วมกับ ListView ด้านนอกได้
                        itemCount: dataCard
                            .length, // ใช้ length ของ dataCard แทนการใช้ map
                        itemBuilder: (context, index) {
                          final item = dataCard[
                              index]; // ดึงข้อมูลแต่ละรายการจาก dataCard
                          return Card(
                            elevation: 8.0,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Color.fromRGBO(204, 235, 252, 1.0),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(15.0),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          child: Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Item : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              CustomContainerStyles
                                                  .styledContainer(
                                                item['item_code'],
                                                child: Text(
                                                  item['item_code'] ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        SizedBox(
                                          child: Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Lot No : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              CustomContainerStyles
                                                  .styledContainer(
                                                item[
                                                    'lots_no'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                child: Text(
                                                  item['lots_no'] ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        SizedBox(
                                          child: Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'จำนวนที่จ่าย : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              CustomContainerStyles
                                                  .styledContainer(
                                                item['pack_qty']
                                                    .toString(), // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                child: Text(
                                                  NumberFormat(
                                                          '#,###,###,###,###,###')
                                                      .format(
                                                          item['pack_qty'] ??
                                                              ''),
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        SizedBox(
                                          child: Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Pack : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              CustomContainerStyles
                                                  .styledContainer(
                                                item[
                                                    'pack_code'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                child: Text(
                                                  item['pack_code'] ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        SizedBox(
                                          child: Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Location : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              CustomContainerStyles
                                                  .styledContainer(
                                                item[
                                                    'location_code'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                child: Text(
                                                  item['location_code'] ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              const Text(
                                                'PD Location : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              CustomContainerStyles
                                                  .styledContainer(
                                                item[
                                                    'pd_location'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                child: Text(
                                                  item['pd_location'] ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        SizedBox(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                child: Text(
                                                  'Reason : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomContainerStyles
                                                    .styledContainer(
                                                  item['reason_mismatch'],
                                                  child: Text(
                                                    item['reason_mismatch'] ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                    softWrap:
                                                        true, // เปิดให้ตัดบรรทัด
                                                    overflow: TextOverflow
                                                        .visible, // แสดงข้อความทั้งหมด
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        SizedBox(
                                          child: Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'ใช้แทนจุด : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              CustomContainerStyles
                                                  .styledContainer(
                                                item[
                                                    'attribute3'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                child: Text(
                                                  item['attribute3'] ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        SizedBox(
                                          child: Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Replace Lot# : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              CustomContainerStyles
                                                  .styledContainer(
                                                item[
                                                    'attribute4'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                child: Text(
                                                  item['attribute4'] ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
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
                                                  item['seq'],
                                                  item['pack_qty'],
                                                  item['nb_item_name'] ?? '',
                                                  item['rowid'] ?? '',
                                                  // item['nb_pack_name'] ?? '',
                                                  item['item_code'] ?? '',
                                                  item['pack_code'] ?? '',
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
                        },
                      )
              ]),
            ),
            // ),
            // --------------------------------------------------------------------
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: 'not_show',
      ),
    );
  }

  void showDialogComfirmDelete(BuildContext context, String pSeq,
      String pItemCode, String messageDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
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
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
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
                    child: const Text('OK'),
                  ),
                ],
              )
            ]);
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showDetailsDialog(
    BuildContext context,
    int seq,
    int packQty,
    String nbItemName,
    String rowID,
    String itemCode,
    String packCode,
  ) async {
    String formattedSysQty =
        NumberFormat('#,###,###,###,###,###').format(packQty);
    TextEditingController packQtyController =
        TextEditingController(text: formattedSysQty.toString());
    String formattedSeq = NumberFormat('#,###,###,###,###,###').format(seq);
    TextEditingController seqController =
        TextEditingController(text: formattedSeq);
    TextEditingController nbItemNameController =
        TextEditingController(text: nbItemName);

    String CheckDataPackQty = packQty.toString();
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54, // Background color with some transparency
      transitionDuration: const Duration(milliseconds: 200),
      // title: T,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            if (CheckDataPackQty.toString() !=
                                packQty.toString()) {
                              showExitWarningDialog();
                            } else {
                              Navigator.of(context).pop(false);
                              fetchData();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: seqController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelText: 'Seq',
                                  labelStyle: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          flex: 7,
                          child: GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
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
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: packQtyController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'จำนวนที่จ่าย',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      onChanged: (value) {
                        CheckDataPackQty = value;
                      },
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: AppStyles.ConfirmChecRecievekButtonStyle(),
                          onPressed: () async {
                            int updatedPackQty = int.tryParse(packQtyController
                                    .text
                                    .replaceAll(',', '')) ??
                                packQty;

                            Navigator.of(context).pop(true);
                            await updatePackQty(
                                updatedPackQty, itemCode, packCode, rowID);
                            await fetchData();
                            setState(() {});
                            print('updatedPackQty : $updatedPackQty');
                            print('packQtyController : $packQtyController');
                          },
                          child: Image.asset(
                            'assets/images/check-mark.png',
                            width: 25.0,
                            height: 25.0,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
    //.then((value) {
    //   // เช็คเมื่อ dialog ถูกปิดจากการกดด้านนอก
    //   if (value == null) {
    //     if (CheckDataPackQty.toString() != packQty.toString()) {
    //       showExitWarningDialog();
    //       print('result : กดออกจากข้างนอก');
    //     }
    //   }
    // });
    // print('result : $result');
    // print(
    //     'ChECK :  ${CheckDataPackQty.toString()}   !=   ${packQty.toString()} ');
    // if (result == null) {
    //   if (CheckDataPackQty.toString() != packQty.toString()) {
    //     showExitWarningDialog();
    //     print('result : กดออกจากข้างนอก');
    //   }
    // }
  }

  void showExitWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
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
                      'คุณต้องการออกจากหน้านี้โดยไม่บันทึกหรือไม่',
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop(true);
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
}

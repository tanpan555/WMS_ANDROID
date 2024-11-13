import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/centered_message.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT31_picking_slip.dart';

class Ssfgdt31Grid extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final String docNo;
  final String docType;
  final String docDate;
  final String moDoNo;
  final String refNo;
  final String statusCase;
  Ssfgdt31Grid({
    Key? key,
    required this.pWareCode,
    required this.docNo,
    required this.docType,
    required this.docDate,
    required this.moDoNo,
    required this.refNo,
    required this.statusCase,
  }) : super(key: key);
  @override
  _Ssfgdt31GridState createState() => _Ssfgdt31GridState();
}

class _Ssfgdt31GridState extends State<Ssfgdt31Grid> {
  //
  List<dynamic> dataCard = [];

  String deleteStatus = '';
  String deleteMessage = '';
  String deleteCardAllStatus = '';
  String deleteCardAllMessage = '';

  bool isLoading = false;
  String? nextLink = '';
  String? prevLink = '';
  int countData = 0;

  String urlLoad = '';
  int showRecordRRR = 0;

  String countDataGridCardNUMBER1 = '';
  String countDataGridCardNUMBER2 = '';
  String statusCountDataGridCard = '';
  String messageCountDataGridCard = '';

  @override
  void initState() {
    fetchData();
    countDataGridCard(true);
    super.initState();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData([String? url]) async {
    print(
        '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_3_DataGrid/${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/${widget.docNo}/${widget.docType}');
    isLoading = true;
    final String requestUrl = url ??
        '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_3_DataGrid/${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/${widget.docNo}/${widget.docType}';
    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);

        if (mounted) {
          setState(() {
            if (parsedResponse is Map && parsedResponse.containsKey('items')) {
              dataCard = parsedResponse['items'];
            } else {
              dataCard = [];
            }

            List<dynamic> links = parsedResponse['links'] ?? [];
            nextLink = getLink(links, 'next');
            prevLink = getLink(links, 'prev');
            countData = parsedResponse['count'];
            urlLoad = url ??
                '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_3_DataGrid/${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/${widget.docNo}/${widget.docType}';
            if (url.toString().isNotEmpty) {
              extractLastNumberFromUrl(url.toString() ==
                      '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_3_DataGrid/${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/${widget.docNo}/${widget.docType}'
                  ? 'null'
                  : url.toString());
            }

            if (countData == 0 && prevLink != null) {
              loadPrevPage();
              // countDataGridCard(true);
            }
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            print('Failed to load data fetchData: ${response.statusCode}');
          });
        }
        print(
            'HTTP Error fetchData : ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions that may occur
      if (mounted) {
        setState(() {
          // isLoading = false;
          print('Error occurred: $e');
        });
      }
      print('Exception: $e');
    }
  }

  String? getLink(List<dynamic> links, String rel) {
    final link =
        links.firstWhere((item) => item['rel'] == rel, orElse: () => null);
    return link != null ? link['href'] : null;
  }

  void loadNextPage() {
    if (nextLink != '') {
      setState(() {
        showRecordRRR = 0;
        // countData = 0;
        print('nextLink $nextLink');
        isLoading = true;
      });
      fetchData(nextLink);
    }
  }

  void loadPrevPage() {
    if (prevLink != '') {
      setState(() {
        showRecordRRR = 0;
        // countData = 0;
        isLoading = true;
      });
      fetchData(prevLink);
    }
  }

  void extractLastNumberFromUrl(String url) {
    // Regular Expression สำหรับจับค่าหลัง offset=
    RegExp regExp = RegExp(r'offset=(\d+)$');
    RegExpMatch? match = regExp.firstMatch(url);

    // ตัวแปรสำหรับเก็บผลลัพธ์
    int showRecord = 0; // ตั้งค่าเริ่มต้นเป็น 0

    if (match != null) {
      // แปลงค่าที่จับคู่ได้จาก String ไปเป็น int
      showRecordRRR =
          int.parse(match.group(1)!); // group(1) หมายถึงค่าหลัง offset=
      print('ตัวเลขท้ายสุดคือ: $showRecord');
      print('$showRecordRRR');
      print('$showRecordRRR + 1 = ${showRecordRRR + 1}');
      print('${dataCard.length}');
      print(
          '${dataCard.length} + $showRecordRRR = ${dataCard.length + showRecordRRR}');
    } else {
      // ถ้าไม่พบค่า ให้ผลลัพธ์เป็น 0
      print('ไม่พบตัวเลขท้ายสุด, ส่งกลับเป็น 0');
    }

    // พิมพ์ค่าที่ได้
    print('ผลลัพธ์: $showRecord');
  }

  Future<void> countDataGridCard(bool checking) async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_3_CountDataGrid/${globals.P_ERP_OU_CODE}/${widget.docNo}/${widget.docType}'));

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataConut = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        if (mounted) {
          setState(() {
            statusCountDataGridCard = dataConut['po_status'];
            messageCountDataGridCard = dataConut['po_message'];
            if (checking == true) {
              if (statusCountDataGridCard == '0') {
                countDataGridCardNUMBER1 = dataConut['po_count_check'];
              }
            }
            if (checking == false) {
              if (statusCountDataGridCard == '0') {
                countDataGridCardNUMBER2 = dataConut['po_count_check'];
                checkCount(countDataGridCardNUMBER1.toString(),
                    countDataGridCardNUMBER2.toString());
              }
            }
            // isFirstLoad = false;
            print('statusCountDataGridCard : $statusCountDataGridCard');
            print('messageCountDataGridCard : $messageCountDataGridCard');
            print('countDataGridCardNUMBER1 : $countDataGridCardNUMBER1');
            print('countDataGridCardNUMBER2 : $countDataGridCardNUMBER2');
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print(
            'ดึงข้อมูลล้มเหลว.countDataGridCard  รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error countDataGridCard: $e');
    }
  }

  void checkCount(
      String countDataGridCardNUMBER1, String countDataGridCardNUMBER2) {
    int count1 = int.parse(countDataGridCardNUMBER1);
    int count2 = int.parse(countDataGridCardNUMBER2);
    int floorDivision = 0;
    int multiplication = 0;
    int limitPage = 5;
    String lastURL = '';

    if (count1 == count2) {
      fetchData(urlLoad);
      print('จำนวนเท่ากัน โหลดข้อมูลหน้าเดิม');
    } else if (count1 > count2) {
      //
      print('จำนวนไม่เท่ากัน ข้อมูลถูกลบ');
    } else if (count1 < count2) {
      floorDivision = count2 ~/ limitPage;
      print('floorDivision = ${count2 ~/ limitPage}');

      multiplication = floorDivision * limitPage;
      print('multiplication = ${floorDivision * limitPage}');

      if (multiplication >= limitPage) {
        lastURL =
            '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_3_DataGrid/${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/${widget.docNo}/${widget.docType}';

        if (lastURL != '') {
          print(
              'โหลดหน้าสุดท้าย : ${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_3_DataGrid/${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/${widget.docNo}/${widget.docType}');
          fetchData(lastURL);
          countDataGridCard(true);
        }
      } else {
        fetchData(urlLoad);
      }
      print('จำไม่เท่ากัน ข้อมูลถูกเพิ่ม');
    }
    lastURL = '';
  }

  Future<void> updatePackQty(
      int packQty, String itemCode, String packCode, String rowID) async {
    print('packQty in updatePackQty: $packQty type : ${packQty.runtimeType}');
    final url =
        '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_UpdatePackQty';

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
        '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_deleteCardGrid';

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
                  await fetchData(urlLoad);
                  await countDataGridCard(true);
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
        '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_DeleteCardAll';

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
                setState(() async {
                  Navigator.of(context).pop();
                  await fetchData();
                  await countDataGridCard(true);
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
      appBar: CustomAppBar(
          title: 'รับคืนจากการเบิกเพื่อผลผลิต', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Ssfgdt09lPickingSlip(
                                pMoDoNO: widget.moDoNo,
                                pDocNo: widget.docNo,
                              )),
                    ).then((value) async {
                      showRecordRRR = 0;
                      await fetchData(urlLoad);
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => Ssfgdt09lVerify(
                    //             pErpOuCode: globals.P_ERP_OU_CODE,
                    //             pOuCode: globals.P_OU_CODE,
                    //             docNo: widget.docNo,
                    //             docType: widget.docType,
                    //             docDate: widget.docDate,
                    //             moDoNo: widget.moDoNo,
                    //             pWareCode: widget.pWareCode,
                    //           )),
                    // ).then((value) async {
                    //   showRecordRRR = 0;
                    //   await fetchData();
                    // });
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
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        // flex: 5,
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
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
                      // Expanded(
                      //   flex: 3,
                      //   child: Container(
                      //     padding: const EdgeInsets.all(12.0),
                      //     decoration: BoxDecoration(
                      //       color: Colors.yellow[200], // พื้นหลังสีเหลืองอ่อน
                      //       border: Border.all(
                      //         color: Colors.black, // ขอบสีดำ
                      //         width: 2.0, // ความกว้างของขอบ 2.0
                      //       ),
                      //       borderRadius: BorderRadius.circular(
                      //           8.0), // เพิ่มมุมโค้งให้กับ Container
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         widget.moDoNo,
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 14, // ปรับขนาดตัวอักษรตามที่ต้องการ
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // --------------------------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            style: ButtonStyles.createButtonStyle,
                            onPressed: () async {
                              // await Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => Ssfgdt09lBarcode(
                              //             pWareCode: widget.pWareCode,
                              //             pErpOuCode: globals.P_ERP_OU_CODE,
                              //             pOuCode: globals.P_OU_CODE,
                              //             pAttr1: widget.pAttr1,
                              //             pAppUser: widget.pAppUser,
                              //             pDocNo: widget.docNo,
                              //             pDocType: widget.docType,
                              //             pDocDate: widget.docDate,
                              //             pMoDoNO: widget.moDoNo,
                              //           )),
                              // ).then((value) async {
                              //   // เมื่อกลับมาหน้าเดิม เรียก fetchData
                              //   await countDataGridCard(false);
                              // });
                            },
                            child: ButtonStyles.createButtonContent(),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // --------------------------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            style: ButtonStyles.createButtonStyle,
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
                            child: ButtonStyles.deleteButtonContent(),
                          ),
                        ],
                      ),
                      // --------------------------------------------------------------------
                    ],
                  ),
                  const SizedBox(height: 8),
                  // ข้อมูลที่ต้องการแสดงใน ListView
                  isLoading
                      ? Center(child: LoadingIndicator())
                      : dataCard.isEmpty
                          ? const Column(
                              children: [
                                SizedBox(height: 60.0),
                                Center(child: CenteredMessage())
                              ],
                            )
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
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 6,
                                                    child: SizedBox(
                                                      child: Row(
                                                        // mainAxisAlignment:
                                                        //     MainAxisAlignment
                                                        //         .start,
                                                        children: [
                                                          const Text(
                                                            'จำนวนที่จ่าย : ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.0),
                                                          ),
                                                          CustomContainerStyles
                                                              .styledContainer(
                                                            item['pack_qty']
                                                                .toString(), // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                            child: Text(
                                                              NumberFormat(
                                                                      '#,###,###,###,###,###')
                                                                  .format(item[
                                                                          'pack_qty'] ??
                                                                      ''),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  // const SizedBox(width: 4.0),
                                                  Expanded(
                                                    flex: 4,
                                                    child: SizedBox(
                                                      child: Row(
                                                        // mainAxisAlignment:
                                                        //     MainAxisAlignment
                                                        //         .end,
                                                        children: [
                                                          const Text(
                                                            'Pack : ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.0),
                                                          ),
                                                          CustomContainerStyles
                                                              .styledContainer(
                                                            item[
                                                                'pack_code'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                            child: Text(
                                                              item['pack_code'] ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item[
                                                          'location_code'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                      child: Text(
                                                        item['location_code'] ??
                                                            '',
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item[
                                                          'pd_location'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                      child: Text(
                                                        item['pd_location'] ??
                                                            '',
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
                                                  mainAxisSize: MainAxisSize
                                                      .min, // ให้ Row ใช้ขนาดที่จำเป็น
                                                  children: [
                                                    const Text(
                                                      'Reason : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    Flexible(
                                                      // ใช้ Flexible แทน Expanded เพื่อให้ขยายตามขนาดที่จำเป็น
                                                      child:
                                                          CustomContainerStyles
                                                              .styledContainer(
                                                        item['reason_mismatch'],
                                                        child: Text(
                                                          item['reason_mismatch'] ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      14.0),
                                                          softWrap:
                                                              true, // เปิดให้ตัดบรรทัดเมื่อความยาวเกิน
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item[
                                                          'attribute3'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                      child: Text(
                                                        item['attribute3'] ??
                                                            '',
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item[
                                                          'attribute4'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                      child: Text(
                                                        item['attribute4'] ??
                                                            '',
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        String messageDelete =
                                                            'ต้องการลบรายการหรือไม่ ?';

                                                        showDialogComfirmDelete(
                                                          context,
                                                          item['seq']
                                                              .toString(),
                                                          item['item_code'] ??
                                                              '',
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
                                                        item['nb_item_name'] ??
                                                            '',
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
                            ),

                  // =======================================================  dataCard.length > 1
                  !isLoading
                      ? dataCard.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    prevLink != null
                                        ? ElevatedButton(
                                            onPressed: prevLink != null
                                                ? loadPrevPage
                                                : null,
                                            style: ButtonStyles
                                                .previousButtonStyle,
                                            child: ButtonStyles
                                                .previousButtonContent,
                                          )
                                        : ElevatedButton(
                                            onPressed: prevLink != null
                                                ? loadPrevPage
                                                : null,
                                            style: DisableButtonStyles
                                                .disablePreviousButtonStyle,
                                            child: DisableButtonStyles
                                                .disablePreviousButtonContent,
                                          )
                                  ],
                                ),
                                // const SizedBox(width: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        '${showRecordRRR == 0 ? '1' : showRecordRRR + 1} - ${showRecordRRR == 0 ? dataCard.length : showRecordRRR + dataCard.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                // const SizedBox(width: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    nextLink != null
                                        ? ElevatedButton(
                                            onPressed: nextLink != null
                                                ? loadNextPage
                                                : null,
                                            style: ButtonStyles.nextButtonStyle,
                                            child: ButtonStyles
                                                .nextButtonContent(),
                                          )
                                        : ElevatedButton(
                                            onPressed: null,
                                            style: DisableButtonStyles
                                                .disableNextButtonStyle,
                                            child: DisableButtonStyles
                                                .disablePreviousButtonContent,
                                          ),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox.shrink()
                      : const SizedBox.shrink(),
                  // =======================================================  dataCard.length > 1
                ],
              ),
            ),
            // =======================================================  dataCard.length == 1
            // dataCard.length == 1
            //     ? Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               prevLink != null
            //                   ? ElevatedButton.icon(
            //                       onPressed:
            //                           prevLink != null ? loadPrevPage : null,
            //                       icon: const Icon(
            //                           MyIcons.arrow_back_ios_rounded,
            //                           color: Colors.black),
            //                       label: const Text(
            //                         'Previous',
            //                         style: TextStyle(color: Colors.black),
            //                       ),
            //                       style: AppStyles.PreviousButtonStyle(),
            //                     )
            //                   : ElevatedButton.icon(
            //                       onPressed: null,
            //                       icon: const Icon(
            //                           MyIcons.arrow_back_ios_rounded,
            //                           color: Color.fromARGB(255, 23, 21, 59)),
            //                       label: const Text(
            //                         'Previous',
            //                         style: TextStyle(
            //                             color: Color.fromARGB(255, 23, 21, 59)),
            //                       ),
            //                       style: AppStyles.DisablePreviousButtonStyle(),
            //                     ),
            //             ],
            //           ),
            //           // const SizedBox(width: 30),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Center(
            //                 child: Text(
            //                   '${showRecordRRR == 0 ? '1' : showRecordRRR + 1} - ${showRecordRRR == 0 ? dataCard.length : showRecordRRR + dataCard.length}',
            //                   style: const TextStyle(
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //           // const SizedBox(width: 30),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.end,
            //             children: [
            //               nextLink != null
            //                   ? ElevatedButton(
            //                       onPressed:
            //                           nextLink != null ? loadNextPage : null,
            //                       style: AppStyles.NextRecordDataButtonStyle(),
            //                       child: const Row(
            //                         mainAxisSize: MainAxisSize.min,
            //                         children: [
            //                           Text(
            //                             'Next',
            //                             style: TextStyle(color: Colors.black),
            //                           ),
            //                           SizedBox(width: 7),
            //                           Icon(MyIcons.arrow_forward_ios_rounded,
            //                               color: Colors.black),
            //                         ],
            //                       ),
            //                     )
            //                   : ElevatedButton(
            //                       onPressed: null,
            //                       style: AppStyles
            //                           .DisableNextRecordDataButtonStyle(),
            //                       child: const Row(
            //                         mainAxisSize: MainAxisSize.min,
            //                         children: [
            //                           Text(
            //                             'Next',
            //                             style: TextStyle(
            //                                 color: Color.fromARGB(
            //                                     255, 23, 21, 59)),
            //                           ),
            //                           SizedBox(width: 7),
            //                           Icon(MyIcons.arrow_forward_ios_rounded,
            //                               color:
            //                                   Color.fromARGB(255, 23, 21, 59)),
            //                         ],
            //                       ),
            //                     ),
            //             ],
            //           ),
            //         ],
            //       )
            //     : const SizedBox.shrink(),
            // ======================================================= dataCard.length == 1
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: 'show',
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
                              fetchData(urlLoad);
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
                            await fetchData(urlLoad);
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
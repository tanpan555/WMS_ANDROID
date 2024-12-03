import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:intl/intl.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/centered_message.dart';
// import 'SSFGDT12_main.dart';
import 'SSFGDT12_barcode.dart';

class Ssfgdt12Grid extends StatefulWidget {
  // final String pOuCode;
  // final String browser_language;
  final String nbCountStaff;
  final String nbCountDate;
  final String docNo;
  final String status;
  // final String browser_language;
  final String wareCode; // ware code ที่มาจาก API แต่เป็น null
  final String pErpOuCode;
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final String docDate;
  final String countStaff;
  final String p_attr1;
  final String? statuForCHK;
  Ssfgdt12Grid({
    Key? key,
    required this.nbCountStaff,
    required this.nbCountDate,
    required this.docNo,
    required this.status,
    // required this.browser_language,
    required this.wareCode,
    required this.pErpOuCode,
    required this.pWareCode,
    required this.docDate,
    required this.countStaff,
    required this.p_attr1,
    this.statuForCHK,
  }) : super(key: key);
  @override
  _Ssfgdt12GridState createState() => _Ssfgdt12GridState();
}

class _Ssfgdt12GridState extends State<Ssfgdt12Grid> {
  List<dynamic> dataCard = []; // data ของ card ทั้งหมด
  List<dynamic> dataCheck = []; // check data ก็กดยื่นยันคลังสินค้า
  List<dynamic> dataSubmit = []; //
  int vCouQty = 0; // เก็บค่า v_cou_qty
  String appUser = globals.APP_USER;
  String selectedStatusSubmit = 'ให้จำนวนนับเป็นศูนย์';
  String statusCondition = '1';
  String conditionNull = 'null';
  String statusSubmit = '';
  String messageSubmit = '';
  List<dynamic> dropdownStatusSubmit = [
    {
      'd': 'ให้จำนวนนับเป็นศูนย์',
      'r': '1',
    },
    {
      'd': 'ให้จำนวนนับเท่ากับในระบบ',
      'r': '2',
    },
  ];
  String statusCancel = '';
  String messageCancel = '';
  String vRetCancel = '';
  String vChkStatusCancel = '';

  String statusForCheck = '';

  bool isLoading = true;
  String? nextLink = '';
  String? prevLink = '';

  String urlLoad = '';
  int showRecordRRR = 0;

  // --------------------------------------\\
  bool checkUpdateData = false;
  // --------------------------------------\\

  TextEditingController dataLovStatusConfirmSubmitController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    selectStatusForCheck();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData([String? url]) async {
    isLoading = true;
    final String requestUrl = url ??
        '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_3_SelectDataGridCard/${globals.P_ERP_OU_CODE}/${widget.docNo}/${globals.BROWSER_LANGUAGE}';
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
            urlLoad = url ??
                '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_3_SelectDataGridCard/${globals.P_ERP_OU_CODE}/${widget.docNo}/${globals.BROWSER_LANGUAGE}';
            if (url.toString().isNotEmpty) {
              extractLastNumberFromUrl(url.toString() ==
                      '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_3_SelectDataGridCard/${globals.P_ERP_OU_CODE}/${widget.docNo}/${globals.BROWSER_LANGUAGE}'
                  ? 'null'
                  : url.toString());
            }
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            print('Failed to load data: ${response.statusCode}');
          });
        }
        print('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
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

  Future<void> checkData() async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_3_CheckDataGrid/${globals.P_ERP_OU_CODE}/${widget.docNo}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataBarcodeList =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = dataBarcodeList['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          //

          //
          print('Fetched dataBarcodeList: $jsonDecode');
          if (mounted) {
            setState(() {
              vCouQty = item['v_cou_qty'] ?? '';
              vCouQty != ''
                  ? checkVCouQty(context, vCouQty)
                  : print('vCouQty == null ');
              print('vCouQty : $vCouQty type : ${vCouQty.runtimeType}');
            });
          }
        } else {
          print('No items found.');
        }
      } else {
        print(
            'dataBarcodeList  Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataBarcodeList Error: $e');
    }
  }

  void checkVCouQty(
    BuildContext context,
    int vCouQty,
  ) {
    if (vCouQty == 0) {
      showDialogconfirm(context);
    } else {
      showDialogCONFIRMCOUNT();
    }
  }

  Future<void> submitData(String condition) async {
    final url =
        '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_3_SubmitData';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'P_ERP_OU_CODE': widget.pErpOuCode,
      'p_doc_no': widget.docNo,
      'p_doc_date': widget.docDate,
      'p_nb_count_date': widget.nbCountDate,
      'p_count_staff': widget.countStaff,
      'p_nb_count_staff': widget.nbCountStaff,
      'p_condition': condition,
      'p_app_user': appUser,
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
            statusSubmit = dataSubmit['po_status'];
            messageSubmit = dataSubmit['po_message'];
            checkStatusSubmit(
              context,
              statusSubmit,
              messageSubmit,
            );
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

  Future<void> updateDataGridDetail(int updatedCountQty, String updatedRemark,
      String erp_ou_code, String doc_no, int seq) async {
    final url =
        '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_3_UpdateDataGridCrad';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'count_qty': updatedCountQty == 0 ? 'null' : updatedCountQty.toString(),
      'remark': updatedRemark.isNotEmpty ? updatedRemark : 'null',
      'app_user': globals.APP_USER,
      'erp_ou_code': erp_ou_code,
      'doc_no': doc_no,
      'seq': seq.toString(),
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
      print('updateDataGridDetail Error: $e');
    }
  }

  Future<void> cancelGrid(String pDocNO) async {
    final url =
        '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_3_CancelGrid';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_doc_no': pDocNO,
      'p_erp_ou_code': widget.pErpOuCode,
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
            statusCancel = dataSubmit['po_status'];
            messageCancel = dataSubmit['po_message'];
            vRetCancel = dataSubmit['v_ret'];
            vChkStatusCancel = dataSubmit['po_chk_status'];
            showDialogCancelSucceed(
                statusCancel, messageCancel, vRetCancel, vChkStatusCancel);
            // fetchData();
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

  Future<void> selectStatusForCheck() async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_3_SelectStatusForCheck/${widget.docNo}'));

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataStatusForCheck = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print(
            'dataStatusForCheck : $dataStatusForCheck type : ${dataStatusForCheck.runtimeType}');
        if (mounted) {
          setState(() {
            statusForCheck = dataStatusForCheck['status'] ?? '';
            print(
                'statusForCheck : $statusForCheck   Type : ${statusForCheck.runtimeType}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ผลการตรวจนับ', showExitWarning: false),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: isLoading
            ? Center(child: LoadingIndicator())
            : dataCard.isEmpty
                ? const Center(child: CenteredMessage())
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (statusForCheck != 'X') ...[
                            ElevatedButton(
                              onPressed: () {
                                showDialogconfirmCancel(
                                  context,
                                  widget.docNo,
                                );
                              },
                              style: AppStyles.cancelButtonStyle(),
                              child: Text('ยกเลิก',
                                  style: AppStyles.CancelbuttonTextStyle()),
                            ),
                          ],
                          ElevatedButton(
                            onPressed: () {
                              _navigateToPage(
                                  context,
                                  Ssfgdt12Barcode(
                                    nbCountStaff: widget.nbCountStaff,
                                    nbCountDate: widget.nbCountDate,
                                    docNo: widget.docNo,
                                    status: widget.status,
                                    wareCode: widget.wareCode,
                                    pErpOuCode: widget.pErpOuCode,
                                    pWareCode: widget.pWareCode,
                                    docDate: widget.docDate,
                                    countStaff: widget.countStaff,
                                    p_attr1: widget.p_attr1,
                                  )
                                  //
                                  );
                            },
                            style: AppStyles.cancelButtonStyle(),
                            child: Text('บันทึกสินค้าเพิ่มเติม',
                                style: AppStyles.CancelbuttonTextStyle()),
                          ),
                          if (statusForCheck == 'N' ||
                              statusForCheck == 'T' ||
                              statusForCheck == 'X') ...[
                            ElevatedButton(
                              onPressed: () async {
                                await checkData();
                              },
                              style: AppStyles.ConfirmbuttonStyle(),
                              child: Text(
                                'ยืนยัน',
                                style: AppStyles.ConfirmbuttonTextStyle(),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
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
                              fontSize: 20, // ปรับขนาดตัวอักษรตามที่ต้องการ
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          //
                          // children: dataCard.map((item) {
                          //   return Card(
                          //     elevation: 8.0,
                          //     margin: EdgeInsets.symmetric(vertical: 8.0),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(
                          //           15.0), // กำหนดมุมโค้งของ Card
                          //     ),
                          //     color: Color.fromRGBO(204, 235, 252, 1.0),
                          //     child: InkWell(
                          //       onTap: () {},
                          //       borderRadius: BorderRadius.circular(
                          //           15.0), // กำหนดมุมโค้งให้ InkWell เช่นกัน
                          //       child: Stack(
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.all(
                          //                 16.0), // เพิ่ม padding เพื่อให้ content ไม่ชิดขอบ
                          //             child: Column(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 Container(
                          //                   decoration: const BoxDecoration(
                          //                     border: Border(
                          //                       bottom: BorderSide(
                          //                         color: Colors.grey, // สีของเส้น
                          //                         width: 1.0, // ความหนาของเส้น
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   child: Row(
                          //                     mainAxisAlignment:
                          //                         MainAxisAlignment.center,
                          //                     children: [
                          //                       Text(
                          //                         'รหัสสินค้า : ${item['item_code']}',
                          //                         style: const TextStyle(
                          //                             fontSize: 18,
                          //                             fontWeight: FontWeight.bold),
                          //                       ),
                          //                       // IconButton(
                          //                       //   icon: const Icon(Icons.close),
                          //                       //   onPressed: () {
                          //                       //     Navigator.of(context).pop();
                          //                       //   },
                          //                       // ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 const SizedBox(height: 8),
                          //                 // Text(
                          //                 //   'รหัสสินค้า : ${item['item_code']}',
                          //                 //   style: const TextStyle(
                          //                 //       fontWeight: FontWeight.bold,
                          //                 //       fontSize: 18.0),
                          //                 // ),
                          //                 SizedBox(
                          //                   child: Row(
                          //                     children: [
                          //                       Text(
                          //                         'ชื่อสินค้า : ',
                          //                         style: TextStyle(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 14.0),
                          //                       ),
                          //                       Container(
                          //                         padding: EdgeInsets.all(3.0),
                          //                         color: Colors.white,
                          //                         child: Text(
                          //                           item['get_item_name'],
                          //                           style: const TextStyle(
                          //                               fontSize: 14.0),
                          //                         ),
                          //                       ),
                          //                       // Text(
                          //                       //   item['get_item_name'],
                          //                       //   style: TextStyle(fontSize: 14.0),
                          //                       // ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 const SizedBox(height: 4),
                          //                 SizedBox(
                          //                   child: Row(
                          //                     children: [
                          //                       Text(
                          //                         'จำนวนคงเหลือในระบบ : ',
                          //                         style: TextStyle(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 14.0),
                          //                       ),
                          //                       Container(
                          //                         padding: EdgeInsets.all(5.0),
                          //                         color: Colors.white,
                          //                         child: Text(
                          //                           NumberFormat(
                          //                                   '#,###,###,###,###,###.##')
                          //                               .format(item['sys_qty']),
                          //                           style: const TextStyle(
                          //                               fontSize: 14.0),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 const SizedBox(height: 4),
                          //                 SizedBox(
                          //                   child: Row(
                          //                     children: [
                          //                       Text(
                          //                         'ผลต่างการตรวจนับ : ',
                          //                         style: TextStyle(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 14.0),
                          //                       ),
                          //                       Container(
                          //                         padding: EdgeInsets.all(5.0),
                          //                         color: Colors.white,
                          //                         child: Text(
                          //                           NumberFormat(
                          //                                   '#,###,###,###,###,###.##')
                          //                               .format(item['diff_qty']),
                          //                           style: const TextStyle(
                          //                               fontSize: 14.0),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 const SizedBox(height: 4),
                          //                 SizedBox(
                          //                   child: Row(
                          //                     // mainAxisAlignment:
                          //                     //     MainAxisAlignment.spaceBetween,
                          //                     children: [
                          //                       Text(
                          //                         'คลังสินค้า : ',
                          //                         style: TextStyle(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 14.0),
                          //                       ),
                          //                       Container(
                          //                         padding: EdgeInsets.all(5.0),
                          //                         color: Colors.white,
                          //                         child: Text(
                          //                           item['ware_code'],
                          //                           style: const TextStyle(
                          //                               fontSize: 14.0),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 const SizedBox(height: 4),
                          //                 SizedBox(
                          //                   child: Row(
                          //                     // mainAxisAlignment:
                          //                     // MainAxisAlignment.spaceBetween,
                          //                     children: [
                          //                       Text(
                          //                         'ตำแหน่งจัดเก็บ : ',
                          //                         style: TextStyle(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 14.0),
                          //                       ),
                          //                       Container(
                          //                         padding: EdgeInsets.all(5.0),
                          //                         color: Colors.white,
                          //                         child: Text(
                          //                           item['location_code'],
                          //                           style: const TextStyle(
                          //                               fontSize: 14.0),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 // const SizedBox(height: 4),
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.end,
                          //                   children: [
                          //                     IconButton(
                          //                       iconSize: 10.0,
                          //                       icon: Image.asset(
                          //                         'assets/images/edit.png',
                          //                         width: 20.0,
                          //                         height: 20.0,
                          //                       ),
                          //                       onPressed: () {
                          //                         showDetailsDialog(
                          //                           context,
                          //                           item['sys_qty'].toDouble(),
                          //                           item['diff_qty'].toDouble(),
                          //                           // double.parse(item['diff_qty']),
                          //                           item['rowid'],
                          //                           item['count_qty'] ?? 0,
                          //                           item['remark'] ?? '',
                          //                           widget.docNo,
                          //                           widget.pErpOuCode,
                          //                           item['seq'],
                          //                           item['item_code'],
                          //                         );
                          //                       },
                          //                     ),
                          //                   ],
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //           // Positioned(
                          //           //   bottom: 0.4,
                          //           //   right: 8.0,
                          //           //   child: GestureDetector(
                          //           //     onTap: () {},
                          //           //     child: IconButton(
                          //           //       iconSize: 20.0,
                          //           //       icon: Image.asset(
                          //           //         'assets/images/edit.png',
                          //           //         width: 20.0,
                          //           //         height: 20.0,
                          //           //       ),
                          //           //       onPressed: () {
                          //           //         showDetailsDialog(
                          //           //           context,
                          //           //           item['sys_qty'].toDouble(),
                          //           //           item['diff_qty'].toDouble(),
                          //           //           // double.parse(item['diff_qty']),
                          //           //           item['rowid'],
                          //           //           item['count_qty'] ?? 0,
                          //           //           item['remark'] ?? '',
                          //           //           widget.docNo,
                          //           //           widget.pErpOuCode,
                          //           //           item['seq'],
                          //           //           item['item_code'],
                          //           //         );
                          //           //       },
                          //           //     ),
                          //           //   ),
                          //           // ),
                          //         ],
                          //       ),
                          //     ),
                          //   );
                          // }).toList(),

                          ///////////////////////////////////////////////////
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(), // เพื่อให้ทำงานร่วมกับ ListView ด้านนอกได้
                              itemCount: dataCard.length,
                              itemBuilder: (context, index) {
                                // ดึงข้อมูลรายการจาก dataCard
                                var item = dataCard[index];
                                return Card(
                                  elevation: 8.0,
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15.0), // กำหนดมุมโค้งของ Card
                                  ),
                                  color: Color.fromRGBO(204, 235, 252, 1.0),
                                  child: InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(
                                        15.0), // กำหนดมุมโค้งให้ InkWell เช่นกัน
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              16.0), // เพิ่ม padding เพื่อให้ content ไม่ชิดขอบ
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors
                                                          .grey, // สีของเส้น
                                                      width:
                                                          1.0, // ความหนาของเส้น
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'รหัสสินค้า : ${item['item_code']}',
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'ลำดับ : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item['seq']
                                                          .toString(), // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                      child: Text(
                                                        item['seq'].toString(),
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              SizedBox(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize
                                                      .min, // ให้ Row ใช้ขนาดที่จำเป็น
                                                  children: [
                                                    const Text(
                                                      'ชื่อสินค้า : ',
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
                                                        item['get_item_name'],
                                                        child: Text(
                                                          item['get_item_name'] ??
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
                                              const SizedBox(height: 4),
                                              SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'คลังสินค้า : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item[
                                                          'ware_code'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                      child: Text(
                                                        item['ware_code'] ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  // MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'ตำแหน่งจัดเก็บ : ',
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
                                              const SizedBox(height: 4),
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'จำนวนคงเหลือในระบบ : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item['sys_qty']
                                                          ?.toString(),
                                                      child: Text(
                                                        item['sys_qty'] != null
                                                            ? NumberFormat(
                                                                    '#,###,###,###,###,###.##')
                                                                .format(item[
                                                                    'sys_qty'])
                                                            : '',
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'ผลต่างการตรวจนับ : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item['diff_qty']
                                                          ?.toString(),
                                                      child: Text(
                                                        item['diff_qty'] != null
                                                            ? NumberFormat(
                                                                    '#,###,###,###,###,###.##')
                                                                .format(item[
                                                                    'diff_qty'])
                                                            : '',
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'จำนวนที่ตรวจนับได้ได้รับ : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item['count_qty']
                                                          ?.toString(),
                                                      child: Text(
                                                        item['count_qty'] !=
                                                                null
                                                            ? NumberFormat(
                                                                    '#,###,###,###,###,###.##')
                                                                .format(item[
                                                                    'count_qty'])
                                                            : '',
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              SizedBox(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize
                                                      .min, // ให้ Row ใช้ขนาดที่จำเป็น
                                                  children: [
                                                    const Text(
                                                      'หมายเหตุสินค้า : ',
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
                                                        item['remark'],
                                                        child: Text(
                                                          item['remark'] ?? '',
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
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    // flex: 5,
                                                    child: SizedBox(
                                                      child: Row(
                                                        // mainAxisAlignment:
                                                        //     MainAxisAlignment
                                                        //         .start,
                                                        children: [
                                                          const Text(
                                                            'หน่วยนับ : ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.0),
                                                          ),
                                                          CustomContainerStyles
                                                              .styledContainer(
                                                            item['ums_code']
                                                                .toString(), // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                            child: Text(
                                                              item['ums_code'],
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
                                                  // Expanded(
                                                  //   flex: 5,
                                                  //   child: SizedBox(
                                                  //     child: Row(
                                                  //       // mainAxisAlignment:
                                                  //       //     MainAxisAlignment
                                                  //       //         .end,
                                                  //       children: [
                                                  //         const Text(
                                                  //           '',
                                                  //           style: TextStyle(
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .bold,
                                                  //               fontSize: 14.0),
                                                  //         ),
                                                  //         CustomContainerStyles
                                                  //             .styledContainer(
                                                  //           item[
                                                  //               'get_ums_name'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                  //           child: Text(
                                                  //             item['get_ums_name'] ??
                                                  //                 '',
                                                  //             style:
                                                  //                 const TextStyle(
                                                  //                     fontSize:
                                                  //                         14.0),
                                                  //           ),
                                                  //         ),
                                                  //       ],
                                                  //     ),
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              if (statusForCheck == 'T' ||
                                                  statusForCheck == 'N') ...[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      iconSize: 10.0,
                                                      icon: Image.asset(
                                                        'assets/images/edit.png',
                                                        width: 40.0,
                                                        height: 40.0,
                                                      ),
                                                      onPressed: () {
                                                        showDetailsDialog(
                                                          context,
                                                          item['sys_qty']
                                                              .toDouble(),
                                                          item['diff_qty']
                                                              .toDouble(),
                                                          // double.parse(item['diff_qty']),
                                                          item['rowid'],
                                                          item['count_qty'] ??
                                                              0,
                                                          item['remark'] ?? '',
                                                          widget.docNo,
                                                          widget.pErpOuCode,
                                                          item['seq'],
                                                          item['item_code'],
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                )
                                              ]
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
                            dataCard.isNotEmpty
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          nextLink != null
                                              ? ElevatedButton(
                                                  onPressed: nextLink != null
                                                      ? loadNextPage
                                                      : null,
                                                  style: ButtonStyles
                                                      .nextButtonStyle,
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
                      //                       onPressed: prevLink != null
                      //                           ? loadPrevPage
                      //                           : null,
                      //                       icon: const Icon(
                      //                           MyIcons.arrow_back_ios_rounded,
                      //                           color: Colors.black),
                      //                       label: const Text(
                      //                         'Previous',
                      //                         style: TextStyle(
                      //                             color: Colors.black),
                      //                       ),
                      //                       style:
                      //                           AppStyles.PreviousButtonStyle(),
                      //                     )
                      //                   : ElevatedButton.icon(
                      //                       onPressed: null,
                      //                       icon: const Icon(
                      //                           MyIcons.arrow_back_ios_rounded,
                      //                           color: Color.fromARGB(
                      //                               255, 23, 21, 59)),
                      //                       label: const Text(
                      //                         'Previous',
                      //                         style: TextStyle(
                      //                             color: Color.fromARGB(
                      //                                 255, 23, 21, 59)),
                      //                       ),
                      //                       style: AppStyles
                      //                           .DisablePreviousButtonStyle(),
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
                      //                       onPressed: nextLink != null
                      //                           ? loadNextPage
                      //                           : null,
                      //                       style: AppStyles
                      //                           .NextRecordDataButtonStyle(),
                      //                       child: const Row(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         children: [
                      //                           Text(
                      //                             'Next',
                      //                             style: TextStyle(
                      //                                 color: Colors.black),
                      //                           ),
                      //                           SizedBox(width: 7),
                      //                           Icon(
                      //                               MyIcons
                      //                                   .arrow_forward_ios_rounded,
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
                      //                           Icon(
                      //                               MyIcons
                      //                                   .arrow_forward_ios_rounded,
                      //                               color: Color.fromARGB(
                      //                                   255, 23, 21, 59)),
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

  void showDetailsDialog(
    BuildContext context,
    double sys_qty,
    double diff_qty,
    String row_ID,
    int count_qty,
    String remark,
    String doc_no,
    String erp_ou_code,
    int seq,
    String item_code,
  ) {
    // String formattedSysQty =
    //     NumberFormat('#,###,###,###,###,###.##').format(sys_qty);
    // String formattedDiffQty =
    //     NumberFormat('#,###,###,###,###,###.##').format(diff_qty);
    String formattedCountQty =
        NumberFormat('#,###,###,###,###,###').format(count_qty);
    String formattedSeq = NumberFormat('#,###,###,###,###,###').format(seq);
    // TextEditingController sysQtyController =
    //     TextEditingController(text: formattedSysQty);
    // TextEditingController diffQtyController =
    //     TextEditingController(text: formattedDiffQty);
    TextEditingController countQtyController = TextEditingController(
        text: count_qty == 0 ? '' : formattedCountQty.toString());
    TextEditingController seqController =
        TextEditingController(text: formattedSeq.toString());
    TextEditingController itemCodeController =
        TextEditingController(text: item_code.toString());
    // TextEditingController countQtyController =
    //     TextEditingController(text: count_qty.toString());
    TextEditingController remarkController =
        TextEditingController(text: remark.toString());

    String checkCountQTY = count_qty.toString();
    String checkRemake = remark;

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
                            if (checkCountQTY.toString() !=
                                    count_qty.toString() ||
                                checkRemake != remark) {
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
                                controller: itemCodeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelText: 'รหัสสินค้า',
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
                    // const SizedBox(height: 8.0),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: GestureDetector(
                    //         child: AbsorbPointer(
                    //           child: TextFormField(
                    //             controller: sysQtyController,
                    //             readOnly: true,
                    //             decoration: InputDecoration(
                    //               border: InputBorder.none,
                    //               filled: true,
                    //               fillColor: Colors.grey[300],
                    //               labelText: 'จำนวนคงเหลือในระบบ',
                    //               labelStyle: const TextStyle(
                    //                 color: Colors.black87,
                    //               ),
                    //             ),
                    //             keyboardType: TextInputType.number,
                    //             textAlign: TextAlign.right,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 8.0),
                    //     Expanded(
                    //       child: GestureDetector(
                    //         child: AbsorbPointer(
                    //           child: TextFormField(
                    //             controller: diffQtyController,
                    //             readOnly: true,
                    //             decoration: InputDecoration(
                    //               border: InputBorder.none,
                    //               filled: true,
                    //               fillColor: Colors.grey[300],
                    //               labelText: 'ผลต่างการตรวจนับ',
                    //               labelStyle: const TextStyle(
                    //                 color: Colors.black87,
                    //               ),
                    //             ),
                    //             keyboardType: TextInputType.number,
                    //             textAlign: TextAlign.right,
                    //           ),
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: countQtyController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'จำนวนที่ตรวจได้',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      textAlign: TextAlign.right,
                      onChanged: (value) {
                        checkCountQTY = value;
                      },
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: remarkController,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'หมายเหตุสินค้า',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      onChanged: (value) {
                        checkRemake = value;
                      },
                    ),
                    const SizedBox(height: 8.0),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         Navigator.of(context).pop();
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.white,
                    //         side: const BorderSide(color: Colors.grey),
                    //       ),
                    //       child: const Text(
                    //         'ย้อนกลับ',
                    //       ),
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //         int updatedCountQty = int.tryParse(countQtyController
                    //                 .text
                    //                 .replaceAll(',', '')) ??
                    //             count_qty;
                    //         String updatedRemark =
                    //             remarkController.text.isNotEmpty
                    //                 ? remarkController.text
                    //                 : remark;

                    //         Navigator.of(context).pop();
                    //         await updateDataGridDetail(
                    //           updatedCountQty,
                    //           updatedRemark,
                    //           ou_code,
                    //           doc_no,
                    //           seq,
                    //         );
                    //         await fetchData();
                    //         setState(() {});
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.white,
                    //         side: const BorderSide(color: Colors.grey),
                    //       ),
                    //       child: const Text(
                    //         'บันทึก',
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: AppStyles.ConfirmChecRecievekButtonStyle(),
                          onPressed: () async {
                            int updatedCountQty = int.tryParse(
                                    countQtyController.text
                                        .replaceAll(',', '')) ??
                                0;
                            String updatedRemark =
                                remarkController.text.isNotEmpty
                                    ? remarkController.text
                                    : 'null';

                            Navigator.of(context).pop(true);
                            await updateDataGridDetail(
                              updatedCountQty,
                              updatedRemark,
                              erp_ou_code,
                              doc_no,
                              seq,
                            );
                            await fetchData(urlLoad);
                            setState(() {});
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
  }

  void showDialogconfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: const Text('ต้องการยืนยันตรวจนับ หรือไม่ !!!'),
          onClose: () => Navigator.of(context).pop(),
          onConfirm: () {
            submitData(conditionNull);
          },
        );
      },
    );
  }

  void showDialogCONFIRMCOUNT() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.displayTextFormFieldAndMessage(
          context: context,
          controller: dataLovStatusConfirmSubmitController,
          headTextDialog: 'แจ้งเตือน',
          labelText: 'สถานะ',
          message: 'ตรวจพบสินค้าที่ไม่ระบุจำนวนตรวจนับ',
          onTap: () => showDialogSelectDataStatusConfirmSubmit(),
          onCloseDialog: () {
            Navigator.of(context).pop();
          },
          onConfirmDialog: () {
            submitData(statusCondition);
          },
        );
      },
    );
  }

  void checkStatusSubmit(
    BuildContext context,
    String statusSubmit,
    String messageSubmit,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.notification_important,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'แจ้งเตือน',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      if (statusSubmit == '1') {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        //   _navigateToPage(
                        //       context,
                        //       SSFGDT12_MAIN(
                        //         p_attr1: widget.p_attr1,
                        //         pErpOuCode: widget.pErpOuCode,
                        //       )
                        //       //
                        //       );
                      }
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
                    messageSubmit,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (statusSubmit == '1')
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
                if (statusSubmit == '0')
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      //   _navigateToPage(
                      //       context,
                      //       SSFGDT12_MAIN(
                      //         p_attr1: widget.p_attr1,
                      //         pErpOuCode: widget.pErpOuCode,
                      //       )
                      //       //
                      //       );
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
        );
      },
    );
  }

  void showDialogconfirmCancel(
    BuildContext context,
    String pDocNO,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: const Text('ต้องการยกเลิกยืนยันตรวจนับ หรือไม่ !!!'),
          onClose: () => Navigator.of(context).pop(),
          onConfirm: () {
            cancelGrid(pDocNO);
          },
        );
      },
    );
  }

  void showDialogCancelSucceed(
    String statusCancel,
    String messageCancel,
    String vRetCancel,
    String vChkStatusCancel,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text(messageCancel),
          onClose: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          onConfirm: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            // fetchData();
            // _navigateToPage(
            //     context,
            //     SSFGDT12_MAIN(
            //       p_attr1: widget.p_attr1,
            //       pErpOuCode: widget.pErpOuCode,
            //     )
            //     //
            //     );
          },
        );
      },
    );
  }

  void showDialogSelectDataStatusConfirmSubmit() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customRequiredSelectLovDialog(
          context: context,
          headerText: 'สถานะ',
          data: dropdownStatusSubmit,
          displayItem: (item) => '${item['d'] ?? ''}',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              selectedStatusSubmit = item['d'];
              statusCondition = item['r'];
              dataLovStatusConfirmSubmitController.text = selectedStatusSubmit;
              // -----------------------------------------
              print(
                  'dataLovStatusConfirmSubmitController New: $dataLovStatusConfirmSubmitController Type : ${dataLovStatusConfirmSubmitController.runtimeType}');
              print(
                  'selectedStatusSubmit New: $selectedStatusSubmit Type : ${selectedStatusSubmit.runtimeType}');
              print(
                  'statusCondition New: $statusCondition Type : ${statusCondition.runtimeType}');
            });
          },
        );
      },
    );
  }

  void showExitWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogStyles.warningNotSaveDialog(
          context: context,
          textMessage: 'คุณต้องการออกจากหน้านี้โดยไม่บันทึกหรือไม่?',
          onCloseDialog: () {
            Navigator.of(context).pop();
          },
          onConfirmDialog: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

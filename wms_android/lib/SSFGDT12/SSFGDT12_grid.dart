import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:intl/intl.dart';
import 'package:wms_android/styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'SSFGDT12_main.dart';
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
  final List<String> dropdownStatusSubmit = [
    'ให้จำนวนนับเป็นศูนย์',
    'ให้จำนวนนับเท่ากับในระบบ',
  ];
  String statusCancel = '';
  String messageCancel = '';
  String vRetCancel = '';
  String vChkStatusCancel = '';

  bool isLoading = true;
  String? nextLink = '';
  String? prevLink = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    print(
        'nbCountStaff : ${widget.nbCountStaff} Type : ${widget.nbCountStaff.runtimeType}');
    print(
        'nbCountDate : ${widget.nbCountDate} Type : ${widget.nbCountDate.runtimeType}');
    print('docNo : ${widget.docNo} Type : ${widget.docNo.runtimeType}');
    print('status : ${widget.status} Type : ${widget.status.runtimeType}');
    print(
        'wareCode : ${widget.wareCode} Type : ${widget.wareCode.runtimeType}');
    print(
        'pErpOuCode : ${widget.pErpOuCode} Type : ${widget.pErpOuCode.runtimeType}');
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
        'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_3_SelectDataGridCard/${widget.pErpOuCode}/${widget.docNo}';
    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);

        setState(() {
          if (parsedResponse is Map && parsedResponse.containsKey('items')) {
            dataCard = parsedResponse['items'];
          } else {
            dataCard = [];
          }

          List<dynamic> links = parsedResponse['links'] ?? [];
          nextLink = getLink(links, 'next');
          prevLink = getLink(links, 'prev');
          isLoading = false;
        });
      } else {
        setState(() {
          print('Failed to load data: ${response.statusCode}');
        });
        print('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions that may occur
      setState(() {
        // isLoading = false;
        print('Error occurred: $e');
      });
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
        print('nextLink $nextLink');
        isLoading = true;
      });
      fetchData(nextLink);
    }
  }

  void loadPrevPage() {
    if (prevLink != '') {
      setState(() {
        isLoading = true;
      });
      fetchData(prevLink);
    }
  }

  Future<void> checkData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_3_CheckDataGrid/${widget.pErpOuCode}/${widget.docNo}'));

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
              vCouQty != null || vCouQty != ''
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
      showDialogconfirm();
    } else {
      showDialogCONFIRMCOUNT();
    }
  }

  Future<void> submitData(String condition) async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_3_SubmitData';

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
      String ou_code, String doc_no, int seq) async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_3_UpdateDataGridCrad';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'COUNT_QTY': updatedCountQty,
      'REMARK': updatedRemark,
      'ou_code': ou_code,
      'doc_no': doc_no,
      'seq': seq,
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
      print('Error: $e');
    }
  }

  Future<void> cancelGrid(String pDocNO) async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_3_CancelGrid';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'ผลการตรวจนับ'),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialogconfirmCancel(
                      widget.docNo,
                    );
                  },
                  style: AppStyles.cancelButtonStyle(),
                  child:
                      Text('ยกเลิก', style: AppStyles.CancelbuttonTextStyle()),
                ),
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
                ElevatedButton(
                  onPressed: () async {
                    await checkData();
                  },
                  style: AppStyles.ConfirmbuttonStyle(),
                  child: Text(
                    'Confirm',
                    style: AppStyles.ConfirmbuttonTextStyle(),
                  ),
                ),
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
                borderRadius:
                    BorderRadius.circular(8.0), // เพิ่มมุมโค้งให้กับ Container
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
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
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
                                                  color:
                                                      Colors.grey, // สีของเส้น
                                                  width: 1.0, // ความหนาของเส้น
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
                                                // IconButton(
                                                //   icon: const Icon(Icons.close),
                                                //   onPressed: () {
                                                //     Navigator.of(context).pop();
                                                //   },
                                                // ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // Text(
                                          //   'รหัสสินค้า : ${item['item_code']}',
                                          //   style: const TextStyle(
                                          //       fontWeight: FontWeight.bold,
                                          //       fontSize: 18.0),
                                          // ),
                                          SizedBox(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'ชื่อสินค้า : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                ),
                                                Expanded(
                                                  // หรือใช้ Flexible ก็ได้
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.all(3.0),
                                                    color: Colors.white,
                                                    child: Text(
                                                      item['get_item_name'],
                                                      style: const TextStyle(
                                                          fontSize: 14.0),
                                                      softWrap:
                                                          true, // เปิดให้ตัดบรรทัด
                                                      overflow: TextOverflow
                                                          .visible, // กำหนดการแสดงผลเมื่อข้อความยาวเกิน
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          SizedBox(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'จำนวนคงเหลือในระบบ : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  color: Colors.white,
                                                  child: Text(
                                                    NumberFormat(
                                                            '#,###,###,###,###,###.##')
                                                        .format(
                                                            item['sys_qty']),
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
                                                Text(
                                                  'ผลต่างการตรวจนับ : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  color: Colors.white,
                                                  child: Text(
                                                    NumberFormat(
                                                            '#,###,###,###,###,###.##')
                                                        .format(
                                                            item['diff_qty']),
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
                                              //     MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'คลังสินค้า : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  color: Colors.white,
                                                  child: Text(
                                                    item['ware_code'],
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
                                                Text(
                                                  'ตำแหน่งจัดเก็บ : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  color: Colors.white,
                                                  child: Text(
                                                    item['location_code'],
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                iconSize: 10.0,
                                                icon: Image.asset(
                                                  'assets/images/edit.png',
                                                  width: 20.0,
                                                  height: 20.0,
                                                ),
                                                onPressed: () {
                                                  showDetailsDialog(
                                                    context,
                                                    item['sys_qty'].toDouble(),
                                                    item['diff_qty'].toDouble(),
                                                    // double.parse(item['diff_qty']),
                                                    item['rowid'],
                                                    item['count_qty'] ?? 0,
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: prevLink != null ? loadPrevPage : null,
                              child: const Text('Previous'),
                            ),
                            ElevatedButton(
                              onPressed: nextLink != null ? loadNextPage : null,
                              child: const Text('Next'),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
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
    String ou_code,
    int seq,
    String item_code,
  ) {
    String formattedSysQty =
        NumberFormat('#,###,###,###,###,###.##').format(sys_qty);
    String formattedDiffQty =
        NumberFormat('#,###,###,###,###,###.##').format(diff_qty);
    String formattedCountQty =
        NumberFormat('#,###,###,###,###,###').format(count_qty);
    TextEditingController sysQtyController =
        TextEditingController(text: formattedSysQty);
    TextEditingController diffQtyController =
        TextEditingController(text: formattedDiffQty);
    TextEditingController countQtyController =
        TextEditingController(text: formattedCountQty.toString());
    // TextEditingController countQtyController =
    //     TextEditingController(text: count_qty.toString());
    TextEditingController remarkController =
        TextEditingController(text: remark.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('รหัสสินค้า $item_code'), // หัวเรื่องของ Dialog
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // จัดชิดซ้าย
                children: [
                  TextFormField(
                    controller: sysQtyController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'จำนวนคงเหลือในระบบ',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: diffQtyController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'ผลต่างการตรวจนับ',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: countQtyController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'จำนวนที่ตรวจได้',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: remarkController,
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
                  ),
                  const SizedBox(height: 8.0),
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
                        child: const Text(
                          'ย้อนกลับ',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          int updatedCountQty = int.tryParse(countQtyController
                                  .text
                                  .replaceAll(',', '')) ??
                              count_qty;
                          String updatedRemark =
                              remarkController.text.isNotEmpty
                                  ? remarkController.text
                                  : remark;

                          Navigator.of(context).pop();
                          await updateDataGridDetail(
                            updatedCountQty,
                            updatedRemark,
                            ou_code,
                            doc_no,
                            seq,
                          );
                          await fetchData();
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text(
                          'บันทึก',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [],
        );
      },
    );
  }

  void showDialogconfirm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.notification_important, // ใช้ไอคอนแจ้งเตือน
                  color: Colors.red, // สีของไอคอน
                ),
                SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                Text('แจ้งเตือน'), // ข้อความแจ้งเตือน
              ],
            ),
            content: const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('ต้องการยืนยันตรวจนับ หรือไม่ !!!'),
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
                    child: const Text(
                      'ย้อนกลับ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      submitData(conditionNull);
                      // Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text(
                      'ยืนยัน',
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  void showDialogCONFIRMCOUNT() {
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
              SizedBox(width: 8),
              Text('แจ้งเตือน'),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ตรวจพบสินค้าที่ไม่ระบุจำนวนนับ',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField2<String>(
                    value: selectedStatusSubmit,
                    isExpanded: true, // Ensures the dropdown takes full width
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black87,
                    ),
                    items: dropdownStatusSubmit
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'สถานะ',
                      labelStyle: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black87,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedStatusSubmit = value ?? '';
                        switch (selectedStatusSubmit) {
                          case 'ให้จำนวนนับเป็นศูนย์':
                            statusCondition = '1';
                            break;
                          case 'ให้จำนวนนับเท่ากับในระบบ':
                            statusCondition = '2';
                            break;
                          default:
                            statusCondition = 'Unknown';
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 8),
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
                  child: const Text(
                    'ย้อนกลับ',
                  ),
                ),
                const SizedBox(width: 8), // Add some spacing between buttons
                ElevatedButton(
                  onPressed: () {
                    submitData(statusCondition);
                    // Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text(
                    'ยืนยัน',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void checkStatusSubmit(
    BuildContext context,
    String statusSubmit,
    String messageSubmit,
  ) {
    IconData iconData;
    Color textColor;
    String statusText;

    switch (statusSubmit) {
      case '0':
        iconData = Icons.check_circle;
        textColor = Colors.black;
        statusText = 'Success';
        break;
      case '1':
        iconData = Icons.notification_important;
        textColor = Colors.red;
        statusText = 'Error';
        break;
      default:
        iconData = Icons.help;
        textColor = Colors.grey;
        statusText = 'Unknown';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                iconData,
                color: textColor,
              ),
              const SizedBox(width: 10),
              Text(
                statusText,
                style: TextStyle(color: textColor),
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
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    child: const Text('ย้อนกลับ'),
                  ),
                if (statusSubmit == '0')
                  ElevatedButton(
                    onPressed: () {
                      _navigateToPage(
                          context,
                          SSFGDT12_MAIN(
                            p_attr1: widget.p_attr1,
                            pErpOuCode: widget.pErpOuCode,
                          )
                          //
                          );
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
        );
      },
    );
  }

  void showDialogconfirmCancel(String pDocNO) {
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
                SizedBox(width: 8),
                Text('แจ้งเตือน'),
              ],
            ),
            content: const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('ต้องการยกเลิกยืนยันตรวจนับ หรือไม่ !!!'),
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
                    child: const Text(
                      'ย้อนกลับ',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      cancelGrid(pDocNO);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text(
                      'ยืนยัน',
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  void showDialogCancelSucceed(
    String statusCancel,
    String messageCancel,
    String vRetCancel,
    String vChkStatusCancel,
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
                SizedBox(width: 8),
                Text('แจ้งเตือน'),
              ],
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(messageCancel),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      fetchData();
                      // _navigateToPage(
                      //     context,
                      //     SSFGDT12_MAIN(
                      //       p_attr1: widget.p_attr1,
                      //       pErpOuCode: widget.pErpOuCode,
                      //     )
                      //     //
                      //     );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text(
                      'ยืนยัน',
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}

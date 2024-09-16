import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT09L_main.dart';

class Ssfgdt09lVerify extends StatefulWidget {
  final String pErpOuCode;
  final String pOuCode;
  final String docNo;
  final String docType;
  final String moDoNo;
  // final String pWareCode;
  // final String pAttr1;
  // // final String refNo;
  // final String pAppUser;
  // final String statusCase;
  Ssfgdt09lVerify({
    Key? key,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.docNo,
    required this.docType,
    required this.moDoNo,
    // required this.pWareCode,
    // required this.pAttr1,
    // // required this.refNo,
    // required this.pAppUser,
    // required this.statusCase,
  }) : super(key: key);
  @override
  _Ssfgdt09lVerifyState createState() => _Ssfgdt09lVerifyState();
}

class _Ssfgdt09lVerifyState extends State<Ssfgdt09lVerify> {
  List<dynamic> dataCard = [];

  String statusSubmit = '';
  String messageSubmit = '';

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
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_5_SelectDetailCard/${widget.pOuCode}/${widget.pErpOuCode}/${widget.docNo}/${widget.docType}'));

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

  Future<void> submitData() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_5_Submit';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_erp_ou_code': widget.pErpOuCode,
      'p_doc_no': widget.docNo,
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
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        print('data : $data type : ${data.runtimeType}');
        setState(() {
          statusSubmit = data['po_status'];
          messageSubmit = data['po_message'];
          print(
              'statusSubmit : $statusSubmit Type : ${statusSubmit.runtimeType}');
          print(
              'messageSubmit : $messageSubmit Type : ${messageSubmit.runtimeType}');

          if (statusSubmit == '1') {
            showDialogAlert(context, messageSubmit);
          }
          if (statusSubmit == '0') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SSFGDT09L_MAIN(
                        pAttr1: globals.ATTR1,
                        pErpOuCode: widget.pErpOuCode,
                        pOuCode: widget.pOuCode,
                      )),
            ).then((value) {
              fetchData();
            });
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
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                    // submitData();                  // รอ check จาก rujxyho ก่อน **************************************************
                  },
                ),
              ),
              // --------------------------------------------------------------------
            ],
          ),
          const SizedBox(height: 10),
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
                      widget.docNo,
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
          Expanded(
            child: ListView(
              children: dataCard.map((item) {
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Item : ${item['item_code'] ?? ''}',
                                style: TextStyle(color: Colors.black),
                              ),

                              SizedBox(height: 4.0),
                              Text(
                                'Lot No. : ${item['lots_no'] ?? ''}',
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
                                      'Locator : ${item['location_code'] ?? ''}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'จำนวนที่จ่าย : ${NumberFormat('#,###,###,###,###,###').format(item['pack_qty'] ?? '')}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: Text(
                                  //     'Pack : ${item['pack_code'] ?? ''}',
                                  //     style: TextStyle(color: Colors.black),
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 4.0),
                              // -------------------------------------------------------------
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Expanded(
                                  //   child: Text(
                                  //     'Locator : ${item['location_code'] ?? ''}',
                                  //     style: TextStyle(color: Colors.black),
                                  //   ),
                                  // ),
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

                              SizedBox(height: 20.0),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     InkWell(
                              //       onTap: () {
                              //         // showDialogComfirmDelete(
                              //         //     context,
                              //         //     item['seq'].toString(),
                              //         //     item['item_code'] ?? '');
                              //       },
                              //       child: Container(
                              //         width: 30,
                              //         height: 30,
                              //         // color: cardColor, // เปลี่ยนสีพื้นหลังที่นี่
                              //         child: Image.asset(
                              //           'assets/images/bin.png',
                              //           fit: BoxFit.contain,
                              //         ),
                              //       ),
                              //     ),
                              //     // InkWell(
                              //     //   onTap: () {
                              //     //     showDetailsDialog(
                              //     //       context,
                              //     //       item['pack_qty'],
                              //     //       item['nb_item_name'] ?? '',
                              //     //       item['nb_pack_name'] ?? '',
                              //     //       item['item_code'] ?? '',
                              //     //       item['pack_code'] ?? '',
                              //     //       item['rowid'] ?? '',
                              //     //     );
                              //     //   },
                              //     //   child: Container(
                              //     //     width: 30,
                              //     //     height: 30,
                              //     //     // color: cardColor, // เปลี่ยนสีพื้นหลังที่นี่
                              //     //     child: Image.asset(
                              //     //       'assets/images/edit (1).png',
                              //     //       fit: BoxFit.contain,
                              //     //     ),
                              //     //   ),
                              //     // ),
                              //   ],
                              // ),
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
        ]),
      ),
      bottomNavigationBar: BottomBar(),
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
                    messageAlert,
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

  // void showDialogComfirmDelete(
  //     BuildContext context, String pSeq, String pItemCode) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Row(
  //           children: [
  //             Icon(
  //               Icons.notification_important,
  //               color: Colors.red,
  //             ),
  //             SizedBox(width: 10),
  //             Text(
  //               'แจ้งแตือน',
  //               style: TextStyle(color: Colors.black),
  //             ),
  //           ],
  //         ),
  //         content: SingleChildScrollView(
  //           child: Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               children: [
  //                 const SizedBox(height: 10),
  //                 const Text(
  //                   'ต้องการลบรายการหรือไม่ ?',
  //                   style: TextStyle(color: Colors.red),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Row(
  //                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.white,
  //                         side: const BorderSide(color: Colors.grey),
  //                       ),
  //                       child: const Text('ย้อนกลับ'),
  //                     ),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         // Navigator.of(context).pop();
  //                         deleteCard(pSeq, pItemCode);
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.white,
  //                         side: const BorderSide(color: Colors.grey),
  //                       ),
  //                       child: const Text('ยืนยัน'),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

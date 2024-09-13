import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT09L_search.dart';
import 'SSFGDT09L_form.dart';

class Ssfgdt09lMenu extends StatefulWidget {
  final String pWareCode;
  final String pWareName;
  final String pErpOuCode;
  final String pOuCode;
  final String pAttr1;

  const Ssfgdt09lMenu({
    Key? key,
    required this.pWareCode,
    required this.pWareName,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAttr1,
  }) : super(key: key);

  @override
  _Ssfgdt09lMenuState createState() => _Ssfgdt09lMenuState();
}

class _Ssfgdt09lMenuState extends State<Ssfgdt09lMenu> {
  List<dynamic> dataMenu = [
    {
      'items': [
        {'card_name': 'ค้นหาเอกสาร'},
        {'card_name': 'สร้างเอกสาร'},
      ]
    }
  ];
  List<dynamic> dataLovDocType = [];

  Map<String, dynamic>? selectedDocTypeItem;

  String docTypeLovD = '';
  String docTypeLovR = '';

  Widget? checkName(String cardName) {
    // เช็คชื่่อและส่งไปตาม return
    switch (cardName) {
      case 'ค้นหาเอกสาร':
        return Ssfgdt09lSearch(
          pWareCode: widget.pWareCode,
          pWareName: widget.pWareName,
          pErpOuCode: widget.pErpOuCode,
          pOuCode: widget.pOuCode,
          pAttr1: widget.pAttr1,
        );
      default:
        return null;
    }
  }

  @override
  void initState() {
    selectLovDocType();
    super.initState();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> selectLovDocType() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_SelectLovDocType/${widget.pAttr1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');

        setState(() {
          dataLovDocType =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);

          selectedDocTypeItem = dataLovDocType[0];
          docTypeLovD = selectedDocTypeItem?['d'] ?? '';
          docTypeLovR = selectedDocTypeItem?['r'] ?? '';
        });
        print('dataLovDocType : $dataLovDocType');
      } else {
        throw Exception('dataLovDocType Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('dataLovDocType ERROR IN Fetch Data : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: dataMenu[0]['items'].map<Widget>((item) {
                // IconData iconData;
                Color cardColor;
                String imagePath;

                switch (item['card_name']) {
                  case 'ค้นหาเอกสาร':
                    // iconData = Icons.search;
                    cardColor = Colors.grey[300]!;
                    imagePath = 'assets/images/search_doc.png';
                    break;
                  case 'สร้างเอกสาร':
                    // iconData = Icons.list;
                    cardColor = Colors.grey[300]!;
                    imagePath = 'assets/images/add_doc.png';
                    break;
                  default:
                    // iconData = Icons.help_outline;
                    cardColor = Colors.grey;
                    imagePath = 'assets/images/dt_alert.png';
                }

                return Card(
                  elevation: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  color: cardColor,
                  child: ListTile(
                    leading: Image.asset(
                      imagePath,
                      width: 40,
                    ),
                    title: Text('${item['card_name']}'),
                    // trailing: Icon(iconData),
                    onTap: () {
                      String cardName = item['card_name'] ?? '';
                      Widget? pageWidget = checkName(cardName);

                      if (pageWidget != null) {
                        _navigateToPage(context, pageWidget);
                      } else {}
                    },
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showDialogCreateDoc(
    BuildContext context,
    String messageAlert,
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
                'สร้างรายการ',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Replace LOT',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                      ),
                    ),

                    value:
                        selectedDocTypeItem, // ค่าที่เลือกไว้ก่อนหน้า (ถ้ามี)
                    items: dataLovDocType.map((item) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: item,
                        child: Container(
                          // width: 300, // กำหนดความกว้างของรายการ
                          child: Text(
                            item['d'] ?? '',
                            // maxLines: 3, // กำหนดจำนวนบรรทัดสูงสุด
                            overflow: TextOverflow
                                .ellipsis, // เพิ่มข้อความ '...' ถ้าข้อมูลเกิน
                            // style: TextStyle(
                            //   fontSize: 12,
                            // ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDocTypeItem = value;
                        // เก็บค่า name และ codeName
                        docTypeLovD = value?['d'] ?? '';
                        docTypeLovR = value?['r'] ?? '';

                        // แสดงค่าที่ถูกเลือก
                        print('d: $docTypeLovD, r: $docTypeLovR');
                      });
                    },
                    dropdownColor: Colors.white, // กำหนดสีพื้นหลังของ dropdown
                    style: const TextStyle(
                        color: Colors
                            .black), // กำหนดสีตัวอักษรเมื่อแสดงรายการที่ถูกเลือก
                  ),
                  // const SizedBox(height: 20),
                  // --------------------------------------------------------------------------------------------------
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
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => Ssfgdt09lForm(
                          //             pWareCode: widget.pWareCode,
                          //             pAttr1: widget.pErpOuCode,
                          //             pDocNo: widget.pOuCode,
                          //             pDocType: widget.pAttr1,
                          //             pOuCode: widget.pOuCode,
                          //             pErpOuCode: widget.p,
                          //           )),
                          // ).then((value) {
                          //   // เมื่อกลับมาหน้าเดิม เรียก fetchData
                          //   // fetchData();
                          //   selectLovDocType();
                          // });
                        },
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

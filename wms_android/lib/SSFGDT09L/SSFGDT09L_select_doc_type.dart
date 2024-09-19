import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT09L_form.dart';

class Ssfgdt09lSelectDocType extends StatefulWidget {
  final String pWareCode;
  final String pErpOuCode;
  final String pOuCode;
  final String pAttr1;

  const Ssfgdt09lSelectDocType({
    Key? key,
    required this.pWareCode,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAttr1,
  }) : super(key: key);

  @override
  _Ssfgdt09lSelectDocTypeState createState() => _Ssfgdt09lSelectDocTypeState();
}

class _Ssfgdt09lSelectDocTypeState extends State<Ssfgdt09lSelectDocType> {
  List<dynamic> dataLovDocType = [];
  Map<String, dynamic>? selectedDocTypeItem;
  String docTypeLovD = '';
  String docTypeLovR = '';
  String chkCardName = '';
  String statusChkCreate = '';
  String messageChkCreate = '';
  String poDocType = '';
  String poDocNo = '';

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

  Future<void> chkCreateCard() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_CreateCard';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_ou_code': widget.pOuCode,
      'p_erp_ou_code': widget.pErpOuCode,
      'p_app_session': globals.APP_SESSION,
      'p_ware_code': widget.pWareCode,
      'p_doc_type': docTypeLovR,
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
        final Map<String, dynamic> data = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('data : $data type : ${data.runtimeType}');
        setState(() {
          statusChkCreate = data['po_status'];
          messageChkCreate = data['po_message'];
          print(
              'statusChkCreate : $statusChkCreate Type : ${statusChkCreate.runtimeType}');
          print(
              'messageChkCreate : $messageChkCreate Type : ${messageChkCreate.runtimeType}');

          if (statusChkCreate == '1') {
            showDialogAlert(context, messageChkCreate);
          }
          if (statusChkCreate == '0') {
            poDocNo = data['po_doc_no'];
            poDocType = data['po_doc_type'];

            print('poDocNo : $poDocNo Type : ${poDocNo.runtimeType}');

            print('poDocType : $poDocType Type : ${poDocType.runtimeType}');

            _navigateToPage(
                context,
                Ssfgdt09lForm(
                  pWareCode: widget.pWareCode,
                  pAttr1: widget.pAttr1,
                  pDocNo: poDocNo,
                  pDocType: poDocType,
                  pOuCode: widget.pOuCode,
                  pErpOuCode: widget.pErpOuCode,
                ));
          }
        });
      } else {
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
          DropdownButtonFormField<Map<String, dynamic>>(
            decoration: const InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              labelText: 'ประเภทเอกสาร',
              labelStyle: TextStyle(
                color: Colors.black87,
              ),
            ),

            value: selectedDocTypeItem, // ค่าที่เลือกไว้ก่อนหน้า (ถ้ามี)
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
                color:
                    Colors.black), // กำหนดสีตัวอักษรเมื่อแสดงรายการที่ถูกเลือก
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  chkCreateCard();
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
                  'ยืนยัน',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
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
}

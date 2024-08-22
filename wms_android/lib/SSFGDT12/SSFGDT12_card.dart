import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSFGDT12_form.dart';

class Ssfgdt12Card extends StatefulWidget {
  final String docNo;
  final String date;
  final String status;
  final String pWareCode;
  final int p_flag;
  final String browser_language;
  final String p_ou_code;
  Ssfgdt12Card({
    Key? key,
    required this.docNo,
    required this.date,
    required this.status,
    required this.pWareCode,
    required this.p_flag,
    required this.browser_language,
    required this.p_ou_code,
  }) : super(key: key);
  @override
  _Ssfgdt12CardState createState() => _Ssfgdt12CardState();
}

class _Ssfgdt12CardState extends State<Ssfgdt12Card> {
  //
  List<dynamic> dataCard = [];
  List<dynamic> displayedData = [];
  String data_null = 'null';

  @override
  void initState() {
    print('docNo : ${widget.docNo} Type : ${widget.docNo.runtimeType}');
    print('date : ${widget.date} Type : ${widget.date.runtimeType}');
    print('status : ${widget.status} Type : ${widget.status.runtimeType}');
    print(
        'pWareCode : ${widget.pWareCode} Type : ${widget.pWareCode.runtimeType}');
    print('p_flag : ${widget.p_flag} Type : ${widget.p_flag.runtimeType}');
    print(
        'browser_language : ${widget.browser_language} Type : ${widget.browser_language.runtimeType}');
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
      // ตรวจสอบว่า widget.docNo มีค่าหรือไม่
      final String endpoint = widget.docNo != ''
          ? 'http://172.16.0.82:8888/apex/wms/SSFGDT12/selectCard/${widget.p_flag}/${widget.p_ou_code}/${widget.docNo}/${widget.status}/${widget.browser_language}'
          : 'http://172.16.0.82:8888/apex/wms/SSFGDT12/selectCard/${widget.p_flag}/${widget.p_ou_code}/$data_null/${widget.status}/${widget.browser_language}';

      print('Fetching data from: $endpoint');

      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        setState(() {
          dataCard =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          filterData();
        });
        print('dataCard: $dataCard');
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data: $e');
    }
  }

  void filterData() {
    setState(() {
      displayedData = dataCard.where((item) {
        final doc_date = item['doc_date'] ?? '';
        if (widget.date.isEmpty) {
          final matchesSearchQuery = doc_date == doc_date;
          return matchesSearchQuery;
        } else {
          final matchesSearchQuery = doc_date == widget.date;
          return matchesSearchQuery;
        }
      }).toList();
      print(
          'displayedData : $displayedData Type : ${displayedData.runtimeType}');
    });
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
            Expanded(
              child: ListView(
                children: displayedData.map((item) {
                  // Check card_value and set icon accordingly
                  // String combinedValue = '${item['card_value']}';
                  // IconData iconData;
                  Color cardColor;
                  String statusText;
                  switch (item['status']) {
                    ////      WMS คลังวัตถุดิบ
                    case 'N':
                      // iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Color.fromRGBO(246, 250, 112, 1.0);
                      statusText = 'รอตรวจนับ';
                      break;
                    case 'T':
                      // iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Color.fromRGBO(208, 206, 206, 1.0);
                      statusText = 'กำลังตรวจนับ';
                      break;
                    case 'X':
                      // iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Color.fromRGBO(146, 208, 80, 1.0);
                      statusText = 'ยื่นยันตรวจนับแล้ว';
                      break;
                    case 'A':
                      // iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Color.fromRGBO(208, 206, 206, 1.0);
                      statusText = 'กำลังปรับปรุงจำนวน/มูลค่า';
                      break;
                    case 'B':
                      // iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Color.fromRGBO(146, 208, 80, 1.0);
                      statusText = 'ยืนยันปรับปรุงจำนวน/มูลค่าแล้ว';
                      break;
                    default:
                      // iconData = Icons.help; // Default icon
                      cardColor = Colors.grey;
                      statusText = 'Unknown';
                  }

                  return Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // กำหนดมุมโค้งของ Card
                    ),
                    color: cardColor,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Ssfgdt12Form(
                              docNo: item['doc_no'],
                              pOuCode: widget.p_ou_code,
                              browser_language: widget.browser_language,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(
                          15.0), // กำหนดมุมโค้งให้ InkWell เช่นกัน
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(
                                16.0), // เพิ่ม padding เพื่อให้ content ไม่ชิดขอบ
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['doc_no'] ?? 'No Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                SizedBox(
                                    height:
                                        10.0), // เพิ่มระยะห่างระหว่างข้อความ
                                item['ware_code'] == null
                                    ? Text(
                                        '${item['doc_date']} ${item['doc_no']}',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54),
                                      )
                                    : Text(
                                        '${item['doc_date']} ${item['doc_no']} ${item['ware_code']}',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54),
                                      ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border:
                                    Border.all(color: Colors.black, width: 2.0),
                              ),
                              child: Text(
                                statusText, // แสดง STATUS ที่ได้จาก switch case
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

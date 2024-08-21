import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';

class Ssfgdt12Card extends StatefulWidget {
  final String docNo;
  final String date;
  final String status;
  final String pWareCode;
  Ssfgdt12Card({
    Key? key,
    required this.docNo,
    required this.date,
    required this.status,
    required this.pWareCode,
  }) : super(key: key);
  @override
  _Ssfgdt12CardState createState() => _Ssfgdt12CardState();
}

class _Ssfgdt12CardState extends State<Ssfgdt12Card> {
  //
  List<dynamic> dataCard = [];

  @override
  void initState() {
    print('docNo : ${widget.docNo} Type : ${widget.docNo.runtimeType}');
    print('docNo : ${widget.date} Type : ${widget.date.runtimeType}');
    print('docNo : ${widget.status} Type : ${widget.status.runtimeType}');
    print('docNo : ${widget.pWareCode} Type : ${widget.pWareCode.runtimeType}');
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
      final response = await http.get(Uri.parse('ยังไม่ได้สร้างจ้าาาาาา'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');

        setState(() {
          dataCard =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataMenu : $dataCard');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'ผลการตรวจนับ'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: dataCard.length, // กำหนดจำนวนรายการจาก dataCard
          itemBuilder: (context, index) {
            final item = dataCard[index]; // เข้าถึงข้อมูลแต่ละรายการ

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 5, // เพิ่มความสูงเงา
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  children: [
                    // Image.network(
                    //   item['imageUrl'], // ใช้ URL ของรูปภาพจาก API
                    //   height: 150,
                    //   width: double.infinity,
                    //   fit: BoxFit.cover,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'], // แสดงชื่อจาก API
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['description'], // แสดงคำอธิบายจาก API
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey[600],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // การทำงานเมื่อปุ่มถูกกด
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'DETAILS',
                                  style: TextStyle(color: Colors.white),
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
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

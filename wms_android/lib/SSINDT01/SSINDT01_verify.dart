import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/bottombar.dart'; // Import the BottomBar

class Ssindt01Verify extends StatefulWidget {
  final String poReceiveNo;
  final String? poPONO;

  Ssindt01Verify({required this.poReceiveNo, this.poPONO});

  @override
  _Ssindt01VerifyState createState() => _Ssindt01VerifyState();
}

class _Ssindt01VerifyState extends State<Ssindt01Verify> {
  List<Map<String, dynamic>> dataList = [];
  List<dynamic> data = [];
  String? poStatus;
  String? poMessage;

  @override
  void initState() {
    super.initState();
    sendGetRequestlineWMS();
    chk_sub();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> sendGetRequestlineWMS() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/c/pull_po/${widget.poReceiveNo}';

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    print('Request URL: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);

        setState(() {
          dataList =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('Success: $dataList');
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> chk_sub() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/c/Submit_ver/${widget.poReceiveNo}'));
      print(widget.poReceiveNo);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          poStatus = jsonData['po_status'];
          poMessage = jsonData['po_message'];
          print(response.statusCode);
          print(jsonData);
          print(poStatus);
          print(poMessage);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ'),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: dataList.isEmpty
                ? Center(
                    child: Text('No data available',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))
                : SingleChildScrollView(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: dataList.map((data) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 6.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Item: ${data['item'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Icon(Icons.assignment,
                                        color: Colors.grey[700]),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        'จำนวนรับ: ${data['receive_qty']?.toString() ?? 'N/A'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(Icons.pending,
                                        color: Colors.orange[700]),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        'Pending Quantity: ${data['pending_qty']?.toString() ?? 'N/A'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        color: Colors.blue[700]),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        'Locator: ${data['locator_det']?.toString() ?? 'N/A'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(Icons.check, color: Colors.blue[700]),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        'Product No: ${data['lot_product_no']?.toString() ?? 'N/A'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                chk_sub();
                if (poStatus == '0') {
                  showCustomDialog(context);
                } else if (poStatus == '1') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(poMessage!)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'ยืนยัน',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยัน'),
          content: Text('ยืนยันหรือไม่?'),
          actions: [
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

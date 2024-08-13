import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Verify extends StatefulWidget {
    final String poReceiveNo;
  final String? poPONO;

Verify({required this.poReceiveNo, this.poPONO});


  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<Verify> {
  

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

 List<Map<String, dynamic>> dataList = [];

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

  List<dynamic> data = [];
  String? poStatus;
  String? poMessage;

  Future<void> chk_sub() async {
    try {
      final response = await http.get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/Submit_ver/${widget.poReceiveNo}'));
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
      appBar: AppBar(
        title: Text('Verify'),
      ),
      body: dataList.isEmpty
        ? Center(child: Text('No data available'))
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: TableBorder(
                  verticalInside: BorderSide(
                      width: 0.1,
                      color: Colors.black,
                      style: BorderStyle.solid)),
              columnSpacing: 12.0,
              columns: [
                DataColumn(label: Text('Item')),
                DataColumn(label: Text('จำนวนรับ')),
                DataColumn(label: Text('ค้างรับ')),
                DataColumn(label: Text('Locator')),
                DataColumn(label: Text('จำนวนรวม')),
                DataColumn(label: Text('UOM')),
              ],
              rows: dataList.map((data) {
                return DataRow(
                  cells: [
                    DataCell(
                      InkWell(
            
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(data['item']?.toString() ?? '')),
                      ),
                    ),
                    DataCell(
                      InkWell(
        
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child:
                                Text(data['receive_qty']?.toString() ?? '')),
                      ),
                    ),
                    DataCell(
                      InkWell(
              
                        child: Align(
                            alignment: Alignment.center,
                            child:
                                Text(data['pending_qty']?.toString() ?? '')),
                      ),
                    ),
                    DataCell(
                      InkWell(
   
                        child: Align(
                            alignment: Alignment.center,
                            child:
                                Text(data['locator_det']?.toString() ?? '')),
                      ),
                    ),
                    DataCell(
                      InkWell(
                    
                        child: Align(
                            alignment: Alignment.center,
                            child:
                                Text(data['lot_total_nb']?.toString() ?? '')),
                      ),
                    ),
                    DataCell(
                      InkWell(
                
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(data['uom']?.toString() ?? '')),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          chk_sub();
          if(poStatus == '0'){
          showCustomDialog(context);
          }
          else if(poStatus == '1'){
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(poMessage!)),
          );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
    );
  }


void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('TEST'),
        content: Text('========================'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('OK'),
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




import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/styles.dart';
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT31_FROM_ADD.dart'; // เพิ่มการนำเข้าไฟล์ FROM.dart
import 'package:wms_android/Global_Parameter.dart' as gb;

class SSFGDT31_ADD_DOC extends StatefulWidget {
  final String pWareCode;

  SSFGDT31_ADD_DOC({
    Key? key,
    required this.pWareCode,
  }) : super(key: key);

  @override
  _SSFGDT31_ADD_DOCState createState() => _SSFGDT31_ADD_DOCState();
}

class _SSFGDT31_ADD_DOCState extends State<SSFGDT31_ADD_DOC> {
  List<dynamic> statusItems = [];
  String? selectedValue;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchStatusItems();
    print(widget.pWareCode);
  }

  String? po_doc_no;
  String? po_doc_type;
  String? po_status;
  String? po_message;

  Future<void> fetchStatusItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/DOC_TYPE/${gb.ATTR1}'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      print('Fetched data: $data');

      setState(() {
        statusItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        if (statusItems.isNotEmpty) {
          selectedValue = statusItems[0]['doc_type'];
        }
        print('dataMenu: $statusItems');
        print('Initial selectedValue: $selectedValue');
      });
    } else {
      throw Exception('Failed to load status items');
    }
  }

  Future<void> create_NewINXfer_WMS() async {
    final url = 'http://172.16.0.82:8888/apex/wms/SSFGDT31/Creacte_NewINHead';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      'APP_SESSION': gb.APP_SESSION,
      'APP_USER': gb.APP_USER,
      'P_WARE_CODE': widget.pWareCode,
      'p_doc_type': selectedValue,
      'P_OU_CODE': gb.P_OU_CODE,
    });

    print('headers : $headers Type : ${headers.runtimeType}');
    print('body : $body Type : ${body.runtimeType}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          po_doc_no = responseData['po_doc_no'];
          po_doc_type = responseData['po_doc_type'];
          po_status = responseData['po_status'];
          po_message = responseData['po_message'];
        });
        print('===============================');
        print(po_doc_no);
        print(po_doc_type);
        print(po_status);
        print(po_message);
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Method to show the document type selection dialog
  void _showDocumentTypeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'เลือกประเภทเอกสาร',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () =>
                    Navigator.of(context).pop(), // Close the dialog
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: statusItems.map((item) {
                return Container(
                  margin:
                      const EdgeInsets.only(bottom: 8), // Margin between items
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black, width: 1.0), // Black border
                    borderRadius: BorderRadius.circular(5.0), // Rounded corners
                  ),
                  child: ListTile(
                    title: Text(
                      item['doc_desc'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedValue = item['doc_type'];
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับคืนจากการเบิกผลิต'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Replace DropdownButton with a button to open dialog
                GestureDetector(
                  onTap: _showDocumentTypeDialog,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      // borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedValue != null
                              ? statusItems.firstWhere((item) =>
                                      item['doc_type'] ==
                                      selectedValue)['doc_desc'] ??
                                  ''
                              : 'ประเภทเอกสาร',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.black),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await create_NewINXfer_WMS();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SSFGDT31_FROM(
                                      po_doc_no: po_doc_no ?? '',
                                      po_doc_type: selectedValue ?? '',
                                      pWareCode: widget.pWareCode,
                                    )),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('กรุณาเลือกข้อมูลก่อนกด CONFIRM'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'CONFIRM',
                        style: AppStyles.ConfirmbuttonTextStyle(),
                      ),
                      style: AppStyles.ConfirmbuttonStyle(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

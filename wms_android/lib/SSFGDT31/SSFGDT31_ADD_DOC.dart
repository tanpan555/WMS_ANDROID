import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/styles.dart';
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT31_FROM_ADD.dart'; // Import FROM.dart
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
  final TextEditingController dataLovDocTypeController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? po_doc_no;
  String? po_doc_type;
  String? po_status;
  String? po_message;

  @override
  void initState() {
    super.initState();
    fetchStatusItems();
    print(widget.pWareCode);
  }

  Future<void> fetchStatusItems() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT31/DOC_TYPE/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        print('Fetched data: $data');
        if (mounted) {
          setState(() {
            // Ensure you're parsing it correctly
            statusItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
            if (statusItems.isNotEmpty) {
              // Accessing values correctly from the first item
              selectedValue = statusItems[0]['doc_type']
                  as String; // Ensure this is a String
              dataLovDocTypeController.text = statusItems[0]['doc_desc']
                  as String; // Ensure this is a String
            } else {
              dataLovDocTypeController.clear(); // Clear if no items found
            }
            print('dataMenu: $statusItems');
            print('Initial selectedValue: $selectedValue');
          });
        }
      } else {
        showDialogAlert(
            context, 'Failed to load status items: ${response.reasonPhrase}');
      }
    } catch (e) {
      showDialogAlert(context, 'An error occurred: $e');
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
            po_doc_no = responseData['po_doc_no'];
            po_doc_type = responseData['po_doc_type'];
            po_status = responseData['po_status'];
            po_message = responseData['po_message'];
          });
        }
        print('Document Number: $po_doc_no');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showDocumentTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Close Button with bottom line
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey, // Color of the line
                        width: 1.0, // Thickness of the line
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'เลือกประเภทรายการ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16), // Space between title and list

                // ListView with items having a black frame
                Expanded(
                  child: ListView.builder(
                    itemCount: statusItems.length,
                    itemBuilder: (context, index) {
                      final item =
                          statusItems[index]; // This is a Map<String, dynamic>

                      return Container(
                        height: 55,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ListTile(
                          title: Text(item['doc_desc'] ?? '',
                              style: TextStyle(
                                  fontSize: 14)), // Accessing a String
                          onTap: () {
                            setState(() {
                              selectedValue = item['doc_type']
                                  as String?; // Ensure this is a String
                              dataLovDocTypeController.text =
                                  item['doc_desc'] ?? ''; // Set text safely
                            });
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF110038),
      appBar: CustomAppBar(title: 'รับคืนจากการเบิกผลิต'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: dataLovDocTypeController,
                readOnly: true,
                onTap: _showDocumentTypeDialog,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'ประเภทเอกสาร',
                  labelStyle: const TextStyle(color: Colors.black87),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await create_NewINXfer_WMS();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SSFGDT31_FROM(
                              po_doc_no: po_doc_no ?? '',
                              po_doc_type: selectedValue ?? '',
                              pWareCode: widget.pWareCode,
                            ),
                          ),
                        );
                      } else {
                        showDialogAlert(
                            context, 'กรุณาเลือกข้อมูลก่อนกด CONFIRM');
                      }
                    },
                    style: AppStyles.ConfirmbuttonStyle(),
                    child: Text(
                      'CONFIRM',
                      style: AppStyles.ConfirmbuttonTextStyle(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }

  void showDialogAlert(BuildContext context, String messageAlert) {
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
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(messageAlert, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ตกลง'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

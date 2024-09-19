import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
// import 'SSFGDT04_FORM.dart'; // เพิ่มการนำเข้าไฟล์ FROM.dart
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGDT04_FORM.dart';

class SSFGDT04_TYPE extends StatefulWidget {
  final String pWareCode;
  final String pErpOuCode;

  SSFGDT04_TYPE({
    Key? key,
    required this.pWareCode,
    required this.pErpOuCode,
  }) : super(key: key);
  @override
  _SSFGDT04_TYPEState createState() => _SSFGDT04_TYPEState();
}

class _SSFGDT04_TYPEState extends State<SSFGDT04_TYPE> {
  // DateTime? _selectedDate;
  List<dynamic> statusItems = [];
  String? pWareCodeCreateNewINXferWMS;
String? pDocTypeCreateNewINXferWMS;

  // String? selectedValue;
  String? selectedDocType;

  final _formKey = GlobalKey<FormState>();
  // 'V_CR_WHCODE': selectedValue,
  //     'p_doc_type': LocCode,
  //     'P_WARE_CODE': whOUTCode,
  //     'P_OU_CODE': LocOUTCode,
  //     'P_ERP_OU_CODE': currentSessionID,
  //     'APP_SESSION': docData,
  //     'p_ware_code': warecode,
  //     'APP_USER': appuser,

  @override
  void initState() {
    super.initState();
    fetchStatusItems();
  }

  Future<void> fetchStatusItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_1_TYPE/${gb.ATTR1}'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      print('Fetched data: $data');

      setState(() {
        statusItems = List<Map<String, dynamic>>.from(data['items'] ?? []);

        // ตั้งค่า selectedDocType ให้เป็นค่าแรกของ statusItems
        if (statusItems.isNotEmpty) {
          selectedDocType = statusItems[0]['doc_type'];
        }
        print('dataMenu: $statusItems');
      });
    } else {
      throw Exception('Failed to load status items');
    }
  }


  // String? poStatus;
  // String? poMessage;
  // String? po_doc_no;
  // String? po_doc_type;
  // String? p_ware_code;

  String? poStatus;
  String? poMessage;
  String? po_doc_no;
  String? po_doc_type;

  Future<void> create_NewINXfer_WMS(String? p_doc_type) async {
    final url = 'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_1_Create_NewINHead';

    final headers = {
      'Content-Type': 'application/json',
    };
    print(p_doc_type);
    print(gb.P_OU_CODE);
    print(gb.P_ERP_OU_CODE);
    print(gb.APP_SESSION);
    print(gb.APP_USER);


    final body = jsonEncode({
      'P_DOC_TYPE': p_doc_type,
      'P_WARE_CODE': gb.P_WARE_CODE,
      'P_OU_CODE': gb.P_OU_CODE,
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      'APP_SESSION': gb.APP_SESSION,
      'APP_USER': gb.APP_USER,
      // 'p_ware_code': 'WH001',
      
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
          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];

          print('po_doc_no : $po_doc_no Type : ${po_doc_no.runtimeType}');
          print('po_doc_type : $po_doc_type Type : ${po_doc_type.runtimeType}');
          print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
          print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
        });
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับตรง (ไม่อ้าง PO'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'ประเภทเอกสาร',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  items: statusItems
                      .map((item) => DropdownMenuItem<String>(
                            value: item['doc_type'],
                            child: Text(
                              item['doc_desc'] ?? 'doc_desc = null',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a status.';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedDocType = value.toString();
                    });
                  },
                  onSaved: (value) {
                    selectedDocType = value.toString();
                  },
                  value: selectedDocType,
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 113, 113, 113),
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    maxHeight: 150,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                          onPressed: () async {
                            // เรียกใช้ฟังก์ชันเพื่อสร้างเอกสารใหม่
                            await create_NewINXfer_WMS(selectedDocType ?? '');

                            // ตรวจสอบว่า form ได้รับการตรวจสอบแล้วหรือไม่
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              // ตรวจสอบว่า poStatus เป็น 0 เพื่อไปยังหน้าฟอร์ม
                              if (poStatus == '0') {
                                await create_NewINXfer_WMS(selectedDocType);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SSFGDT04_FORM(
                                      po_doc_no: po_doc_no ?? '',   // ส่งค่า po_doc_no
                                      po_doc_type: po_doc_type,     // ส่งค่า po_doc_type
                                      pWareCode: widget.pWareCode,
                                    ),
                                  ),
                                );
                              } else if (poStatus == '1') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('คำเตือน'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text('Status: ${poStatus ?? 'No status available'}'),
                                        // SizedBox(height: 8.0),
                                        Text('${poMessage}'),
                                        // SizedBox(height: 8.0),
                                        // Text('Step: ${poStep ?? 'No message available'}'),
                                      ],
                                    ),
                                    actions: [
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
                            } else {
                              // แสดงข้อความแจ้งเตือนหากไม่ได้เลือกข้อมูล
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('กรุณาเลือกข้อมูลก่อนกด CONFIRM'),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'CONFIRM',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[500],
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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

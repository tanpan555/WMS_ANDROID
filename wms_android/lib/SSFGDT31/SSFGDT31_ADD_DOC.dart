import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT31_FROM_ADD.dart'; // เพิ่มการนำเข้าไฟล์ FROM.dart

class SSFGDT31_ADD_DOC extends StatefulWidget {
  @override
  _SSFGDT31_ADD_DOCState createState() => _SSFGDT31_ADD_DOCState();
}

class _SSFGDT31_ADD_DOCState extends State<SSFGDT31_ADD_DOC> {
  // DateTime? _selectedDate;
  List<dynamic> statusItems = [];

  String? selectedValue;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchStatusItems();
  }

  Future<void> fetchStatusItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/DOC_TYPE/p_ATTR1'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      print('Fetched data: $data');

      setState(() {
        statusItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        print('dataMenu: $statusItems');
      });
    } else {
      throw Exception('Failed to load status items');
    }
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
                            value: item['doc_desc'],
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
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value.toString();
                    });
                  },
                  onSaved: (value) {
                    selectedValue = value.toString();
                  },
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SSFGDT31_FROM()),
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

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure you import intl for DateFormat
import 'package:wms_android/SSFGDT17/SSFGDT17_MAIN.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;

class SSFGDT17_SEARCH extends StatefulWidget {
  final String pWareCode;
  const SSFGDT17_SEARCH({Key? key, required this.pWareCode}) : super(key: key);

  @override
  _SSFGDT17_SEARCHState createState() => _SSFGDT17_SEARCHState();
}

class _SSFGDT17_SEARCHState extends State<SSFGDT17_SEARCH> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;
  String? selectedValue;
  final List<String> statusItems = ['ทั้งหมด', 'ปกติ', 'ยกเลิก','รับโอนแล้ว'];
  String? docData;

  @override
  void initState() {
    super.initState();
    selectedValue = 'ทั้งหมด';
    
    // print('docData : $docData');
  }




  final TextEditingController _documentNumberController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _dateController.clear();
    setState(() {
      selectedValue = 'ทั้งหมด';
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color(0xFF17153B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'ประเภทรายการ',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  items: statusItems
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item, style: const TextStyle(fontSize: 14, color: Colors.black)),
                          ))
                      .toList(),
                  validator: (value) => value == null ? 'Please select a status.' : null,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  onSaved: (value) => selectedValue = value,
                  value: selectedValue,
                  style: TextStyle(color: Colors.black),
                  icon: const Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 113, 113, 113)),
                  dropdownColor: Colors.white,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _documentNumberController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'เลขที่เอกสาร',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16),
                TextField(
                  readOnly: true,
                  controller: _dateController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'วันที่รับคืน',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.black),
                  ),
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null && selectedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = selectedDate;
                        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _resetForm,
                      child: Image.asset('assets/images/eraser_red.png', width: 50, height: 25),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[300],
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        final documentNumber = _documentNumberController.text;

    
    // Debugging output
    print(selectedValue);
    print(documentNumber);
    print('date ${_dateController.text}'); 
  

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SSFGDT17_MAIN(
          pWareCode: widget.pWareCode,
        selectedValue: selectedValue,
        documentNumber: documentNumber,
        dateController: _dateController.text,
        ),
      ),
    );
                      },
                      child: Image.asset('assets/images/search_color.png', width: 50, height: 25),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

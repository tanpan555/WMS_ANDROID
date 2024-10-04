import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure you import intl for DateFormat
import 'package:wms_android/SSFGDT17/SSFGDT17_MAIN.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/styles.dart';
import 'package:flutter/services.dart'; // Add this import

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
  final List<String> statusItems = ['ทั้งหมด', 'ปกติ', 'ยกเลิก', 'รับโอนแล้ว'];
  String? docData;
  String? docData1;
  bool isDateValid = true;

  @override
  void initState() {
    super.initState();
    selectedValue = 'ปกติ';
    fetchDocType();
  }

  final TextEditingController _documentNumberController =
      TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _documentNumberController.clear();
    _dateController.clear();
    setState(() {
      selectedValue = 'ทั้งหมด';
      _selectedDate = null;
    });
  }

  String formatDate(String input) {
    if (input.length == 8) {
      // Attempt to parse the input string as a date in ddMMyyyy format
      final day = int.tryParse(input.substring(0, 2));
      final month = int.tryParse(input.substring(2, 4));
      final year = int.tryParse(input.substring(4, 8));
      if (day != null && month != null && year != null) {
        final date = DateTime(year, month, day);
        if (date.year == year && date.month == month && date.day == day) {
          // Return the formatted date if valid
          return DateFormat('dd/MM/yyyy').format(date);
        }
      }
    }
    return input; // Return original input if invalid
  }

  Future<void> fetchDocType() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT17/default_doc_type'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        docData1 = data['DOC_TYPE'];
      });
      print('Fetched docData1: $docData1');
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Move Locator',
      ),
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
                DropdownButtonFormField2<String>(
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
                            child: Text(item,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ))
                      .toList(),
                  validator: (value) =>
                      value == null ? 'Please select a status.' : null,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  onSaved: (value) => selectedValue = value,
                  value: selectedValue,
                  style: TextStyle(color: Colors.black),
                  buttonStyleData:
                      const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113)),
                    iconSize: 24,
                  ),
                  //  dropdownStyleData: DropdownStyleData(
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15),
                  //       color: Colors.white),
                  //   maxHeight: 350,
                  // ),
                  menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _documentNumberController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'เลขที่ใบโอน',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'วันที่โอน',
                    hintText: 'DD/MM/YYYY',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today_outlined,
                          color: Colors.black),
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _selectedDate = selectedDate;
                            _dateController.text =
                                DateFormat('dd/MM/yyyy').format(selectedDate);
                            isDateValid =
                                true; // Set to true when a date is selected from the picker
                          });
                        }
                      },
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                  onChanged: (value) {
                    // Check if the input is in the format ddMMyyyy
                    if (value.length == 8 &&
                        RegExp(r'^\d{8}$').hasMatch(value)) {
                      final day = int.tryParse(value.substring(0, 2));
                      final month = int.tryParse(value.substring(2, 4));
                      final year = int.tryParse(value.substring(4, 8));
                      if (day != null && month != null && year != null) {
                        final date = DateTime(year, month, day);
                        if (date.year == year &&
                            date.month == month &&
                            date.day == day) {
                          setState(() {
                            isDateValid = true; // Valid date
                            _selectedDate = date; // Update selected date
                            _dateController.text =
                                DateFormat('dd/MM/yyyy').format(date);
                          });
                        } else {
                          setState(() {
                            isDateValid = false; // Invalid date
                          });
                        }
                      } else {
                        setState(() {
                          isDateValid = false; // Parsing failed
                        });
                      }
                    } else {
                      setState(() {
                        isDateValid = false; // Not the correct length or format
                      });
                    }
                  },
                ),

// Update the validation message display logic as needed
                isDateValid == false
                    ? const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _resetForm,
                      child: Image.asset('assets/images/eraser_red.png',
                          width: 50, height: 25),
                      style: AppStyles.EraserButtonStyle(),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        final documentNumber =
                            _documentNumberController.text.isEmpty
                                ? 'null'
                                : _documentNumberController.text;
                        final selectedDate = _selectedDate == null
                            ? 'null'
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!);

                        // Debugging output
                        print(selectedValue);
                        print(documentNumber);
                        print('date ${_dateController.text}');
                        print(
                            'docData1: $docData1'); // Ensure docData1 is correctly fetched

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SSFGDT17_MAIN(
                                pWareCode: widget.pWareCode,
                                selectedValue: selectedValue,
                                documentNumber: documentNumber,
                                dateController: selectedDate,
                                docData1: docData1 ?? '' // Handle null case
                                ),
                          ),
                        );
                      },
                      child: Image.asset('assets/images/search_color.png',
                          width: 50, height: 25),
                      style: AppStyles.SearchButtonStyle(),
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

import 'dart:convert';
import 'dart:developer';
import 'dart:math';

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
  final TextEditingController _selectedProductTypeController =
      TextEditingController(text: 'ปกติ'); // Controller for product type
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
    _selectedProductTypeController.text = 'ทั้งหมด';
    if (mounted) {
      setState(() {
        isDateValid = true;
        selectedValue = 'ทั้งหมด';
        _selectedDate = null;
      });
    }
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
      if (mounted) {
        setState(() {
          docData1 = data['DOC_TYPE'];
        });
      }
      print('Fetched docData1: $docData1');
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _showProductTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 300, // Adjust the height as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'เลือกประเภทรายการ', // Title
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // List of Items with black frame around each item
                Expanded(
                  child: ListView.builder(
                    itemCount: statusItems.length,
                    itemBuilder: (context, index) {
                      final item = statusItems[index];

                      return Container(
                        height: 55,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              width: 1.0), // Black border around each item
                          borderRadius: BorderRadius.circular(
                              16.0), // Rounded corners (optional)
                        ),
                        child: Align(
                          alignment:
                              Alignment.centerLeft, // Align text to center-left
                          child: ListTile(
                            title: Text(
                              item,
                              // overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            onTap: () {
                              setState(() {
                                selectedValue = item;
                                _selectedProductTypeController.text = item;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
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
                GestureDetector(
                  onTap: _showProductTypeDialog,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _selectedProductTypeController,
                      decoration: InputDecoration(
                        labelText: 'ประเภทรายการ',
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.arrow_drop_down,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
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
                    labelStyle: TextStyle(
                      color: isDateValid == false
                          ? Colors.red
                          : Colors
                              .black, // Change label color based on validity
                    ),
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
                                true; // Reset validity when a date is picked
                          });
                        }
                      },
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9/]')), // Allow only numbers and slashes
                  ],
                  onChanged: (value) {
                    // Remove all slashes for processing
                    String numbersOnly = value.replaceAll('/', '');

                    // Limit the length of the input to 8 digits
                    if (numbersOnly.length > 8) {
                      numbersOnly = numbersOnly.substring(0, 8);
                    }

                    // Format the value with slashes
                    String formattedValue = '';
                    for (int i = 0; i < numbersOnly.length; i++) {
                      if (i == 2 || i == 4) {
                        formattedValue += '/'; // Add slashes after DD and MM
                      }
                      formattedValue += numbersOnly[i];
                    }

                    // Update the controller
                    _dateController.value = TextEditingValue(
                      text: formattedValue,
                      selection: TextSelection.collapsed(
                          offset:
                              formattedValue.length), // Set cursor to the end
                    );

                    // Validate the date
                    if (numbersOnly.length == 8) {
                      try {
                        final day = int.parse(numbersOnly.substring(0, 2));
                        final month = int.parse(numbersOnly.substring(2, 4));
                        final year = int.parse(numbersOnly.substring(4, 8));

                        final date = DateTime(year, month, day);

                        // Check if the day, month, and year are valid
                        if (date.day == day &&
                            date.month == month &&
                            date.year == year) {
                          setState(() {
                            isDateValid = true; // Valid date
                            _selectedDate = date; // Update selected date
                          });
                        } else {
                          throw Exception('Invalid date');
                        }
                      } catch (e) {
                        setState(() {
                          isDateValid = false; // Invalid date
                        });
                      }
                    } else {
                      setState(() {
                        isDateValid =
                            false; // Invalid length (not 8 digits yet)
                      });
                    }
                  },
                ),

// Validation message display logic
                isDateValid == false
                    ? const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
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
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}

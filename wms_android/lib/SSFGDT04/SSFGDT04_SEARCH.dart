import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSFGDT04_CARD.dart';
import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import '../styles.dart';
import 'package:flutter/services.dart';

class SSFGDT04_SEARCH extends StatefulWidget {
  final String pWareCode;
  final String pErpOuCode;

  const SSFGDT04_SEARCH({
    super.key,
    required this.pWareCode,
    required this.pErpOuCode,
  });

  @override
  _SSFGDT04_SEARCHState createState() => _SSFGDT04_SEARCHState();
}

class _SSFGDT04_SEARCHState extends State<SSFGDT04_SEARCH> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int pFlag = 1;
  String pSoNo = 'null';
  String selectedItem =
      'ระหว่างบันทึก'; // Ensure this value exists in dropdownItems
  String status = '1'; // Default status
  String selectedDate = 'null'; // Allow null for the date
  String appUser = gb.APP_USER;
  TextEditingController _dateController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final String sDateFormat = "dd-MM-yyyy";
  final List<String> dropdownItems = [
    'ทั้งหมด',
    'ระหว่างบันทึก',
    'ยืนยันการรับ',
    'ยกเลิก',
  ];
  String? _dateError;

  @override
  void initState() {
    super.initState();
    // Ensure selectedItem has a valid initial value
    if (!dropdownItems.contains(selectedItem)) {
      selectedItem = dropdownItems.first;
    }
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //     initialEntryMode: DatePickerEntryMode.calendarOnly,
  //   );

  //   if (pickedDate != null) {
  //     // Format the date as dd-MM-yyyy for internal use
  //     String formattedDateForSearch =
  //         DateFormat('dd-MM-yyyy').format(pickedDate);
  //     // Format the date as dd/MM/yyyy for display
  //     String formattedDateForDisplay =
  //         DateFormat('dd/MM/yyyy').format(pickedDate);

  //     setState(() {
  //       _dateController.text = formattedDateForDisplay;
  //       selectedDate = formattedDateForSearch;
  //     });
  //   }
  // }
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      if (mounted) {
        setState(() {
          _dateController.text = formattedDate;
          selectedDate = _dateController.text;
        });
      }
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: const CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                DropdownButtonFormField2<String>(
                  value: selectedItem,
                  items: dropdownItems
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'ประเภทรายการ',
                    hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value ??
                          dropdownItems.first; // Ensure selectedItem is valid
                      switch (selectedItem) {
                        case 'ทั้งหมด':
                          status = '0';
                          break;
                        case 'ระหว่างบันทึก':
                          status = '1';
                          break;
                        case 'ยืนยันการรับ':
                          status = '2';
                          break;
                        case 'ยกเลิก':
                          status = '3';
                          break;
                        default:
                          status = '0'; // Default status
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'เลขที่เอกสาร',
                    hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      pSoNo = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dateController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // ยอมรับเฉพาะตัวเลข
                    LengthLimitingTextInputFormatter(
                        8), // จำกัดจำนวนตัวอักษรไม่เกิน 8 ตัว
                    DateInputFormatter(), // กำหนดรูปแบบ __/__/____
                  ],
                  onTap: () {
                    // อนุญาตให้ผู้ใช้กรอกวันที่เอง
                    _dateController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _dateController.text.length,
                    );
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'วันที่ส่งสินค้า',
                    hintStyle:
                        const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today,
                          color: Color.fromARGB(255, 64, 64, 64)),
                      onPressed: () => _selectDate(context),
                    ),
                    errorText: _dateError, // แสดงข้อผิดพลาดที่นี่
                  ),
                  onChanged: (value) {
                    setState(() {
                      _dateController.text = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _controller.clear();
                        _dateController.clear();
                        setState(() {
                          selectedDate = 'null'; // Set selectedDate to null
                          selectedItem =
                              dropdownItems.first; // Reset to a valid value
                          status = '0'; // Reset status to default
                        });
                      },
                      style: AppStyles.EraserButtonStyle(),
                      child: Image.asset('assets/images/eraser_red.png',
                          width: 50, height: 25),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: selectedItem.isNotEmpty
                          ? () {
                              if (_dateController.text.isNotEmpty) {
                                try {
                                  DateTime parsedDate = DateFormat('dd/MM/yyyy')
                                      .parse(_dateController.text);
                                  String formattedDateForSearch =
                                      DateFormat('dd-MM-yyyy')
                                          .format(parsedDate);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SSFGDT04_CARD(
                                        pErpOuCode: widget.pErpOuCode,
                                        pWareCode: widget.pWareCode,
                                        pAppUser: appUser,
                                        pFlag: pFlag,
                                        soNo: pSoNo.isEmpty ? 'null' : pSoNo,
                                        date: formattedDateForSearch,
                                        status: status,
                                      ),
                                    ),
                                  ).then((value) {
                                    setState(() {
                                      pSoNo = '';
                                      selectedDate = 'null';
                                      selectedItem = dropdownItems.first;
                                      status = '0';
                                      // _dateController.clear();
                                      // _controller.clear();
                                    });
                                  });
                                } catch (e) {
                                  setState(() {
                                    _dateError =
                                        'กรุณากรอกวันที่ให้ถูกต้องตามรูปแบบ DD/MM/YYYY';
                                  });
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SSFGDT04_CARD(
                                      pErpOuCode: widget.pErpOuCode,
                                      pWareCode: widget.pWareCode,
                                      pAppUser: appUser,
                                      pFlag: pFlag,
                                      soNo: pSoNo.isEmpty ? 'null' : pSoNo,
                                      date: 'null',
                                      status: status,
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {
                                    pSoNo = '';
                                    selectedDate = 'null';
                                    selectedItem = dropdownItems.first;
                                    status = '0';
                                    _dateController.clear();
                                    _controller.clear();
                                  });
                                });
                              }
                            }
                          : null,
                      style: AppStyles.SearchButtonStyle(),
                      child: Image.asset(
                        'assets/images/search_color.png',
                        width: 50,
                        height: 25,
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

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // กรองเฉพาะตัวเลข
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    // จัดรูปแบบเป็น DD/MM/YYYY
    if (text.length > 2 && text.length <= 4) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    } else if (text.length > 4 && text.length <= 8) {
      text =
          '${text.substring(0, 2)}/${text.substring(2, 4)}/${text.substring(4)}';
    }

    // จำกัดความยาวไม่เกิน 10 ตัว (รวม /)
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

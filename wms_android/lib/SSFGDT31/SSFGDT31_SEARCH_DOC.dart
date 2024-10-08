import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart'; // Importing for input formatters
import 'package:wms_android/styles.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT31_CARD.dart'; // Import the SSFGDT31_CARD file

class SSFGDT31_SEARCH_DOC extends StatefulWidget {
  final String pWareCode;

  SSFGDT31_SEARCH_DOC({
    Key? key,
    required this.pWareCode,
  }) : super(key: key);

  @override
  _SSFGDT31_SEARCH_DOCState createState() => _SSFGDT31_SEARCH_DOCState();
}

class _SSFGDT31_SEARCH_DOCState extends State<SSFGDT31_SEARCH_DOC> {
  DateTime? _selectedDate;
  final List<String> statusItems = [
    'ทั้งหมด',
    'ระหว่างบันทึก',
    'ปกติ',
    'ยืนยันการตรวจรับ',
    'อ้างอิงแล้ว',
    'ยกเลิก',
    'รับเข้าคลัง',
  ];

  String? selectedValue;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController _selectedStatusController =
      TextEditingController();
  bool isDateValid = true;

  @override
  void initState() {
    super.initState();
    print(widget.pWareCode);
    selectedValue = 'ระหว่างบันทึก';
    _selectedStatusController.text = selectedValue!;
    _dateController.text = _selectedDate == null
        ? ''
        : DateFormat('dd/MM/yyyy').format(_selectedDate!);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _selectedStatusController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _showStatusDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Close Button
                Row(
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
                SizedBox(height: 16),

                // ListView with items having a black frame
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: statusItems.length,
                    itemBuilder: (context, index) {
                      final item = statusItems[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              width: 1.0), // Black border around each item
                          borderRadius: BorderRadius.circular(
                              5.0), // Rounded corners for each item (optional)
                        ),
                        child: ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              selectedValue = item;
                              _selectedStatusController.text = item;
                            });
                            Navigator.of(context).pop();
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

  void _validateDate(String value) {
    if (value.isNotEmpty) {
      final parts = value.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);

        if (day != null && month != null && year != null) {
          final date = DateTime(year, month, day);
          setState(() {
            _selectedDate = date;
            isDateValid = true; // Set date valid if parsing is successful
          });
        } else {
          setState(() {
            isDateValid = false; // Set date invalid if parsing fails
          });
        }
      } else {
        setState(() {
          isDateValid = false; // Set date invalid if format is incorrect
        });
      }
    } else {
      setState(() {
        isDateValid = true; // Allow empty input as valid
      });
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
                GestureDetector(
                  onTap: _showStatusDialog,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _selectedStatusController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'ประเภทรายการ',
                        labelStyle:
                            TextStyle(fontSize: 16, color: Colors.black),
                        suffixIcon: Icon(Icons.arrow_drop_down,
                            color: Color.fromARGB(255, 113, 113, 113)),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _dateController,
                  readOnly: false, // Make the TextField editable
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'วันที่รับคืน',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'DD/MM/YYYY',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today_outlined,
                          color: Colors.black),
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                  onChanged: (value) {
                    String numbersOnly = value.replaceAll('/', '');

                    // Limit input to 8 digits (DDMMYYYY)
                    if (numbersOnly.length > 8) {
                      numbersOnly = numbersOnly.substring(0, 8);
                    }

                    // Format the input as DD/MM/YYYY
                    String formattedValue = '';
                    for (int i = 0; i < numbersOnly.length; i++) {
                      if (i == 2 || i == 4) {
                        formattedValue += '/'; // Add slashes after DD and MM
                      }
                      formattedValue += numbersOnly[i];
                    }

                    // Update the text field with formatted value
                    _dateController.value = TextEditingValue(
                      text: formattedValue,
                      selection: TextSelection.collapsed(
                          offset: formattedValue.length),
                    );

                    // Validate the date if it has 8 digits
                    if (numbersOnly.length == 8) {
                      final day = int.tryParse(numbersOnly.substring(0, 2));
                      final month = int.tryParse(numbersOnly.substring(2, 4));
                      final year = int.tryParse(numbersOnly.substring(4, 8));

                      if (day != null && month != null && year != null) {
                        final date = DateTime(year, month, day);

                        if (date.year == year &&
                            date.month == month &&
                            date.day == day) {
                          setState(() {
                            isDateValid = true; // Valid date
                            _selectedDate = date; // Update selected date
                          });
                        } else {
                          setState(() {
                            isDateValid = false; // Invalid date
                          });
                        }
                      } else {
                        setState(() {
                          isDateValid = false; // Invalid date components
                        });
                      }
                    } else {
                      setState(() {
                        isDateValid =
                            false; // Invalid length (not 8 digits yet)
                      });
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    LengthLimitingTextInputFormatter(
                        8), // Limit to 8 digits (DDMMYYYY)
                  ],
                ),
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
                      onPressed: () {
                        setState(() {
                          _selectedDate = null;
                          _dateController.clear();
                          searchController.clear();
                          selectedValue = 'ทั้งหมด';
                          isDateValid = true; // Reset the validity
                        });
                      },
                      child: Image.asset('assets/images/eraser_red.png',
                          width: 50, height: 25),
                      style: AppStyles.EraserButtonStyle(),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (isDateValid == false) {
                        } else {
                          final documentNumber = searchController.text.isEmpty
                              ? 'null'
                              : searchController.text;

                          final selectedDate = _selectedDate == null
                              ? 'null'
                              : DateFormat('dd/MM/yyyy').format(_selectedDate!);

                          // Push to SSFGDT31_CARD with the selected values
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SSFGDT31_CARD(
                                soNo: documentNumber,
                                statusDesc: selectedValue ?? 'ทั้งหมด',
                                wareCode: widget.pWareCode,
                                receiveDate: selectedDate,
                              ),
                            ),
                          );
                        }
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
      bottomNavigationBar: BottomBar(), // Ensure you have a BottomBar widget
    );
  }
}

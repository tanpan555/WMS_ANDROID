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
                SizedBox(height: 16),

                // ListView with items having a black frame
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
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
                              16.0), // Rounded corners for each item (optional)
                        ),
                        child: ListTile(
                          title: Text(item, style: TextStyle(fontSize: 14)),
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

                // New TextField for search
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'เลขที่เอกสาร', // Label for the search field
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  style: TextStyle(color: Colors.black),
                ),

                const SizedBox(height: 16),
                TextField(
                  controller: _dateController,
                  readOnly: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'วันที่รับคืน',
                    labelStyle: TextStyle(
                      color: isDateValid == false ? Colors.red : Colors.black,
                    ),
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
                            isDateValid = true;
                          });
                        }
                      },
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Existing date validation and formatting logic here...
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
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
                              fontSize: 11),
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
                          isDateValid = true;
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
                          // Handle invalid date case
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
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}

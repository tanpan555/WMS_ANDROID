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

  @override
  void initState() {
    super.initState();
    print(widget.pWareCode);
    selectedValue = 'ระหว่างบันทึก';
    _dateController.text = _selectedDate == null
        ? ''
        : DateFormat('dd/MM/yyyy').format(_selectedDate!);
  }

  @override
  void dispose() {
    _dateController.dispose();
    searchController.dispose();
    super.dispose();
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
                    labelText: 'ประเภทรายการ',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  value: selectedValue,
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
                  buttonStyleData:
                      const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113)),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    maxHeight: 350,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: searchController,
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
                  controller: _dateController,
                  readOnly: false, // Make the TextField read-only
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'วันที่รับคืน',
                    labelStyle: TextStyle(color: Colors.black),
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
                        if (selectedDate != null && selectedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = selectedDate;
                            _dateController.text =
                                DateFormat('dd/MM/yyyy').format(selectedDate);
                          });
                        }
                      },
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Handle input formatting
                    if (RegExp(r'^\d{8}$').hasMatch(value)) {
                      final day = int.parse(value.substring(0, 2));
                      final month = int.parse(value.substring(2, 4));
                      final year = int.parse(value.substring(4, 8));
                      final date = DateTime(year, month, day);
                      setState(() {
                        _dateController.text = DateFormat('dd/MM/yyyy').format(date);
                        _selectedDate = date;
                      });
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    LengthLimitingTextInputFormatter(8), // Limit to 8 digits
                  ],
                ),
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
                        });
                      },
                      child: Image.asset('assets/images/eraser_red.png',
                          width: 50, height: 25),
                      style: AppStyles.EraserButtonStyle(),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
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

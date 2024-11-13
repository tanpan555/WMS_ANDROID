import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSFGDT04_CARD.dart';
import 'dart:ui';
import 'package:wms_android/Global_Parameter.dart' as gb;
import '../styles.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/checkDataFormate.dart';

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
  TextEditingController _controller = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  final String sDateFormat = "dd-MM-yyyy";
  final List<dynamic> dropdownItems = [
    'ทั้งหมด',
    'ยกเลิก',
    'ยืนยันการรับ',
    'ระหว่างบันทึก',
  ];
  final dateRegExp =
      RegExp(r"^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$");

  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false;
  bool chkDate = false;
  bool isLoading = false;
  String? initialFormattedDate;
  final dateInputFormatter = DateInputFormatter();
  bool isDateInvalid = false;

  @override
  void initState() {
    setData();
    super.initState();
    print(
        'selectedItem in search page : $selectedItem Type : ${selectedItem.runtimeType}');
    print('statusDESC in search page : $status Type : ${status.runtimeType}');
    print(
        'selectedDate in search page : $selectedDate Type : ${selectedDate.runtimeType}');
  }

  @override
  void dispose() {
    _dateController.dispose();
    _controller.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void setData() {
    isLoading = true;
    if (mounted) {
      setState(() {
        _statusController.text = 'ระหว่างบันทึก';
        isLoading = false;
      });
    }
  }
  
  Future<void> _selectDate(
      BuildContext context, String? initialDateString) async {
    DateTime? initialDate;

    if (initialDateString != null) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parseStrict(initialDateString);
      } catch (e) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      String formattedDate = new DateFormat('dd/MM/yyyy').format(pickedDate);
      if (mounted) {
        setState(() {
          noDate = false;
          chkDate = false;
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

  void _showDropdownPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ประเภทรายการ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dropdownItems.length,
                        itemBuilder: (context, index) {
                          var item = dropdownItems[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedItem = item;
                                _statusController.text = selectedItem;

                                switch (item) {
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
                                    status = '0';
                                }
                              });
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      appBar:
          CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)', showExitWarning: false),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  onTap: _showDropdownPopup,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'ประเภทรายการ',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 113, 113, 113),
                    ),
                  ),
                  controller: _statusController,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'เลขที่เอกสาร',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      pSoNo = value.toUpperCase();
                    });
                  },
                ),

                const SizedBox(height: 8),
                TextFormField(
                  controller: _dateController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                    dateInputFormatter,
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'วันที่ส่งสินค้า',
                    hintText: 'DD/MM/YYYY',
                    hintStyle: const TextStyle(color: Colors.grey),
                    labelStyle: isDateInvalid
                        ? const TextStyle(color: Colors.red)
                        : const TextStyle(color: Colors.black87),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context, selectedDate);
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedDate = value;
                      isDateInvalid = dateInputFormatter.noDateNotifier.value;
                    });
                    print('isDateInvalid : $isDateInvalid');
                  },
                ),
                if (isDateInvalid == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                // const SizedBox(height: 20),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          _dateController.clear();
                          _statusController.text =
                              'ทั้งหมด'; // Set the default for dropdown
                          selectedDate = 'null'; // Reset selectedDate to null
                          selectedItem = 'ทั้งหมด'; // Reset dropdown selection
                          status = '0';
                          noDate = false;
                          chkDate = false; // Reset status to default

                          // Clear date error when delete button is pressed
                          isDateInvalid = false;
                        });
                      },
                      style: AppStyles.EraserButtonStyle(),
                      child: Image.asset('assets/images/eraser_red.png',
                          width: 50, height: 25),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        // ตรวจสอบว่า selectedDate ไม่เป็น null หรือว่าง
                        if (isDateInvalid == false) {
                          if (selectedDate != 'null' &&
                              selectedDate.isNotEmpty &&
                              selectedDate != 'null') {
                            try {
                              // แปลงวันที่ให้เป็นรูปแบบที่ถูกต้อง
                              String modifiedDate =
                                  selectedDate.replaceAll('-', '/');
                              DateTime parsedDate =
                                  DateFormat('dd/MM/yyyy').parse(modifiedDate);

                              // แปลงวันที่กลับเป็นรูปแบบ dd-MM-yyyy
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(parsedDate);

                              setState(() {
                                selectedDate = formattedDate;
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SSFGDT04_CARD(
                                    pErpOuCode: widget.pErpOuCode,
                                    pWareCode: widget.pWareCode,
                                    pAppUser: appUser,
                                    pFlag: pFlag,
                                    soNo: pSoNo.isEmpty ? 'null' : pSoNo,
                                    date: formattedDate.isEmpty
                                        ? 'null'
                                        : formattedDate,
                                    status: status,
                                  ),
                                ),
                              ).then((value) async {
                                print('isDateInvalid PPPPPP $isDateInvalid');
                                print('selectedDate PPPPPP $selectedDate');
                              });
                            } catch (e) {
                              // ถ้ามีข้อผิดพลาดในการแปลงวันที่ จับข้อผิดพลาดและแสดงข้อความ
                              print('Error parsing date: $e');
                              // สามารถเพิ่มการแจ้งเตือนหรือแสดงข้อความให้กับผู้ใช้ที่ไม่สามารถแปลงวันที่ได้
                            }
                          } else {
                            // หาก selectedDate เป็น null หรือว่างให้ส่งค่า 'null' แทน
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SSFGDT04_CARD(
                                  pErpOuCode: widget.pErpOuCode,
                                  pWareCode: widget.pWareCode,
                                  pAppUser: appUser,
                                  pFlag: pFlag,
                                  soNo: pSoNo.isEmpty ? 'null' : pSoNo,
                                  date:
                                      'null', // ส่ง 'null' เมื่อ selectedDate เป็นค่าว่างหรือ null
                                  status: status,
                                ),
                              ),
                            ).then((value) async {});
                          }
                        }
                      },
                      style: AppStyles.SearchButtonStyle(),
                      child: Image.asset(
                        'assets/images/search_color.png',
                        width: 50,
                        height: 25,
                      ),
                    )
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

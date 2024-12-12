import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSFGDT04_CARD.dart';
import 'dart:ui';
import 'package:wms_android/Global_Parameter.dart' as gb;
import '../styles.dart';
import 'package:flutter/services.dart';
import '../TextFormFieldCheckDate.dart';

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
  String? pSoNo;
  DateTime? selectedDate;
  String selectedItem =
      'ระหว่างบันทึก'; // Ensure this value exists in dropdownItems
  String status = '1'; // Default status
  String appUser = gb.APP_USER;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _soNoController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  final List<dynamic> statusItems = [
    'ทั้งหมด',
    'ยกเลิก',
    'ยืนยันการรับ',
    'ระหว่างบันทึก',
  ];

  bool isLoading = false;
  final ValueNotifier<bool> isDateInvalidNotifier = ValueNotifier<bool>(false);
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
    _soNoController.dispose();
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
                            'เลือกประเภทรายการ',
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
                        itemCount: statusItems.length,
                        itemBuilder: (context, index) {
                          var item = statusItems[index];
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
                  controller: _soNoController,
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
                CustomTextFormField(
                  controller: _dateController,
                  labelText: 'วันที่ส่งสินค้า',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    try {
                      selectedDate = DateFormat('dd/MM/yyyy').parse(value);
                    } catch (e) {
                      selectedDate = null; // Set to null if parsing fails
                      print('Invalid date format: $value');
                    }
                    print('วันที่: $selectedDate');
                  },
                  isDateInvalidNotifier: isDateInvalidNotifier,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          pSoNo = '';
                          status = '0';
                          selectedDate = null;
                          selectedItem = 'ทั้งหมด';
                          _statusController.text = 'ทั้งหมด';
                          _soNoController.clear();
                          _dateController.clear();
                          isDateInvalidNotifier.value = false;
                        });
                      },
                      style: AppStyles.EraserButtonStyle(),
                      child: Image.asset('assets/images/eraser_red.png',
                          width: 50, height: 25),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (isDateInvalidNotifier.value == false) {
                          pSoNo = _soNoController.text.isNotEmpty
                              ? _soNoController.text
                              : null;

                          String formattedDate = selectedDate != null
                              ? DateFormat('dd-MM-yyyy').format(selectedDate!)
                              : 'null';
                          String soNoRP =
                              _soNoController.text.replaceAll(' ', '');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SSFGDT04_CARD(
                                pErpOuCode: widget.pErpOuCode,
                                pWareCode: widget.pWareCode,
                                pAppUser: appUser,
                                pFlag: pFlag,
                                status: status,
                                soNo: soNoRP == '' ? 'null' : soNoRP,
                                date: formattedDate,
                              ),
                            ),
                          ).then((value) async {
                            if (soNoRP == '') {
                              setState(() {
                                pSoNo = '';
                                _soNoController.text = '';
                              });
                            }
                            print('isDateInvalid $isDateInvalid');
                            print('selectedDate $selectedDate');
                          });
                        }
                      },
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
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/TextFormFieldCheckDate.dart';
import 'SSFGDT31_CARD.dart';

class Ssfgdt31Search extends StatefulWidget {
  final String pWareCode;
  final String pWareName;
  Ssfgdt31Search({
    Key? key,
    required this.pWareCode,
    required this.pWareName,
  }) : super(key: key);
  @override
  _Ssfgdt31SearchState createState() => _Ssfgdt31SearchState();
}

class _Ssfgdt31SearchState extends State<Ssfgdt31Search> {
  int pFlag = 1;
  String pSoNo = '';
  String selectedItem = 'ระหว่างบันทึก';
  String statusDESC = 'ระหว่างบันทึก';
  String selectedDate = '';
  String appUser = globals.APP_USER;
  TextEditingController dateController = TextEditingController();
  final TextEditingController pSoNoController = TextEditingController();
  final String sDateFormat = "dd-MM-yyyy";
  final TextEditingController dataLovStatusController = TextEditingController();
  List<dynamic> dropdownItems = [
    {
      'd': 'ทั้งหมด',
      'r': 'ทั้งหมด',
    },
    {
      'd': 'ระหว่างบันทึก',
      'r': 'ระหว่างบันทึก',
    },
    {
      'd': 'ปกติ',
      'r': 'ปกติ',
    },
    {
      'd': 'ยืนยันการตรวจรับ',
      'r': 'ยืนยันการตรวจรับ',
    },
    {
      'd': 'อ้างอิงแล้ว',
      'r': 'อ้างอิงแล้ว',
    },
    {
      'd': 'ยกเลิก',
      'r': 'ยกเลิก',
    },
    {
      'd': 'รับเข้าคลังแล้ว',
      'r': 'รับเข้าคลังแล้ว',
    },
  ];
  final ValueNotifier<bool> isDateInvalidNotifier = ValueNotifier<bool>(false);
  bool isDateInvalid = false;

  bool isLoading = false;

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    pSoNoController.dispose();
    dataLovStatusController.dispose();
    super.dispose();
  }

  void setData() {
    isLoading = true;
    if (mounted) {
      setState(() {
        dataLovStatusController.text = 'ระหว่างบันทึก';
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(
    BuildContext context,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      String formattedDate = new DateFormat('dd/MM/yyyy').format(pickedDate);
      if (mounted) {
        setState(() {
          isDateInvalid = false;
          dateController.text = formattedDate;
          selectedDate = dateController.text;
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
      appBar: CustomAppBar(
          title: 'รับคืนจากการเบิกเพื่อผลผลิต', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: LoadingIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: dataLovStatusController,
                      readOnly: true,
                      onTap: () => showDialogSelectDataStatus(),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'ประเภทรายการ',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                        ),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    //////////////////////////////////////////////////////////////
                    TextFormField(
                      controller: pSoNoController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'เลขที่เอกสาร',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          pSoNo = value;
                        });
                      },
                    ),
                    //////////////////////////////////////////////////////////////
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: dateController,
                      labelText: 'วันที่รับคืน',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        selectedDate = value;
                        print('วันที่ที่กรอก: $selectedDate');
                      },
                      isDateInvalidNotifier: isDateInvalidNotifier,
                    ),
                    //////////////////////////////////////////////////////////////
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              pSoNo = '';
                              selectedDate = '';
                              selectedItem = 'ทั้งหมด';
                              statusDESC = 'ทั้งหมด';
                              dataLovStatusController.text = 'ทั้งหมด';
                              dateController.clear();
                              pSoNoController.clear();
                              isDateInvalid = false;
                            });
                          },
                          style: AppStyles.EraserButtonStyle(),
                          child: Image.asset(
                            'assets/images/eraser_red.png', // ใส่ภาพจากไฟล์ asset
                            width: 50, // กำหนดขนาดภาพ
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 20),
                        //////////////////////////////////////////////////////
                        ElevatedButton(
                          onPressed: () {
                            if (isDateInvalid == false) {
                              String pSoNoRP = pSoNo.replaceAll(' ', '');
                              if (selectedDate.isNotEmpty) {
                                if (selectedDate != '') {
                                  String modifiedDate =
                                      selectedDate.replaceAll('-', '/');
                                  DateTime parsedDate = DateFormat('dd/MM/yyyy')
                                      .parse(modifiedDate);
                                  String formattedDate =
                                      DateFormat('dd-MM-yyyy')
                                          .format(parsedDate);

                                  setState(() {
                                    selectedDate = formattedDate;
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Ssfgdt31Card(
                                          pWareCode: widget.pWareCode,
                                          pStatusDESC: statusDESC,
                                          pSoNo:
                                              pSoNoRP == '' ? 'null' : pSoNoRP,
                                          pDocDate: formattedDate == ''
                                              ? 'null'
                                              : formattedDate),
                                    ),
                                  ).then(
                                    (value) async {
                                      if (pSoNoRP == '') {
                                        setState(() {
                                          pSoNo = '';
                                          pSoNoController.text = '';
                                        });
                                      }
                                    },
                                  );
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Ssfgdt31Card(
                                        pWareCode: widget.pWareCode,
                                        pStatusDESC: statusDESC,
                                        pSoNo: pSoNoRP == '' ? 'null' : pSoNoRP,
                                        pDocDate: 'null'),
                                  ),
                                ).then(
                                  (value) async {
                                    if (pSoNoRP == '') {
                                      setState(() {
                                        pSoNo = '';
                                        pSoNoController.text = '';
                                      });
                                    }
                                  },
                                );
                              }
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
      bottomNavigationBar: BottomBar(
        currentPage: 'not_show',
      ),
    );
  }

  void showDialogSelectDataStatus() {
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
                    Expanded(
                      child: ListView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                                    item['d'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    selectedItem = item['d'];
                                    statusDESC = item['r'];
                                    dataLovStatusController.text = selectedItem;
                                    // -----------------------------------------
                                    print(
                                        'dataLovStatusController New: $dataLovStatusController Type : ${dataLovStatusController.runtimeType}');
                                    print(
                                        'selectedItem New: $selectedItem Type : ${selectedItem.runtimeType}');
                                    print(
                                        'statusDESC New: $statusDESC Type : ${statusDESC.runtimeType}');
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )

                    // ช่องค้นหา
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

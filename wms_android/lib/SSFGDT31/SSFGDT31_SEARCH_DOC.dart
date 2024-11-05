import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/checkDataFormate.dart';
import 'package:wms_android/loading.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT31_CARD.dart';

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
  String selectedItem = 'ระหว่างบันทึก'; // display status
  String statusDESC = 'ระหว่างบันทึก'; // return status
  String selectedDate = ''; // diaplay date
  String pSoNo = ''; // diaplay sono
  bool isLoading = false;
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
      'd': 'รับเข้าคลัง',
      'r': 'รับเข้าคลัง',
    },
  ];

  final TextEditingController dateController = TextEditingController();
  final TextEditingController pSoNoController = TextEditingController();
  final TextEditingController dataLovStatusController = TextEditingController();
  final dateInputFormatter = DateInputFormatter();
  bool isDateInvalid = false;

  @override
  void initState() {
    if (mounted) {
      dataLovStatusController.text = 'ระหว่างบันทึก';
    }
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    dataLovStatusController.dispose();
    pSoNoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, String? initialDateString) async {
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
          dateController.text = formattedDate;
          selectedDate = dateController.text;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: 'รับคืนจากการเบิกผลิต', showExitWarning: false),
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
                      onTap: () => showDialogDropdownSearchStatus(),
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
                    //////////////////////////////////////////////////////////////
                    const SizedBox(height: 8),
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
                    TextFormField(
                      controller: dateController,
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
                        labelText: 'วันที่รับคืน',
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
                          isDateInvalid =
                              dateInputFormatter.noDateNotifier.value;
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = '';
                              dateController.clear();
                              pSoNoController.clear();
                              selectedItem = 'ทั้งหมด';
                              statusDESC = 'ทั้งหมด';
                              dataLovStatusController.text = 'ทั้งหมด';
                            });
                          },
                          child: Image.asset('assets/images/eraser_red.png',
                              width: 50, height: 25),
                          style: AppStyles.EraserButtonStyle(),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (isDateInvalid == false) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SSFGDT31_CARD(
                                    soNo: pSoNo.isNotEmpty ? pSoNo : 'null',
                                    statusDesc: statusDESC,
                                    wareCode: widget.pWareCode,
                                    receiveDate: selectedDate.isNotEmpty
                                        ? selectedDate
                                        : 'null',
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
      bottomNavigationBar: BottomBar(
        currentPage: 'not_show',
      ),
    );
  }

  void showDialogDropdownSearchStatus() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customSelectLovDialog(
          context: context,
          headerText: 'เลือกประเภทรายการ',
          data: dropdownItems,
          displayItem: (item) => '${item['d'] ?? ''}',
          onTap: (item) {
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSFGDT12_grid.dart';

class Ssfgdt12Form extends StatefulWidget {
  final String docNo;
  final String pOuCode;
  final String browser_language;
  final String wareCode; // ware code ที่มาจาก API แต่เป็น null
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final String p_attr1;
  Ssfgdt12Form({
    Key? key,
    required this.docNo,
    required this.pOuCode,
    required this.browser_language,
    required this.wareCode,
    required this.pWareCode,
    required this.p_attr1,
  }) : super(key: key);
  @override
  _Ssfgdt12FormState createState() => _Ssfgdt12FormState();
}

class _Ssfgdt12FormState extends State<Ssfgdt12Form> {
  //
  List<dynamic> dataForm = [];
  String staffCode = '';
  String docDate = '';
  String nbStaffName = '';
  String nbStaffCountName = '';
  String countStaff = '';
  String nbCountStaff = '';
  String updBy = '';
  String updDate = '';
  String remark = '';
  String status = '';
  String updBy1 = '';
  String nbCountDate = '';
  String docNo = '';

  final TextEditingController staffCodeController = TextEditingController();
  final TextEditingController docDateController = TextEditingController();
  final TextEditingController nbStaffNameController = TextEditingController();
  final TextEditingController nbStaffCountNameController =
      TextEditingController();
  final TextEditingController countStaffController = TextEditingController();
  final TextEditingController nbCountStaffController = TextEditingController();
  final TextEditingController updByController = TextEditingController();
  final TextEditingController updDateController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController updBy1Controller = TextEditingController();
  final TextEditingController nbCountDateController = TextEditingController();
  final TextEditingController docNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    print(
        'wareCode : ${widget.wareCode} Type : ${widget.wareCode.runtimeType}');
  }

  @override
  void dispose() {
    staffCodeController.dispose();
    docDateController.dispose();
    nbStaffNameController.dispose();
    nbStaffCountNameController.dispose();
    countStaffController.dispose();
    nbCountStaffController.dispose();
    updByController.dispose();
    updDateController.dispose();
    remarkController.dispose();
    statusController.dispose();
    updBy1Controller.dispose();
    nbCountDateController.dispose();
    docNoController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/formPageData/${widget.pOuCode}/${widget.docNo}/${widget.browser_language}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          //

          //
          print('Fetched data: $jsonDecode');

          setState(() {
            staffCode = item['staff_code'] ?? '';
            docDate = item['doc_date'] ?? '';
            nbStaffName = item['nb_staff_name'] ?? '';
            nbStaffCountName = item['nb_staff_count_name'] ?? '';
            countStaff = item['count_staff'] ?? '';
            nbCountStaff = item['nb_count_staff'] ?? '';
            updBy = item['upd_by'] ?? '';
            updDate = item['upd_date'] ?? '';
            remark = item['remark'] ?? '';
            status = item['status'] ?? '';
            updBy1 = item['upd_by1'] ?? '';
            nbCountDate = item['nb_count_date'] ?? '';
            docNo = widget.docNo;

            staffCodeController.text = staffCode;
            docDateController.text = docDate;
            nbStaffNameController.text = nbStaffName;
            nbStaffCountNameController.text = nbStaffCountName;
            countStaffController.text = countStaff;
            nbCountStaffController.text = nbCountStaff;
            updByController.text = updBy;
            updDateController.text = updDate;
            remarkController.text = remark;
            statusController.text = status;
            updBy1Controller.text = updBy1;
            nbCountDateController.text = nbCountDate;
            docNoController.text = docNo;
          });
        } else {
          print('No items found.');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      // Format the date as dd/MM/yyyy
      String formattedDate = new DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        nbCountDateController.text = formattedDate;
        nbCountDate = nbCountDateController.text;
      });
    }
  }

  // Future<void> fetchData() async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'http://172.16.0.82:8888/apex/wms/SSFGDT12/formPageData/${widget.pOuCode}/${widget.docNo}/${widget.browser_language}'));

  //     if (response.statusCode == 200) {
  //       final responseBody = utf8.decode(response.bodyBytes);
  //       final responseData = jsonDecode(responseBody);
  //       //

  //         //
  //       print('Fetched data: $jsonDecode');

  //       setState(() {
  //         dataForm =
  //             List<Map<String, dynamic>>.from(responseData['items'] ?? []);
  //       });
  //       print('dataForm : $dataForm');
  //     } else {
  //       throw Exception('Failed to load fetchData');
  //     }
  //   } catch (e) {
  //     setState(() {});
  //     print('ERROR IN Fetch Data : $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'ผลการตรวจนับ'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    iconSize: 20.0,
                    icon: Image.asset(
                      'assets/images/right.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Ssfgdt12Grid(
                            nbCountStaff: nbCountStaff,
                            nbCountDate: nbCountDate,
                            docNo: docNo,
                            status: status,
                            wareCode: widget.wareCode,
                            pOuCode: widget.pOuCode,
                            pWareCode: widget.pWareCode,
                            docDate: docDate,
                            countStaff: countStaff,
                            p_attr1: widget.p_attr1,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: docNoController,
                      readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          // borderRadius: BorderRadius.circular(5.5),
                        ),
                        // hintText: 'เลขที่เอกสาร',
                        // hintStyle: const TextStyle(color: Colors.blue),
                        labelText: "เลขที่เอกสาร",
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[350],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: docDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        labelText: 'วันที่เตรียมการตรวจนับ',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[350],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nbCountDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        labelText: 'วันที่ตรวจนับ',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon:
                            Icon(Icons.calendar_today, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: staffCodeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        labelText: 'ผู้เตรียมข้อมูลตรวจนับ',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[350],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nbStaffNameController,
                      readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        labelText: '',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[350],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nbCountStaffController,
                      // readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        labelText: 'ผู้ทำการตรวจนับ',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          nbCountStaff = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nbStaffCountNameController,
                      readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        labelText: '',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[350],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: remarkController,
                      readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        labelText: 'คำอธิบาย',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[350],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: statusController,
                      readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        labelText: 'สถานะเอกสาร',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[350],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: updBy1Controller,
                      readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        labelText: 'ผู้ปรับปรุงล่าสุด',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[350],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: updDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        labelText: 'วันที่ปรับปรุงล่าสุด',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[350],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

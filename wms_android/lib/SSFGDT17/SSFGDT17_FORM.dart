import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_BARCODE.dart';
import 'package:wms_android/custom_appbar.dart';
// import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:http/http.dart' as http;

class SSFGDT17_FORM extends StatefulWidget {
  final String po_doc_no;
  final String? po_doc_type;
  final String? LocCode;

  final String? selectedwhCode;
  final String? selectedLocCode;
  final String? whOUTCode;
  final String? LocOUTCode;

  SSFGDT17_FORM(
      {required this.po_doc_no,
      this.po_doc_type,
      this.LocCode,
      this.selectedwhCode,
      this.selectedLocCode,
      this.whOUTCode,
      this.LocOUTCode});

  @override
  _SSFGDT17_FORMState createState() => _SSFGDT17_FORMState();
}

class _SSFGDT17_FORMState extends State<SSFGDT17_FORM> {
  String currentSessionID = '';
  late DateTime selectedDate;
  final ERP_OU_CODE = gb.P_ERP_OU_CODE;
  final P_OU_CODE = gb.P_OU_CODE;
  final APP_USER = gb.APP_USER;

  late final TextEditingController po_doc_noText =
      TextEditingController(text: widget.po_doc_no);
  late final TextEditingController po_doc_typeText =
      TextEditingController(text: widget.po_doc_type ?? '');
  late final TextEditingController CR_DATE = TextEditingController();
  late final TextEditingController REF_NO = TextEditingController();
  late final TextEditingController MO_DO_NO = TextEditingController();
  late final TextEditingController NB_WARE_CODE = TextEditingController();
  late final TextEditingController REF_ERP = TextEditingController();
  late final TextEditingController NB_TO_WH = TextEditingController();
  late final TextEditingController STAFF_CODE = TextEditingController();
  late final TextEditingController PO_REMARK = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
    selectedDate = DateTime.now();
    CR_DATE.text = _formatDate(selectedDate);
    print('ERP_OU_CODE: $ERP_OU_CODE');
    print('P_OU_CODE: $P_OU_CODE');
    print('APP_USER: $APP_USER');
    print('LocCode: ${widget.LocCode}');
    print(widget.selectedwhCode);
  }

  @override
  void dispose() {
    po_doc_noText.dispose();
    po_doc_typeText.dispose();
    CR_DATE.dispose();
    REF_NO.dispose();
    MO_DO_NO.dispose();
    NB_WARE_CODE.dispose();
    REF_ERP.dispose();
    NB_TO_WH.dispose();
    STAFF_CODE.dispose();
    PO_REMARK.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        CR_DATE.text = _formatDate(selectedDate);
      });
    }
  }

  String? poStatus;
  String? poMessage;

  Future<void> chk_validateSave() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT17/validateSave_INHeadXfer_WMS/$P_OU_CODE/$ERP_OU_CODE/${widget.po_doc_no}/$APP_USER');

    final headers = {
      'Content-Type': 'application/json',
    };

    print('headers : $headers Type : ${headers.runtimeType}');
    print('URL : $url');

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];

          print('poStatus: $poStatus');
          print('poMessage: $poMessage');
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: const CustomAppBar(title: 'Move Locator',),
      body: Column(
        children: [
          Row(
            children: [
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: const Color.fromARGB(255, 103, 58, 183),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12.0),
              //     ),
              //     minimumSize: const Size(10, 20),
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              //   child: const Text(
              //     'ย้อนกลับ',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: const Size(10, 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                onPressed: () async{
                  await chk_validateSave();
                  if (poStatus == '0') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SSFGDT17_BARCODE(
                            po_doc_no: widget.po_doc_no ?? '',
                            po_doc_type: widget.po_doc_type,
                            LocCode: widget.LocCode,
                            selectedwhCode: widget.selectedwhCode,
                            selectedLocCode: widget.selectedLocCode,
                            whOUTCode: widget.whOUTCode,
                            LocOUTCode: widget.LocOUTCode),
                      ),
                    );
                  }
                },
                child: const Icon(
                  Icons.arrow_forward,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 24,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  SizedBox(height: 8),
                  _buildTextField(po_doc_noText, 'เลขที่เอกสาร WMS',
                      readOnly: true),
                  _buildTextField(po_doc_typeText, 'ประเภทเอกสาร',
                      readOnly: true),
                  _buildDateTextField(CR_DATE, 'วันที่บันทึก'),
                  _buildTextField(REF_NO, 'เลขที่เอกสารอ้างอิง'),
                  _buildTextField(MO_DO_NO, 'เลขที่คำสั่งผลผลิต'),
                  _buildTextField(NB_WARE_CODE, 'คลังต้นทาง', readOnly: true),
                  _buildTextField(NB_TO_WH, 'คลังปลายทาง', readOnly: true),
                  _buildTextField(STAFF_CODE, 'ผู้บันทึก'),
                  _buildTextField(PO_REMARK, 'หมายเหตุ'),
                  _buildTextField(REF_ERP, 'เลขที่เอกสาร ERP'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : Colors.white,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none),
      ),
    );
  }
}

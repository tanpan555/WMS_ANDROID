import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import '../styles.dart';
import 'SSFGPC04_WARE.dart';
import '../TextFormFieldCheckDate.dart';

class SSFGPC04_MAIN extends StatefulWidget {
  final String? v_nb_doc_no;
  final String? note;

  const SSFGPC04_MAIN({Key? key, this.v_nb_doc_no, this.note}) : super(key: key);
  @override
  _SSFGPC04_MAINState createState() => _SSFGPC04_MAINState();
}

class _SSFGPC04_MAINState extends State<SSFGPC04_MAIN> {
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Default status
  DateTime? selectedDate; // Allow null for the date
  String pSoNo = 'null';
  TextEditingController _dateController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  late TextEditingController _docNoController;
  final ValueNotifier<bool> isDateInvalidNotifier = ValueNotifier<bool>(false);
  final dateInputFormatter = DateInputFormatter();
  bool isDateInvalid = false;

  @override
void initState() {
  super.initState();
  _docNoController = TextEditingController(
    text: widget.v_nb_doc_no ?? 'AUTO',
  );
  final now = DateTime.now();
  _dateController.text = DateFormat('dd/MM/yyyy').format(now);
  selectedDate = now; // กำหนดค่าเริ่มต้นให้ selectedDate ตรงกับวันที่ปัจจุบัน
  _noteController = TextEditingController(text: widget.note);
}


  @override
  void dispose() {
    _dateController.dispose();
    _docNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: 'ประมวลผลก่อนการตรวจนับ', showExitWarning: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _dateController,
                  labelText: 'ณ วันที่',
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
                const SizedBox(height: 8),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'เลขที่เอกสาร',
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle:
                        const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    border: InputBorder.none,
                  ),
                  controller: _docNoController.text.isNotEmpty
                      ? _docNoController
                      : TextEditingController(text: 'AUTO'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'หมายเหตุ',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    // floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  controller: _noteController,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
  onPressed: () {
    try {
      // พยายามแปลงค่าจาก _dateController เป็น DateTime
      selectedDate = DateFormat('dd/MM/yyyy').parse(_dateController.text);
    } catch (e) {
      selectedDate = null; // หากไม่สามารถแปลงได้ ให้ตั้งค่าเป็น null
    }

    if (selectedDate != null && isDateInvalidNotifier.value == false) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SSFGPC04_WARE(
            docNo: _docNoController.text,
            note: _noteController.text,
            date: formattedDate, // ส่งวันที่ในรูปแบบ dd-MM-yyyy
          ),
        ),
      );
    } else {
      // แสดงคำเตือนหากวันที่ไม่ถูกต้อง
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณากรอกวันที่ให้ถูกต้อง'),
        ),
      );
    }
  },
  style: AppStyles.ConfirmbuttonStyle(),
  child: Text(
    'NEXT',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      letterSpacing: 1.2,
    ),
  ),
),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }
}

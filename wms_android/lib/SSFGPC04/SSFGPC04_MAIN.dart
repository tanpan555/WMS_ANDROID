import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import '../styles.dart';
import 'SSFGPC04_WARE.dart';
import '../TextFormFieldCheckDate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;

class SSFGPC04_MAIN extends StatefulWidget {
  final String? v_nb_doc_no;
  final String? note;

  const SSFGPC04_MAIN({Key? key, this.v_nb_doc_no, this.note})
      : super(key: key);
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
  String note = '';
  String docDate = '';
  TextEditingController _dateController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  late TextEditingController _docNoController;
  final ValueNotifier<bool> isDateInvalidNotifier = ValueNotifier<bool>(false);
  final dateInputFormatter = DateInputFormatter();
  bool isDateInvalid = false;
  bool checkUpdateData = false;

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

  String message = '';
  Future<void> deleteData() async {
    final String url =
        'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_1_clear_temp';
    // final String url = '${gb.IP_API}/apex/wms/SSFGPC04/Step_1_clear_temp';
    print('Sending DELETE to: $url');
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'APP_SESSION': gb.APP_SESSION}),
      );
      print(gb.APP_SESSION);

      if (response.statusCode == 200) {
        print('Delete successful: ${response.body}');
        setState(() {
          message = 'Data deleted successfully.';
        });
      } else {
        print('Delete failed with status: ${response.statusCode}');
        setState(() {
          message = 'Failed to delete. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Delete error: $e');
      setState(() {
        message = 'Error deleting data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'ประมวลผลก่อนการตรวจนับ', showExitWarning: checkUpdateData),
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
                  showAsterisk: true,
                  onChanged: (value) {
                    docDate = value;
                    print('วันที่ที่กรอก: $docDate');
                    if (docDate != selectedDate) {
                      checkUpdateData = true;
                    }
                  },
                  isDateInvalidNotifier: isDateInvalidNotifier,
                ),
                const SizedBox(height: 8),
                AbsorbPointer(
            child: TextField(
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
                  onChanged: (value) {
                    setState(() {
                      note = value;
                      if (note != _noteController) {
                        checkUpdateData = true;
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isDateInvalid
                          ? null // ปิดปุ่มหากวันที่ไม่ถูกต้อง
                          : () async {
                              try {
                                // พยายามแปลงค่าจาก _dateController เป็น DateTime
                                selectedDate = DateFormat('dd/MM/yyyy')
                                    .parse(_dateController.text);
                              } catch (e) {
                                selectedDate =
                                    null; // หากไม่สามารถแปลงได้ ให้ตั้งค่าเป็น null
                              }
                              if (_dateController.text.isEmpty ||
                                  isDateInvalidNotifier.value) {
                                isDateInvalidNotifier.value =
                                    true; // แสดงข้อความแจ้งเตือน
                                return;
                              }

                              if (selectedDate != null &&
                                  isDateInvalidNotifier.value == false) {
                                String formattedDate = DateFormat('dd-MM-yyyy')
                                    .format(selectedDate!);

                                // เรียกใช้งาน deleteData() และรอผลลัพธ์
                                await deleteData();

                                // นำทางไปยังหน้าถัดไป
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SSFGPC04_WARE(
                                      docNo: _docNoController.text,
                                      note: _noteController.text,
                                      date:
                                          formattedDate, // ส่งวันที่ในรูปแบบ dd-MM-yyyy
                                    ),
                                  ),
                                );
                              }
                            },
                      style: AppStyles.ConfirmbuttonStyle(),
                      child: Text(
                        'ถัดไป',
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

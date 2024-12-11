import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure you import intl for DateFormat
import 'package:wms_android/SSFGDT17/SSFGDT17_MAIN.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/styles.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:wms_android/Global_Parameter.dart' as gb;
import '../TextFormFieldCheckDate.dart';

class SSFGDT17_SEARCH extends StatefulWidget {
  final String pWareCode;
  const SSFGDT17_SEARCH({Key? key, required this.pWareCode}) : super(key: key);

  @override
  _SSFGDT17_SEARCHState createState() => _SSFGDT17_SEARCHState();
}

class _SSFGDT17_SEARCHState extends State<SSFGDT17_SEARCH> {
  final _formKey = GlobalKey<FormState>();
  String? docType;
  DateTime? _selectedDate;
  String? selectedValue;
  String? documentNumber;
  final _dateController = TextEditingController();
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _selectedProductTypeController =
      TextEditingController(text: 'ปกติ'); // Controller for product type
  final List<String> statusItems = ['ทั้งหมด', 'ปกติ', 'ยกเลิก', 'รับโอนแล้ว'];

  final ValueNotifier<bool> isDateInvalidNotifier = ValueNotifier<bool>(false);
  final dateInputFormatter = DateInputFormatter();
  bool isDateInvalid = false;

  @override
  void initState() {
    super.initState();
    selectedValue = 'ปกติ';
    fetchDocType();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _documentNumberController.dispose();
    _selectedProductTypeController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _documentNumberController.clear();
    _dateController.clear();
    _selectedProductTypeController.text = 'ทั้งหมด';
    if (mounted) {
      setState(() {
        isDateInvalidNotifier.value = false;
        selectedValue = 'ทั้งหมด';
        _selectedDate = null;
      });
    }
  }

  Future<void> fetchDocType() async {
    final response = await http.get(Uri.parse(
        '${gb.IP_API}/apex/wms/SSFGDT17/Step_1_default_doc_type/${gb.ATTR1}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (mounted) {
        setState(() {
          docType = data['DOC_TYPE'];
        });
      }
      print('Fetched docType: $docType');
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _showProductTypeDialog() {
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
                                selectedValue = item;
                                _selectedProductTypeController.text = item;
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
      appBar: CustomAppBar(title: 'Move Locator', showExitWarning: false),
      // backgroundColor: const Color(0xFF17153B),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _showProductTypeDialog,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _selectedProductTypeController,
                      decoration: InputDecoration(
                        labelText: 'ประเภทรายการ',
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.arrow_drop_down,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _documentNumberController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'เลขที่ใบโอน',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      documentNumber = value.toUpperCase();
                    });
                  },
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _dateController,
                  labelText: 'วันที่โอน',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    try {
                      _selectedDate = DateFormat('dd/MM/yyyy').parse(value);
                    } catch (e) {
                      _selectedDate = null; // Set to null if parsing fails
                      print('Invalid date format: $value');
                    }
                    print('วันที่: $_selectedDate');
                  },
                  isDateInvalidNotifier: isDateInvalidNotifier,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _resetForm,
                      child: Image.asset('assets/images/eraser_red.png',
                          width: 50, height: 25),
                      style: AppStyles.EraserButtonStyle(),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (isDateInvalidNotifier.value == false) {
                          final documentNumber =
                              _documentNumberController.text.isEmpty
                                  ? 'null'
                                  : _documentNumberController.text;

                          String formattedDate = _selectedDate != null
                              ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
                              : 'null';
                          String docnum = _documentNumberController.text
                              .replaceAll(' ', '');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SSFGDT17_MAIN(
                                pWareCode: widget.pWareCode,
                                selectedValue: selectedValue,
                                documentNumber: docnum == '' ? 'null' : docnum,
                                dateController: formattedDate,
                                docType: docType ?? '',
                              ),
                            ),
                          ).then((value) async {
                            if (docnum == '') {
                              setState(() {
                                _documentNumberController.text = '';
                              });
                            }
                            print('documentNumber $documentNumber');
                            print('docType $docType');
                            print('isDateInvalid $isDateInvalid');
                            print('selectedDate $_selectedDate');
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

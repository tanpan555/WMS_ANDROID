import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:wms_android/SSINDT01/SSINDT01_main.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/styles.dart';

class SSINDT01_SEARCH extends StatefulWidget {
  final String pWareCode;
  final String pWareName;
  final String p_ou_code;

  const SSINDT01_SEARCH(
      {Key? key,
      required this.pWareCode,
      required this.pWareName,
      required this.p_ou_code})
      : super(key: key);

  @override
  _SSINDT01_SEARCHState createState() => _SSINDT01_SEARCHState();
}

class _SSINDT01_SEARCHState extends State<SSINDT01_SEARCH> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> statusItems = [
    'ทั้งหมด',
    'รายการรอรับดำเนินการ',
    'รายการใบสั่งซื้อ'
  ];

  String currentSessionID = '';
  List<dynamic> apCodes = [];
  String errorMessage = '';
  String? _selectedValue = 'ทั้งหมด';
  String? selectedApCode = 'ทั้งหมด'; // Initialize with 'ทั้งหมด'
  String? documentNumber;

  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _selectedApCodeController =
      TextEditingController();
  final TextEditingController _selectedProductTypeController =
      TextEditingController(text: 'ทั้งหมด'); // Controller for product type

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
    fetchApCodes();
    print('Search Global Ware Code: ${gb.P_WARE_CODE}');
    log('Search Global Ware Code: ${gb.P_WARE_CODE}');
  }

  Future<void> fetchApCodes() async {
    try {
      final response = await http
          .get(Uri.parse('${gb.IP_API}/apex/wms/SSINDT01/Step_1_AP_CODE'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        if (mounted) {
          setState(() {
            apCodes = jsonData['items'] ?? [];
            // apCodes.insert(0, {'ap_code': 'ทั้งหมด', 'ap_name': 'ทั้งหมด'});
          });
        }
      } else {
        throw Exception('Failed to load AP codes');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          print(
              'errorMessage : $errorMessage Type : ${errorMessage.runtimeType}');
        });
      }
    }
  }

  void _resetForm() {
    if (mounted) {
      setState(() {
        _selectedValue = 'ทั้งหมด';
        selectedApCode = 'ทั้งหมด';
        _documentNumberController.clear();
        _selectedApCodeController.clear();
        errorMessage = '';
      });
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
                            'เลือกประเภทสินค้า',
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
                                _selectedValue = item; // Update the selection
                                _selectedProductTypeController.text =
                                    item; // Update the controller
                              });
                              Navigator.of(context).pop(); // Close the dialog
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

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'เลือกผู้ขาย', // Dialog title
          searchController: _searchController,
          data: apCodes,
          docString: (item) => '${item['ap_code']} ${item['ap_name']}',
          titleText: (item) => item['ap_code'],
          subtitleText: (item) => item['ap_name'],
          onTap: (item) {
            setState(() {
              selectedApCode = item['ap_code']; // Update selected code
              _selectedApCodeController.text =
                  item['ap_name']; // Update display text
            });
            Navigator.of(context).pop(); // Close the dialog after selection
          },
        );
      },
    ).then((_) {
      _searchController.clear(); // Clear search field after closing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ', showExitWarning: false),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _showProductTypeDialog,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _selectedProductTypeController,
                      decoration: InputDecoration(
                        labelText: 'ประเภทสินค้า',
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: _showDialog,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _selectedApCodeController,
                      decoration: InputDecoration(
                        labelText: 'ผู้ขาย',
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.black),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _documentNumberController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'เลขที่เอกสาร',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      documentNumber = value.toUpperCase();
                    });
                  },
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
                        final documentNumber =
                            _documentNumberController.text.isNotEmpty
                                ? _documentNumberController.text
                                : 'null';

                        print('selectedApCode $selectedApCode');
                        print(_selectedValue);
                        print(documentNumber);
                        String docNum =
                            _documentNumberController.text.replaceAll(' ', '');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SSINDT01_MAIN(
                              pWareCode: widget.pWareCode,
                              pWareName: widget.pWareName,
                              p_ou_code: widget.p_ou_code,
                              selectedValue: _selectedValue ?? 'ทั้งหมด',
                              apCode: selectedApCode ?? '',
                              documentNumber: docNum == '' ? 'null' : docNum,
                            ),
                          ),
                        ).then((value) async {
                          if (docNum == '') {
                            setState(() {
                              _documentNumberController.text = '';
                            });
                          }
                        });
                      },
                      style: AppStyles.SearchButtonStyle(),
                      child: Image.asset('assets/images/search_color.png',
                          width: 50, height: 25),
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

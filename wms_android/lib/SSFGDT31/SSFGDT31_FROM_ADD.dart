import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/SSFGDT31/SSFGDT31_CARD.dart';
import 'package:wms_android/SSFGDT31/SSFGDT31_GRID.dart';
import 'package:wms_android/SSFGDT31/SSFGDT31_SCREEN2.dart';
import 'package:wms_android/SSFGDT31/SSFGDT31_SEARCH_DOC.dart';
import 'package:wms_android/styles.dart';
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SSFGDT31_FROM extends StatefulWidget {
  final String po_doc_no;
  final String po_doc_type;
  final String pWareCode;

  SSFGDT31_FROM({
    Key? key,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.pWareCode,
  }) : super(key: key);

  @override
  _SSFGDT31_FROMState createState() => _SSFGDT31_FROMState();
}

class _SSFGDT31_FROMState extends State<SSFGDT31_FROM> {
  late final TextEditingController DOC_NO =
      TextEditingController(text: widget.po_doc_no);
  late final TextEditingController DOC_TYPE = TextEditingController();
  late final TextEditingController DOC_DATE = TextEditingController();
  late final TextEditingController REF_NO = TextEditingController();
  late final TextEditingController CUST = TextEditingController();
  late final TextEditingController NOTE = TextEditingController();
  late final TextEditingController ERP_DOC_NO = TextEditingController();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();
  final TextEditingController _searchController3 = TextEditingController();
  final TextEditingController _CcodeController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  List<dynamic> statusItems = [];
  List<Map<String, dynamic>> moDoNoItems = [];
  String? selectedMoDoNo;
  String? selectedValue;
  Future<void> fetchStatusItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/DOC_TYPE/${gb.ATTR1}'));
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      print('Fetched data: $data');

      setState(() {
        statusItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        print('dataMenu: $statusItems');

        final docType = widget.po_doc_type;
        final docDesc = statusItems
            .where((item) => item['doc_type'] == docType)
            .map((item) => item['doc_desc'])
            .firstWhere((desc) => desc != null, orElse: () => '');

        DOC_TYPE.text = docDesc;
      });
    } else {
      throw Exception('Failed to load status items');
    }
  }

  Future<void> fetchFormData() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/get_form/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'] ?? [];
        print(items);

        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];

          setState(() {
            DOC_NO.text = item['doc_no'] ?? '';
            DOC_TYPE.text = item['doc_type'] ?? '';
            DOC_DATE.text = _formatDate(DateTime.parse(
                item['doc_date'] ?? DateTime.now().toIso8601String()));
            REF_NO.text = item['ref_no'] ?? 'null';
            // CUST.text = item['staff_code'] ?? '';
            NOTE.text = item['note'] ?? '';
            ERP_DOC_NO.text = item['erp_doc_no'] ?? '';
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
    final DateTime? picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        DOC_DATE.text = displayFormat
            .format(selectedDate); // Update DOC_DATE with the selected date
        isDateValid =
            true; // Set isDateValid to true as we know this is a valid date
      });
    }
  }

  Future<void> fetchMoDoNoLIST() async {
    final url =
        Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT31/MO_DO_NO_LIST');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'] ?? [];
        print(items);

        if (items.isNotEmpty) {
          setState(() {
            moDoNoItems = List<Map<String, dynamic>>.from(items);
            if (moDoNoItems.isNotEmpty) {
              selectedMoDoNo = moDoNoItems[0]['mo_do_no'];
            }
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

  String? csValue;
  List<Map<String, dynamic>> custCodeItems = [];
  Future<void> fetchCustCode() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/CUST_CODE/$selectedMoDoNo');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'] ?? [];
        print(items);

        if (items.isNotEmpty) {
          setState(() {
            custCodeItems = List<Map<String, dynamic>>.from(items);
            if (custCodeItems.isNotEmpty) {
              csValue = custCodeItems[0]['cs'];
              print('CS Value: $csValue');
            } else {
              print('No items found.');
              custCodeItems = [];
            }
          });
        } else {
          print('No items found.');
          setState(() {
            custCodeItems = [];
          });
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? doc_no;
  List<Map<String, dynamic>> REF_NOItems = [];
  Future<void> REF_NO_LIST() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/REF_NO_LIST/${gb.P_ERP_OU_CODE}/${gb.ATTR1}/${widget.pWareCode}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'] ?? [];
        print(items);

        if (items.isNotEmpty) {
          setState(() {
            REF_NOItems = List<Map<String, dynamic>>.from(items);
            if (REF_NOItems.isNotEmpty) {
              csValue = REF_NOItems[0]['doc_no'] ?? 'null';
              print('doc_no: $doc_no');
            } else {
              print('No items found.');
              custCodeItems = [];
            }
          });
        } else {
          print('No items found.');
          setState(() {
            custCodeItems = [];
          });
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? v_ref_type;
  String? v_ref_doc_no;
  Future<void> updateForm() async {
    final url =
        Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT31/save_form');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'REF_NO': REF_NO.text,
          'DOC_TYPE': widget.po_doc_type,
          'MO_DO_NO': selectedMoDoNo,
          'doc_date': DOC_DATE.text,
          'note': NOTE.text,
          'UPD_BY': gb.APP_USER,
          'OU_CODE': gb.P_ERP_OU_CODE,
          'DOC_NO': widget.po_doc_no,
        }),
      );

      print('Request body: ${jsonEncode({
            'REF_NO': REF_NO.text,
            'DOC_TYPE': widget.po_doc_type,
            'MO_DO_NO': selectedMoDoNo,
            'doc_date': DOC_DATE.text,
            // 'doc_date': '11/09/2024',
            'note': NOTE.text,
            'UPD_BY': gb.APP_USER,
            'OU_CODE': gb.P_ERP_OU_CODE,
            'DOC_NO': widget.po_doc_no,
          })}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          v_ref_type = responseBody['v_ref_type'];
          v_ref_doc_no = responseBody['v_ref_doc_no'];
          print('v_ref_type: $v_ref_type');
          print('v_ref_doc_no: $v_ref_doc_no');
        });
      } else {
        print(
            'Failed to update: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  String? poStatus;
  String? poMessage;
  Future<void> fetchPoStatus() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/validateSave_INHeadReceive_WMS/${DOC_NO.text}/${DOC_TYPE.text}/$v_ref_type/$v_ref_doc_no/${REF_NO.text}/$selectedMoDoNo/${gb.P_ERP_OU_CODE}/${gb.APP_USER}';
    try {
      print(url);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          poStatus = responseBody['po_status'];
          poMessage = responseBody['po_message'];
          print('po_status: $poStatus');
          print('po_message: $poMessage');
        });
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      setState(() {
        poStatus = 'Error';
        poMessage = e.toString();
      });
    }
  }

  List<Map<String, dynamic>> cCode = [];
  String? selectedcCode;
  bool isLoading = true;
  String errorMessage = '';

  Future<void> cancelCode() async {
    try {
      final response = await http.get(
          Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT31/cancel_list'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          cCode = (jsonData['items'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
          selectedcCode = cCode.isNotEmpty ? '' : null;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _showDialog() {
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
                height: 300, // Adjust the height as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'เลือกเหตุยกเลิก', // Title for the dialog
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ค้นหา', // Search hint
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Create a filtered list based on search query
                          final filteredList = cCode.where((item) {
                            final code = item['r']?.toString() ?? '';
                            final description = item['d']?.toString() ?? '';
                            return code.toLowerCase().contains(
                                    _searchController.text.toLowerCase()) ||
                                description.toLowerCase().contains(
                                    _searchController.text.toLowerCase());
                          }).toList();

                          if (filteredList.isEmpty) {
                            return Center(
                                child: Text(
                                    'No data found')); // Show when no matches
                          }

                          return ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              final code = item['r']?.toString() ?? 'No code';
                              final description =
                                  item['d']?.toString() ?? 'No description';

                              return ListTile(
                                title: Text(
                                  code,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(description),
                                onTap: () {
                                  setState(() {
                                    selectedcCode = code; // Set selected code
                                    _CcodeController.text = selectedcCode ?? '';
                                    print('$selectedcCode');
                                  });
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              );
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

  void showCancelDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            // width: 600.0,
            height: 200.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Cancel',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Add horizontal padding
                  child: GestureDetector(
                    onTap: _showDialog,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _CcodeController,
                        decoration: InputDecoration(
                          labelText: 'สาเหตุยกเลิก',
                          filled: true,
                          fillColor: Colors.white,
                          // Add black border to TextField
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black), // Black border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.black), // Black border when focused
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.black), // Black border when enabled
                          ),
                          labelStyle: TextStyle(color: Colors.black),
                          suffixIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Color.fromARGB(255, 113, 113, 113),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('OK'),
                        onPressed: () async {
                          await cancel_from(selectedcCode ?? '');
                          if (selectedcCode == '') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons
                                            .notifications, // Use the bell icon
                                        color:
                                            Colors.red, // Set the color to red
                                      ),
                                      SizedBox(
                                          width:
                                              8), // Add some space between the icon and the text
                                      Text('แจ้งเตือน'), // Title text
                                    ],
                                  ),
                                  content: Text('$pomsg'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons
                                            .notifications, // Use the bell icon
                                        color:
                                            Colors.red, // Set the color to red
                                      ),
                                      SizedBox(
                                          width:
                                              8), // Add some space between the icon and the text
                                      Text('แจ้งเตือน'), // Title text
                                    ],
                                  ),
                                  content: Text('ยกเลิกรายการเสร็จสมบูรณ์'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                        cancel_from(selectedcCode!).then((_) {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SSFGDT31_SCREEN2(
                                                        pWareCode:
                                                            widget.pWareCode)),
                                          );
                                        }).catchError((error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'An error occurred: $error'),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? pomsg;
  Future<void> cancel_from(String selectedcCode) async {
    final url =
        Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT31/cancel_form');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'p_doc_type': widget.po_doc_type,
        'p_doc_no': widget.po_doc_no,
        'p_cancel_code': selectedcCode,
        'APP_USER': gb.APP_USER,
        'P_OU_CODE': gb.P_OU_CODE,
        'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      }),
    );

    print('Cancel form with data: ${jsonEncode({
          'p_doc_type': widget.po_doc_type,
          'p_doc_no': widget.po_doc_no,
          'p_cancel_code': selectedcCode,
          'APP_USER': gb.APP_USER,
          'P_OU_CODE': gb.P_OU_CODE,
          'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
        })}');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final poStatus = responseData['po_status'] ?? 'Unknown';
        pomsg = responseData['po_message'] ?? 'Unknown';
        print('po_status: $poStatus');
        print('po_message: $pomsg');
      } catch (e) {
        print('Error parsing response: $e');
      }
    } else {
      print('Failed to cancel: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.po_doc_type);
    selectedValue = widget.po_doc_type;
    fetchStatusItems();
    fetchFormData();
    fetchMoDoNoLIST();
    REF_NO_LIST();
    cancelCode();
    print('=====================');
    print(widget.po_doc_type);
  }

  @override
  void dispose() {
    DOC_NO.dispose();
    DOC_TYPE.dispose();
    DOC_DATE.dispose();
    REF_NO.dispose();
    CUST.dispose();
    NOTE.dispose();
    ERP_DOC_NO.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับคืนจากการเบิกผลิต'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: Column(
        children: [
          // Row for the fixed buttons at the top
          Row(
            children: [
              const SizedBox(width: 8.0),
              ElevatedButton(
                style: AppStyles.cancelButtonStyle(),
                onPressed: () {
                  showCancelDialog(context);
                },
                child: Text(
                  'ยกเลิก',
                  style: AppStyles.CancelbuttonTextStyle(),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: AppStyles.NextButtonStyle(),
                onPressed: () async {
                  if (isDateValid == false) {
                  } else {
                    await updateForm();
                    await fetchPoStatus();
                    if (poStatus == '0') {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SSFGDT31_GRID(
                            po_doc_no: widget.po_doc_no,
                            po_doc_type: widget.po_doc_type,
                            pWareCode: widget.pWareCode,
                            v_ref_doc_no: v_ref_doc_no ?? '',
                            v_ref_type: v_ref_type ?? '',
                            SCHID: selectedMoDoNo ?? '',
                            DOC_DATE: DOC_DATE.text ?? '',
                          ),
                        ),
                      );
                      print('pass');
                    }

                    print(widget.po_doc_no);
                    print(widget.po_doc_type);
                    print(selectedMoDoNo);
                    print(NOTE.text);

                    // Log the button press
                    print('Right button pressed');
                  }
                },
                child: Image.asset(
                  'assets/images/right.png',
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              const SizedBox(width: 8.0),
            ],
          ),

          // Space between buttons and scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  Container(
                    child: Column(
                      children: [
                        _buildTextFieldstar(DOC_NO, 'เลขที่เอกสาร WMS',
                            readOnly: true),
                        _buildDropdownForDocType(),
                        _buildDateTextField(DOC_DATE, 'วันที่บันทึก'),
                        _buildDropdownForRefNo(),
                        _buildDropdownSearch(),
                        _buildTextField(CUST, 'ลูกค้า', readOnly: true),
                        _buildTextField(NOTE, 'หมายเหตุ'),
                        _buildTextField(ERP_DOC_NO, 'เลขที่เอกสาร ERP',
                            readOnly: true),
                      ],
                    ),
                  ),
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
      padding: const EdgeInsets.only(bottom: 8.0),
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

  Widget _buildTextFieldstar(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        readOnly: readOnly,
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(color: Colors.black),
                ),
                const TextSpan(
                  text: ' *', // Asterisk for required field
                  style: TextStyle(color: Colors.red), // Red color for asterisk
                ),
              ],
            ),
          ),
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : Colors.white,
          border: InputBorder.none,
        ),
      ),
    );
  }

  bool isDateValid = true;
  final DateFormat displayFormat = DateFormat('dd/MM/yyyy');

  Widget _buildDateTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            inputFormatters: [
              // Allow only digits (numbers)
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.length == 8) {
                try {
                  // Parse the date assuming the format is ddMMyyyy
                  DateTime parsedDate = DateTime.parse(
                    "${value.substring(4, 8)}-${value.substring(2, 4)}-${value.substring(0, 2)}",
                  );

                  // Validate the date (e.g., check if it's a valid day of the month)
                  if (parsedDate.day == int.parse(value.substring(0, 2)) &&
                      parsedDate.month == int.parse(value.substring(2, 4)) &&
                      parsedDate.year == int.parse(value.substring(4, 8))) {
                    // Update the controller with formatted date
                    controller.text = displayFormat.format(parsedDate);
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                    setState(() {
                      isDateValid = true; // Date is valid
                    });
                  } else {
                    throw FormatException("Invalid date");
                  }
                } catch (e) {
                  print('Error parsing date: $e');
                  setState(() {
                    isDateValid = false; // Invalid date
                  });
                }
              } else {
                setState(() {
                  isDateValid = false; // Invalid length
                });
              }
            },
            decoration: InputDecoration(
              labelText: null,
              hintText: 'DD/MM/YYYY',
              hintStyle: TextStyle(color: Colors.grey),
              label: RichText(
                text: TextSpan(
                  text: label,
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today_outlined, color: Colors.black),
                onPressed: () async {
                  _selectDate(context);
                },
              ),
            ),
          ),
          isDateValid == false
              ? const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _showProductionOrderDialog() {
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
                height: 300, // Adjust the height as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ค้นหาเลขที่คำสั่งผลิต',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        setState(
                            () {}); // Trigger UI update when search query changes
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Filter the items based on the search query
                          final filteredItems = moDoNoItems.where((item) {
                            final schid = '${item['schid']}';
                            final custName = item['cust_name'] ?? '';
                            return schid.toLowerCase().contains(
                                    _searchController.text.toLowerCase()) ||
                                custName.toLowerCase().contains(
                                    _searchController.text.toLowerCase());
                          }).toList();

                          if (filteredItems.isEmpty) {
                            // Show "No data found" if no results match the search query
                            return Center(
                              child: Text(
                                'No data found',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final schid = '${item['schid']}';
                              final custName = item['cust_name'] ?? '';

                              return ListTile(
                                title: Text(
                                  schid,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  custName,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedMoDoNo =
                                        schid; // Update the selected item
                                    CUST.text =
                                        custName; // Update the text controller
                                    print('Selected SCHID: $schid');
                                    print('Selected Cust Name: $custName');
                                  });
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              );
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
    ).then((_) {
      setState(() {
        // Force rebuild to reflect the selected production order in the dropdown
      });
    });
  }

  Widget _buildDropdownSearch() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          _showProductionOrderDialog(); // Show the dialog on tap
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "เลขที่คำสั่งผลิต",
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Align text and arrow
            children: [
              Text(
                selectedMoDoNo ?? '', // Default placeholder text
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                Icons.arrow_drop_down, // Dropdown arrow icon
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? selectedDocType = '';
  String? displayDocType = '';

  Future<void> _showDocTypeDialog() async {
    final TextEditingController _searchController2 = TextEditingController();

    String? selectedValue = await showDialog<String>(
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
                height: 300, // Adjust height as necessary
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'เลือกประเภทเอกสาร',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _searchController2,
                      decoration: InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (query) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Filter statusItems based on search query
                          final filteredItems = statusItems.where((item) {
                            final docType =
                                item['doc_type']?.toLowerCase() ?? '';
                            final docDesc =
                                item['doc_desc']?.toLowerCase() ?? '';
                            final searchQuery =
                                _searchController2.text.toLowerCase();

                            return docType.contains(searchQuery) ||
                                docDesc.contains(searchQuery);
                          }).toList();

                          if (filteredItems.isEmpty) {
                            return Center(
                              child: Text(
                                'No data found',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final docType = item['doc_type'] as String;
                              final docDesc = item['doc_desc'] as String;

                              return ListTile(
                                title: Text(
                                  docType,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  docDesc,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                onTap: () => Navigator.of(context).pop(docType),
                              );
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

    // Update the selected document type after the dialog is closed
    if (selectedValue != null) {
      setState(() {
        selectedDocType = selectedValue;
        DOC_TYPE.text = statusItems.firstWhere(
          (item) => item['doc_type'] == selectedValue,
          orElse: () => {'doc_desc': ''},
        )['doc_desc'] as String;
      });
    }
  }

  Widget _buildDropdownForDocType() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: _showDocTypeDialog,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "ประเภทเอกสาร", // Changed to "Document Type"
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DOC_TYPE.text.isNotEmpty ? DOC_TYPE.text : 'เลือกประเภทเอกสาร',
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? selectedrRefNo = '';

  Future<void> _showRefNoDialog() async {
    final TextEditingController _searchController3 = TextEditingController();

    String? selectedValue = await showDialog<String>(
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
                height: 300, // Adjust the height as necessary
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'เลือกประเภทเอกสาร',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _searchController3,
                      decoration: InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (query) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Filter statusItems based on the search query
                          final filteredItems = statusItems.where((item) {
                            final docNo = item['doc_no']?.toLowerCase() ?? '';
                            final searchQuery =
                                _searchController3.text.toLowerCase();
                            return docNo.contains(searchQuery);
                          }).toList();

                          // Show "No data found" if the filtered list is empty
                          if (filteredItems.isEmpty) {
                            return Center(
                              child: Text(
                                'No data found',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final docNo = item['doc_no'] ?? '';

                              return ListTile(
                                title: Text(
                                  docNo,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () => Navigator.of(context).pop(docNo),
                              );
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

    // Ensure that selectedValue is not null and not empty
    if (selectedValue != null && selectedValue.isNotEmpty) {
      setState(() {
        selectedDocType = selectedValue;

        // Use a safe way to get the document type
        var foundItem = statusItems.firstWhere(
          (item) => item['doc_no'] == selectedValue,
          orElse: () => null, // Return null if not found
        );

        // Check if foundItem is not null before accessing its properties
        DOC_TYPE.text = foundItem != null ? foundItem['doc_no'] as String : '';
      });
    }
  }

  Widget _buildDropdownForRefNo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          _showRefNoDialog(); // Show dialog on tap
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "ประเภทเอกสาร",
            // hintText: "Select Item",
            hintStyle: TextStyle(fontSize: 12.0),
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Align text and arrow
            children: [
              Text(
                selectedrRefNo ?? '', // Default placeholder text
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                Icons.arrow_drop_down, // Dropdown arrow icon
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

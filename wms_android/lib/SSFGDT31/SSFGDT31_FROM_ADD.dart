import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/SSFGDT31/SSFGDT31_CARD.dart';
import 'package:wms_android/SSFGDT31/SSFGDT31_GRID.dart';
import 'package:wms_android/SSFGDT31/SSFGDT31_SEARCH_DOC.dart';
import 'package:wms_android/styles.dart';
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
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
          selectedcCode = cCode.isNotEmpty ? cCode[0]['r'] : null;
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

  void showCancelDialog() {
    String? selectedcCode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 600.0,
            height: 250.0,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedcCode,
                    isExpanded: true,
                    items: cCode.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['r'],
                        child: Container(
                          width: 250.0,
                          child: Row(
                            children: [
                              Text(
                                item['r'] ?? 'No code',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  item['d'] ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedcCode = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Cancel Code',
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      border: OutlineInputBorder(),
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
                        onPressed: () {
                          if (selectedcCode != null) {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                if (poStatus == '1') {}
                                return AlertDialog(
                                  title: Text('คำเตือน'),
                                  content: Text('ยกเลิกรายการเสร็จสมบูรณ์'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                  

                                        cancel_from(selectedcCode!).then((_) {
                                          Navigator.of(context).pop(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SSFGDT31_SEARCH_DOC(
                                                pWareCode: widget.pWareCode,
                                              ),
                                            ),
                                          );

                                           Navigator.of(context).pop();
                                        Navigator.of(context).pop();
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
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('คำเตือน'),
                                  content: Text('โปรดเลือกเหตุยกเลิก'),
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
        final pomsg = responseData['po_message'] ?? 'Unknown';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            Row(
              children: [
                const SizedBox(width: 4.0),
                ElevatedButton(
                  style: AppStyles.cancelButtonStyle(),
                  onPressed: () {
                    showCancelDialog();
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
  },
  child: Image.asset(
    'assets/images/right.png',
    width: 20.0,
    height: 20.0,
  ),
),

                const SizedBox(width: 4.0),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField(DOC_NO, 'เลขที่เอกสาร WMS*', readOnly: true),
                  _buildDropdownForDocType(),
                  _buildDateTextField(DOC_DATE, 'วันที่บันทึก*'),
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
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
        ),
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null && pickedDate != selectedDate) {
            setState(() {
              selectedDate = pickedDate;
              controller.text = _formatDate(pickedDate);
            });
          }
        },
      ),
    );
  }

  Widget _buildDropdownSearch() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownSearch<String>(
      popupProps: PopupProps.menu(
        showSearchBox: true,
        showSelectedItems: true,
        itemBuilder: (context, item, isSelected) {
          final itemData = moDoNoItems.firstWhere(
            (element) => '${element['schid']}' == item,
            orElse: () => {'schid': '', 'cust_name': ''},
          );

          return ListTile(
            title: Text(item),
            subtitle: Text(itemData['cust_name'] ?? ''),
            selected: isSelected,
          );
        },
        constraints: BoxConstraints(
          maxHeight: 200,
        ),
      ),
      items: [
        // '',
        ...moDoNoItems.map((item) => '${item['schid']}'.toString()).toList()
      ],
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          labelText: "เลขที่คำสั่งผลิต",
          hintText: "Select Item",
          hintStyle: TextStyle(fontSize: 12.0),
        ),
      ),
      onChanged: (String? value) async {
        setState(() {
          selectedMoDoNo = value;
        });

        if (value == '') {
          setState(() {
            csValue = null;
            CUST.text = 'null';
          });
        } else {
          await fetchCustCode();

          final selectedItem = moDoNoItems.firstWhere(
            (element) => '${element['schid']}' == value,
            orElse: () => {'schid': '', 'cust_name': ''},
          );

          print('Selected SCHID: ${selectedItem['schid']}');
          print('Selected Cust Name: ${selectedItem['cust_name']}');

          setState(() {
            CUST.text = csValue ?? 'null';
          });
        }

        print(selectedMoDoNo);
      },
      selectedItem: selectedMoDoNo ?? '',
    ),
  );
}


  Widget _buildDropdownForRefNo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
          showSearchBox: true,
          showSelectedItems: true,
        ),
        items: [
          // '',
          ...REF_NOItems.map((item) => item['doc_no'].toString()).toList(),
        ],
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            border: InputBorder.none,
            labelText: "เลขที่เอกสารอ้างอิง",
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        onChanged: (String? value) {
          setState(() {
            if (value == '') {
              doc_no = null;
              REF_NO.text = 'null';
            } else {
              doc_no = value;
              REF_NO.text = value ?? 'null';
            }
          });
        },
        selectedItem: doc_no ?? '',
      ),
    );
  }

Widget _buildDropdownForDocType() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownSearch<String>(
      popupProps: PopupProps.menu(
        showSearchBox: true,
        showSelectedItems: true,
        itemBuilder: (context, item, isSelected) {
          return ListTile(
            title: Text(item),
            selected: isSelected,
          );
        },
      ),
      items: [
        // '',
        ...statusItems.map((item) => item['doc_desc'].toString()).toList(),
      ],
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: InputBorder.none,
          labelText: "ประเภทการจ่าย",
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          if (value == '') {
            selectedValue = null;
            DOC_TYPE.text = '';
          } else {
            final selectedItem = statusItems.firstWhere(
              (element) => element['doc_desc'] == value,
              orElse: () => {'doc_type': '', 'doc_desc': ''},
            );
            selectedValue = selectedItem['doc_type'];
            DOC_TYPE.text = value ?? '';
          }
        });
      },
      selectedItem: statusItems
          .firstWhere(
            (element) => element['doc_type'] == selectedValue,
            orElse: () => {'doc_type': '', 'doc_desc': ''},
          )['doc_desc']
          .toString(),
    ),
  );
}

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/SSFGDT04/SSFGDT04_main.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_BARCODE.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_MENU.dart';
import 'package:wms_android/custom_appbar.dart';
// import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wms_android/styles.dart';

class SSFGDT17_FORM extends StatefulWidget {
  final String po_doc_no;
  final String? po_doc_type;
  final String? LocCode;

  final String? selectedwhCode;
  final String? selectedLocCode;
  final String? whOUTCode;
  final String? LocOUTCode;

  final String? pWareName;
  final String? pWareCode;

  SSFGDT17_FORM(
      {required this.po_doc_no,
      this.po_doc_type,
      this.LocCode,
      this.selectedwhCode,
      this.selectedLocCode,
      this.whOUTCode,
      this.LocOUTCode,
      this.pWareName,
      required this.pWareCode});

  @override
  _SSFGDT17_FORMState createState() => _SSFGDT17_FORMState();
}

class _SSFGDT17_FORMState extends State<SSFGDT17_FORM> {
  String currentSessionID = '';
  late DateTime selectedDate;
  final ERP_OU_CODE = gb.P_ERP_OU_CODE;
  final P_OU_CODE = gb.P_OU_CODE;
  final APP_USER = gb.APP_USER;
  final DateFormat displayFormat = DateFormat('dd/MM/yyyy');
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

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _CcodeController = TextEditingController();
  bool isDateValid = true;

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
    selectedDate = DateTime.now();

    // CR_DATE.text = _formatDate(selectedDate);
    CR_DATE.text = '';
    cancelCode();
    fetchREF_NOLIST();
    fetchStaffLIST();

    print('ERP_OU_CODE: $ERP_OU_CODE');
    print('P_OU_CODE: $P_OU_CODE');
    print('APP_USER: $APP_USER');
    print('FORM  =============================');
    print('pWareCode: ${widget.pWareCode}');
    print('pWareName: ${widget.pWareName}');
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
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: selectedDate ??
          DateTime.now(), // Fallback to current date if selectedDate is null
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        isDateValid = true;
        selectedDate = picked;
        CR_DATE.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        // Update CR_DATE with the selected date
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

  // String _formatDate(DateTime date) {
  //   return "${date.day}/${date.month}/${date.year}";
  // }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return ''; // Return blank if date is null
    }
    return "${date.day}/${date.month}/${date.year}";
  }

  List<Map<String, dynamic>> cCode = [];
  String? selectedcCode;
  bool isLoading = true;
  String errorMessage = '';

  Future<void> cancelCode() async {
    try {
      final response = await http.get(
          Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT17/cancel_list'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          cCode = (jsonData['items'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
          selectedcCode = '';
          print('selectedcCode $selectedcCode');
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
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black), // Black border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black), // Black border when focused
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black), // Black border when enabled
                        ),
                      ),
                      onChanged: (query) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cCode.length,
                        itemBuilder: (context, index) {
                          final item = cCode[index];
                          final code = item['r']?.toString() ?? 'No code';

                          // Filter based on search query
                          if (_searchController.text.isNotEmpty &&
                              !code.toLowerCase().contains(
                                  _searchController.text.toLowerCase())) {
                            return SizedBox
                                .shrink(); // Filter out non-matching items
                          }

                          return ListTile(
                            title: Text(
                              code,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                                item['cancel_desc']?.toString() ?? 'No code'),
                            onTap: () {
                              setState(() {
                                selectedcCode = code; // Set selected code
                                _CcodeController.text =
                                    selectedcCode.toString();
                                print('$selectedcCode');
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
                                          Navigator.of(context).pop(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SSFGDT17_MENU(
                                                pWareCode:
                                                    widget.pWareCode ?? '',
                                                pWareName:
                                                    widget.pWareName ?? '',
                                                p_ou_code: gb.P_ERP_OU_CODE,
                                              ),
                                            ),
                                          );
                                        }).catchError((error) {
                                          ScaffoldMessenger.of(parentContext)
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
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT17/cancel_INHeadXfer_WMS');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'p_doc_type': widget.po_doc_type,
        'p_doc_dec': widget.po_doc_no,
        'p_cancel': selectedcCode,
        'APP_USER': gb.APP_USER,
        'P_OU_CODE': gb.P_OU_CODE,
        'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      }),
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final poStatus = responseData['po_status'] ?? 'Unknown';
        pomsg = responseData['po_message'] ?? 'Unknown';
        print('po_status: $poStatus');
        print('po_message: $pomsg');
        print(widget.po_doc_type);
        print(widget.po_doc_no);
        print(selectedcCode);
        print(gb.APP_USER);
        print(gb.P_OU_CODE);
        print(gb.P_ERP_OU_CODE);
      } catch (e) {
        print('Error parsing response: $e');
      }
    } else {
      print('Failed to cancel: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: const CustomAppBar(
        title: 'Move Locator',
      ),
      body: Column(
        children: [
          const SizedBox(height: 8.0),
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
                  if (CR_DATE.text.isEmpty || isDateValid == false) {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.notifications, // Use the bell icon
                                color: Colors.red, // Set the color to red
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between the icon and the text
                              Text('แจ้งเตือน'), // Title text
                            ],
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                    'ต้องระบุข้อมูลที่จำเป็น * ให้ครบถ้วน !!!'),
                              ],
                            ),
                          ),
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
                            LocOUTCode: widget.LocOUTCode,
                            pWareCode: widget.pWareCode,
                            pWareName: widget.pWareName,
                          ),
                        ),
                      );
                    }
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
                  _buildDropRefdownSearch(),
                  _buildTextField(MO_DO_NO, 'เลขที่คำสั่งผลผลิต'),
                  _buildTextField(NB_WARE_CODE, 'คลังต้นทาง', readOnly: true),
                  _buildTextField(NB_TO_WH, 'คลังปลายทาง', readOnly: true),
                  _buildDropStaffdownSearch(),
                  _buildTextField(PO_REMARK, 'หมายเหตุ'),
                  _buildTextField(REF_ERP, 'เลขที่เอกสาร ERP', readOnly: true),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  List<Map<String, dynamic>> REF_NOItems = [];
  String? selectedREF_NO;
  Future<void> fetchREF_NOLIST() async {
    final url =
        Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT17/SSFGDT17_REF_NO');
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
              selectedREF_NO = REF_NOItems[0]['so_no'];
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

  List<Map<String, dynamic>> StaffItems = [];
  String? selectedStaff;
  Future<void> fetchStaffLIST() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT17/SSFGDT17_STAFF_CODE/${gb.P_ERP_OU_CODE}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'] ?? [];
        print(items);

        if (items.isNotEmpty) {
          setState(() {
            StaffItems = List<Map<String, dynamic>>.from(items);
            if (StaffItems.isNotEmpty) {
              selectedStaff = '';
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

  void _showStaffDialog() {
    final TextEditingController _searchController = TextEditingController();

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
                          'เลือกผู้บันทึก',
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
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        setState(() {}); // Update the UI on search text change
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Filter StaffItems based on search query
                          final filteredItems = StaffItems.where((item) {
                            final staffCode = item['r']?.toLowerCase() ?? '';
                            final empName =
                                item['emp_name']?.toLowerCase() ?? '';
                            final searchQuery =
                                _searchController.text.toLowerCase();

                            return staffCode.contains(searchQuery) ||
                                empName.contains(searchQuery);
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
                              final staffCode = item['r'];
                              final empName = item['emp_name'] ?? '';

                              return ListTile(
                                title: Text(
                                  staffCode,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  empName,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedStaff =
                                        staffCode; // Update the selected item
                                    STAFF_CODE.text =
                                        staffCode; // Update the text controller
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
      // This code runs after the dialog is closed
      setState(() {
        // Force rebuild to reflect the selected staff in the dropdown or other UI element
      });
    });
  }

  Widget _buildDropStaffdownSearch() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          _showStaffDialog(); // Show the dialog on tap
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "ผู้บันทึก",
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
                selectedStaff.toString(), // Default placeholder text
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

  void _showRefNoDialog() {
    final TextEditingController _searchController = TextEditingController();

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
                height: 300, // Adjust height as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'เลือกเลขที่เอกสารอ้างอิง',
                          style: TextStyle(
                            fontSize: 14,
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
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        setState(() {}); // Update UI on text change
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Filter REF_NOItems based on the search query
                          final filteredItems = REF_NOItems.where((item) {
                            final soNo = item['so_no']?.toLowerCase() ?? '';
                            final searchQuery =
                                _searchController.text.toLowerCase();
                            return soNo.contains(searchQuery);
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
                              final soNo = item['so_no'];
                              final arName = item['ar_name'];

                              return ListTile(
                                title: Text(
                                  soNo,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  arName ?? '',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedREF_NO =
                                        soNo; // Update the selected item
                                    MO_DO_NO.text =
                                        soNo; // Update the text controller
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

  Widget _buildDropRefdownSearch() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          _showRefNoDialog(); // Show dialog on tap
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "เลขที่เอกสารอ้างอิง",
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
                selectedREF_NO ?? '', // Default placeholder text
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

  Widget _buildTextimportantField(
      TextEditingController controller, String label,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: null, // Set to null to customize with RichText
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : Colors.white,
          border: InputBorder.none,
          // Using label as a RichText
          label: RichText(
            text: TextSpan(
              text: label, // Main label text
              style: TextStyle(color: Colors.black), // Default label color
              children: [
                TextSpan(
                  text: '*', // Asterisk
                  style: TextStyle(color: Colors.red), // Red asterisk
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
              // Only proceed if there is input
              if (value.isNotEmpty) {
                String numbersOnly =
                    value.replaceAll('/', ''); // Remove existing slashes
                if (numbersOnly.length > 8) {
                  numbersOnly =
                      numbersOnly.substring(0, 8); // Restrict to 8 characters
                }

                // Format the input as dd/MM/yyyy
                String formattedValue = '';
                for (int i = 0; i < numbersOnly.length; i++) {
                  if (i == 2 || i == 4) {
                    formattedValue += '/'; // Add slashes after dd and MM
                  }
                  formattedValue += numbersOnly[i];
                }

                // Update the controller text with the formatted value
                controller.value = TextEditingValue(
                  text: formattedValue,
                  selection: TextSelection.collapsed(
                      offset: formattedValue.length), // Set cursor to the end
                );

                // Validate the date
                if (numbersOnly.length == 8) {
                  try {
                    final day = int.parse(numbersOnly.substring(0, 2));
                    final month = int.parse(numbersOnly.substring(2, 4));
                    final year = int.parse(numbersOnly.substring(4, 8));

                    final date = DateTime(year, month, day);
                    setState(() {
                      isDateValid = true; // Valid date
                      selectedDate = date; // Store the selected date
                      CR_DATE.text = DateFormat('dd/MM/yyyy').format(
                          date); // Assuming CR_DATE is your date variable
                    });
                  } catch (e) {
                    print('Error parsing date: $e');
                    setState(() {
                      isDateValid = false; // Invalid date
                    });
                  }
                } else {
                  setState(() {
                    isDateValid = false; // Input is incomplete
                  });
                }
              } else {
                setState(() {
                  isDateValid = false; // No input
                });
              }
            },
            decoration: InputDecoration(
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
                  _selectDate(
                      context); // Assume this method opens the date picker
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
}

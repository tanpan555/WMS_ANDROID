import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT04/SSFGDT04_main.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_BARCODE.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_MENU.dart';
import 'package:wms_android/custom_appbar.dart';
// import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:http/http.dart' as http;
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
      this.LocOUTCode, this.pWareName, required this.pWareCode});

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
      initialDate: selectedDate ?? DateTime.now(), // Fallback to current date if selectedDate is null
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        CR_DATE.text = _formatDate(selectedDate); // Update CR_DATE with the selected date
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
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                                item['cancel_desc'] ?? '',
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
                              return AlertDialog(
                                title: Text('คำเตือน'),
                                content: Text('ยกเลิกรายการเสร็จสมบูรณ์...'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('ตกลง'),
                                    onPressed: () {
                                      Navigator.of(context).pop();

                                      cancel_from(selectedcCode!).then((_) {
                                        Navigator.of(context).pop(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SSFGDT17_MENU(
                                                pWareCode: widget.pWareCode ?? '', 
                                                pWareName: widget.pWareName ?? '', 
                                                p_ou_code: gb.P_ERP_OU_CODE,
                                      
                                            ),
                                          ),
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
    final url = Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT17/cancel_INHeadXfer_WMS');
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
        final pomsg = responseData['po_message'] ?? 'Unknown';
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
      appBar: const CustomAppBar(title: 'Move Locator',),
      body: Column(
        children: [
          const SizedBox(height: 8.0),
          Row(
            children: [
              const SizedBox(width: 8.0),
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
    if(CR_DATE.text.isEmpty){
      showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('คำเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ต้องระบุข้อมูลที่จำเป็น * ให้ครบถ้วน !!!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    }
    else{
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
  final url = Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT17/SSFGDT17_STAFF_CODE/${gb.P_ERP_OU_CODE}');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> items = data['items'] ?? [];
      print(items);

      if (items.isNotEmpty) {
        setState(() {
          StaffItems = List<Map<String, dynamic>>.from(items);
          if (StaffItems.isNotEmpty) {
            selectedStaff = StaffItems[0]['r'];
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

Widget _buildDropStaffdownSearch() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: DropdownSearch<String>(
      popupProps: PopupProps.dialog(
        showSearchBox: true,
        showSelectedItems: true,
        itemBuilder: (context, item, isSelected) {
          // Find the item data based on the selected item
          final itemData = StaffItems.firstWhere(
            (element) => '${element['r']}' == item,
            orElse: () => {'r': '', 'emp_name': ''},
          );

          return ListTile(
            title: Text(item),
            subtitle: Text(itemData['emp_name'] ?? ''),
            selected: isSelected,
          );
        },
      ),
      items: StaffItems.map((item) => '${item['r']}'.toString()).toList(),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          labelText: "ผู้บันทึก",
          hintText: "Select Item",
          hintStyle: TextStyle(fontSize: 12.0),
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          selectedREF_NO = value;
        });

        if (value == '') {
          setState(() {
            STAFF_CODE.text = 'null';
          });
        } else {
          final selectedItem = StaffItems.firstWhere(
            (element) => '${element['r']}' == value,
            orElse: () => {'so_no': '', 'emp_name': ''},
          );

          setState(() {
            STAFF_CODE.text = value ?? 'null';
          });
        }
      },
      selectedItem: selectedREF_NO ?? '',
    ),
  );
}



Widget _buildDropRefdownSearch() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: DropdownSearch<String>(
      popupProps: PopupProps.dialog(
        showSearchBox: true,
        showSelectedItems: true,
        itemBuilder: (context, item, isSelected) {
          // Find the item data based on the selected item
          final itemData = REF_NOItems.firstWhere(
            (element) => '${element['so_no']}' == item,
            orElse: () => {'so_no': '', 'ar_name': ''},
          );

          return ListTile(
            title: Text(item),
            subtitle: Text(itemData['ar_name'] ?? ''),
            selected: isSelected,
          );
        },
      ),
      items: REF_NOItems.map((item) => '${item['so_no']}'.toString()).toList(),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          labelText: "เลขที่เอกสารอ้างอิง",
          hintText: "Select Item",
          hintStyle: TextStyle(fontSize: 12.0),
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          selectedREF_NO = value;
        });

        if (value == '') {
          setState(() {
            MO_DO_NO.text = 'null';
          });
        } else {
          final selectedItem = REF_NOItems.firstWhere(
            (element) => '${element['so_no']}' == value,
            orElse: () => {'so_no': '', 'cust_name': ''},
          );

          setState(() {
            MO_DO_NO.text = value ?? 'null';
          });
        }
      },
      selectedItem: selectedREF_NO ?? '',
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

  Widget _buildTextimportantField(TextEditingController controller, String label,
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
    child: TextField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      readOnly: false,
      // onTap: () => _selectDate(context),
      onChanged: (value) {
   controller.text = value;
  },
      decoration: InputDecoration(
        labelText: null,
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
      }
      ),
        
      ),
    ),
  );
}

}

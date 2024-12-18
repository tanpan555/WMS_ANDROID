import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_BARCODE.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_MENU.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wms_android/styles.dart';
import '../TextFormFieldCheckDate.dart';

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
  String date = '';
  String currentSessionID = '';
  DateTime? selectedDate;
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

  bool checkUpdateData = false;
  final ValueNotifier<bool> isDateInvalidNotifier = ValueNotifier<bool>(false);

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
    print(widget.LocOUTCode);
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
      initialDate:
          selectedDate, // Fallback to current date if selectedDate is null
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (mounted) {
        setState(() {
          isDateValid = true;
          selectedDate = picked;
          CR_DATE.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
          // Update CR_DATE with the selected date
        });
      }
    }
  }

  String? poStatus;
  String? poMessage;

  Future<void> chk_validateSave() async {
    final url = Uri.parse(
        '${gb.IP_API}/apex/wms/SSFGDT17/Step_2_validateSave_INHeadXfer_WMS/$P_OU_CODE/$ERP_OU_CODE/${widget.po_doc_no}/$APP_USER');

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
        if (mounted) {
          setState(() {
            poStatus = responseData['po_status'];
            poMessage = responseData['po_message'];

            print('poStatus: $poStatus');
            print('poMessage: $poMessage');
          });
        }
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
      final response = await http
          .get(Uri.parse('${gb.IP_API}/apex/wms/SSFGDT17/Step_2_cancel_list'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        if (mounted) {
          setState(() {
            cCode = (jsonData['items'] as List)
                .map((item) => item as Map<String, dynamic>)
                .toList();
            selectedcCode = '';
            print('selectedcCode $selectedcCode');
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'เลือกเหตุยกเลิก', // Title for the dialog
          searchController: _searchController,
          data: cCode,
          docString: (item) =>
              item['r']?.toString() ?? 'No code', // Document string
          titleText: (item) => item['r']?.toString() ?? 'No code', // Title text
          subtitleText: (item) =>
              item['cancel_desc']?.toString() ??
              'No description', // Subtitle text
          onTap: (item) {
            final selectedDescription = item['cancel_desc']?.toString() ?? '';
            selectedcCode = item['r']?.toString() ?? ''; // Set selected code
            _CcodeController.text = '$selectedcCode $selectedDescription';
            print('$selectedcCode');
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  bool isDialogShowing = false;
  void showCancelDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return DialogStyles.cancelDialog(
          context: context,
          onCloseDialog: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          onConfirmDialog: () async {
            if (isDialogShowing) return;

            setState(() {
              isDialogShowing =
                  true; // Set flag to true when a dialog is about to be shown
            });
            // Perform your cancellation logic here
            await cancel_from(selectedcCode ?? '');

            if (selectedcCode == '') {
              setState(() {
                isDialogShowing =
                    false; // Reset the flag when the first dialog is closed
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogStyles.alertMessageDialog(
                    context: context,
                    content: Text('$pomsg'),
                    onClose: () {
                      Navigator.of(context).pop();
                    },
                    onConfirm: () async {
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            } else {
              Navigator.of(context).pop(); // Close the cancel dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogStyles.alertMessageDialog(
                    context: context,
                    content: Text('ยกเลิกรายการเสร็จสมบูรณ์'),
                    onClose: () async {
                      await cancel_from(selectedcCode!).then((_) {
                        Navigator.of(context).pop(); // Close the success dialog
                        Navigator.of(context)
                            .pop(); // Go back to the previous screen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SSFGDT17_MENU(
                              pWareCode: widget.pWareCode ?? '',
                              pWareName: widget.pWareName ?? '',
                              p_ou_code: gb.P_ERP_OU_CODE,
                            ),
                          ),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(
                            content: Text('An error occurred: $error'),
                          ),
                        );
                      });
                    },
                    onConfirm: () async {
                      await cancel_from(selectedcCode!).then((_) {
                        Navigator.of(context).pop(); // Close the success dialog
                        Navigator.of(context)
                            .pop(); // Go back to the previous screen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SSFGDT17_MENU(
                              pWareCode: widget.pWareCode ?? '',
                              pWareName: widget.pWareName ?? '',
                              p_ou_code: gb.P_ERP_OU_CODE,
                            ),
                          ),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(
                            content: Text('An error occurred: $error'),
                          ),
                        );
                      });
                    },
                  );
                },
              );
            }
          },
          onTap:
              _showDialog, // This should remain as it is if you want to handle the dropdown
          controller:
              _CcodeController, // Pass the controller for the TextFormField
        );
      },
    );
  }

  String? pomsg;
  Future<void> cancel_from(String selectedcCode) async {
    final url = Uri.parse(
        '${gb.IP_API}/apex/wms/SSFGDT17/Step_2_cancel_INHeadXfer_WMS');
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
      // backgroundColor: const Color(0xFF17153B),
      appBar:
          CustomAppBar(title: 'Move Locator', showExitWarning: checkUpdateData),
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
              ElevatedButtonStyle.nextpage(
                onPressed: () async {
                  if (CR_DATE.text.isEmpty || isDateInvalidNotifier.value) {
                    isDateInvalidNotifier.value = true;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogStyles.alertMessageDialog(
                          context: context,
                          content:
                              Text('ต้องระบุข้อมูลที่จำเป็น * ให้ครบถ้วน !!!'),
                          onClose: () {
                            Navigator.of(context).pop();
                          },
                          onConfirm: () async {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  } else {
                    await chk_validateSave();
                    if (poStatus == '0') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SSFGDT17_BARCODE(
                            po_doc_no: widget.po_doc_no,
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
                  GestureDetector(
                      child: AbsorbPointer(
                    child: _buildTextField(po_doc_noText, 'เลขที่เอกสาร WMS',
                        readOnly: true),
                  )),
                  GestureDetector(
                      child: AbsorbPointer(
                    child: _buildTextField(po_doc_typeText, 'ประเภทเอกสาร',
                        readOnly: true),
                  )),
                  _buildDateTextField(CR_DATE, 'วันที่บันทึก'),
                  _buildDropRefdownSearch(),
                  _buildTextField(MO_DO_NO, 'เลขที่คำสั่งผลผลิต'),
                  GestureDetector(
                      child: AbsorbPointer(
                    child: _buildTextField(NB_WARE_CODE, 'คลังต้นทาง',
                        readOnly: true),
                  )),
                  GestureDetector(
                      child: AbsorbPointer(
                    child: _buildTextField(NB_TO_WH, 'คลังปลายทาง',
                        readOnly: true),
                  )),
                  _buildDropStaffdownSearch(),
                  _buildTextFormField(PO_REMARK, 'หมายเหตุ'),
                  GestureDetector(
                      child: AbsorbPointer(
                    child: _buildTextField(REF_ERP, 'เลขที่เอกสาร ERP',
                        readOnly: true),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }

  List<Map<String, dynamic>> REF_NOItems = [];
  String? selectedREF_NO;
  Future<void> fetchREF_NOLIST() async {
    final url = Uri.parse('${gb.IP_API}/apex/wms/SSFGDT17/Step_2_REF_NO');
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
        '${gb.IP_API}/apex/wms/SSFGDT17/Step_2_STAFF_CODE/${gb.P_ERP_OU_CODE}/${gb.BROWSER_LANGUAGE}');
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
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'เลือกผู้บันทึก', // Title for the dialog
          searchController: _searchController,
          data: StaffItems,
          docString: (item) =>
              '${item['r'] ?? ''} ${item['emp_name'] ?? ''}', // Document string
          titleText: (item) => item['r'] ?? 'No code', // Title text
          subtitleText: (item) => item['emp_name'] ?? '', // Subtitle text
          onTap: (item) {
            final staffCode = item['r'];
            final empName = item['emp_name'] ?? '';
            selectedStaff = staffCode; // Update the selected staff code
            STAFF_CODE.text = empName; // Update the text controller
            Navigator.of(context).pop(); // Close the dialog
          },
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
          _showStaffDialog(); // Show dialog on tap
        },
        child: AbsorbPointer(
          child: TextField(
              decoration: InputDecoration(
                labelText: 'ผู้บันทึก',
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromARGB(255, 113, 113, 113),
                ),
              ),
              controller: STAFF_CODE),
        ),
      ),
    );
  }

  void _showRefNoDialog() {
    final TextEditingController _searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'เลือกเลขที่เอกสารอ้างอิง',
          searchController: _searchController,
          data: REF_NOItems,
          docString: (item) => '${item['so_no'] ?? ''} ${item['ar_name'] ?? ''}',
          titleText: (item) => item['so_no'] ?? '',
          subtitleText: (item) => item['ar_name'] ?? '',
          onTap: (item) {
            setState(() {
              selectedREF_NO = item['so_no']; // Update the selected item
              REF_NO.text = item['so_no']; // Update the text controller
            });
            Navigator.of(context).pop(); // Close the dialog
          },
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
        child: AbsorbPointer(
          child: TextField(
              decoration: InputDecoration(
                labelText: 'อ้างอิง SO',
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromARGB(255, 113, 113, 113),
                ),
              ),
              controller: REF_NO),
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
        onChanged: (value) {
          setState(() {
            checkUpdateData = true;
          });
        },
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

  Widget _buildTextFormField(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        minLines: 1,
        maxLines: 5,
        controller: controller,
        style: TextStyle(color: Colors.black),
        readOnly: readOnly,
        onChanged: (value) {
          setState(() {
            checkUpdateData = true;
          });
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : Colors.white,
          border: InputBorder.none,
          // floatingLabelBehavior: FloatingLabelBehavior.always,
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
          CustomTextFormField(
            controller: controller,
            labelText: 'วันที่บันทึก',
            keyboardType: TextInputType.number,
            showAsterisk: true,
            onChanged: (value) {
              date = value;
              print('วันที่ที่กรอก: $date');
              if (date != selectedDate) {
                checkUpdateData = true;
              }
            },
            isDateInvalidNotifier: isDateInvalidNotifier,
          ),
        ],
      ),
    );
  }
}

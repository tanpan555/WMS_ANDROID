import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_FORM.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/styles.dart';

class SSFGDT17_CREATE extends StatefulWidget {
  final String pWareCode;
  final String? pWareName;
  const SSFGDT17_CREATE({
    Key? key,
    required this.pWareCode,
    required this.pWareName,
  }) : super(key: key);

  @override
  _SSFGDT17_CREATEState createState() => _SSFGDT17_CREATEState();
}

class _SSFGDT17_CREATEState extends State<SSFGDT17_CREATE> {
  String currentSessionID = '';
  List<dynamic> whCodes = [];
  String? selectedwhCode;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
    selectedwhCode = widget.pWareCode;
    print('CREATE  =============================');
    print('pWareCode: ${widget.pWareCode}');
    print('pWareName: ${widget.pWareName}');
    print(selectedwhCode);
    fetchwhCodes();
    fetchwhOUTCodes();
    fetchDocType();
    fetchLocationCodes();
  }

  Future<void> fetchwhCodes() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT17/Step_1_WHCode/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched data: $jsonData');
        fetchLocationCodes();
        if (mounted) {
          setState(() {
            whCodes = jsonData['items'];
            if (whCodes.isNotEmpty) {
              selectedwhCode = widget.pWareCode;
            }
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<dynamic> locCode = [];
  String? selectedLocCode;
  Future<void> fetchLocationCodes() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT17/Step_1_LOACATION/$selectedwhCode/${gb.P_ERP_OU_CODE}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched Loc data: $jsonData');
        if (mounted) {
          setState(() {
            locCode = jsonData['items'];
            if (locCode.isNotEmpty) {
              selectedLocCode = locCode[0]['location_code'];
            }
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<dynamic> whOUTCode = [];
  String? selectedwhOUTCode;
  Future<void> fetchwhOUTCodes() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT17/Step_1_WH_OUT/${gb.P_ERP_OU_CODE}/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched data: $jsonData');
        if (mounted) {
          setState(() {
            whOUTCode = jsonData['items'];
            if (whOUTCode.isNotEmpty) {
              selectedwhOUTCode = whOUTCode[0]['ware_code'];
            }
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<dynamic> locOUTCode = [];
  String? selectedLocOUTCode;
  Future<void> fetchLocationOutCodes() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT17/Step_1_LOCATION_OUT/$selectedwhOUTCode/${gb.P_ERP_OU_CODE}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched Loc data: $jsonData');
        if (mounted) {
          setState(() {
            locOUTCode = jsonData['items'];
            if (locOUTCode.isNotEmpty) {
              selectedLocOUTCode = locOUTCode[0]['location_code'];
            }
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? docData;
  Future<void> fetchDocType() async {
    try {
      final url = Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT17/Step_1_default_doc_type/${gb.ATTR1}');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        if (mounted) {
          setState(() {
            docData = jsonData['DOC_TYPE'];
          });
        }
      } else {
        throw Exception('Failed to load DOC_TYPE');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? poStatus;
  String? poMessage;
  String? po_doc_no;
  String? po_doc_type;

  Future<void> create_NewINXfer_WMS(
      String LocCode, String whOUTCode, String LocOUTCode) async {
    final url = '${gb.IP_API}/apex/wms/SSFGDT17/Step_1_create_NewINXfer_WMS';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'V_CR_WHCODE': selectedwhCode,
      'V_LOCATION': LocCode,
      'V_NB_OUT_WH': whOUTCode,
      'V_NB_LOC_OUT': LocOUTCode,
      'APP_SESSION': currentSessionID,
      'V_DOC_TYPE_OUT': docData,
      'p_ou': gb.P_OU_CODE,
      'p_erp_ou': gb.P_ERP_OU_CODE,
      'APP_USER': gb.APP_USER,
    });

    print('headers : $headers Type : ${headers.runtimeType}');
    print('body : $body Type : ${body.runtimeType}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            po_doc_no = responseData['po_doc_no'];
            po_doc_type = responseData['po_doc_type'];
            poStatus = responseData['po_status'];
            poMessage = responseData['po_message'];

            print('po_doc_no : $po_doc_no Type : ${po_doc_no.runtimeType}');
            print(
                'po_doc_type : $po_doc_type Type : ${po_doc_type.runtimeType}');
            print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
            print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
          });
        }
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'Move Locator', showExitWarning: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              color: const Color.fromARGB(255, 255, 242, 204),
              child: Center(
                child: Text(
                  'คลังสินค้า $selectedwhCode',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: EdgeInsets.all(16.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Stepper(
                  currentStep: _currentStep,
                  onStepTapped: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  onStepContinue: () async {
                    if (_currentStep < 2) {
                      setState(() {
                        _currentStep += 1;
                      });
                    } else {
                      final LocCode = selectedLocCode ?? 'null';
                      final whOUTCode = selectedwhOUTCode ?? 'null';
                      final LocOUTCode = selectedLocOUTCode ?? 'null';

                      await create_NewINXfer_WMS(
                        LocCode,
                        whOUTCode,
                        LocOUTCode,
                      );
                      if (poStatus == '0') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SSFGDT17_FORM(
                              po_doc_no: po_doc_no ?? '',
                              po_doc_type: po_doc_type,
                              LocCode: LocCode,
                              selectedwhCode: selectedwhCode,
                              selectedLocCode: selectedLocCode,
                              whOUTCode: whOUTCode,
                              LocOUTCode: LocOUTCode,
                              pWareCode: widget.pWareCode,
                              pWareName: widget.pWareName,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep -= 1;
                      });
                    }
                  },
                  steps: [
                    Step(
                      title: Text(
                        'เลือก Location ต้นทาง',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: buildLocationDropdown(
                        context, // Pass the BuildContext here
                        locCode, // List of location items
                        selectedLocCode, // Current selected value
                        (value) {
                          setState(() {
                            selectedLocCode = value?[
                                'location_code']; // Update the selected location code
                          });
                        },
                        '', // Label for the dropdown
                      ),
                    ),
                    Step(
                      title: Text(
                        'เลือกคลังปลายทาง',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: buildWarehouseOutDropdown(
                        context, // Pass the BuildContext here
                        whOUTCode, // List of warehouse items
                        selectedwhOUTCode, // Currently selected warehouse code
                        (value) {
                          setState(() {
                            selectedwhOUTCode = value?[
                                'ware_code']; // Update selected warehouse code
                            fetchLocationOutCodes(); // Fetch location codes after selection
                          });
                        },
                        '', // Provide a meaningful label for the dropdown
                      ),
                    ),
                    Step(
                      title: Text(
                        'เลือก Location ปลายทาง', // "Select Destination Location" in Thai
                        style: TextStyle(color: Colors.black),
                      ),
                      content: buildLocationOutDropdown(
                        context, // Add the BuildContext parameter
                        locOUTCode, // List of location items
                        selectedLocOUTCode, // Currently selected value
                        (value) {
                          // onChanged function
                          setState(() {
                            selectedLocOUTCode = value?[
                                'location_code']; // Set selected location
                          });
                        },
                        '', // Label for dropdown
                      ),
                    ),
                  ],
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controls) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 8), // เพิ่มระยะห่างด้านบน
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            onPressed: controls.onStepCancel,
                            child: const Text('ย้อนกลับ'),
                          ),
                          SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed: controls.onStepContinue,
                            child: Text(
                              _currentStep == 2 ? 'สร้าง' : 'ต่อไป',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 103, 58, 183),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }

  Widget buildLocationDropdown(
    BuildContext context,
    List<dynamic> items,
    String? selectedValue,
    Function(Map<String, dynamic>?) onChanged,
    String label,
  ) {
    // Find the selected item based on selectedValue
    String displayText = 'Select Location'; // Default text
    if (selectedValue != null) {
      final selectedItem = items.firstWhere(
        (item) => item['location_code'] == selectedValue,
        orElse: () => null,
      );
      if (selectedItem != null) {
        displayText = selectedItem['location_name'] ?? 'Select Location';
      }
    }

    return GestureDetector(
      onTap: () {
        _showDialog1(context, items, selectedValue, onChanged, label);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.black, fontSize: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  displayText, // Display location_name or "Select Location"
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog1(
    BuildContext context,
    List<dynamic> items,
    String? selectedValue,
    Function(Map<String, dynamic>?) onChanged,
    String label,
  ) {
    final TextEditingController _searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'เลือก Location ต้นทาง',
          searchController: _searchController,
          data: items,
          docString: (item) =>
              '${item['location_code'] ?? ''} ${item['location_name'] ?? ''}',
          titleText: (item) => item['location_code'] ?? '',
          subtitleText: (item) => item['location_name'] ?? '',
          onTap: (item) {
            onChanged(item); // Call onChanged with the selected item
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  void _showDialog2(
    BuildContext context,
    List<dynamic> items,
    String? selectedValue,
    Function(Map<String, dynamic>?) onChanged,
    String label,
  ) {
    final TextEditingController _searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'เลือกคลังปลายทาง',
          searchController: _searchController,
          data: items,
          docString: (item) =>
              '${item['ware_code'] ?? ''} ${item['ware_name'] ?? ''}',
          titleText: (item) => item['ware_name'] ?? '',
          subtitleText: (item) => item['ware_code'] ?? '',
          onTap: (item) {
            onChanged(item); // Call onChanged with the selected item
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  Widget buildWarehouseOutDropdown(
    BuildContext context,
    List<dynamic> items,
    String? selectedValue,
    Function(Map<String, dynamic>?) onChanged,
    String label,
  ) {
    String displayText = 'เลือกคลังปลายทาง'; // Default text
    if (selectedValue != null) {
      final selectedItem = items.firstWhere(
        (item) => item['ware_code'] == selectedValue,
        orElse: () => null,
      );
      if (selectedItem != null) {
        displayText = selectedItem['ware_name'];
      }
    }

    return GestureDetector(
      onTap: () {
        _showDialog2(context, items, selectedValue, onChanged, label);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.black, fontSize: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  displayText,
                  style: TextStyle(color: Colors.black),
                  overflow:
                      TextOverflow.visible, // Changed from ellipsis to visible
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog3(
    BuildContext context,
    List<dynamic> items,
    String? selectedValue,
    Function(Map<String, dynamic>?) onChanged,
    String label,
  ) {
    final TextEditingController _searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'เลือก Location ปลายทาง',
          searchController: _searchController,
          data: items,
          docString: (item) =>
              '${item['location_code'] ?? ''} ${item['location_name'] ?? ''}',
          titleText: (item) => item['location_code'] ?? '',
          subtitleText: (item) => item['location_name'] ?? '',
          onTap: (item) {
            onChanged(item); // Call onChanged with the selected item
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  Widget buildLocationOutDropdown(
    BuildContext context,
    List<dynamic> items,
    String? selectedValue,
    Function(Map<String, dynamic>?) onChanged,
    String label,
  ) {
// Default text
    String displayText = 'เลือก Location ปลายทาง'; // Default text
    if (selectedValue != null) {
      final selectedItem = items.firstWhere(
        (item) => item['location_code'] == selectedValue,
        orElse: () => null,
      );
      if (selectedItem != null) {
        displayText = selectedItem['location_name'] ?? 'Select Location';
      }
    }
    return GestureDetector(
      onTap: () {
        _showDialog3(context, items, selectedValue, onChanged, label);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.black, fontSize: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  displayText, // Display location_name or "Select Location"
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

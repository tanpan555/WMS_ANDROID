import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_FORM.dart';
import 'package:wms_android/custom_appbar.dart';
// import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;

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
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/WH/WHCode'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched data: $jsonData');
        fetchLocationCodes();

        setState(() {
          whCodes = jsonData['items'];
          if (whCodes.isNotEmpty) {
            selectedwhCode = widget.pWareCode;
          }
        });
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
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/LOACATION/$selectedwhCode'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched Loc data: $jsonData');

        setState(() {
          locCode = jsonData['items'];
          if (locCode.isNotEmpty) {
            selectedLocCode = locCode[0]['location_code'];
          }
        });
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
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT17/WH_OUT'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched data: $jsonData');

        setState(() {
          whOUTCode = jsonData['items'];
          if (whOUTCode.isNotEmpty) {
            selectedwhOUTCode = whOUTCode[0]['ware_code'];
          }
        });
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
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/LOACATION/$selectedwhOUTCode'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched Loc data: $jsonData');

        setState(() {
          locOUTCode = jsonData['items'];
          if (locOUTCode.isNotEmpty) {
            selectedLocOUTCode = locOUTCode[0]['location_code'];
          }
        });
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
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/default_doc_type');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        setState(() {
          docData = jsonData['DOC_TYPE'];
        });
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
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT17/create_NewINXfer_WMS';

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
        setState(() {
          po_doc_no = responseData['po_doc_no'];
          po_doc_type = responseData['po_doc_type'];
          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];

          print('po_doc_no : $po_doc_no Type : ${po_doc_no.runtimeType}');
          print('po_doc_type : $po_doc_type Type : ${po_doc_type.runtimeType}');
          print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
          print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
        });
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
      backgroundColor: const Color(0xFF17153B),
      appBar: const CustomAppBar(
        title: 'Move Locator',
      ),
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
                        locCode,
                        selectedLocCode,
                        (value) {
                          setState(() {
                            selectedLocCode = value?['location_code'];
                          });
                        },
                        'เลือก Location ต้นทาง',
                      ),
                    ),
                    Step(
                      title: Text(
                        'เลือกคลังปลายทาง',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: buildWarehouseOutDropdown(
                        whOUTCode,
                        selectedwhOUTCode,
                        (value) {
                          setState(() {
                            selectedwhOUTCode = value?['ware_code'];
                            fetchLocationOutCodes();
                          });
                        },
                        'เลือกคลังปลายทาง',
                      ),
                    ),
                    Step(
                      title: Text(
                        'เลือก Location ปลายทาง',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: buildLocationOutDropdown(
                        locOUTCode,
                        selectedLocOUTCode,
                        (value) {
                          setState(() {
                            selectedLocOUTCode = value?['location_code'];
                          });
                        },
                        'เลือก Location ปลายทาง',
                      ),
                    ),
                  ],
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controls) {
                    return Row(
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
                            backgroundColor: Color.fromARGB(255, 103, 58, 183),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget buildLocationDropdown(
    List<dynamic> items,
    String? selectedValue,
    Function(Map<String, dynamic>?) onChanged,
    String label,
  ) {
    return DropdownSearch<Map<String, dynamic>>(
      items: items.map((item) => item as Map<String, dynamic>).toList(),
      selectedItem: items.isNotEmpty
          ? items.firstWhere(
              (item) => item['location_code'] == selectedValue,
              orElse: () => items.first,
            )
          : null,
      itemAsString: (item) => '${item['location_code']}' ?? '',
      onChanged: onChanged,
      dropdownBuilder: (context, item) {
        if (item == null) {
          return Text(label);
        }
        return ListTile(
          title: Text(item['location_name'] ?? ''),
        );
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.black, fontSize: 16),
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
      popupProps: PopupProps.dialog(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "ค้นหาตำแหน่ง",
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          style: TextStyle(color: Colors.black),
        ),
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
      ),
    );
  }

  Widget buildWarehouseOutDropdown(
    List<dynamic> items,
    String? selectedValue,
    Function(Map<String, dynamic>?) onChanged,
    String label,
  ) {
    return DropdownSearch<Map<String, dynamic>>(
      items: items.map((item) => item as Map<String, dynamic>).toList(),
      selectedItem: items.isNotEmpty
          ? items.firstWhere(
              (item) => item['ware_code'] == selectedValue,
              orElse: () => items.first,
            )
          : null,
      itemAsString: (item) => '${item['ware_name']}' ?? '',
      onChanged: onChanged,
      dropdownBuilder: (context, item) {
        if (item == null) {
          return Text(label);
        }
        return ListTile(
          subtitle: Text(item['ware_name'] ?? ''),
        );
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.black, fontSize: 16),
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
      popupProps: PopupProps.dialog(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "ค้นหาคลังออก",
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          style: TextStyle(color: Colors.black),
        ),
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
      ),
    );
  }

  Widget buildLocationOutDropdown(
    List<dynamic> items,
    String? selectedValue,
    Function(Map<String, dynamic>?) onChanged,
    String label,
  ) {
    return DropdownSearch<Map<String, dynamic>>(
      items: items.map((item) => item as Map<String, dynamic>).toList(),
      selectedItem: items.isNotEmpty
          ? items.firstWhere(
              (item) => item['location_code'] == selectedValue,
              orElse: () => items.first,
            )
          : null,
      itemAsString: (item) => item['location_code'] ?? '',
      onChanged: onChanged,
      dropdownBuilder: (context, item) {
        if (item == null) {
          return Text(label);
        }
        return ListTile(
          title: Text(item['location_code'] ?? ''),
          subtitle: Text(item['location_name'] ?? ''),
        );
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
      popupProps: PopupProps.dialog(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "ค้นหาตำแหน่งออก",
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          style: TextStyle(color: Colors.black),
        ),
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
      ),
    );
  }
}
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
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/LOACATION/$selectedwhCode'));

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
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT17/WH_OUT'));

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
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/LOACATION/$selectedwhOUTCode'));

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
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/default_doc_type');
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
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'Move Locator', showExitWarning: true),
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
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Align text and arrow
          children: [
            Text(
              selectedValue ?? 'Select Location',
              style: TextStyle(color: Colors.black),
            ),
            Icon(
              Icons.arrow_drop_down, // Dropdown arrow icon
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
                          'เลือก Location ต้นทาง',
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
                        setState(() {}); // Trigger UI update on search
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Filter items based on the search query
                          final filteredItems = items.where((item) {
                            final locationCode =
                                item['location_code']?.toLowerCase() ?? '';
                            final searchQuery =
                                _searchController.text.toLowerCase();
                            return locationCode.contains(searchQuery);
                          }).toList();

                          if (filteredItems.isEmpty) {
                            return Center(
                              child: Text(
                                'No data found', // Display this when no items match
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
                              final item =
                                  filteredItems[index] as Map<String, dynamic>;
                              final locationCode = item['location_code'];
                              final locationName = item['location_name'];

                              return ListTile(
                                title: Text(
                                  locationCode,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  locationName,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                onTap: () {
                                  onChanged(
                                      item); // Call onChanged with the selected item
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
                          'เลือกคลังปลายทาง',
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
                        hintText: 'ค้นหา', // Search hint text
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        setState(() {}); // Trigger UI update on search
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Filter items based on the search query
                          final filteredItems = items.where((item) {
                            final wareName =
                                item['ware_name']?.toLowerCase() ?? '';
                            final searchQuery =
                                _searchController.text.toLowerCase();
                            return wareName.contains(searchQuery);
                          }).toList();

                          if (filteredItems.isEmpty) {
                            return Center(
                              child: Text(
                                'No data found', // Display this when no items match
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
                              final item =
                                  filteredItems[index] as Map<String, dynamic>;
                              final wareCode = item['ware_code'];
                              final wareName = item['ware_name'];

                              return ListTile(
                                title: Text(
                                  wareName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  onChanged(
                                      item); // Call onChanged with the selected item
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

  Widget buildWarehouseOutDropdown(
    BuildContext context,
    List<dynamic> items,
    String? selectedValue,
    Function(Map<String, dynamic>?) onChanged,
    String label,
  ) {
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
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Align text and arrow
          children: [
            Text(
              selectedValue ?? 'Select Location',
              style: TextStyle(color: Colors.black),
            ),
            Icon(
              Icons.arrow_drop_down, // Dropdown arrow icon
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
                          'เลือก Location ปลายทาง',
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
                        hintText: 'ค้นหาตำแหน่งออก', // Search hint text
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        setState(() {}); // Trigger UI update on search
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Filter items based on the search query
                          final filteredItems = items.where((item) {
                            final locationCode =
                                item['location_code']?.toLowerCase() ?? '';
                            final searchQuery =
                                _searchController.text.toLowerCase();
                            return locationCode.contains(searchQuery);
                          }).toList();

                          if (filteredItems.isEmpty) {
                            return Center(
                              child: Text(
                                'No data found', // Show message when no data is found
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
                              final item =
                                  filteredItems[index] as Map<String, dynamic>;
                              final locationCode = item['location_code'];
                              final locationName = item['location_name'];

                              return ListTile(
                                title: Text(
                                  locationCode,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  locationName ?? '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                onTap: () {
                                  onChanged(
                                      item); // Call onChanged with the selected item
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

  Widget buildLocationOutDropdown(
    BuildContext context,
    List<dynamic> items,
    String? selectedValue,
    Function(Map<String, dynamic>?) onChanged,
    String label,
  ) {
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
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Align text and arrow
          children: [
            Text(
              selectedValue ?? 'เลือก Location ปลายทาง',
              style: TextStyle(color: Colors.black),
            ),
            Icon(
              Icons.arrow_drop_down, // Dropdown arrow icon
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

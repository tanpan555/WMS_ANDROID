import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
// import 'package:wms_android/custom_drawer.dart';
import 'SSINDT01_form.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:wms_android/Global_Parameter.dart' as gb;

class SSINDT01_MAIN extends StatefulWidget {
final String pWareCode;
  final String pWareName;
  final String p_ou_code;
  final String selectedValue; // Changed parameter name
  final String apCode;
  final String documentNumber;

  const SSINDT01_MAIN({
    Key? key,
    required this.pWareCode,
    required this.pWareName,
    required this.p_ou_code,
    required this.selectedValue, // Changed parameter name
    required this.apCode,
    required this.documentNumber,
  }) : super(key: key);
  // const Ssindt01Card({super.key});
  @override
  _SSINDT01_MAINState createState() => _SSINDT01_MAINState();
}

class _SSINDT01_MAINState extends State<SSINDT01_MAIN> {
  List<dynamic> data = [];
  List<dynamic> displayedData = [];
  bool isLoading = true;
  String errorMessage = '';
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  String? ATTR = gb.Raw_Material;

  List<dynamic> apCodes = [];
  String? selectedApCode;

  List<dynamic> whCodes = [];
  String? selectedwhCode;

  String? _selectedValue;
  String? fixedValue;

  // final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
void initState() {
  super.initState();
  print('Card Global Ware Code: ${gb.P_WARE_CODE}');
                        log('Card Global Ware Code: ${gb.P_WARE_CODE}');
  print('+----------------------------------------');
  print(gb.ATTR1);
  print(widget.selectedValue);
  fixedValue = valueMapping[widget.selectedValue] ?? '';
  print(fixedValue);
   print(widget.apCode);
  _selectedValue = 'ทั้งหมด';
  selectedwhCode = widget.pWareCode;
  selectedApCode = widget.apCode;
  searchQuery = widget.documentNumber;
fetchWareCodes();
// _initializeData();

}

Future<void> _initializeData() async {
  try {
    // Fetch AP codes and wait for it to complete
    await fetchApCodes();
    // Fetch warehouse codes and wait for it to complete
    await fetchwhCodes();
  } catch (e) {
    print('Error during fetch operations: $e');
  } finally {
    // Show the filter dialog after fetching data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _showFilterDialog();
    });
  }
}

  void _handleSelected(String? value) {
    setState(() {
      _selectedValue = widget.selectedValue;
      print('Selected value in handle: $_selectedValue');
    });
  }

  final Map<String, String> valueMapping = {
    'รายการรอรับดำเนินการ': 'A',
    'รายการใบสั่งซื้อ': 'B',
    'ทั้งหมด': 'C',
  };

  Future<void> fetchApCodes() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/AP_CODE'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          apCodes = jsonData['items'] ?? [];
          apCodes.insert(0, {'ap_code': 'ทั้งหมด', 'ap_name': 'ทั้งหมด'});
          selectedApCode = 'ทั้งหมด';
          fetchWareCodes();
        });
      } else {
        throw Exception('Failed to load AP codes');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        print(
            'errorMessage : $errorMessage Type : ${errorMessage.runtimeType}');
      });
    }
  }

  Future<void> fetchwhCodes() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/WH/WHCode'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched data: $jsonData');

        setState(() {
          whCodes = jsonData['items'];
          if (data.isNotEmpty) {
            selectedwhCode = whCodes[0]['ware_code'];
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // void _showFilterDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return Dialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             insetPadding:
  //                 EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
  //             child: Container(
  //               padding: EdgeInsets.all(15.0),
  //               // width: MediaQuery.of(context).size.width * 0.9,
  //               // height: MediaQuery.of(context).size.height * 0.7,
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Text(
  //                       'ตัวเลือกการกรอง',
  //                       style: TextStyle(
  //                         fontSize: 20.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                      Text(
  //                       'คลัง $selectedwhCode',
  //                       style: TextStyle(
  //                         fontSize: 20.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
    
  //                     SizedBox(height: 15),
  //                     DropdownSearch<String>(
  //                       popupProps: PopupProps.menu(
  //                         showSearchBox: true,
  //                         showSelectedItems: true,
  //                         itemBuilder: (context, item, isSelected) {
  //                           return ListTile(
  //                             title: Text(item),
  //                             selected: isSelected,
  //                           );
  //                         },
  //                         constraints: BoxConstraints(
  //                           maxHeight: 250,
  //                         ),
  //                       ),
  //                       items: <String>[
  //                         'รายการรอรับดำเนินการ',
  //                         'รายการใบสั่งซื้อ',
  //                         'ทั้งหมด',
  //                       ],
  //                       dropdownDecoratorProps: DropDownDecoratorProps(
  //                         dropdownSearchDecoration: InputDecoration(
  //                           labelText: "ประเภทสินค้า",
  //                           hintText: "เลือกประเภทสินค้า",
  //                           hintStyle: TextStyle(fontSize: 16.0),
  //                         ),
  //                       ),
  //                       onChanged: (String? value) {
  //                         setState(() {
  //                           _selectedValue = value;
  //                           fixedValue = valueMapping[_selectedValue] ?? '';
  //                         });
  //                       },
  //                       selectedItem: _selectedValue,
  //                     ),
  //                     SizedBox(height: 15),
  //                     DropdownSearch<String>(
  //                       popupProps: PopupProps.menu(
  //                         showSearchBox: true,
  //                         showSelectedItems: true,
  //                         itemBuilder: (context, item, isSelected) {
  //                           // Find the corresponding item details from apCodes
  //                           final apCodeItem = apCodes.firstWhere(
  //                             (element) => element['ap_code'] == item,
  //                             orElse: () => {'ap_name': 'No name'},
  //                           );
  //                           return ListTile(
  //                             title: Text(
  //                               item,
  //                               style: TextStyle(fontWeight: FontWeight.bold),
  //                             ),
  //                             subtitle: Text(
  //                               apCodeItem['ap_name'] ?? 'No name',
  //                               style:
  //                                   TextStyle(color: Colors.grey, fontSize: 8),
  //                             ),
  //                             selected: isSelected,
  //                           );
  //                         },
  //                         constraints: BoxConstraints(
  //                           maxHeight: 300,
  //                         ),
  //                       ),
  //                       items: apCodes
  //                           .map((item) => item['ap_code'] as String)
  //                           .toList(),
  //                       dropdownDecoratorProps: DropDownDecoratorProps(
  //                         dropdownSearchDecoration: InputDecoration(
  //                           labelText: "ผู้ขาย",
  //                           hintText: "เลือกผู้ขาย",
  //                         ),
  //                       ),
  //                       onChanged: (String? value) {
  //                         setState(() {
  //                           selectedApCode = value;
  //                         });
  //                       },
  //                       selectedItem: selectedApCode,
  //                     ),

  //                     SizedBox(height: 15),
  //                     TextField(
  //                       controller: searchController,
  //                       decoration: InputDecoration(
  //                         labelText: 'ค้นหา',
  //                         border: OutlineInputBorder(),
  //                       ),
  //                       onChanged: (value) {
  //                         setState(() {
  //                           searchQuery = value;
  //                         });
  //                       },
  //                     ),
  //                     SizedBox(height: 15),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         TextButton(
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                           },
  //                           style: TextButton.styleFrom(
  //                             backgroundColor: Colors.red,
  //                           ),
  //                           child: Text(
  //                             'ยกเลิก',
  //                             style:
  //                                 TextStyle(color: Colors.white, fontSize: 20),
  //                           ),
  //                         ),
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                             setState(() {
  //                               if(_selectedValue == 'ทั้งหมด'){
  //                                 fixedValue = 'C';
  //                               }
  //                               fetchWareCodes();
  //                             });
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.green,
  //                           ),
  //                           child: Text(
  //                             'ยืนยัน',
  //                             style:
  //                                 TextStyle(color: Colors.white, fontSize: 20),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void performSearch() {
    filterData();
  }

  int _displayLimit = 15;

  void _loadMoreItems() {
    setState(() {
      _displayLimit += 15;
    });
  }

  Future<void> fetchWareCodes() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/c/new_card_list/$fixedValue/$ATTR'));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          data = jsonData['items'] ?? [];
          filterData();
          isLoading = false;
        });
        print(data);
        print('http://172.16.0.82:8888/apex/wms/c/new_card_list/$fixedValue/$ATTR');
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

  void filterData() {
    setState(() {
      displayedData = data.where((item) {
        final poNo = item['po_no']?.toString().toLowerCase() ?? '';
        final matchesSearchQuery = poNo.contains(searchQuery.toLowerCase());
        final matchesApCode =
            selectedApCode == 'ทั้งหมด' || item['ap_code'] == selectedApCode;
        return matchesSearchQuery && matchesApCode;
      }).toList();
      print(
          'displayedData : $displayedData Type : ${displayedData.runtimeType}');
    });
  }

  String? poStatus;
  String? poMessage;
  String? poStep;

  Future<void> fetchPoStatus(String poNo, String? receiveNo) async {
    final String receiveNoParam = receiveNo ?? 'null';
    final String apiUrl =
        'http://172.16.0.82:8888/apex/wms/c/check_rcv/$poNo/$receiveNoParam/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          poStatus = responseBody['po_status'];
          poMessage = responseBody['po_message'];
          poStep = responseBody['po_goto_step'];

          print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
          print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
          print('poStep : $poStep Type : ${poStep.runtimeType}');
        });
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      setState(() {
        poStatus = 'Error';
        poMessage = e.toString();

        print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
        print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
      });
    }
  }

  String? poReceiveNo;

  Future<void> sendPostRequest(
      String poNo, String receiveNo, String selectedwhCode) async {
    final url = 'http://172.16.0.82:8888/apex/wms/c/create_inhead_wms';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_po_no': poNo,
      'p_receive_no': receiveNo,
      'p_wh_code': selectedwhCode,
      'APP_SESSION': gb.APP_SESSION,
      'APP_USER': gb.APP_USER,
      'P_OU_CODE': gb.P_OU_CODE,
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,

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
          poReceiveNo = responseData['po_receive_no'];
          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];

          print('poReceiveNo : $poReceiveNo Type : ${poReceiveNo.runtimeType}');
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

  // void _showSelectWareCodeDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('เลือกคลังสินค้า'),
  //         content: DropdownButton<String>(
  //           isExpanded: true,
  //           value: selectedwhCode,
  //           hint: Text('เลือกคลังปฏิบัติการ'),
  //           items: whCodes.map((item) {
  //             return DropdownMenuItem<String>(
  //               value: item['ware_code'],
  //               child: Text(item['ware_code'] ?? 'No code'),
  //             );
  //           }).toList(),
  //           onChanged: (value) {
  //             setState(() {
  //               selectedwhCode = value;
  //               Navigator.of(context).pop();
  //               _showFilterDialog();
  //             });
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  void handleTap(BuildContext context, Map<String, dynamic> item) async {
    if (selectedwhCode == null) {
      AlertDialog(
            title: Text('คำเตือน'),
            content: Text('โปรดเลือกคลังสินค้า'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
      return;
    }
    final pPoNo = item['po_no'] ?? '';
    final vReceiveNo = item['receive_no'] ?? 'null';
    // ScaffoldMessenger.of(context).showSnackBar(
    //                     SnackBar(
    //                       content: Text(
    //                           'WH: $selectedwhCode Pono: $pPoNo RecNo: $vReceiveNo'),
    //                     ),
    //                   );
    await fetchPoStatus(pPoNo, vReceiveNo);

    if (poStatus == '0') {
      await sendPostRequest(pPoNo, vReceiveNo, selectedwhCode ?? '');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Ssindt01Form(poReceiveNo: poReceiveNo ?? '', pWareCode: widget.pWareCode ?? '', pWareName: widget.pWareName, p_ou_code: widget.p_ou_code,),
        ),
      );
    } else if (poStatus == '1' && poStep == '9') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('คำเตือน'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Status: ${poStatus ?? 'No status available'}'),
                // SizedBox(height: 8.0),
                Text('${poMessage ?? 'No message available'}'),
                // SizedBox(height: 8.0),
                // Text('Step: ${poStep ?? 'No message available'}'),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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
    } else if (poStatus == '1' && poStep == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('คำเตือน'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Status: ${poStatus ?? 'No status available'}'),
                // SizedBox(height: 8.0),
                Text('${poMessage ?? 'No message available'}'),
                // Text('Step: ${poStep ?? 'No message available'}'),
              ],
            ),
            actions: [
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
  }

Widget buildListTile(BuildContext context, Map<String, dynamic> item) {
  // Define a map for status values to colors
  Map<String, Color> statusColors = {
    'ตรวจรับบางส่วน': Colors.orange,
    'บันทึก': Colors.blue,
    'รอยืนยัน': Colors.yellow,
    'ปกติ': Colors.grey,
    'อนุมัติ': Colors.green,
  };

  Color statusColor = statusColors[item['status_desc']] ?? Colors.grey;

  TextStyle statusStyle = TextStyle(
    color: statusColor,
    fontWeight: FontWeight.bold,
  );

  BoxDecoration statusDecoration = BoxDecoration(
    border: Border.all(color: statusColor, width: 2.0),
    borderRadius: BorderRadius.circular(4.0),
  );

  // Determine the content for card_qc
  Widget cardQcWidget;
  if (item['card_qc'] == '#APP_IMAGES#rt_machine_on.png') {
    cardQcWidget = Image.asset(
      'assets/images/rt_machine_on.png',
      width: 64.0,
      height: 64.0,
    );
  } else if (item['card_qc'] == '#APP_IMAGES#rt_machine_off.png') {
    cardQcWidget = Image.asset(
      'assets/images/rt_machine_off.png',
      width: 64.0,
      height: 64.0,
    );
  } else if (item['card_qc'] == 'No item') {
    cardQcWidget = SizedBox.shrink(); // No widget displayed
  } else {
    cardQcWidget = Text('');
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    child: Card(
      color: const Color.fromRGBO(204, 235, 252, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(item['ap_name'] ?? 'No Name'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                      decoration: statusDecoration,
                      child: Text(
                        '${item['status_desc'] ?? 'No Status'}',
                        style: statusStyle,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    cardQcWidget,
                  ],
                ),
                Text(
                  '${item['po_date'] ?? ''} ${item['po_no'] ?? ''} \n${item['item_stype_desc'] ?? '\n'}'
                  '${item['receive_date'] ?? ''} ${item['receive_no'] ?? ''} ${item['warehouse'] ?? ''}',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                SizedBox(height: 8.0),
                
              ],
            ),
            contentPadding: EdgeInsets.all(16.0),
            onTap: () => handleTap(context, item),
          ),
        ],
        
      ),
      
    ),
    
  );
  
}


////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ'),
      // drawer: const CustomDrawer(),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          return isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text('Error: $errorMessage'))
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          if (isPortrait)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            Row(
                children: [
                  //           ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //     minimumSize: const Size(10, 20),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 10, vertical: 5),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: const Text(
                  //     'ย้อนกลับ',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  ],),
                          const SizedBox(height: 10),
                          Expanded(
                            child: displayedData.isEmpty
                                ? Center(child: Text('No data available'))
                                : ListView.builder(
                                    controller: _scrollController,
                                    itemCount:
                                        (_displayLimit < displayedData.length)
                                            ? _displayLimit + 1
                                            : displayedData.length,
                                    itemBuilder: (context, index) {
                                      if (index == _displayLimit) {
                                        return Center(
                                          child: ElevatedButton(
                                            onPressed: _loadMoreItems,
                                            child: Text('แสดงเพิ่มเติม'),
                                          ),
                                        );
                                      }
                                      if (index < displayedData.length) {
                                        final item = displayedData[index];
                                        return buildListTile(context, item);
                                      }
                                      return Container();
                                    },
                                  ),
                          ),
                        ],
                      ),
                    );
        },
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}


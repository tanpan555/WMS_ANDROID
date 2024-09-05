import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGD17_VERIFY.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_BARCODE.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_FORM.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;


class SSFGDT17_MAIN extends StatefulWidget {
 final String pWareCode;
  final String? selectedValue;
  final String documentNumber;
  final String dateController;

  const SSFGDT17_MAIN({
    Key? key,
    required this.pWareCode,
    this.selectedValue,
    required this.documentNumber,
    required this.dateController,
  }) : super(key: key);

  @override
  _SSFGDT17_MAINState createState() => _SSFGDT17_MAINState();
}

class _SSFGDT17_MAINState extends State<SSFGDT17_MAIN> {
  String currentSessionID = '';
  List<dynamic> whCodes = [];
  String? selectedwhCode;
  String? docData;

  
  
  DateTime? selectedDate;
String? docNumberFilter;
  final TextEditingController _docNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
void initState() {
  super.initState();
  
  currentSessionID = SessionManager().sessionID;
selectedwhCode = widget.pWareCode;
print(selectedwhCode);
  // _dateController.text = selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : '';
   _dateController.text = widget.dateController;
  _selectedStatusValue = widget.selectedValue;
  docNumberFilter = widget.documentNumber;
fetchDocType().then((data) {
      setState(() {
        print('docData: $docData');
        data_card_list();
      });
    }).catchError((e) {
      print('Error fetching doc type: $e');
    });
  
}

@override
void dispose() {
  _docNumberController.dispose();
  _dateController.dispose();
  super.dispose();
}
   void _selectDate() async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (pickedDate != null && pickedDate != selectedDate) {
    setState(() {
      selectedDate = pickedDate;
      _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
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
          if (whCodes.isNotEmpty) {
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


Future<void> fetchDocType() async {
  final response = await http.get(Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT17/default_doc_type'));

  if (response.statusCode == 200) {
    // Parse the JSON data
    final Map<String, dynamic> data = json.decode(response.body);
    docData = data['DOC_TYPE'];
    print(docData);
  } else {
    // Handle the error
    throw Exception('Failed to load data');
  }
}




String? _selectedStatusValue = 'ทั้งหมด';
  String? fixedValue = '0';

  void _handleSelected(String? value) {
    setState(() {
      _selectedStatusValue = value;
      print('Selected value in handle: $_selectedStatusValue');
    });
  }

  final Map<String, String> valueMapping = {
    'ทั้งหมด': '0',
    'ปกติ': '1',
    'ยกเลิก': '2',
    'รับโอนแล้ว': '3',
  };

  List<dynamic> data = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> data_card_list() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/SSFGDT17_Card_List/$selectedwhCode/$fixedValue/000/$docData'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        List<dynamic> fetchedData = jsonData['items'] ?? [];

        // Convert dateController text to DateTime
        DateTime? filterDate;
        try {
          filterDate = DateFormat('dd/MM/yyyy').parse(_dateController.text);
        } catch (e) {
          print('Date format error: $e');
        }

        if (filterDate != null) {
          fetchedData = fetchedData.where((item) {
            DateTime? itemDate;
            try {
              itemDate = DateFormat('dd/MM/yyyy').parse(item['doc_date'] ?? '');
            } catch (e) {
              return false;
            }
            return itemDate != null && itemDate.isAtSameMomentAs(filterDate!);
          }).toList();
        }

        if (docNumberFilter != null && docNumberFilter!.isNotEmpty) {
          fetchedData = fetchedData.where((item) {
            return (item['doc_number'] ?? '').contains(docNumberFilter!);
          }).toList();
        }

        setState(() {
          data = fetchedData;
          print(data);
          isLoading = false;
        });
        print('http://172.16.0.82:8888/apex/wms/SSFGDT17/SSFGDT17_Card_List/$selectedwhCode/$fixedValue/000/$docData');
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

String? doc_no;
String? doc_out;


 Widget buildListTile(BuildContext context, Map<String, dynamic> item) {
  Map<String, Color> statusColors = {
    'ยกเลิก': Colors.orange,
    'รับโอน': Colors.blue,
    'ปกติ': Colors.green,
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

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    child: Card(
      color: const Color.fromRGBO(204,235,252,1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5,
      child: ListTile(
        title: Text(item['doc_number'] ?? 'No doc_number'),
        subtitle: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${item['doc_date'] ?? 'No doc_date'} '
                          '${item['from_warehouse'] ?? 'No WAREHOUSE'}\n',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    if (item['status_desc'] != null)
                      WidgetSpan(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          decoration: statusDecoration,
                          child: Text(
                            '${item['status_desc'] ?? 'No Status'}',
                            style: statusStyle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap:() {
          print('${item['doc_no'] ?? 'No doc_no'} ');
          print('${item['doc_type'] ?? 'No doc_type'} ');
          doc_no = item['doc_no'];
          doc_out = item['doc_type'];
          chk_validate();
          chk_validate_inhead();
          print('poStatusinhead: $poStatusinhead');
          // print('$poStatus $poMessage $goToStep' );

        if(poStatus == '1'){
          print(poMessage);
          showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('คำเตือน'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${poMessage ?? 'No message available'}'),
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
        else if(poStatus == '0'){
          if(goToStep == '2'){
            print('ไปหน้า Form');
            if(poStatusinhead == '0'){
              Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SSFGDT17_FORM(
                            po_doc_no: doc_no ?? '',
                            po_doc_type: doc_out,
                            LocCode: '',
                            selectedwhCode: '',
                            selectedLocCode: '',
                            whOUTCode: '',
                            LocOUTCode: '', pWareCode: '',),
                      ),
                    );
            }
          }
          else if(goToStep == '3'){
            print('ไปหน้า barcode');
            if(poStatusinhead == '0'){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SSFGDT17_BARCODE(
                            po_doc_no: doc_no ?? '',
                            po_doc_type: doc_out,
                            LocCode: '',
                            selectedwhCode: '',
                            selectedLocCode: '',
                            whOUTCode: '',
                            LocOUTCode: ''),
                      ),
                    );
            }
          }
          else if(goToStep == '4'){
            print('ไปหน้ายืนยัน');
            if(poStatusinhead == '0'){
              Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SSFGD17_VERIFY(
                            po_doc_no: doc_no ?? '',
                            po_doc_type: doc_out,
                            selectedwhCode: '',),
                      ),
                    );
            }
          }
        }

        },
      ),
    ),
  );
}


  int _displayLimit = 15;
  final ScrollController _scrollController = ScrollController();

  void _loadMoreItems() {
    setState(() {
      _displayLimit += 15;
    });
  }
//  void _filterDialog() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return AlertDialog(
//             title: const Text('ตัวกรองค้นหา'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 DropdownButton<String>(
//                   isExpanded: true,
//                   value: _selectedStatusValue,
//                   hint: const Text('ประเภทรายการ'),
//                   items: <String>[
//                     'ทั้งหมด',
//                     'ปกติ',
//                     'ยกเลิก',
//                     'รับโอนแล้ว',
//                   ].map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? value) {
//                     setState(() {
//                       _selectedStatusValue = value;
//                       fixedValue = valueMapping[_selectedStatusValue] ?? '';
//                     });
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: _docNumberController,
//                   decoration: const InputDecoration(
//                     labelText: 'เลขที่ใบโอน',
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       docNumberFilter = value;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: _dateController,
//                   decoration: const InputDecoration(
//                     labelText: 'วันที่',
//                     border: OutlineInputBorder(),
//                   ),
//                   readOnly: true,
//                   onTap: _selectDate,
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     fixedValue = '0';
//                     docNumberFilter = '';
//                     _docNumberController.clear();
//                     _dateController.clear();
//                     selectedDate = null;
//                   });
        
//                 },
//                 child: const Text('Clear Filter'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     docNumberFilter = _docNumberController.text;
//                   });
//                   Navigator.of(context).pop();
//                   data_card_list();
//                 },
//                 child: const Text('ค้นหา'),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

String? poStatus;
  String? poMessage;
  String? goToStep;

  Future<void> chk_validate() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/check_TFLOCDirect_validate/$doc_no/$doc_out/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}'));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          poStatus = jsonData['po_status'];
          poMessage = jsonData['po_message'];
          goToStep = jsonData['po_goto_step'];
          print(response.statusCode);
          print(jsonData);
          print(poStatus);
          print(poMessage);
          print(goToStep);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? poStatusinhead;

  Future<void> chk_validate_inhead() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/get_INHeadXfer_WMS/$doc_no/$doc_out/${widget.pWareCode}/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}/${gb.APP_USER}'));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          poStatusinhead = jsonData['po_status'];
 
          print('poStatusinhead: $poStatusinhead');
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: const CustomAppBar(title: 'Move Locator'),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          return isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text('Error: $errorMessage'))
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          
                          if (isPortrait)
                //             Row(
                // children: [
                //   // ElevatedButton(
                //   //   style: ElevatedButton.styleFrom(
                //   //     backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                //   //     shape: RoundedRectangleBorder(
                //   //       borderRadius: BorderRadius.circular(12.0),
                //   //     ),
                //   //     minimumSize: const Size(10, 20),
                //   //     padding: const EdgeInsets.symmetric(
                //   //         horizontal: 10, vertical: 5),
                //   //   ),
                //   //   onPressed: () {
                //   //     Navigator.pop(context);
                //   //   },
                //   //   child: const Text(
                //   //     'ย้อนกลับ',
                //   //     style: TextStyle(
                //   //       color: Colors.white,
                //   //       fontWeight: FontWeight.bold,
                //   //     ),
                //   //   ),
                //   // ),
                // ]
                // ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: data.isEmpty
                                ? const Center(child: Text('No Data Available',style: TextStyle(color: Colors.white),))
                                : ListView.builder(
                                    controller: _scrollController,
                                    itemCount: (_displayLimit < data.length)
                                        ? _displayLimit + 1
                                        : data.length,
                                    itemBuilder: (context, index) {
                                      if (index == _displayLimit) {
                                        return Center(
                                          child: ElevatedButton(
                                            onPressed: _loadMoreItems,
                                            child: const Text('แสดงเพิ่มเติม'),
                                          ),
                                        );
                                      }
                                      if (index < data.length) {
                                        final item = data[index];
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

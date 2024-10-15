import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGD17_VERIFY.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_BARCODE.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_FORM.dart';
import 'package:wms_android/custom_appbar.dart';
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
  final String docData1;

  const SSFGDT17_MAIN({
    Key? key,
    required this.pWareCode,
    this.selectedValue,
    required this.documentNumber,
    required this.dateController,
    required this.docData1,
  }) : super(key: key);

  @override
  _SSFGDT17_MAINState createState() => _SSFGDT17_MAINState();
}

class _SSFGDT17_MAINState extends State<SSFGDT17_MAIN> {
  String currentSessionID = '';
  List<dynamic> whCodes = [];
  String? selectedwhCode;
  String? docData;

  String? nextLink;
  String? prevLink;

  DateTime? selectedDate;
  String? docNumberFilter;
  final TextEditingController _docNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? DateSend;

  @override
  void initState() {
    super.initState();

    currentSessionID = SessionManager().sessionID;
    selectedwhCode = widget.pWareCode;
    print(selectedwhCode);
    // _dateController.text = selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : '';
    _dateController.text = widget.dateController;
    _selectedStatusValue = widget.selectedValue;
    // fixedValue = widget.selectedValue;
    print('fixedValue: $fixedValue');
    docNumberFilter = widget.documentNumber;
    print('=====================');
    print(widget.docData1);
    print(widget.documentNumber);
    print(widget.dateController);
    print(_dateController.text);

    DateSend = widget.dateController;
    if (DateSend != null) {
      DateSend = DateSend!.replaceAll('/', '-');
    }
    data_card_list();
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
      if (mounted) {
        setState(() {
          selectedDate = pickedDate;
          _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
        });
      }
    }
  }

  void _loadNextPage() {
    if (nextLink != null) {
      if (mounted) {
        setState(() {
          print('nextLink $nextLink');
          isLoading = true;
        });
      }
      data_card_list(nextLink);
    }
  }

  void _loadPrevPage() {
    if (prevLink != null) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      data_card_list(prevLink);
    }
  }

  String? _selectedStatusValue = 'ทั้งหมด';
  String? fixedValue;

  void _handleSelected(String? value) {
    if (mounted) {
      setState(() {
        _selectedStatusValue = value;
        print('Selected value in handle: $_selectedStatusValue');
      });
    }
  }

  final Map<String, String> valueMapping = {
    'ทั้งหมด': '0',
    'ปกติ': '1',
    'รับโอนแล้ว': '2',
    'ยกเลิก': '3',
  };

  List<dynamic> data = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> data_card_list([String? url]) async {
    final String statusValue = valueMapping[_selectedStatusValue] ?? '0';
    try {
      final uri = url ??
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/SSFGDT17_Card_List/$selectedwhCode/$statusValue/000/${widget.docData1}/$DateSend/${widget.documentNumber}';
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        print(uri);
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);
        if (mounted) {
          setState(() {
            if (parsedResponse is Map && parsedResponse.containsKey('items')) {
              data = parsedResponse['items'];
            } else {
              data = [];
            }

            List<dynamic> links = parsedResponse['links'] ?? [];
            nextLink = getLink(links, 'next');
            prevLink = getLink(links, 'prev');
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

  String? getLink(List<dynamic> links, String rel) {
    final link =
        links.firstWhere((item) => item['rel'] == rel, orElse: () => null);
    return link != null ? link['href'] : null;
  }

  String? doc_no;
  String? doc_out;

  Widget buildListTile(BuildContext context, Map<String, dynamic> item) {
    Map<String, Color> statusColors = {
      'ยกเลิก': Colors.grey,
      'รับโอนแล้ว': Colors.green,
      'ปกติ': Colors.yellow,
    };

    Color statusColor = statusColors[item['status_desc']] ?? Colors.grey;

    TextStyle statusStyle = TextStyle(
      color: Colors.black,
      // fontWeight: FontWeight.bold,
    );

    BoxDecoration statusDecoration = BoxDecoration(
      border: Border.all(color: statusColor, width: 2.0),
      color: statusColor,
      borderRadius: BorderRadius.circular(4.0),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Card(
        color: const Color.fromRGBO(204, 235, 252, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        child: Column(
          children: [
            ListTile(
              title: Center(
                child: Text(
                  item['doc_number'] ?? 'No doc_number',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
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
                        TextSpan(
                          text: '\n \n',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        TextSpan(
                          text:
                              '${item['doc_date'] ?? 'No doc_date'} ${item['from_warehouse'] ?? 'No WAREHOUSE'} ${item['staff_name'] ?? ''}',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () async {
                print('${item['doc_no'] ?? 'No doc_no'} ');
                print('${item['doc_type'] ?? 'No doc_type'} ');
                doc_no = item['doc_no'];
                doc_out = item['doc_type'];
                await chk_validate();
                await chk_validate_inhead();
                print('poStatusinhead: $poStatusinhead');
                // print('$poStatus $poMessage $goToStep');

                if (poStatus == '1') {
                  print(poMessage);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Row(
                          children: [
                            Icon(
                              Icons.notification_important, // Use the bell icon
                              color: Colors.red, // Set the color to red
                            ),
                            SizedBox(
                                width:
                                    8), // Add some space between the icon and the text
                            Text('แจ้งเตือน'), // Title text
                          ],
                        ),
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
                } else if (poStatus == '0') {
                  if (goToStep == '2') {
                    print('ไปหน้า Form');
                    if (poStatusinhead == '0') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SSFGDT17_FORM(
                            po_doc_no: doc_no ?? '',
                            po_doc_type: doc_out,
                            LocCode: '',
                            selectedwhCode: '',
                            selectedLocCode: '',
                            whOUTCode: '',
                            LocOUTCode: '',
                            pWareCode: '',
                          ),
                        ),
                      );
                    }
                  } else if (goToStep == '3') {
                    print('ไปหน้า barcode');
                    if (poStatusinhead == '0') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SSFGDT17_BARCODE(
                            po_doc_no: doc_no ?? '',
                            po_doc_type: doc_out,
                            LocCode: '',
                            selectedwhCode: '',
                            selectedLocCode: '',
                            whOUTCode: '',
                            LocOUTCode: '',
                          ),
                        ),
                      );
                    }
                  } else if (goToStep == '4') {
                    print('ไปหน้ายืนยัน');
                    if (poStatusinhead == '0') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SSFGD17_VERIFY(
                            po_doc_no: doc_no ?? '',
                            po_doc_type: doc_out,
                            selectedwhCode: '',
                          ),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

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
        if (mounted) {
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
        }
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
        if (mounted) {
          setState(() {
            poStatusinhead = jsonData['po_status'];

            print('poStatusinhead: $poStatusinhead');
          });
        }
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
      appBar: CustomAppBar(title: 'Move Locator', showExitWarning: false),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (isPortrait) const SizedBox(height: 4),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage.isNotEmpty
                          ? Center(
                              child: Text(
                                'Error: $errorMessage',
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          : data.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No Data Available',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : ListView(
                                  children: [
                                    ...data
                                        .map((item) =>
                                            buildListTile(context, item))
                                        .toList(),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: prevLink != null
                                              ? _loadPrevPage
                                              : null,
                                          child: const Text('Previous'),
                                        ),
                                        ElevatedButton(
                                          onPressed: nextLink != null
                                              ? _loadNextPage
                                              : null,
                                          child: const Text('Next'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}

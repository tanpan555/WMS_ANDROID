import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_VERIFY.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_BARCODE.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_FORM.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/styles.dart';
import '../loading.dart';
import '../centered_message.dart';

class SSFGDT17_MAIN extends StatefulWidget {
  final String pWareCode;
  final String? selectedValue;
  final String documentNumber;
  final String dateController;
  final String docType;

  const SSFGDT17_MAIN({
    Key? key,
    required this.pWareCode,
    this.selectedValue,
    required this.documentNumber,
    required this.dateController,
    required this.docType,
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
  final ScrollController _scrollController = ScrollController();
  final ScrollController _singleChildScrollController = ScrollController();
  final ScrollController _listViewScrollController = ScrollController();
  String? DateSend;

  int itemsPerPage = 15; // Number of records per page
  int currentPage = 0; // Current page number

  bool isNavigating = false;

  @override
  void initState() {
    super.initState();

    currentSessionID = SessionManager().sessionID;
    selectedwhCode = widget.pWareCode;
    print(selectedwhCode);
    _dateController.text = widget.dateController;
    _selectedStatusValue = widget.selectedValue;
    print('fixedValue: $fixedValue');
    docNumberFilter = widget.documentNumber;
    print('=====================');
    print(widget.docType);
    print('documentNumber $widget.documentNumber');
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
    _scrollController.dispose();
    _singleChildScrollController.dispose();
    _listViewScrollController.dispose();
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

  int totalPages() {
    return (data.length / itemsPerPage).ceil(); // คำนวณจำนวนหน้าทั้งหมด
  }

  void _loadPrevPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        // No need to call fetchData here, just update the UI
      });
      _scrollToTop();
    }
  }

  void _loadNextPage() {
    if ((currentPage + 1) * itemsPerPage < data.length) {
      setState(() {
        currentPage++;
        // No need to call fetchData here, just update the UI
      });
      _scrollToTop();
    }
  }

  List<dynamic> getCurrentData() {
    final start = currentPage * itemsPerPage;
    final end = start + itemsPerPage;

    return data.sublist(start, end.clamp(0, data.length));
  }

  void _scrollToTop() {
    if (_singleChildScrollController.hasClients) {
      _singleChildScrollController.jumpTo(0); // Scroll to the top
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
    if (!mounted) return;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    print('URL : $url ');
    final String statusValue = valueMapping[_selectedStatusValue] ?? '0';
    final String requestUrl = url ??
        '${gb.IP_API}/apex/wms/SSFGDT17/Step_1_Card_List/$selectedwhCode/$statusValue/${gb.P_ERP_OU_CODE}/${widget.docType}/$DateSend/${widget.documentNumber}/${gb.BROWSER_LANGUAGE}';
    print('URL : $requestUrl ');
    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);

        if (mounted) {
          setState(() {
            if (parsedResponse is Map && parsedResponse.containsKey('items')) {
              data = parsedResponse['items'];
            } else {
              data = [];
            }
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            print('Failed to load data: ${response.statusCode}');
          });
        }
        print('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      if (mounted) {
        isLoading = false;
        setState(() {
          print('Error occurred: $e');
        });
      }
      print('Exception: $e');
    }
  }

  String? doc_no;
  String? doc_out;
  String? poStatus;
  String? poMessage;
  String? goToStep;

  Future<void> chk_validate() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT17/Step_1_check_TFLOCDirect_validate/$doc_no/$doc_out/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}'));
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
          '${gb.IP_API}/apex/wms/SSFGDT17/Step_1_get_INHeadXfer_WMS/$doc_no/$doc_out/${widget.pWareCode}/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}/${gb.APP_USER}'));
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
      appBar: CustomAppBar(title: 'Move Locator', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: isLoading
                    ? Center(child: LoadingIndicator())
                    : data.isEmpty
                        ? const Center(child: CenteredMessage())
                        : SingleChildScrollView(
                            controller: _singleChildScrollController,
                            child: ListView.builder(
                              controller: _listViewScrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: getCurrentData().length + 1,
                              itemBuilder: (context, index) {
                                if (index < getCurrentData().length) {
                                  var item = getCurrentData()[index];
                                  return Card(
                                    elevation: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.lightBlue[100],
                                    child: InkWell(
                                      onTap: () async {
                                        if (isNavigating) return;

                                        setState(() {
                                          isNavigating = true;
                                        });

                                        try {
                                          print(
                                              '${item['doc_no'] ?? 'No doc_no'} ');
                                          print(
                                              '${item['doc_type'] ?? 'No doc_type'} ');
                                          doc_no = item['doc_no'];
                                          doc_out = item['doc_type'];
                                          await chk_validate();
                                          await chk_validate_inhead();
                                          print(
                                              'poStatusinhead: $poStatusinhead');

                                          if (poStatus == '1') {
                                            print(poMessage);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DialogStyles
                                                    .alertMessageDialog(
                                                  context: context,
                                                  content: Text(
                                                      '${poMessage ?? 'No message available'}'),
                                                  onClose: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  onConfirm: () async {
                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                              },
                                            );
                                          } else if (poStatus == '0') {
                                            if (goToStep == '2') {
                                              print('ไปหน้า Form');
                                              if (poStatusinhead == '0') {
                                                await Navigator.of(context)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SSFGDT17_FORM(
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
                                                await Navigator.of(context)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SSFGDT17_BARCODE(
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
                                                await Navigator.of(context)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SSFGDT17_VERIFY(
                                                      po_doc_no: doc_no ?? '',
                                                      po_doc_type: doc_out,
                                                      selectedwhCode: '',
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        } finally {
                                          setState(() {
                                            isNavigating = false;
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['doc_number'] ??
                                                      'No doc_number',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ),
                                                const Divider(
                                                    color: Colors.black26,
                                                    thickness: 1),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 6.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: (() {
                                                          switch (item[
                                                              'status_desc']) {
                                                            case 'ปกติ':
                                                              return const Color
                                                                  .fromRGBO(246,
                                                                  250, 112, 1);
                                                            case 'รับโอนแล้ว':
                                                              return const Color
                                                                  .fromRGBO(146,
                                                                  208, 80, 1);
                                                            case 'ยกเลิก':
                                                              return const Color
                                                                  .fromRGBO(208,
                                                                  206, 206, 1);
                                                            case 'ทั้งหมด':
                                                            default:
                                                              return const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  255);
                                                          }
                                                        })(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Text(
                                                        item['status_desc'],
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Center(
                                                      child:
                                                          item['status_desc'] !=
                                                                  null
                                                              ? Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        72,
                                                                        145,
                                                                        144,
                                                                        144),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                )
                                                              : const SizedBox
                                                                  .shrink(),
                                                    ),
                                                  ],
                                                ),
                                                // const Spacer(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 6.0,
                                                      ),
                                                      child: Text(
                                                        '${item['doc_date'] ?? 'No doc_date'} ${item['from_warehouse'] ?? 'No WAREHOUSE'} ${item['staff_name'] ?? ''}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return getCurrentData().length > 3
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                currentPage > 0
                                                    ? ElevatedButton(
                                                        onPressed:
                                                            currentPage > 0
                                                                ? () {
                                                                    _loadPrevPage();
                                                                  }
                                                                : null,
                                                        style: ButtonStyles
                                                            .previousButtonStyle,
                                                        child: ButtonStyles
                                                            .previousButtonContent,
                                                      )
                                                    : ElevatedButton(
                                                        onPressed: null,
                                                        style: DisableButtonStyles
                                                            .disablePreviousButtonStyle,
                                                        child: DisableButtonStyles
                                                            .disablePreviousButtonContent,
                                                      )
                                              ],
                                            ),
                                            // const SizedBox(width: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    '${(currentPage * itemsPerPage) + 1} - ${data.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, data.length) : 0}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            // const SizedBox(width: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                currentPage < totalPages() - 1
                                                    ? ElevatedButton(
                                                        onPressed: currentPage <
                                                                totalPages() - 1
                                                            ? () {
                                                                _loadNextPage();
                                                              }
                                                            : null,
                                                        style: ButtonStyles
                                                            .nextButtonStyle,
                                                        child: ButtonStyles
                                                            .nextButtonContent(),
                                                      )
                                                    : ElevatedButton(
                                                        onPressed: null,
                                                        style: DisableButtonStyles
                                                            .disableNextButtonStyle,
                                                        child: DisableButtonStyles
                                                            .disablePreviousButtonContent,
                                                      ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink();
                                }
                              },
                            ))),
            !isLoading && getCurrentData().length > 0
                ? getCurrentData().length <= 3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              currentPage > 0
                                  ? ElevatedButton(
                                      onPressed: currentPage > 0
                                          ? () {
                                              _loadPrevPage();
                                            }
                                          : null,
                                      style: ButtonStyles.previousButtonStyle,
                                      child: ButtonStyles.previousButtonContent,
                                    )
                                  : ElevatedButton(
                                      onPressed: null,
                                      style: DisableButtonStyles
                                          .disablePreviousButtonStyle,
                                      child: DisableButtonStyles
                                          .disablePreviousButtonContent,
                                    )
                            ],
                          ),
                          // const SizedBox(width: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  '${(currentPage * itemsPerPage) + 1} - ${data.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, data.length) : 0}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                          // const SizedBox(width: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              currentPage < totalPages() - 1
                                  ? ElevatedButton(
                                      onPressed: currentPage < totalPages() - 1
                                          ? () {
                                              _loadNextPage();
                                            }
                                          : null,
                                      style: ButtonStyles.nextButtonStyle,
                                      child: ButtonStyles.nextButtonContent(),
                                    )
                                  : ElevatedButton(
                                      onPressed: null,
                                      style: DisableButtonStyles
                                          .disableNextButtonStyle,
                                      child: DisableButtonStyles
                                          .disablePreviousButtonContent,
                                    ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink()
                : const SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/centered_message.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT12_form.dart';

class Ssfgdt12Card extends StatefulWidget {
  final String docNo;
  final String date;
  final String status;
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final int p_flag;
  final String browser_language;
  final String pErpOuCode;
  final String p_attr1;
  Ssfgdt12Card({
    Key? key,
    required this.docNo,
    required this.date,
    required this.status,
    required this.pWareCode,
    required this.p_flag,
    required this.browser_language,
    required this.pErpOuCode,
    required this.p_attr1,
  }) : super(key: key);
  @override
  _Ssfgdt12CardState createState() => _Ssfgdt12CardState();
}

class _Ssfgdt12CardState extends State<Ssfgdt12Card> {
  //
  List<dynamic> dataCard = [];
  List<dynamic> displayedData = [];
  String data_null = 'null';

  bool isLoading = true;
  bool isCardDisabled = false;
  int currentPage = 0;
  final int itemsPerPage = 15;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    print('docNo : ${widget.docNo} Type : ${widget.docNo.runtimeType}');
    print('date : ${widget.date} Type : ${widget.date.runtimeType}');
    print('status : ${widget.status} Type : ${widget.status.runtimeType}');
    print(
        'pWareCode : ${widget.pWareCode} Type : ${widget.pWareCode.runtimeType}');
    print('p_flag : ${widget.p_flag} Type : ${widget.p_flag.runtimeType}');
    print(
        'browser_language : ${widget.browser_language} Type : ${widget.browser_language.runtimeType}');
    super.initState();
    _scrollController = ScrollController();
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData([String? url]) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final String requestUrl = url ??
        '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_1_SelectDataCard/${globals.P_ERP_OU_CODE}/${widget.docNo.isNotEmpty ? widget.docNo : 'null'}/${widget.status}/${globals.BROWSER_LANGUAGE}';

    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);

        if (mounted) {
          setState(() {
            if (parsedResponse is Map && parsedResponse.containsKey('items')) {
              dataCard = parsedResponse['items'];
            } else {
              dataCard = [];
            }
            filterData();
            print('dataCard : $dataCard Type : ${dataCard.runtimeType}');
          });
        }
      } else {
        setState(() {
          print('Failed to load data: ${response.statusCode}');
        });
        print('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions that may occur
      if (mounted) {
        setState(() {
          // isLoading = false;
          print('Error occurred: $e');
        });
      }
      print('Exception: $e');
    }
  }

  void filterData() {
    if (mounted) {
      setState(() {
        displayedData = dataCard.where((item) {
          final doc_date = item['doc_date'] ?? '';
          if (widget.date.isEmpty) {
            final matchesSearchQuery = doc_date == doc_date;
            return matchesSearchQuery;
          } else {
            final matchesSearchQuery = doc_date == widget.date;
            return matchesSearchQuery;
          }
        }).toList();
        isLoading = false;
        print(
            'displayedData : $displayedData Type : ${displayedData.runtimeType}');
      });
    }
  }

  int totalPages() {
    return (displayedData.length / itemsPerPage)
        .ceil(); // คำนวณจำนวนหน้าทั้งหมด
  }

  void loadNextPage() {
    if (currentPage < totalPages() - 1) {
      setState(() {
        currentPage++;
        _scrollController.jumpTo(0);
      });
    }
  }

  void loadPrevPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        _scrollController.jumpTo(0);
      });
    }
  }

  List<dynamic> getCurrentData() {
    final start = currentPage * itemsPerPage;
    final end = start + itemsPerPage;

    return displayedData.sublist(start, end.clamp(0, displayedData.length));
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0); // เลื่อนไปยังตำแหน่งเริ่มต้น (index 0)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ผลการตรวจนับ', showExitWarning: false),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(child: LoadingIndicator())
                  : displayedData.isEmpty
                      ? const Center(child: CenteredMessage())
                      : SingleChildScrollView(
                          controller: _scrollController,
                          child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: getCurrentData().length + 1,
                            itemBuilder: (context, index) {
                              if (index < getCurrentData().length) {
                                var item = getCurrentData()[index];

                                Color cardColor;
                                String statusText;
                                // String iconImageYorN;
                                switch (item['status']) {
                                  ////      WMS คลังวัตถุดิบ
                                  case 'N':
                                    // iconData = Icons.arrow_circle_right_outlined;
                                    cardColor =
                                        Color.fromRGBO(246, 250, 112, 1.0);
                                    statusText = 'รอตรวจนับ';
                                    break;
                                  case 'T':
                                    // iconData = Icons.arrow_circle_right_outlined;
                                    cardColor =
                                        Color.fromRGBO(208, 206, 206, 1.0);
                                    statusText = 'กำลังตรวจนับ';
                                    break;
                                  case 'X':
                                    // iconData = Icons.arrow_circle_right_outlined;
                                    cardColor =
                                        Color.fromRGBO(146, 208, 80, 1.0);
                                    statusText = 'ยืนยันตรวจนับแล้ว';
                                    break;
                                  case 'A':
                                    // iconData = Icons.arrow_circle_right_outlined;
                                    cardColor =
                                        Color.fromRGBO(208, 206, 206, 1.0);
                                    statusText = 'กำลังปรับปรุงจำนวน/มูลค่า';
                                    break;
                                  case 'B':
                                    // iconData = Icons.arrow_circle_right_outlined;
                                    cardColor =
                                        Color.fromRGBO(146, 208, 80, 1.0);
                                    statusText =
                                        'ยืนยันปรับปรุงจำนวน/มูลค่าแล้ว';
                                    break;
                                  default:
                                    // iconData = Icons.help; // Default icon
                                    cardColor = Colors.grey;
                                    statusText = 'Unknown';
                                }
                                // switch (item['status']) {
                                //   ////      WMS คลังวัตถุดิบ
                                //   case 'N':
                                //     iconImageYorN =
                                //         'assets/images/rt_machine_off.png';
                                //     break;
                                //   case 'X':
                                //     iconImageYorN =
                                //         'assets/images/rt_machine_on.png';
                                //     break;
                                //   default:
                                //     iconImageYorN =
                                //         'assets/images/rt_machine_off.png';
                                // }

                                return CardStyles.cardPage(
                                  showON: item['status'] == 'X' ? true : false,
                                  headerText: item['doc_no'] ?? '',
                                  isShowPrint: false,
                                  colorStatus: cardColor,
                                  statusCard: statusText,
                                  onCard: isCardDisabled
                                      ? null
                                      : () async {
                                          setState(() {
                                            isCardDisabled = true;
                                          });
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Ssfgdt12Form(
                                                docNo: item['doc_no'],
                                                pErpOuCode: widget.pErpOuCode,
                                                browser_language:
                                                    widget.browser_language,
                                                wareCode: item['ware_code'] ??
                                                    'ware_code',
                                                pWareCode: widget.pWareCode,
                                                p_attr1: widget.p_attr1,
                                              ),
                                            ),
                                          ).then((value) async {
                                            setState(() {
                                              isCardDisabled = false;
                                            });
                                          });
                                        },
                                  onPrint: () {
                                    print('Print tapped!');
                                  },
                                  titleText:
                                      '${item['doc_date'] ?? ''} ${item['doc_no'] ?? ''} ${item['ware_code'] ?? ''}',
                                );
                              } else {
                                // displayedData.length <= 3
                                // ?
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
                                                      onPressed: currentPage > 0
                                                          ? () {
                                                              loadPrevPage();
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
                                                  '${(currentPage * itemsPerPage) + 1} - ${displayedData.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, displayedData.length) : 0}',
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              currentPage < totalPages() - 1
                                                  ? ElevatedButton(
                                                      onPressed: currentPage <
                                                              totalPages() - 1
                                                          ? () {
                                                              loadNextPage();
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
                          ),
                        ),
            ),
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
                                              loadPrevPage();
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
                                  '${(currentPage * itemsPerPage) + 1} - ${displayedData.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, displayedData.length) : 0}',
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
                                              loadNextPage();
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
      bottomNavigationBar: const BottomBar(
        currentPage: 'show',
      ),
    );
  }
}

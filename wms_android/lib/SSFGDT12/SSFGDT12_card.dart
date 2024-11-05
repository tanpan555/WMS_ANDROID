import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
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
  String? nextLink = '';
  String? prevLink = '';

  int showRecordRRR = 0;

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
    fetchData();
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
        'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_1_SelectDataCard/${widget.pErpOuCode}/${widget.docNo.isNotEmpty ? widget.docNo : 'null'}/${widget.status}/${widget.browser_language}';

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

            List<dynamic> links = parsedResponse['links'] ?? [];
            nextLink = getLink(links, 'next');
            prevLink = getLink(links, 'prev');
            if (url.toString().isNotEmpty) {
              extractLastNumberFromUrl(url.toString() ==
                      'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_1_SelectDataCard/${widget.pErpOuCode}/${widget.docNo.isNotEmpty ? widget.docNo : 'null'}/${widget.status}/${widget.browser_language}'
                  ? 'null'
                  : url.toString());
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

  String? getLink(List<dynamic> links, String rel) {
    final link =
        links.firstWhere((item) => item['rel'] == rel, orElse: () => null);
    return link != null ? link['href'] : null;
  }

  void loadNextPage() {
    if (nextLink != '') {
      if (mounted) {
        setState(() {
          showRecordRRR = 0;
          print('nextLink $nextLink');
          isLoading = true;
        });
      }
      fetchData(nextLink);
    }
  }

  void loadPrevPage() {
    if (prevLink != '') {
      if (mounted) {
        setState(() {
          showRecordRRR = 0;
          isLoading = true;
        });
      }
      fetchData(prevLink);
    }
  }

  void extractLastNumberFromUrl(String url) {
    // Regular Expression สำหรับจับค่าหลัง offset=
    RegExp regExp = RegExp(r'offset=(\d+)$');
    RegExpMatch? match = regExp.firstMatch(url);

    // ตัวแปรสำหรับเก็บผลลัพธ์
    int showRecord = 0; // ตั้งค่าเริ่มต้นเป็น 0

    if (match != null) {
      // แปลงค่าที่จับคู่ได้จาก String ไปเป็น int
      showRecordRRR =
          int.parse(match.group(1)!); // group(1) หมายถึงค่าหลัง offset=
      print('ตัวเลขท้ายสุดคือ: $showRecord');
      print('$showRecordRRR');
      print('$showRecordRRR + 1 = ${showRecordRRR + 1}');
      print('${dataCard.length}');
      print(
          '${dataCard.length} + $showRecordRRR = ${dataCard.length + showRecordRRR}');
    } else {
      // ถ้าไม่พบค่า ให้ผลลัพธ์เป็น 0
      print('ไม่พบตัวเลขท้ายสุด, ส่งกลับเป็น 0');
    }
    // match = null;

    // พิมพ์ค่าที่ได้
    print('ผลลัพธ์: $showRecord');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ผลการตรวจนับ', showExitWarning: false),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: isLoading
            ? Center(child: LoadingIndicator())
            : displayedData.isEmpty
                ? const Center(
                    child: Text(
                      'No Data Available',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(), // เพื่อให้ทำงานร่วมกับ ListView ด้านนอกได้
                              itemCount: displayedData.length,
                              itemBuilder: (context, index) {
                                // ดึงข้อมูลรายการจาก dataCard
                                var item = displayedData[index];

                                Color cardColor;
                                String statusText;
                                String iconImageYorN;
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
                                switch (item['status']) {
                                  ////      WMS คลังวัตถุดิบ
                                  case 'N':
                                    iconImageYorN =
                                        'assets/images/rt_machine_off.png';
                                    break;
                                  case 'X':
                                    iconImageYorN =
                                        'assets/images/rt_machine_on.png';
                                    break;
                                  default:
                                    iconImageYorN =
                                        'assets/images/rt_machine_off.png';
                                }

                                return Card(
                                  elevation: 8.0,
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15.0), // กำหนดมุมโค้งของ Card
                                  ),
                                  color: Color.fromRGBO(204, 235, 252, 1.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Ssfgdt12Form(
                                            docNo: item['doc_no'],
                                            pErpOuCode: widget.pErpOuCode,
                                            browser_language:
                                                widget.browser_language,
                                            wareCode: item['ware_code'] ??
                                                'ware_code',
                                            pWareCode: widget.pWareCode,
                                            p_attr1: widget.p_attr1,
                                            // status: item['status'] ?? '',
                                            // wareCode: item['ware_code'] == null
                                            // ? 'ware_code  !!!'
                                            // : item['ware_code'],
                                          ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(
                                        15.0), // กำหนดมุมโค้งให้ InkWell เช่นกัน
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              16.0), // เพิ่ม padding เพื่อให้ content ไม่ชิดขอบ
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['doc_no'] ?? '',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                              SizedBox(
                                                  height:
                                                      10.0), // เพิ่มระยะห่างระหว่างข้อความ
                                              item['ware_code'] == null
                                                  ? Text(
                                                      '${item['doc_date'] ?? ''} ${item['doc_no'] ?? ''}',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                              Colors.black54),
                                                    )
                                                  : Text(
                                                      '${item['doc_date'] ?? ''} ${item['doc_no'] ?? ''} ${item['ware_code'] ?? ''}',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.0,
                                          right: 8.0,
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 6.0),
                                                decoration: BoxDecoration(
                                                  color: cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color: cardColor,
                                                      width: 2.0),
                                                ),
                                                child: Text(
                                                  statusText,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              // SizedBox(height: 5.0),
                                              SizedBox(
                                                width: 100,
                                                height: 40,
                                                child: Image.asset(
                                                  iconImageYorN,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            // ======================================================= dataCard.length > 3
                            dataCard.length > 3
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          prevLink != null
                                              ? ElevatedButton(
                                                  onPressed: prevLink != null
                                                      ? loadPrevPage
                                                      : null,
                                                  style: ButtonStyles
                                                      .previousButtonStyle,
                                                  child: ButtonStyles
                                                      .previousButtonContent,
                                                )
                                              : ElevatedButton(
                                                  onPressed: prevLink != null
                                                      ? loadPrevPage
                                                      : null,
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
                                              '${showRecordRRR == 0 ? '1' : showRecordRRR + 1} - ${showRecordRRR == 0 ? dataCard.length : showRecordRRR + dataCard.length}',
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
                                          nextLink != null
                                              ? ElevatedButton(
                                                  onPressed: nextLink != null
                                                      ? loadNextPage
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
                                : const SizedBox.shrink(),
                            // ======================================================= dataCard.length > 3
                          ],
                        ),
                      ),
                      // ======================================================= dataCard.length <= 3
                      dataCard.length <= 3
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    prevLink != null
                                        ? ElevatedButton(
                                            onPressed: prevLink != null
                                                ? loadPrevPage
                                                : null,
                                            style: ButtonStyles
                                                .previousButtonStyle,
                                            child: ButtonStyles
                                                .previousButtonContent,
                                          )
                                        : ElevatedButton(
                                            onPressed: prevLink != null
                                                ? loadPrevPage
                                                : null,
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
                                        '${showRecordRRR == 0 ? '1' : showRecordRRR + 1} - ${showRecordRRR == 0 ? dataCard.length : showRecordRRR + dataCard.length}',
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
                                    nextLink != null
                                        ? ElevatedButton(
                                            onPressed: nextLink != null
                                                ? loadNextPage
                                                : null,
                                            style: ButtonStyles.nextButtonStyle,
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
                          : const SizedBox.shrink(),
                      // ======================================================= dataCard.length <= 3
                    ],
                  ),
      ),
      bottomNavigationBar: const BottomBar(
        currentPage: 'show',
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGDT04_FORM.dart';

class SSFGDT04_CARD extends StatefulWidget {
  final String soNo;
  final String date;
  final String status;
  final String pWareCode;
  // final String pOuCode;
  final String pErpOuCode;

  SSFGDT04_CARD({
    Key? key,
    required this.soNo,
    required this.date,
    required this.status,
    required this.pWareCode,
    // required this.pOuCode,
    required this.pErpOuCode,
  }) : super(key: key);

  @override
  _SSFGDT04_CARDState createState() => _SSFGDT04_CARDState();
}

class _SSFGDT04_CARDState extends State<SSFGDT04_CARD> {
  List<dynamic> dataCard = [];
  List<dynamic> displayedData = [];
  String data_null = 'null';
  String statusCard = '';
  String messageCard = '';
  String goToStep = '';
  String sessionID = gb.APP_SESSION;
  String pDocNoGetInHead = '';
  String pDocTypeGetInHead = '';

  @override
  void initState() {
    print('status : ${widget.status} Type : ${widget.status.runtimeType}');
    print('date : ${widget.date} Type : ${widget.date.runtimeType}');
    print('sono : ${widget.soNo} Type : ${widget.soNo.runtimeType}');
    print(
        'pWareCode : ${widget.pWareCode} Type : ${widget.pWareCode.runtimeType}');
    print(
        'pErpOuCode : ${widget.pErpOuCode} Type : ${widget.pErpOuCode.runtimeType}');

    super.initState();
    fetchData();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
    final String endpoint = widget.soNo.isNotEmpty
        ? 'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_1_card1/${gb.P_ERP_OU_CODE}/${widget.soNo}/${widget.status}/${gb.ATTR1}/${widget.pWareCode}/${gb.APP_USER}/${widget.date}'
        : 'http://172.16.0.82:8888/apex/wms/SSFGDT12/selectCard/${gb.P_ERP_OU_CODE}/$data_null/${widget.status}/${gb.ATTR1}/${widget.pWareCode}/${gb.APP_USER}/${widget.date}';

    // print('Fetching data from: $endpoint');

    try {
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        setState(() {
          dataCard =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          filterData();
        });
        print('dataCard: $dataCard');
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data: $e');
    }
  }

  Future<void> checkStatusCard(
      String pReceiveNo, String po_doc_no, String po_doc_type) async {
    print('po_status $pReceiveNo Type: ${pReceiveNo.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_1_check_RCVdirect_validate/${widget.pWareCode}/${widget.pErpOuCode}/$pReceiveNo'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataStatusCard =
            jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'dataStatusCard : $dataStatusCard type : ${dataStatusCard.runtimeType}');

        checkGoTostep(
          dataStatusCard['po_status'] ?? '',
          dataStatusCard['po_message'] ?? '',
          dataStatusCard['po_goto_step'] ?? '',
          po_doc_no,
          po_doc_type,
        );
      } else {
        print(
            'checkStatusCard Failed to load data. Status code: ${response.statusCode}');
        // Log more detailed information
        // print('Response body: ${response.body}');
      }
    } catch (e) {
      setState(() {});
      print('checkStatusCard ERROR IN Fetch Data : $e');
    }
  }

  void checkGoTostep(String statusCard, String messageCard, String goToStep,
      String po_doc_no, String po_doc_type) {
    //
    print('statusCard : $statusCard Type : ${statusCard.runtimeType}');
    print('messageCard : $messageCard Type : ${messageCard.runtimeType}');
    print('goToStep : $goToStep Type : ${goToStep.runtimeType}');
    if (statusCard == '1') {
      showMessageStatusCard(context, messageCard);
    }
    if (statusCard == '0') {
      getInhead(
        goToStep,
        po_doc_no,
        po_doc_type,
      );
    }
  }

  // String? poStatus;
  // String? poMessage;
  // String? po_doc_no;
  // String? po_doc_type;

  Future<void> getInhead(
      String po_doc_no, String po_doc_type, String goToStep) async {
    print('po_doc_no $po_doc_no Type: ${po_doc_no.runtimeType}');
    print('po_doc_type $po_doc_type Type: ${po_doc_type.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_1_get_INHead_WMS/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}/$po_doc_type/$po_doc_no/${gb.APP_USER}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataGetInHead =
            jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'dataGetInHead : $dataGetInHead type : ${dataGetInHead.runtimeType}');

        //
        print('Fetched data: $jsonDecode');

        setState(() {
          pDocNoGetInHead = dataGetInHead['po_doc_no'] ?? '';
          pDocTypeGetInHead = dataGetInHead['po_doc_type'] ?? '';
          getInheadStpe(
            dataGetInHead['po_doc_no'] ?? '',
            dataGetInHead['po_doc_type'] ?? '',
            dataGetInHead['po_status'],
            dataGetInHead['po_message'],
            goToStep,
          );

          print(
              'po_doc_type : ${dataGetInHead['po_doc_type']} Type: ${dataGetInHead['po_doc_type'.runtimeType]}');
          print(
              'po_doc_no : ${dataGetInHead['po_doc_no']} Type: ${dataGetInHead['po_doc_no'.runtimeType]}');
          print(
              'po_status : ${dataGetInHead['po_status']} Type: ${dataGetInHead['po_status'.runtimeType]}');
          print(
              'po_message : ${dataGetInHead['po_message']} Type: ${dataGetInHead['po_message'.runtimeType]}');
        });
        // } else {
        //   print('No items found.');
        // }
      } else {
        print(
            'getInhead Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {});
      print('getInhead ERROR IN Fetch Data : $e');
    }
  }

  void filterData() {
    setState(() {
      displayedData = dataCard.where((item) {
        final date = item['po_date'] ?? '';
        if (widget.date.isEmpty) {
          final matchesSearchQuery = date == date;
          return matchesSearchQuery;
        } else {
          final matchesSearchQuery = date == widget.date;
          return matchesSearchQuery;
        }
      }).toList();
      print(
          'displayedData : $displayedData Type : ${displayedData.runtimeType}');
    });
  }

  void getInheadStpe(String pDocNoGetInHead, String pDocTypeGetInHead,
      String poStatus, String poMessage, String goToStep) {
    if (poStatus == '1') {
      showMessageStatusCard(context, poMessage);
    }
    if (poStatus == '0') {
      switch (goToStep) {
        case '2':
          return _navigateToPage(
              context,
              SSFGDT04_FORM(
                pWareCode: widget.pErpOuCode,
                // pAttr1: widget.pAttr1,
                po_doc_no: pDocNoGetInHead,
                po_doc_type: pDocTypeGetInHead,
              ));
        // case '3':
        //   return _navigateToPage(
        //       context,
        //       Ssfgdt09lGrid(
        //         pWareCode: widget.pErpOuCode,
        //         // pAttr1: widget.pAttr1,
        //         statusCase: '3',
        //       ));
        // case '4':
        //   return _navigateToPage(
        //       context,
        //       Ssfgdt09lGrid(
        //         pWareCode: widget.pErpOuCode,
        //         // pAttr1: widget.pAttr1,
        //         statusCase: '4',
        //       ));
        default:
          return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      // backgroundColor: Color.fromARGB(255, 165, 216, 103),
      appBar: CustomAppBar(title: 'รับตรง (ไม่อ้าง PO'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        // child: Column(
        //   children: [
        //     Expanded(
        child: ListView.builder(
          itemCount: dataCard.length,
          itemBuilder: (context, index) {
            final item = dataCard[index];

            // Color cardColor;
            // String imagePath;
            // String statusText;
            // switch (item['card_qc']) {
            //   //on
            //   case 'Y':
            //   imagePath = 'assets/images/rt_machine_on.png';
            //     cardColor = Color.fromRGBO(112, 250, 225, 1);
            //     // statusText = 'พิมพ์';
            //     break;
            //     //off
            //     case 'N':
            //     imagePath = 'assets/images/rt_machine_off.png';
            //     cardColor = Color.fromRGBO(112, 250, 225, 1);
            //     // statusText = 'พิมพ์';
            //     break;
            //   default:
            //     cardColor = Color.fromARGB(255, 110, 217, 220);
            //     statusText = '';
            // }
            // switch (item['card_status_desc']) {
            //   case 'ระหว่างบันทึก':
            //     cardColor = Color.fromARGB(255, 110, 217, 220);
            //     statusText = 'ระหว่างบันทึก';
            //     break;
            //   case 'ยืนยันการรับ':
            //     cardColor = Color.fromARGB(255, 110, 217, 220);
            //     statusText = 'ยืนยันการรับ';
            //     break;
            //   case 'ยกเลิก':
            //     cardColor = Color.fromARGB(255, 110, 217, 220);
            //     statusText = 'ยกเลิก';
            //     break;
            //   default:
            //     cardColor = Color.fromARGB(255, 110, 217, 220);
            //     statusText = '${item['card_status_desc']}';
            // }

            return Card(
              elevation: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.lightBlue[100],
              child: InkWell(
                onTap: () {
                  checkStatusCard(item['po_no'] ?? '', item['p_doc_no'] ?? '',
                      item['p_doc_type'] ?? '');

                  print(
                      'po_no in Card : ${item['po_no']} Type : ${item['po_no'].runtimeType}');
                  print(
                      'p_doc_no in Card : ${item['p_doc_no']} Type : ${item['p_doc_no'].runtimeType}');
                  print(
                      'p_doc_type in Card : ${item['p_doc_type']} Type : ${item['p_doc_type'].runtimeType}');
                },
                borderRadius: BorderRadius.circular(15.0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              item['ap_name'] ?? 'No Name',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                          const Divider(
                      color: Colors.black26, // สีเส้น Divider เบาลง
                      thickness: 1,
                    ),
                          // SizedBox(height: 8),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centers the items in the row
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                    color: (() {
                                      switch (item['card_status_desc']) {
                                        case 'ระหว่างบันทึก':
                                          return Color.fromRGBO(
                                              246, 250, 112, 1);
                                        case 'ยืนยันการรับ':
                                          return Color.fromRGBO(
                                              146, 208, 80, 1);
                                        case 'ยกเลิก':
                                          return Color.fromRGBO(
                                              208, 206, 206, 1);
                                        case 'ทั้งหมด':
                                        default:
                                          return Color.fromARGB(
                                              255, 255, 255, 255);
                                      }
                                    })(),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    item['card_status_desc'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Center(
                                  child: (() {
                                    if (item['card_qc'] ==
                                        '#APP_IMAGES#rt_machine_on.png') {
                                      return Image.asset(
                                        'assets/images/rt_machine_on.png',
                                        width: 50,
                                        height: 50,
                                      );
                                    } else if (item['card_qc'] ==
                                        '#APP_IMAGES#rt_machine_off.png') {
                                      return Image.asset(
                                        'assets/images/rt_machine_off.png',
                                        width: 50,
                                        height: 50,
                                      );
                                    } else if (item['card_qc'] == '') {
                                      return SizedBox
                                          .shrink(); // No widget displayed
                                    } else {
                                      return Text(
                                          ''); // Empty text widget for other cases
                                    }
                                  })(),
                                ),

                                const SizedBox(
                                    width:
                                        8), // Adds space between the Container and the TextButton
                                Center(
                                  child: item['status'] != null
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                72, 145, 144, 144),
                                            borderRadius: BorderRadius.circular(
                                                5), // Optional: Add rounded corners
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              // Handle button press
                                              // Add your navigation or functionality here
                                            },
                                            child: item['status'] == 'พิมพ์'
                                                ? Image.asset(
                                                    'assets/images/printer.png', // Replace with your image path
                                                    width:
                                                        30, // Adjust the size as needed
                                                    height: 30,
                                                  )
                                                : Text(
                                                    item['status']!,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          137, 0, 0, 0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Text(
                              '${item['po_date']} ${item['po_no']} ${item['item_stype_desc'] ?? ''}', //\n ${item['status']?? ''}
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    //   top: 8.0,
                    //   right: 8.0,
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 12.0, vertical: 6.0),
                    //     decoration: BoxDecoration(
                    //       color: (() {
                    //         switch (item['card_status_desc']) {
                    //           case 'ระหว่างบันทึก':
                    //             return Color.fromRGBO(246, 250, 112, 1);
                    //           case 'ยืนยันการรับ':
                    //             return Color.fromRGBO(146, 208, 80, 1);
                    //           case 'ยกเลิก':
                    //             return Color.fromRGBO(208, 206, 206, 1);
                    //           case 'ทั้งหมด':
                    //           default:
                    //             return Color.fromARGB(255, 255, 255, 255);
                    //         }
                    //       })(),
                    //       borderRadius: BorderRadius.circular(5),
                    //     ),
                    //     child: Text(
                    //       statusText,
                    //       style: const TextStyle(
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showMessageStatusCard(
    BuildContext context,
    String messageCard,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'Error',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    messageCard,
                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ย้อนกลับ'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

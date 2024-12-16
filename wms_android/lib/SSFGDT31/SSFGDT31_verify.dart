import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/centered_message.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;

class Ssfgdt31Verify extends StatefulWidget {
  final String docNo;
  final String docType;
  final String docDate;
  final String moDoNo;
  final String refNo;
  final String refDocNo;
  final String refDocType;
  final String pWareCode;
  Ssfgdt31Verify({
    Key? key,
    required this.docNo,
    required this.docType,
    required this.docDate,
    required this.moDoNo,
    required this.refNo,
    required this.refDocNo,
    required this.refDocType,
    required this.pWareCode,
  }) : super(key: key);
  @override
  _Ssfgdt31VerifyState createState() => _Ssfgdt31VerifyState();
}

class _Ssfgdt31VerifyState extends State<Ssfgdt31Verify> {
  List<dynamic> dataCard = [];

  String poTypeComplete = '';
  String poErpDocNo = '';
  String poStatusSubmit = '';
  String poMessageSubmit = '';
  String flag = '1';

  bool checkComfrim = false;
  int currentPage = 0;
  final int itemsPerPage = 5;
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();

// ---------------------------- P ---------------------------- \\
  String? V_DS_PDF;
  String? LIN_ID;
  String? OU_CODE;
  String? PROGRAM_NAME;
  String? CURRENT_DATE;
  String? USER_ID;
  String? PROGRAM_ID;
  String? P_WARE;
  String? P_SESSION;
  String? v_filename;
  String? FLAG;
  // --------------------------- LH ------------------------ \\
  String? LH_PAGE;
  String? LH_DATE;
  String? LH_AR_NAME;
  String? LH_LOGISTIC_COMP;
  String? LH_DOC_TYPE;
  String? LH_WARE;
  String? LH_CAR_ID;
  String? LH_DOC_NO;
  String? LH_DOC_DATE;
  String? LH_INVOICE_NO;

  String? LB_SEQ;
  String? LB_ITEM_CODE;
  String? LB_ITEM_NAME;
  String? LB_LOCATION;
  String? LB_UMS;
  String? LB_LOTS_PRODUCT;
  String? LB_MO_NO;
  String? LB_TRAN_Qty;
  String? LB_WEIGHT;
  String? LB_PD_LOCATION;
  String? LB_USED_TOTAL;

  String? LT_NOTE;
  String? LT_TOTAL_QTY;
  String? LT_ISSUE;
  String? LT_APPROVE;
  String? LT_OUT;
  String? LT_RECEIVE;
  String? LT_BILL;
  String? LT_CHECK;

  @override
  void initState() {
    super.initState();
    fetchData();
    print('docDate : ${widget.docType}');
    print('docDate : ${widget.docDate}');
    print('docDate : ${widget.docNo}');
    print('docDate : $flag');
    print('docDate : ${widget.pWareCode}');
    print('docDate : ${globals.APP_SESSION}');
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData([String? url]) async {
    isLoading = true;
    final String requestUrl = url ??
        '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_6_GridCard/${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/${widget.docNo}/${widget.docType}';
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

  int totalPages() {
    return (dataCard.length / itemsPerPage).ceil(); // คำนวณจำนวนหน้าทั้งหมด
  }

  void loadNextPage() {
    if (currentPage < totalPages() - 1) {
      setState(() {
        currentPage++;
        scrollToTop();
      });
    }
  }

  void loadPrevPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        scrollToTop();
      });
    }
  }

  List<dynamic> getCurrentData() {
    final start = currentPage * itemsPerPage;
    final end = start + itemsPerPage;

    return dataCard.sublist(start, end.clamp(0, dataCard.length));
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0); // เลื่อนไปยังตำแหน่งเริ่มต้น (index 0)
    }
  }

  Future<void> submitData() async {
    final url = '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_6_Submit';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_erp_ou_code': globals.P_ERP_OU_CODE,
      'p_app_user': globals.APP_USER,
      'p_doc_no': widget.docNo,
      'p_doc_type': widget.docType,
    });
    print('Request body: $body');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        print('data : $data type : ${data.runtimeType}');

        if (mounted) {
          setState(() {
            poTypeComplete = data['po_type_complete'];
            poErpDocNo = data['po_erp_doc_no'];
            poStatusSubmit = data['po_status'];
            poMessageSubmit = data['po_message'];

            print(
                'poTypeComplete : $poTypeComplete Type : ${poTypeComplete.runtimeType}');
            print('poErpDocNo : $poErpDocNo Type : ${poErpDocNo.runtimeType}');
            print(
                'poStatusSubmit : $poStatusSubmit Type : ${poStatusSubmit.runtimeType}');
            print(
                'poMessageSubmit : $poMessageSubmit Type : ${poMessageSubmit.runtimeType}');

            if (poStatusSubmit == '1') {
              showDialogAlert(context, poMessageSubmit);
            } else if (poStatusSubmit == '0') {
              showDialogPoDocNo(context, poTypeComplete, poErpDocNo);
            }
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getPDF(String poErpDocNo, String poTypeComplete) async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT31/SSFGDT31_Step_6_GET_PDF/'
          '${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/${globals.APP_USER}/${widget.pWareCode}/'
          '${globals.APP_SESSION}/${widget.docType}/${globals.BROWSER_LANGUAGE}/${globals.P_DS_PDF}'));

      print('Response body: ${response.body}'); // แสดงข้อมูลที่ได้รับจาก API

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataPDF = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
        if (mounted) {
          setState(() async {
            V_DS_PDF = dataPDF['V_DS_PDF'] ?? '';
            LIN_ID = dataPDF['LIN_ID'] ?? '';
            OU_CODE = dataPDF['OU_CODE'] ?? '';
            PROGRAM_NAME = dataPDF['PROGRAM_NAME'] ?? '';
            CURRENT_DATE = dataPDF['CURRENT_DATE'] ?? '';
            USER_ID = dataPDF['USER_ID'] ?? '';
            PROGRAM_ID = dataPDF['PROGRAM_ID'] ?? '';
            P_WARE = dataPDF['P_WARE'] ?? '';
            P_SESSION = dataPDF['P_SESSION'] ?? '';
            v_filename = dataPDF['v_filename'] ?? '';
            FLAG = dataPDF['FLAG'] ?? '';

            LH_PAGE = dataPDF['LH_PAGE'] ?? '';
            LH_DATE = dataPDF['LH_DATE'] ?? '';
            LH_AR_NAME = dataPDF['LH_AR_NAME'] ?? '';
            LH_LOGISTIC_COMP = dataPDF['LH_LOGISTIC_COMP'] ?? '';
            LH_DOC_TYPE = dataPDF['LH_DOC_TYPE'] ?? '';
            LH_WARE = dataPDF['LH_WARE'] ?? '';
            LH_CAR_ID = dataPDF['LH_CAR_ID'] ?? '';
            LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
            LH_DOC_DATE = dataPDF['LH_DOC_DATE'] ?? '';
            LH_INVOICE_NO = dataPDF['LH_INVOICE_NO'] ?? '';

            LB_SEQ = dataPDF['LB_SEQ'] ?? '';
            LB_ITEM_CODE = dataPDF['LB_ITEM_CODE'] ?? '';
            LB_ITEM_NAME = dataPDF['LB_ITEM_NAME'] ?? '';
            LB_LOCATION = dataPDF['LB_LOCATION'] ?? '';
            LB_UMS = dataPDF['LB_UMS'] ?? '';
            LB_LOTS_PRODUCT = dataPDF['LB_LOTS_PRODUCT'] ?? '';
            LB_MO_NO = dataPDF['LB_MO_NO'] ?? '';
            LB_TRAN_Qty = dataPDF['LB_TRAN_Qty'] ?? '';
            LB_WEIGHT = dataPDF['LB_WEIGHT'] ?? '';
            LB_PD_LOCATION = dataPDF['LB_PD_LOCATION'] ?? '';
            LB_USED_TOTAL = dataPDF['LB_USED_TOTAL'] ?? '';
            LT_NOTE = dataPDF['LT_NOTE'] ?? '';
            LT_TOTAL_QTY = dataPDF['LT_TOTAL_QTY'] ?? '';
            LT_ISSUE = dataPDF['LT_ISSUE'] ?? '';
            LT_APPROVE = dataPDF['LT_APPROVE'] ?? '';
            LT_OUT = dataPDF['LT_OUT'] ?? '';
            LT_RECEIVE = dataPDF['LT_RECEIVE'] ?? '';
            LT_BILL = dataPDF['LT_BILL'] ?? '';
            LT_CHECK = dataPDF['LT_CHECK'] ?? '';

            await _launchUrl(poErpDocNo);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in submit Data: $e');
    }
  }

  Future<void> _launchUrl(String pDocNo) async {
    final uri = Uri.parse('${globals.IP_API}/jri/report?'
        '&_repName=/WMS/SSFGDT31_REPORT'
        '&_repFormat=pdf'
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=${widget.docType}-${widget.docNo}.pdf'
        '&_repLocale=en_US'
        '&LIN_ID=$LIN_ID'
        '&OU_CODE=$OU_CODE'
        '&PROGRAM_NAME=$PROGRAM_NAME'
        '&CURRENT_DATE=$CURRENT_DATE'
        '&USER_ID=$USER_ID'
        '&PROGRAM_ID=$PROGRAM_ID'
        '&P_WARE=$P_WARE'
        '&P_SESSION=$P_SESSION'
        '&P_DOC_TYPE=${widget.docType}'
        '&P_ERP_DOC_NO=$pDocNo'
        '&FLAG=$FLAG'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        '&LH_AR_NAME=$LH_AR_NAME'
        '&LH_LOGISTIC_COMP=$LH_LOGISTIC_COMP'
        '&LH_Doc_Type=$LH_DOC_TYPE'
        '&LH_Ware=$LH_WARE'
        '&LH_CAR_ID=$LH_CAR_ID'
        '&LH_Doc_No=$LH_DOC_NO'
        '&LH_Doc_Date=$LH_DOC_DATE'
        '&LH_INVOICE_NO=$LH_INVOICE_NO'
        '&LB_SEQ=$LB_SEQ'
        '&LB_Item_Code=$LB_ITEM_CODE'
        '&LB_Item_Name=$LB_ITEM_NAME'
        '&LB_Location=$LB_LOCATION'
        '&LB_Ums=$LB_UMS'
        '&LB_LOTS_PRODUCT=$LB_LOTS_PRODUCT'
        '&LB_MO_NO=$LB_MO_NO'
        '&LB_TRAN_Qty=$LB_TRAN_Qty'
        '&LB_WEIGHT=$LB_WEIGHT'
        '&LB_PD_LOCATION=$LB_PD_LOCATION'
        '&LB_USED_TOTAL=$LB_USED_TOTAL'
        '&LT_NOTE=$LT_NOTE'
        '&lt_total_qty=$LT_TOTAL_QTY'
        '&LT_ISSUE=$LT_ISSUE'
        '&LT_APPROVE=$LT_APPROVE'
        '&LT_OUT=$LT_OUT'
        '&LT_RECEIVE=$LT_RECEIVE'
        '&LT_BILL=$LT_BILL'
        '&LT_CHECK=$LT_CHECK');

    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'เบิกจ่าย', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isLoading
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        // flex: 5,
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.yellow[200], // พื้นหลังสีเหลืองอ่อน
                            border: Border.all(
                              color: Colors.black, // ขอบสีดำ
                              width: 2.0, // ความกว้างของขอบ 2.0
                            ),
                            borderRadius: BorderRadius.circular(
                                8.0), // เพิ่มมุมโค้งให้กับ Container
                          ),
                          child: Center(
                            child: Text(
                              widget.docNo,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // ปรับขนาดตัวอักษรตามที่ต้องการ
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      ElevatedButton(
                        onPressed: checkComfrim
                            ? null
                            : () async {
                                setState(() {
                                  checkComfrim = true;
                                });
                                await submitData();
                                setState(() {
                                  checkComfrim = false;
                                });
                              },
                        style: AppStyles.ConfirmbuttonStyle(),
                        child: Text(
                          'ยืนยัน',
                          style: AppStyles.ConfirmbuttonTextStyle(),
                        ),
                      ),
                      // --------------------------------------------------------------------
                    ],
                  ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: [
                  isLoading
                      ? const SizedBox.shrink()
                      : Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 65,
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 5.0, left: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  // border: Border.all(
                                  //   color: Colors.black,
                                  //   width: 2.0,
                                  // ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Stack(
                                  children: [
                                    const Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Text(
                                        'เลขที่เอกสารอ้างอิง',
                                        style: TextStyle(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        widget.refNo == 'null'
                                            ? ''
                                            : widget.refNo,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    // flex: 5,
                                    child: Container(
                                      height: 65,
                                      padding: const EdgeInsets.only(
                                          top: 10.0, right: 5.0, left: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        // border: Border.all(
                                        //   color: Colors.black,
                                        //   width: 2.0,
                                        // ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          const Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Text(
                                              'เลขที่คำสั่งผลิต',
                                              style: TextStyle(
                                                color: Colors.black,
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              widget.moDoNo == 'null'
                                                  ? ''
                                                  : widget.moDoNo,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    // flex: 5,
                                    child: Container(
                                      height: 65,
                                      padding: const EdgeInsets.only(
                                          top: 10.0, right: 5.0, left: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        // border: Border.all(
                                        //   color: Colors.black,
                                        //   width: 2.0,
                                        // ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          const Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Text(
                                              'วันที่บันทึก',
                                              style: TextStyle(
                                                color: Colors.black,
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              widget.docDate,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 10.0),
                  isLoading
                      ? Center(child: LoadingIndicator())
                      : dataCard.isEmpty
                          ? const Center(child: CenteredMessage())
                          : ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: getCurrentData().length + 1,
                              itemBuilder: (context, index) {
                                if (index < getCurrentData().length) {
                                  var item = getCurrentData()[index];
                                  return CardStyles.cardGridPageSSFGDT31(
                                      isCanDeleteCard: false,
                                      isCanEditDetail: false,
                                      // lableHeader: 'Item',
                                      dataHeaderCard: item['item_code'] ?? '',
                                      labelDetail1: 'Lot No',
                                      dataDetail1: item['lots_no'] ?? '',
                                      labelDetail2: 'จำนวนรับ',
                                      dataDetail2: item['pack_qty'],
                                      labelDetail3: 'จำนวนจ่าย',
                                      dataDetail3: int.tryParse(
                                              item['old_pack_qty'] ?? '0') ??
                                          0,
                                      labelDetail4: 'Pack',
                                      dataDetail4: item['pack_code'] ?? '',
                                      labelDetail5: 'Location',
                                      dataDetail5: item['location_code'] ?? '',
                                      labelDetail6: 'PD Location',
                                      dataDetail6: item['ATTRIBUTE1'] ?? '',
                                      labelDetail7: 'Reason',
                                      dataDetail7: item['ATTRIBUTE2'] ?? '',
                                      labelDetail8: 'ใช้แทนจุด',
                                      dataDetail8: item['ATTRIBUTE3'] ?? '',
                                      labelDetail9: 'Replace Lot#',
                                      dataDetail9: item['attribute4'] ?? '',
                                      onTapDelete: null,
                                      onTapEditDetail: null);
                                } else {
                                  return Row(
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
                                              '${(currentPage * itemsPerPage) + 1} - ${((currentPage + 1) * itemsPerPage).clamp(1, dataCard.length)}',
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
                                  );
                                }
                              },
                            ),
                ],
              ),
            ),
            // !isLoading && getCurrentData().length > 0
            //     ? getCurrentData().length <= 3
            //         ? Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: [
            //                   currentPage > 0
            //                       ? ElevatedButton(
            //                           onPressed: currentPage > 0
            //                               ? () {
            //                                   loadPrevPage();
            //                                 }
            //                               : null,
            //                           style: ButtonStyles.previousButtonStyle,
            //                           child: ButtonStyles.previousButtonContent,
            //                         )
            //                       : ElevatedButton(
            //                           onPressed: null,
            //                           style: DisableButtonStyles
            //                               .disablePreviousButtonStyle,
            //                           child: DisableButtonStyles
            //                               .disablePreviousButtonContent,
            //                         )
            //                 ],
            //               ),
            //               // const SizedBox(width: 30),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Center(
            //                     child: Text(
            //                       '${(currentPage * itemsPerPage) + 1} - ${dataCard.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, dataCard.length) : 0}',
            //                       style: const TextStyle(
            //                         color: Colors.white,
            //                         fontWeight: FontWeight.bold,
            //                       ),
            //                     ),
            //                   )
            //                 ],
            //               ),
            //               // const SizedBox(width: 30),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.end,
            //                 children: [
            //                   currentPage < totalPages() - 1
            //                       ? ElevatedButton(
            //                           onPressed: currentPage < totalPages() - 1
            //                               ? () {
            //                                   loadNextPage();
            //                                 }
            //                               : null,
            //                           style: ButtonStyles.nextButtonStyle,
            //                           child: ButtonStyles.nextButtonContent(),
            //                         )
            //                       : ElevatedButton(
            //                           onPressed: null,
            //                           style: DisableButtonStyles
            //                               .disableNextButtonStyle,
            //                           child: DisableButtonStyles
            //                               .disablePreviousButtonContent,
            //                         ),
            //                 ],
            //               ),
            //             ],
            //           )
            //         : const SizedBox.shrink()
            //     : const SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: 'show',
      ),
    );
  }

  void showDialogAlert(
    BuildContext context,
    String messageAlert,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text(messageAlert),
          onClose: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showDialogPoDocNo(
    BuildContext context,
    String poTypeComplete,
    String poErpDocNo,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text(poErpDocNo),
          onClose: () {
            setState(() {
              Navigator.of(context).pop();
              String messageText = 'ต้องการพิมพ์เอกสารการรับคืนหรือไม่ ?';
              showDialogCheckPrint(
                  context, poTypeComplete, poErpDocNo, messageText);
            });
          },
          onConfirm: () {
            setState(() {
              Navigator.of(context).pop();
              String messageText = 'ต้องการพิมพ์เอกสารการรับคืนหรือไม่ ?';
              showDialogCheckPrint(
                  context, poTypeComplete, poErpDocNo, messageText);
            });
          },
        );
      },
    );
  }

  void showDialogCheckPrint(BuildContext context, String poTypeComplete,
      String poErpDocNo, String messageText) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageCheckDialog(
          context: context,
          content: Text(messageText),
          onClose: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          onConfirm: () async {
            await getPDF(poErpDocNo, poTypeComplete);
          },
        );
      },
    );
  }
}

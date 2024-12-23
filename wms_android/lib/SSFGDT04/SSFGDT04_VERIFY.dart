import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:intl/intl.dart';
import '../styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'SSFGDT04_MENU.dart';

class SSFGDT04_VERIFY extends StatefulWidget {
  final String pWareCode;
  final String? po_doc_no;
  final String? po_doc_type;
  final String setqc;

  const SSFGDT04_VERIFY({
    super.key,
    required this.pWareCode,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.setqc,
  });

  @override
  _SSFGDT04_VERIFYState createState() => _SSFGDT04_VERIFYState();
}

class _SSFGDT04_VERIFYState extends State<SSFGDT04_VERIFY> {
  List<Map<String, dynamic>> gridItems = [];
  late TextEditingController _docNoController;
  String pDsPdf = gb.P_DS_PDF;
  int currentPage = 0;
  final int itemsPerPage = 5;
  bool isDialogShowing = false;

  bool get hasPreviousPage => currentPage > 0;
  bool get hasNextPage => (currentPage + 1) * itemsPerPage < gridItems.length;

  String? V_DS_PDF;
  String? LIN_ID;
  String? OU_CODE;
  String? USER_ID;
  String? PROGRAM_ID;
  String? P_SESSION;

  String? S_DOC_TYPE;
  String? S_DOC_NO;
  String? E_DOC_TYPE;
  String? E_DOC_NO;
  String? FLAG;

  String? LH_PAGE;
  String? LH_DATE;
  String? LH_WARE;
  String? LH_DOC_NO;
  String? LH_DOC_DATE;
  String? LH_DOC_TYPE;
  String? LH_PROGRAM_NAME;
  String? LH_REF_NO1;
  String? LH_REF_NO2;

  String? LB_ITEM_CODE;
  String? LB_ITEM_NAME;
  String? LB_LOCATION;
  String? LB_UMS;
  String? LB_TRAN_QTY;
  String? LB_TRAN_UCOST;
  String? LB_TRAN_AMT;

  String? LT_NOTE;
  String? LT_TOTAL;
  String? LT_INPUT;
  String? LT_RECEIVE;
  String? LT_CHECK;

  String? LB_PALLET_NO;
  String? LB_PALLET_QTY;
  String? LH_MO_DO_NO;

  @override
  void initState() {
    super.initState();
    fetchGridItems();
    _docNoController = TextEditingController(text: widget.po_doc_no);
  }

  Future<void> fetchGridItems() async {
    final response = await http.get(Uri.parse(
        '${gb.IP_API}/apex/wms/SSFGDT04/Step_5_WMS_IN_TRAN_DETAIL/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}/${gb.P_OU_CODE}'));
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      if (mounted) {
        setState(() {
          gridItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        });
      }
    } else {
      throw Exception('Failed to load DOC_TYPE items');
    }
  }

  String? getLink(List<dynamic> links, String rel) {
    final link =
        links.firstWhere((item) => item['rel'] == rel, orElse: () => null);
    return link != null ? link['href'] : null;
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
    if ((currentPage + 1) * itemsPerPage < gridItems.length) {
      setState(() {
        currentPage++;
        // No need to call fetchData here, just update the UI
      });
      _scrollToTop();
    }
  }

  final ScrollController _scrollController = ScrollController();
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0); // เลื่อนไปยังตำแหน่งเริ่มต้น (index 0)
    }
  }

  String? poStatus;
  String? poMessage;
  String? poErpDocNo;
  String? vTypeComplete;

  Future<void> chk_IntefaceNonePO() async {
    print(poErpDocNo);
    print(vTypeComplete);
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT04/Step_5_Inteface_NonePO_WMS2ERP/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${gb.APP_USER}'));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = json.decode(responseBody);
        if (mounted) {
          setState(() {
            poStatus = data['po_status'];
            poMessage = data['po_message'];
            poErpDocNo = data['po_erp_doc_no'];
            vTypeComplete = data['v_type_complete'];
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getPDF(String poDocNo) async {
    // po_doc_no = 'WM00-24090776';
    // po_doc_type = 'FGI03';
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT04/Step_5_GET_PDF/${gb.P_DS_PDF}/${gb.BROWSER_LANGUAGE}/${widget.po_doc_no}/${gb.P_ERP_OU_CODE}/${gb.APP_USER}/${gb.APP_SESSION}/${gb.FLAG}'));

      print('Response body: ${response.body}'); // แสดงข้อมูลที่ได้รับจาก API

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataPDF = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
        if (mounted) {
          setState(() {
            V_DS_PDF = dataPDF['V_DS_PDF'] ?? '';
            LIN_ID = dataPDF['LIN_ID'] ?? '';
            OU_CODE = dataPDF['OU_CODE'] ?? '';
            USER_ID = dataPDF['USER_ID'] ?? '';
            PROGRAM_ID = dataPDF['PROGRAM_ID'] ?? '';
            P_SESSION = dataPDF['P_SESSION'] ?? '';

            S_DOC_TYPE = dataPDF['S_DOC_TYPE'] ?? '';
            S_DOC_NO = dataPDF['S_DOC_NO'] ?? '';
            E_DOC_TYPE = dataPDF['E_DOC_TYPE'] ?? '';
            E_DOC_NO = dataPDF['E_DOC_NO'] ?? '';
            FLAG = dataPDF['FLAG'] ?? '';

            LH_PAGE = dataPDF['LH_PAGE'] ?? '';
            LH_DATE = dataPDF['LH_DATE'] ?? '';
            LH_WARE = dataPDF['LH_WARE'] ?? '';
            LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
            LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
            LH_DOC_DATE = dataPDF['LH_DOC_DATE'] ?? '';
            LH_DOC_TYPE = dataPDF['LH_DOC_TYPE'] ?? '';
            LH_PROGRAM_NAME = dataPDF['LH_PROGRAM_NAME'] ?? '';
            LH_REF_NO1 = dataPDF['LH_REF_NO1'] ?? '';
            LH_REF_NO2 = dataPDF['LH_REF_NO2'] ?? '';

            LB_ITEM_CODE = dataPDF['LB_ITEM_CODE'] ?? '';
            LB_ITEM_NAME = dataPDF['LB_ITEM_NAME'] ?? '';
            LB_LOCATION = dataPDF['LB_LOCATION'] ?? '';
            LB_UMS = dataPDF['LB_UMS'] ?? '';
            LB_TRAN_QTY = dataPDF['LB_TRAN_QTY'] ?? '';
            LB_TRAN_UCOST = dataPDF['LB_TRAN_UCOST'] ?? '';
            LB_TRAN_AMT = dataPDF['LB_TRAN_AMT'] ?? '';

            LT_NOTE = dataPDF['LT_NOTE'] ?? '';
            LT_TOTAL = dataPDF['LT_TOTAL'] ?? '';
            LT_INPUT = dataPDF['LT_INPUT'] ?? '';
            LT_RECEIVE = dataPDF['LT_RECEIVE'] ?? '';
            LT_CHECK = dataPDF['LT_CHECK'] ?? '';

            LB_PALLET_NO = dataPDF['LB_PALLET_NO'] ?? '';
            LB_PALLET_QTY = dataPDF['LB_PALLET_QTY'] ?? '';
            LH_MO_DO_NO = dataPDF['LH_MO_DO_NO'] ?? '';

            _launchUrl(poDocNo);
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

  Future<void> _launchUrl(String poDocNo) async {
    final uri = Uri.parse('${gb.IP_API}/jri/report?'
        '&_repName=/WMS/SSFGOD01'
        '&_repFormat=pdf'
        '&_dataSource=${gb.P_DS_PDF}'
        '&_outFilename=$poDocNo.pdf'
        '&_repLocale=en_US'
        '&V_DS_PDF=$V_DS_PDF'
        '&LIN_ID=$LIN_ID'
        '&OU_CODE=${gb.P_ERP_OU_CODE}'
        '&USER_ID=$USER_ID'
        '&PROGRAM_ID=$PROGRAM_ID'
        '&P_SESSION=$P_SESSION'
        '&S_DOC_TYPE=$S_DOC_TYPE'
        '&S_DOC_NO=$S_DOC_NO'
        '&E_DOC_TYPE=$E_DOC_TYPE'
        '&E_DOC_NO=$E_DOC_NO'
        '&FLAG=${gb.FLAG}'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        '&LH_WARE=$LH_WARE'
        '&LH_DOC_NO=$LH_DOC_NO'
        '&LH_DOC_DATE=$LH_DOC_DATE'
        '&LH_DOC_TYPE=$LH_DOC_TYPE'
        '&LH_PROGRAM_NAME=$LH_PROGRAM_NAME'
        '&LH_REF_NO1=$LH_REF_NO1'
        '&LH_REF_NO2=$LH_REF_NO2'
        '&LB_ITEM_CODE=$LB_ITEM_CODE'
        '&LB_ITEM_NAME=$LB_ITEM_NAME'
        '&LB_LOCATION=$LB_LOCATION'
        '&LB_UMS=$LB_UMS'
        '&LB_TRAN_QTY=$LB_TRAN_QTY'
        '&LB_TRAN_UCOST=$LB_TRAN_UCOST'
        '&LB_TRAN_AMT=$LB_TRAN_AMT'
        '&LT_NOTE=$LT_NOTE'
        '&LT_TOTAL=$LT_TOTAL'
        '&LT_INPUT=$LT_INPUT'
        '&LT_RECEIVE=$LT_RECEIVE'
        '&LT_CHECK=$LT_CHECK'
        '&LB_PALLET_NO=$LB_PALLET_NO'
        '&LB_PALLET_QTY=$LB_PALLET_QTY'
        '&LH_MO_DO_NO=$LH_MO_DO_NO');

    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    print('${gb.IP_API}/jri/report?'
        '&_repName=/WMS/SSFGOD01'
        '&_repFormat=pdf'
        '&_dataSource=${gb.P_DS_PDF}'
        '&_outFilename=$poDocNo.pdf'
        '&_repLocale=en_US'
        '&V_DS_PDF=$V_DS_PDF'
        '&LIN_ID=$LIN_ID'
        '&OU_CODE=${gb.P_ERP_OU_CODE}'
        '&USER_ID=$USER_ID'
        '&PROGRAM_ID=$PROGRAM_ID'
        '&P_SESSION=$P_SESSION'
        '&S_DOC_TYPE=$S_DOC_TYPE'
        '&S_DOC_NO=$S_DOC_NO'
        '&E_DOC_TYPE=$E_DOC_TYPE'
        '&E_DOC_NO=$E_DOC_NO'
        '&FLAG=${gb.FLAG}'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        '&LH_WARE=$LH_WARE'
        '&LH_DOC_NO=$LH_DOC_NO'
        '&LH_DOC_DATE=$LH_DOC_DATE'
        '&LH_DOC_TYPE=$LH_DOC_TYPE'
        '&LH_PROGRAM_NAME=$LH_PROGRAM_NAME'
        '&LH_REF_NO1=$LH_REF_NO1'
        '&LH_REF_NO2=$LH_REF_NO2'
        '&LB_ITEM_CODE=$LB_ITEM_CODE'
        '&LB_ITEM_NAME=$LB_ITEM_NAME'
        '&LB_LOCATION=$LB_LOCATION'
        '&LB_UMS=$LB_UMS'
        '&LB_TRAN_QTY=$LB_TRAN_QTY'
        '&LB_TRAN_UCOST=$LB_TRAN_UCOST'
        '&LB_TRAN_AMT=$LB_TRAN_AMT'
        '&LT_NOTE=$LT_NOTE'
        '&LT_TOTAL=$LT_TOTAL'
        '&LT_INPUT=$LT_INPUT'
        '&LT_RECEIVE=$LT_RECEIVE'
        '&LT_CHECK=$LT_CHECK'
        '&LB_PALLET_NO=$LB_PALLET_NO'
        '&LB_PALLET_QTY=$LB_PALLET_QTY'
        '&LH_MO_DO_NO=$LH_MO_DO_NO');
  }

  @override
  void dispose() {
    _docNoController.dispose();
    super.dispose();
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4.0), // Optional padding for better spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center, // Align both label and value to the center
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Flexible(
            // Flexible allows the value to take only the necessary space
            child: CustomContainerStyles.styledContainer(
              value, // Pass the value to determine the container style
              padding:
                  5.0, // Adjust padding for better spacing inside the container
              child: Text(
                value,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis), // Ellipsis for long text
                softWrap: true,
                maxLines: 2, // Limit to two lines if necessary
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow1(Map<String, String> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: info.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Key
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      softWrap: false,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 18),

                  Container(
                    constraints: BoxConstraints(
                      minWidth: 80,
                      maxWidth: 160,
                    ),
                    height: 30,
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: entry.value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 10.0,
                        ),
                      ),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.right,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow2(Map<String, String> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: info.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Key
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      softWrap: false,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 18),

                  Container(
                    constraints: BoxConstraints(
                      minWidth: 80,
                      maxWidth: 160,
                    ),
                    height: 30,
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: entry.value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 10.0,
                        ),
                      ),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow3(Map<String, String> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: info.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Key
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      softWrap: false,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 18),

                  Container(
                    constraints: BoxConstraints(
                      minWidth: 80,
                      maxWidth: 160,
                    ),
                    height: 30,
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: entry.value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 10.0,
                        ),
                      ),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow4(Map<String, String> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: info.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Key
                  Container(
                    height: 30,
                    // alignment: Alignment.centerLeft,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      softWrap: false,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 18),

                  Container(
                    constraints: BoxConstraints(
                      minWidth: 80,
                      maxWidth: 160,
                    ),
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalCards = gridItems.length;
    bool hasPreviousPage = currentPage > 0;
    bool hasNextPage = (currentPage + 1) * itemsPerPage < totalCards;
    return Scaffold(
      appBar:
          CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Prevent multiple dialogs from showing simultaneously
                    if (isDialogShowing) return;

                    setState(() {
                      isDialogShowing =
                          true; // Set flag to true when a dialog is about to be shown
                    });

                    await chk_IntefaceNonePO();

                    if (poStatus == '0') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogStyles.messageDialog(
                            context: context,
                            content: Text('$poErpDocNo'),
                            onClose: () {
                              Navigator.of(context).pop();
                              setState(() {
                                isDialogShowing =
                                    false; // Reset the flag when the first dialog is closed
                              });
                            },
                            onConfirm: () async {
                              Navigator.of(context)
                                  .pop(); // Close the first dialog

                              // Wait for a moment to ensure the first dialog is fully closed
                              await Future.delayed(Duration(milliseconds: 100));

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogStyles.alertMessageCheckDialog(
                                    context: context,
                                    content: const Text(
                                        'ต้องการพิมพ์เอกสารใบรับหรือไม่ ?'),
                                    onClose: () {
                                      Navigator.of(context)
                                          .pop(); // Close the second dialog
                                      setState(() {
                                        isDialogShowing =
                                            false; // Reset the flag when the second dialog is closed
                                      });
                                    },
                                    onConfirm: () async {
                                      Navigator.of(context)
                                          .pop(); // Close the second dialog;
                                      // await fetchGetPo(); // Call the fetchGetPo function after confirming
                                      getPDF(widget.po_doc_no ?? '').then((_) {
                                        // หลังจากเรียก getPDF เสร็จแล้ว, กลับไปยังหน้า SSFGDT04_MENU
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop(
                                          MaterialPageRoute(
                                            builder: (context) => SSFGDT04_MENU(
                                              pWareCode: gb.P_WARE_CODE,
                                              pErpOuCode: gb.P_ERP_OU_CODE,
                                            ),
                                          ),
                                        );
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  );
                                },
                              );
                              setState(() {
                                isDialogShowing =
                                    false; // รีเซ็ตสถานะหลังจากปิด dialog
                              });
                            },
                            showCloseIcon: true,
                          );
                        },
                      );
                      setState(() {
                        isDialogShowing = false; // รีเซ็ตสถานะหลังจากปิด dialog
                      });
                    } else if (poStatus == '1') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogStyles.alertMessageDialog(
                            context: context,
                            content: Text(poMessage ?? ''),
                            onClose: () {
                              Navigator.of(context).pop();
                              setState(() {
                                isDialogShowing =
                                    false; // Reset the flag when the dialog is closed
                              });
                            },
                            onConfirm: () async {
                              Navigator.of(context).pop();
                              setState(() {
                                isDialogShowing =
                                    false; // Reset the flag when the dialog is closed
                              });
                            },
                          );
                        },
                      );
                      setState(() {
                        isDialogShowing = false; // รีเซ็ตสถานะหลังจากปิด dialog
                      });
                    }
                  },
                  style: AppStyles.ConfirmbuttonStyle(),
                  child: Text(
                    'ยืนยัน',
                    style: AppStyles.ConfirmbuttonTextStyle(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                // child: _buildCards(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.po_doc_no ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Text with background color
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 80),
                      decoration: BoxDecoration(
                        color: Colors
                            .lightBlue[100], // Background color for the text
                        borderRadius: BorderRadius.circular(
                            8), // Rounded corners (optional)
                      ),
                      child: Text(
                        widget.setqc, // Text ที่ต้องการแสดง
                        style: const TextStyle(
                          color: Colors.black, // Text color
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    gridItems.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Text(
                                'No data found',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            // itemCount: gridItems.length,
                            controller: _scrollController,
                            itemCount:
                                itemsPerPage + 1, // +1 for the pagination row
                            itemBuilder: (context, index) {
                              if (index < itemsPerPage) {
                                int actualIndex =
                                    (currentPage * itemsPerPage) + index;

                                // Check if we have reached the end of the data
                                if (actualIndex >= gridItems.length) {
                                  return const SizedBox.shrink();
                                }

                                final item = gridItems[actualIndex];
                                return Card(
                                  elevation: 4,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Color.fromRGBO(204, 235, 252, 1.0),
                                  child: InkWell(
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Center(
                                                child: Text(
                                                  item['item_code'] ?? '',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const Divider(
                                                  color: Colors.black26,
                                                  thickness: 1),
                                              const SizedBox(height: 4),
                                              _buildInfoRow(
                                                'จำนวนรับ :',
                                                item['pack_qty'] != null
                                                    ? NumberFormat('#,###')
                                                        .format(
                                                            item['pack_qty'])
                                                    : '',
                                              ),
                                              SizedBox(height: 4),
                                              _buildInfoRow(
                                                'จำนวน Pallet :',
                                                item['count_qty'] ?? '',
                                              ),
                                              SizedBox(height: 4),
                                              _buildInfoRow(
                                                'จำนวนรวม :',
                                                item['count_qty_in'] ?? '',
                                              ),
                                              SizedBox(height: 4),
                                              _buildInfoRow(
                                                'Item Desc :',
                                                item['nb_item_name'] ?? '',
                                              ),
                                              // Column(
                                              //   children: [
                                              //     Row(
                                              //       mainAxisAlignment:
                                              //           MainAxisAlignment.start,
                                              //       children: [
                                              //         const Text(
                                              //           'จำนวนรับ :',
                                              //           textAlign: TextAlign.left,
                                              //           style: TextStyle(
                                              //             fontSize: 14,
                                              //             fontWeight: FontWeight.bold,
                                              //           ),
                                              //         ),
                                              //         const SizedBox(width: 8),
                                              //         CustomContainerStyles
                                              //             .styledContainer(
                                              //           item['pack_qty']
                                              //               ?.toString(), // Passing the 'pack_qty' as the itemValue
                                              //           child: Text(
                                              //             item['pack_qty'] != null &&
                                              //                     item['pack_qty'] !=
                                              //                         ''
                                              //                 ? NumberFormat('#,###')
                                              //                     .format(item[
                                              //                         'pack_qty'])
                                              //                 : '',
                                              //             textAlign: TextAlign.left,
                                              //             style: const TextStyle(
                                              //               fontSize: 14,
                                              //               fontWeight:
                                              //                   FontWeight.normal,
                                              //               color: Colors.black,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //     const SizedBox(height: 4),
                                              //     Row(
                                              //       mainAxisAlignment:
                                              //           MainAxisAlignment.start,
                                              //       children: [
                                              //         const Text(
                                              //           'จำนวน Pallet :',
                                              //           textAlign: TextAlign.left,
                                              //           style: TextStyle(
                                              //               fontSize: 14,
                                              //               fontWeight:
                                              //                   FontWeight.bold),
                                              //         ),
                                              //         const SizedBox(width: 8),
                                              //         CustomContainerStyles
                                              //             .styledContainer(
                                              //           item['count_qty']
                                              //               ?.toString(), // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                              //           child: Text(
                                              //             item['count_qty'] ?? '',
                                              //             style: const TextStyle(
                                              //                 fontSize: 14.0),
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //     const SizedBox(height: 4),
                                              //     Row(
                                              //       mainAxisAlignment:
                                              //           MainAxisAlignment.start,
                                              //       children: [
                                              //         const Text(
                                              //           'จำนวนรวม :',
                                              //           textAlign: TextAlign.left,
                                              //           style: TextStyle(
                                              //               fontSize: 14,
                                              //               fontWeight:
                                              //                   FontWeight.bold),
                                              //         ),
                                              //         const SizedBox(width: 8),
                                              //         CustomContainerStyles
                                              //             .styledContainer(
                                              //           item['count_qty_in']
                                              //               ?.toString(), // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                              //           child: Text(
                                              //             item['count_qty_in'] ?? '',
                                              //             style: const TextStyle(
                                              //                 fontSize: 14.0),
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Previous Button
                                    hasPreviousPage
                                        ? ElevatedButton.icon(
                                            onPressed: _loadPrevPage,
                                            icon: const Icon(
                                              Icons.arrow_back_ios_rounded,
                                              color: Colors.black,
                                              size: 20.0,
                                            ),
                                            label: const Text(
                                              'Previous',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            style:
                                                AppStyles.PreviousButtonStyle(),
                                          )
                                        : ElevatedButton.icon(
                                            onPressed: null,
                                            icon: const Icon(
                                              Icons.arrow_back_ios_rounded,
                                              color:
                                                  Color.fromARGB(0, 23, 21, 59),
                                              size: 20.0,
                                            ),
                                            label: const Text(
                                              'Previous',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            style: AppStyles
                                                .DisablePreviousButtonStyle(),
                                          ),

                                    // Page Indicator
                                    Text(
                                      '${(currentPage * itemsPerPage) + 1}-${(currentPage + 1) * itemsPerPage > totalCards ? totalCards : (currentPage + 1) * itemsPerPage}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // Next Button
                                    hasNextPage
                                        ? ElevatedButton(
                                            onPressed: _loadNextPage,
                                            style: AppStyles
                                                .NextRecordDataButtonStyle(),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Next',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(width: 7),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.black,
                                                  size: 20.0,
                                                ),
                                              ],
                                            ),
                                          )
                                        : ElevatedButton(
                                            onPressed: null,
                                            style: AppStyles
                                                .DisableNextRecordDataButtonStyle(),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Next',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        0, 23, 21, 59),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(width: 7),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Color.fromARGB(
                                                      0, 23, 21, 59),
                                                  size: 20.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }
}

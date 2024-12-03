import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/centered_message.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;

class Ssfgdt09lPickingSlip extends StatefulWidget {
  final String pErpOuCode;
  final String pOuCode;
  final String pMoDoNO;
  final String pDocNo;

  Ssfgdt09lPickingSlip({
    Key? key,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pMoDoNO,
    required this.pDocNo,
  }) : super(key: key);
  @override
  _Ssfgdt09lPickingSlipState createState() => _Ssfgdt09lPickingSlipState();
}

class _Ssfgdt09lPickingSlipState extends State<Ssfgdt09lPickingSlip> {
  List<dynamic> dataCard = [];

  bool isLoading = false;
  String? nextLink = '';
  String? prevLink = '';

  String urlLoad = '';
  int showRecordRRR = 0;

//  -----------------------------  p  -----------------------------  \\
  String? P_LIN_ID;
  String? V_DS_PDF;
  String? P_MO_DO_NO;
  String? P_OU_CODE;
  String? P_ERP_OU_CODE;
//  -----------------------------  LH  -----------------------------  \\
  String? LH_PICKING_SLIP;
  String? LH_MO_DO_NO;
  //  -----------------------------  LB  -----------------------------  \\
  String? LB_MATERIAL_CODE;
  String? LB_LOT;
  String? LB_COMB;
  String? LB_USAGE_QTY;
  String? LB_WARE_CODE;
  String? LB_LOCATION_CODE;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData([String? url]) async {
    isLoading = true;
    final String requestUrl = url ??
        '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_PickingSilp/${globals.P_ERP_OU_CODE}/${globals.P_OU_CODE}/${widget.pMoDoNO.isEmpty ? 'null' : widget.pMoDoNO}';
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
            urlLoad = url ??
                '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_PickingSilp/${globals.P_ERP_OU_CODE}/${globals.P_OU_CODE}/${widget.pMoDoNO}';
            if (url.toString().isNotEmpty) {
              extractLastNumberFromUrl(url.toString() ==
                      '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_PickingSilp/${globals.P_ERP_OU_CODE}/${globals.P_OU_CODE}/${widget.pMoDoNO}'
                  ? 'null'
                  : url.toString());
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

    // พิมพ์ค่าที่ได้
    print('ผลลัพธ์: $showRecord');
  }

  Future<void> getPDF() async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_GET_PDF/${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/${widget.pMoDoNO}/${globals.BROWSER_LANGUAGE}/${globals.P_DS_PDF}'));

      print('Response body: ${response.body}'); // แสดงข้อมูลที่ได้รับจาก API

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataPDF = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
        if (mounted) {
          setState(() {
            P_LIN_ID = dataPDF['P_LIN_ID'] ?? '';
            V_DS_PDF = dataPDF['V_DS_PDF'] ?? '';
            P_MO_DO_NO = dataPDF['P_MO_DO_NO'] ?? '';
            P_OU_CODE = dataPDF['P_OU_CODE'] ?? '';
            P_ERP_OU_CODE = dataPDF['P_ERP_OU_CODE'] ?? '';

            LH_PICKING_SLIP = dataPDF['LH_PICKING_SLIP'] ?? '';
            LH_MO_DO_NO = dataPDF['LH_MO_DO_NO'] ?? '';
            LB_MATERIAL_CODE = dataPDF['LB_MATERIAL_CODE'] ?? '';
            LB_LOT = dataPDF['LB_LOT'] ?? '';
            LB_COMB = dataPDF['LB_COMB'] ?? '';
            LB_USAGE_QTY = dataPDF['LB_USAGE_QTY'] ?? '';
            LB_WARE_CODE = dataPDF['LB_WARE_CODE'] ?? '';
            LB_LOCATION_CODE = dataPDF['LB_LOCATION_CODE'] ?? '';

            _launchUrl();
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

  Future<void> _launchUrl() async {
    final uri = Uri.parse('${globals.IP_API}/jri/report?'
        '&_repName=/WMS/WMS_SSFGDT09L_Picking_Slip'
        '&_repFormat=pdf'
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=${widget.pDocNo}.pdf'
        '&_repLocale=en_US'
        '&P_LIN_ID=$P_LIN_ID'
        '&V_DS_PDF=$V_DS_PDF'
        '&P_MO_DO_NO=$P_MO_DO_NO'
        '&P_OU_CODE=$P_OU_CODE'
        '&P_ERP_OU_CODE=$P_ERP_OU_CODE'
        '&LH_PICKING_SLIP=$LH_PICKING_SLIP'
        '&LH_MO_DO_NO=$LH_MO_DO_NO'
        '&LB_MATERIAL_CODE=$LB_MATERIAL_CODE'
        '&LB_LOT=$LB_LOT'
        '&LB_COMB=$LB_COMB'
        '&LB_USAGE_QTY=$LB_USAGE_QTY'
        '&LB_WARE_CODE=$LB_WARE_CODE'
        '&LB_LOCATION_CODE=$LB_LOCATION_CODE');

    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    print('${globals.IP_API}/jri/report?'
        '&_repName=/WMS/SSFGOD02A5'
        '&_repFormat=pdf'
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=${widget.pDocNo}.pdf'
        '&_repLocale=en_US'
        '&P_LIN_ID=$P_LIN_ID'
        '&V_DS_PDF=$V_DS_PDF'
        '&P_MO_DO_NO=$P_MO_DO_NO'
        '&P_OU_CODE=$P_OU_CODE'
        '&P_ERP_OU_CODE=$P_ERP_OU_CODE'
        '&LH_PICKING_SLIP=$LH_PICKING_SLIP'
        '&LH_MO_DO_NO=$LH_MO_DO_NO'
        '&LB_MATERIAL_CODE=$LB_MATERIAL_CODE'
        '&LB_LOT=$LB_LOT'
        '&LB_COMB=$LB_COMB'
        '&LB_USAGE_QTY=$LB_USAGE_QTY'
        '&LB_WARE_CODE=$LB_WARE_CODE'
        '&LB_LOCATION_CODE=$LB_LOCATION_CODE');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Picking Silp', showExitWarning: false),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    getPDF();
                  },
                  style: AppStyles.NextButtonStyle(),
                  child: Image.asset(
                    'assets/images/printer.png', // ใส่ภาพจากไฟล์ asset
                    width: 25, // กำหนดขนาดภาพ
                    height: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? Center(child: LoadingIndicator())
                  : dataCard.isEmpty
                      ? const Center(child: CenteredMessage())
                      : ListView(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: dataCard.length,
                              itemBuilder: (context, index) {
                                final item = dataCard[index];

                                return Card(
                                  elevation: 8.0,
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Color.fromRGBO(204, 235, 252, 1.0),
                                  child: InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  // MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Item : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item[
                                                          'material_code'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                      child: Text(
                                                        item['material_code'] ??
                                                            '',
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              // ---------------------------------------------------- \\
                                              SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  // MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Lot : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item[
                                                          'lot_no'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                      child: Text(
                                                        item['lot_no'] ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              // ---------------------------------------------------- \\
                                              SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  // MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Comb : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item[
                                                          'comb'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                      child: Text(
                                                        item['comb'] ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              // ---------------------------------------------------- \\
                                              SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  // MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'ความต้องการใช้ : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item['usage_qty']
                                                          ?.toString(),
                                                      child: Text(
                                                        item['usage_qty'] !=
                                                                null
                                                            ? NumberFormat(
                                                                    '#,###,###,###,###,###')
                                                                .format(item[
                                                                    'usage_qty'])
                                                            : '',
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              // ---------------------------------------------------- \\
                                              SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  // MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Warehouse : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item[
                                                          'ware_code'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                      child: Text(
                                                        item['ware_code'] ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              // ---------------------------------------------------- \\
                                              SizedBox(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  // MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Locator : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    CustomContainerStyles
                                                        .styledContainer(
                                                      item[
                                                          'location_code'], // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                      child: Text(
                                                        item['location_code'] ??
                                                            '',
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              // ---------------------------------------------------- \\
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            // =======================================================  dataCard.length > 1
                            dataCard.isNotEmpty
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
                            // =======================================================  dataCard.length > 1
                          ],
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: 'show',
      ),
    );
  }
}

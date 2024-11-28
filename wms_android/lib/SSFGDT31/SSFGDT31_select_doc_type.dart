import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'SSFGDT31_form.dart';

class Ssfgdt31SelectDocType extends StatefulWidget {
  final String pWareCode;

  const Ssfgdt31SelectDocType({
    Key? key,
    required this.pWareCode,
  }) : super(key: key);

  @override
  _Ssfgdt31SelectDocTypeState createState() => _Ssfgdt31SelectDocTypeState();
}

class _Ssfgdt31SelectDocTypeState extends State<Ssfgdt31SelectDocType> {
  List<dynamic> dataLovDocType = [];
  Map<String, dynamic>? selectedDocTypeItem;
  String docTypeLovD = '';
  String docTypeLovR = '';
  String chkCardName = '';
  String statusChkCreate = '';
  String messageChkCreate = '';
  String poDocType = '';
  String poDocNo = '';

  bool isLoading = false;
  bool isButtenDisabled = false;

  final TextEditingController dataLovDocTypeController =
      TextEditingController();

  @override
  void initState() {
    selectLovDocType();
    super.initState();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> selectLovDocType() async {
    isLoading = true;
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_1_SelectLovDocType/${globals.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovDocType =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            selectedDocTypeItem = dataLovDocType[0];
            docTypeLovD = selectedDocTypeItem?['d'] ?? '';
            docTypeLovR = selectedDocTypeItem?['r'] ?? '';
            dataLovDocTypeController.text = docTypeLovD;

            isLoading = false;
          });
        }
        print('dataLovDocType : $dataLovDocType');
      } else {
        throw Exception('dataLovDocType Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovDocType ERROR IN Fetch Data : $e');
    }
  }

  Future<void> chkCreateCard() async {
    final url = '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_1_CreateDoc';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'ou_code': globals.P_OU_CODE,
      'erp_ou_code': globals.P_ERP_OU_CODE,
      'app_session': globals.APP_SESSION,
      'ware_code': widget.pWareCode,
      'doc_type': docTypeLovR,
      'app_user': globals.APP_USER,
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
            statusChkCreate = data['po_status'];
            messageChkCreate = data['po_message'];
            print(
                'statusChkCreate : $statusChkCreate Type : ${statusChkCreate.runtimeType}');
            print(
                'messageChkCreate : $messageChkCreate Type : ${messageChkCreate.runtimeType}');

            if (statusChkCreate == '1') {
              showDialogAlert(context, messageChkCreate);
              if (mounted) {
                setState(() {
                  isButtenDisabled = false;
                });
              }
            }
            if (statusChkCreate == '0') {
              poDocNo = data['po_doc_no'];
              poDocType = data['po_doc_type'];

              print('poDocNo : $poDocNo Type : ${poDocNo.runtimeType}');

              print('poDocType : $poDocType Type : ${poDocType.runtimeType}');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Ssfgdt31Form(
                    pDocNo: poDocNo,
                    pDocType: poDocType,
                    pWareCode: widget.pWareCode,
                  ),
                ),
              ).then((value) async {
                if (mounted) {
                  setState(() {
                    isButtenDisabled = false;
                  });
                }
              });
            }
          });
        }
      } else {
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'รับคืนจากการเบิกเพื่อผลผลิต', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isLoading
                ? Center(child: LoadingIndicator())
                : TextFormField(
                    controller: dataLovDocTypeController,
                    readOnly: true,
                    onTap: () => showDialogSelectDocType(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'ประเภทเอกสาร',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                      ),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isButtenDisabled
                      ? null
                      : () async {
                          setState(() {
                            isButtenDisabled = true;
                          });
                          await chkCreateCard();
                        },
                  style: AppStyles.ConfirmbuttonStyle(),
                  child:
                      Text('ยืนยัน', style: AppStyles.ConfirmbuttonTextStyle()),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(
        currentPage: 'not_show',
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
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notification_important,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'แจ้งเตือน',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  Text(
                    messageAlert,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ตกลง'),
                      ),
                    ],
                  )
                ])),
          ),
        );
      },
    );
  }

  void showDialogSelectDocType() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                height: 300, // ปรับความสูงของ Popup ตามต้องการ
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // สีของเส้น
                            width: 1.0, // ความหนาของเส้น
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ประเภทเอกสาร',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // เพื่อให้ทำงานร่วมกับ ListView ด้านนอกได้
                            itemCount: dataLovDocType.length,
                            itemBuilder: (context, index) {
                              // ดึงข้อมูลรายการจาก dataCard
                              var item = dataLovDocType[index];

                              // return GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       dataLocator = item['location_code'];
                              //     });
                              //   },
                              //   child: SizedBox(
                              //     child: Text('${item['location_code']}'),
                              //   ),
                              // );
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey, // สีของขอบทั้ง 4 ด้าน
                                      width: 2.0, // ความหนาของขอบ
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        10.0), // ทำให้ขอบมีความโค้ง
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical:
                                          8.0), // เพิ่ม padding ด้านซ้าย-ขวา และ ด้านบน-ล่าง
                                  child: Text(
                                    item['d'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    docTypeLovD = item['d'];
                                    docTypeLovR = item['r'];
                                    dataLovDocTypeController.text = docTypeLovD;
                                    // -----------------------------------------
                                    print(
                                        'dataLovDocTypeController New: $dataLovDocTypeController Type : ${dataLovDocTypeController.runtimeType}');
                                    print(
                                        'docTypeLovD New: $docTypeLovD Type : ${docTypeLovD.runtimeType}');
                                    print(
                                        'docTypeLovR New: $docTypeLovR Type : ${docTypeLovR.runtimeType}');
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )

                    // ช่องค้นหา
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

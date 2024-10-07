import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'SSFGDT09L_form.dart';

class Ssfgdt09lSelectDocType extends StatefulWidget {
  final String pWareCode;
  final String pErpOuCode;
  final String pOuCode;
  final String pAttr1;

  const Ssfgdt09lSelectDocType({
    Key? key,
    required this.pWareCode,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAttr1,
  }) : super(key: key);

  @override
  _Ssfgdt09lSelectDocTypeState createState() => _Ssfgdt09lSelectDocTypeState();
}

class _Ssfgdt09lSelectDocTypeState extends State<Ssfgdt09lSelectDocType> {
  List<dynamic> dataLovDocType = [];
  Map<String, dynamic>? selectedDocTypeItem;
  String docTypeLovD = '';
  String docTypeLovR = '';
  String chkCardName = '';
  String statusChkCreate = '';
  String messageChkCreate = '';
  String poDocType = '';
  String poDocNo = '';

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
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_SelectLovDocType/${widget.pAttr1}'));

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
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_CreateNewINHead';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_ou_code': widget.pOuCode,
      'p_erp_ou_code': widget.pErpOuCode,
      'p_app_session': globals.APP_SESSION,
      'p_ware_code': widget.pWareCode,
      'p_doc_type': docTypeLovR,
      'p_app_user': globals.APP_USER,
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
            }
            if (statusChkCreate == '0') {
              poDocNo = data['po_doc_no'];
              poDocType = data['po_doc_type'];

              print('poDocNo : $poDocNo Type : ${poDocNo.runtimeType}');

              print('poDocType : $poDocType Type : ${poDocType.runtimeType}');

              _navigateToPage(
                  context,
                  Ssfgdt09lForm(
                    pWareCode: widget.pWareCode,
                    pAttr1: widget.pAttr1,
                    pDocNo: poDocNo,
                    pDocType: poDocType,
                    pOuCode: widget.pOuCode,
                    pErpOuCode: widget.pErpOuCode,
                  ));
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
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextFormField(
            controller: dataLovDocTypeController,
            readOnly: true,
            onTap: () => showDialogSelectDocType(),
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              labelText: 'ประเภทเอกสาร',
              labelStyle: const TextStyle(
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
                onPressed: () {
                  chkCreateCard();
                },
                style: AppStyles.ConfirmbuttonStyle(),
                child:
                    Text('CONFIRM', style: AppStyles.ConfirmbuttonTextStyle()),
              ),
            ],
          ),
        ]),
      ),
      bottomNavigationBar: BottomBar(),
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
          title: const Row(
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
          content: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  Text(
                    messageAlert,
                    style: const TextStyle(color: Colors.red),
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
                                      fontWeight: FontWeight.bold,
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

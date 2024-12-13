import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGDT04_FORM.dart';
import '../styles.dart';

class SSFGDT04_TYPE extends StatefulWidget {
  final String pWareCode;
  final String pErpOuCode;

  const SSFGDT04_TYPE({
    super.key,
    required this.pWareCode,
    required this.pErpOuCode,
  });
  @override
  _SSFGDT04_TYPEState createState() => _SSFGDT04_TYPEState();
}

class _SSFGDT04_TYPEState extends State<SSFGDT04_TYPE> {
  TextEditingController docTypeController = TextEditingController();
  List<dynamic> statusItems = [];
  String? pWareCodeCreateNewINXferWMS;
  String? pDocTypeCreateNewINXferWMS;
  String? selectedDocType;
  String? selectedDocDesc;
  bool isNavigating = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchStatusItems();
  }

  Future<void> fetchStatusItems() async {
    final response = await http.get(
        Uri.parse('${gb.IP_API}/apex/wms/SSFGDT04/Step_1_TYPE/${gb.ATTR1}'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      print('Fetched data: $data');
      if (mounted) {
        setState(() {
          statusItems = List<Map<String, dynamic>>.from(data['items'] ?? []);

          // ตั้งค่า selectedDocType ให้เป็นค่าแรกของ statusItems
          if (statusItems.isNotEmpty) {
            selectedDocType = statusItems[0]['doc_type'];
            selectedDocDesc = statusItems[0]['doc_desc'];
            docTypeController.text = selectedDocDesc ?? '';
          }
          print('dataMenu: $statusItems');
        });
      }
    } else {
      throw Exception('Failed to load status items');
    }
  }

  String? poStatus;
  String? poMessage;
  String? po_doc_no;
  String? po_doc_type;

  Future<void> create_NewINXfer_WMS(String? pDocType) async {
    final url = '${gb.IP_API}/apex/wms/SSFGDT04/Step_1_Create_NewINHead';

    final headers = {
      'Content-Type': 'application/json',
    };
    print(pDocType);
    print(gb.P_OU_CODE);
    print(gb.P_ERP_OU_CODE);
    print(gb.APP_SESSION);
    print(gb.APP_USER);

    final body = jsonEncode({
      'P_DOC_TYPE': pDocType,
      'P_WARE_CODE': gb.P_WARE_CODE,
      'P_OU_CODE': gb.P_OU_CODE,
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      'APP_SESSION': gb.APP_SESSION,
      'APP_USER': gb.APP_USER,
    });

    print('headers : $headers Type : ${headers.runtimeType}');
    print('body : $body Type : ${body.runtimeType}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            po_doc_no = responseData['po_doc_no'];
            po_doc_type = responseData['po_doc_type'];
            poStatus = responseData['po_status'];
            poMessage = responseData['po_message'];

            print('po_doc_no : $po_doc_no Type : ${po_doc_no.runtimeType}');
            print(
                'po_doc_type : $po_doc_type Type : ${po_doc_type.runtimeType}');
            print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
            print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
          });
        }
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showDocumentTypePopup() {
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
                            itemCount: statusItems.length,
                            itemBuilder: (context, index) {
                              // ดึงข้อมูลรายการจาก dataCard
                              var item = statusItems[index];
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
                                    item['doc_desc'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // selectedDocType = item['doc_type'];
                                    selectedDocDesc = item['doc_desc'];
                                    docTypeController.text =
                                        selectedDocDesc ?? '';
                                    // -----------------------------------------
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)', showExitWarning: false),
      // backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  readOnly: true, // Make it read-only to prevent keyboard popup
                  onTap: _showDocumentTypePopup, // Show the popup on tap
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'ประเภทเอกสาร',
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 113, 113, 113),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: const TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                  controller: docTypeController,
                  // controller: TextEditingController(text: selectedDocType)
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Check if navigation is already in progress
                        if (isNavigating) return;

                        setState(() {
                          isNavigating =
                              true; // Set the flag to true to indicate navigation is happening
                        });

                        try {
                          // Call function to create a new document
                          await create_NewINXfer_WMS(selectedDocType ?? '');

                          // Check if form is validated
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            // Check poStatus for form navigation
                            if (poStatus == '0') {
                              await create_NewINXfer_WMS(selectedDocType);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SSFGDT04_FORM(
                                    po_doc_no: po_doc_no, // Pass po_doc_no
                                    po_doc_type:
                                        po_doc_type, // Pass po_doc_type
                                    pWareCode: widget.pWareCode,
                                  ),
                                ),
                              );
                            } else if (poStatus == '1') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogStyles.alertMessageDialog(
                                    context: context,
                                    content: Text('$poMessage'),
                                    onClose: () {
                                      Navigator.of(context).pop();
                                    },
                                    onConfirm: () async {
                                      // Handle confirmation actions
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              );
                            }
                          } else {
                            // Show alert message if form is not valid
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogStyles.alertMessageDialog(
                                  context: context,
                                  content: Text('$poMessage'),
                                  onClose: () {
                                    Navigator.of(context).pop();
                                  },
                                  onConfirm: () async {
                                    // Handle confirmation actions
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          }
                        } finally {
                          setState(() {
                            isNavigating =
                                false; // Reset the flag when navigation is done
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}

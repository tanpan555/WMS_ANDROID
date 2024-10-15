import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';

class Ssfgdt09lReason extends StatefulWidget {
  // final String pWareCode;
  final String pOuCode;
  final String pErpOuCode;
  final String pDocNo;
  final String pMoDoNO;
  final String pItemCode;
  final String pQty;
  final String pBarcode;
  final String pLotNo;
  // final String pOuCode;
  // final String pAttr1;
  // final String pAppUser;
  // final String pDocType;
  Ssfgdt09lReason({
    required this.pOuCode,
    required this.pErpOuCode,
    required this.pDocNo,
    required this.pMoDoNO,
    required this.pItemCode,
    required this.pQty,
    required this.pBarcode,
    required this.pLotNo,
    // required this.pWareCode,
    // required this.pOuCode,
    // required this.pDocType,
    // required this.pAttr1,
    // required this.pAppUser,
    Key? key,
  }) : super(key: key);
  @override
  _Ssfgdt09lReasonState createState() => _Ssfgdt09lReasonState();
}

class _Ssfgdt09lReasonState extends State<Ssfgdt09lReason> {
  List<dynamic> dataLovReason = [];
  List<dynamic> dataLovReasonLot = [];
  List<dynamic> dropdownItemsReasonRpLoc = [
    {
      'd': '--No Value Set--',
      'r': 'null',
    },
    {
      'd': 'DF',
      'r': 'DF',
    },
    {
      'd': 'EM',
      'r': 'EM',
    },
    {
      'd': 'EL',
      'r': 'EL',
    },
    {
      'd': 'BM',
      'r': 'BM',
    },
    {
      'd': 'CM',
      'r': 'CM',
    },
  ];

  String reasonLovD = '';
  String reasonLovR = '';
  String reasonRpLocD = '--No Value Set--';
  String reasonRpLocR = 'null';
  String reasonRpLotD = '';
  String reasonRpLotR = '';
  String remark = '';
  String dataNull = 'null';
  String statusSubmit = '';
  String messageSubmit = '';

  bool isLoading = false;

  Map<String, dynamic>? selectedReasonItem;
  Map<String, dynamic>? selectedLotItem;

  TextEditingController remarkController = TextEditingController();
  TextEditingController dataLovReasonController = TextEditingController();
  TextEditingController dataLovReplaceLocationController =
      TextEditingController();
  TextEditingController dataLovReplaceLotController = TextEditingController();

  // String
  @override
  void dispose() {
    remarkController.dispose();
    dataLovReasonController.dispose();
    dataLovReplaceLocationController.dispose();
    dataLovReplaceLotController.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  void initState() {
    // isLoading = true;
    setData();
    selectLovReason();
    selectLovLot();
    // isLoading = false;
    super.initState();
  }

  void setData() {
    if (mounted) {
      setState(() {
        dataLovReplaceLocationController.text = '--No Value Set--';
      });
    }
  }

  Future<void> selectLovReason() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_SelectLovReason'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovReason =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            selectedReasonItem = dataLovReason[0];
            reasonLovD = selectedReasonItem?['d'] ?? '';
            reasonLovR = selectedReasonItem?['r'] ?? '';
            dataLovReasonController.text = reasonLovD;
          });
        }
        print('dataLovReason : $dataLovReason');
      } else {
        throw Exception('dataLovReason Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovReason ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovLot() async {
    try {
      final String endpoint = widget.pItemCode != '' &&
              widget.pItemCode.isNotEmpty
          ? 'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_SelectLovLot/${widget.pOuCode}/${widget.pMoDoNO}/$reasonRpLocR/${widget.pItemCode}'
          : 'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_SelectLovLot/${widget.pOuCode}/${widget.pMoDoNO}/$reasonRpLocR/$dataNull';

      print('Fetching data from: $endpoint');

      final response = await http.get(Uri.parse(endpoint));
      // final response = await http.get(Uri.parse(
      //     'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_SelectLovLot/${widget.pOuCode}/${widget.pMoDoNO}/$reasonRpLocR/${widget.pItemCode}')),

      //     :
      //     final response = await http.get(Uri.parse(
      //     'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_SelectLovLot/${widget.pOuCode}/${widget.pMoDoNO}/$reasonRpLocR/${widget.pItemCode}'));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovReasonLot =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
            selectedLotItem = dataLovReasonLot[0];
            reasonRpLotD = selectedLotItem?['d'] ?? '';
            reasonRpLotR = selectedLotItem?['r'] ?? '';
            dataLovReplaceLotController.text = reasonRpLotD;
          });
        }
        print('dataLovReasonLot : $dataLovReasonLot');
      } else {
        throw Exception(
            'dataLovReasonLot Failed to load fetchData status : ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovReasonLot ERROR IN Fetch Data : $e');
    }
  }

  Future<void> submitAddLine() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_AddLine';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'pErpOuCode': widget.pErpOuCode.isNotEmpty ? widget.pErpOuCode : 'null',
      'pDocNo': widget.pDocNo.isNotEmpty ? widget.pDocNo : 'null',
      'pBarcode': widget.pBarcode.isNotEmpty ? widget.pBarcode : 'null',
      'pItemCode': widget.pItemCode.isNotEmpty ? widget.pItemCode : 'null',
      'pLotNo': widget.pLotNo.isNotEmpty ? widget.pLotNo : 'null',
      'pQty': widget.pQty.isNotEmpty ? widget.pQty : 'null',
      'pReason': reasonLovR.isNotEmpty ? reasonLovR : 'null',
      'pRemark': remark.isNotEmpty ? remark : 'null',
      'pPdLocation': reasonRpLocR.isNotEmpty ? reasonRpLocR : 'null',
      'pReplaceLot': reasonRpLotR.isNotEmpty ? reasonRpLotR : 'null',
    });
    print('Request body: $body');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataSubmit = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataSubmit : $dataSubmit type : ${dataSubmit.runtimeType}');
        if (mounted) {
          setState(() {
            statusSubmit = dataSubmit['po_status'];
            messageSubmit = dataSubmit['po_message'];

            if (statusSubmit == '1') {
              showDialogAlert(context, messageSubmit);
            }
            if (statusSubmit == '0') {
              Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(
        title: 'Reason',
        showExitWarning: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12.0),
                //     ),
                //     minimumSize: const Size(10, 20),
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //   ),
                //   child: const Text(
                //     'Check DATA',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    submitAddLine();
                  },
                  style: AppStyles.ConfirmbuttonStyle(),
                  child: Text(
                    'บันทึก',
                    style: AppStyles.ConfirmbuttonTextStyle(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // --------------------------------------------------------------------------------------------------
            isLoading
                ? Center(child: CircularProgressIndicator())
                : TextFormField(
                    controller: dataLovReasonController,
                    readOnly: true,
                    onTap: () => showDialogSelectLovReason(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Reason',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: dataLovReplaceLocationController,
              readOnly: true,
              onTap: () => showDialogSelectLovReplaceLocation(),
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Replace Location',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromARGB(255, 113, 113, 113),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
              controller: dataLovReplaceLotController,
              readOnly: true,
              onTap: () => showDialogSelectLovReplaceLot(),
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Replace LOT',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromARGB(255, 113, 113, 113),
                ),
              ),
            ),

            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
                controller: remarkController,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Remark',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      remark = value;
                    },
                  );
                }),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
          ]))),
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
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  void showDialogSelectLovReason() {
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
                            'Reason',
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
                            itemCount: dataLovReason.length,
                            itemBuilder: (context, index) {
                              // ดึงข้อมูลรายการจาก dataCard
                              var item = dataLovReason[index];

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
                                    reasonLovD = item['d'];
                                    reasonLovR = item['r'];
                                    dataLovReasonController.text = reasonLovD;
                                    // -----------------------------------------
                                    print(
                                        'dataLovReasonController New: $dataLovReasonController Type : ${dataLovReasonController.runtimeType}');
                                    print(
                                        'reasonLovD New: $reasonLovD Type : ${reasonLovD.runtimeType}');
                                    print(
                                        'reasonLovR New: $reasonLovR Type : ${reasonLovR.runtimeType}');
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

  void showDialogSelectLovReplaceLocation() {
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
                            'Replace Location',
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
                            itemCount: dropdownItemsReasonRpLoc.length,
                            itemBuilder: (context, index) {
                              // ดึงข้อมูลรายการจาก dataCard
                              var item = dropdownItemsReasonRpLoc[index];

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
                                    item['d'].toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    reasonRpLocD = item['d'];
                                    reasonRpLocR = item['r'];
                                    dataLovReplaceLocationController.text =
                                        reasonRpLocD;
                                    // -----------------------------------------
                                    print(
                                        'dataLovReplaceLocationController New: $dataLovReplaceLocationController Type : ${dataLovReplaceLocationController.runtimeType}');
                                    print(
                                        'reasonRpLocD New: $reasonRpLocD Type : ${reasonRpLocD.runtimeType}');
                                    print(
                                        'reasonRpLocR New: $reasonRpLocR Type : ${reasonRpLocR.runtimeType}');
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

  void showDialogSelectLovReplaceLot() {
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
                            'Replace LOT',
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
                            itemCount: dataLovReasonLot.length,
                            itemBuilder: (context, index) {
                              // ดึงข้อมูลรายการจาก dataCard
                              var item = dataLovReasonLot[index];

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
                                    reasonRpLotD = item['d'];
                                    reasonRpLotR = item['r'];
                                    dataLovReplaceLotController.text =
                                        reasonRpLotD;
                                    // -----------------------------------------
                                    print(
                                        'dataLovReplaceLotController New: $dataLovReplaceLotController Type : ${dataLovReplaceLotController.runtimeType}');
                                    print(
                                        'reasonRpLotD New: $reasonRpLotD Type : ${reasonRpLotD.runtimeType}');
                                    print(
                                        'reasonRpLotR New: $reasonRpLotR Type : ${reasonRpLotR.runtimeType}');
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

import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_CREATE.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_SEARCH.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import '../loading.dart';

class SSFGDT17_MENU extends StatefulWidget {
  final String pWareCode;
  final String pWareName;
  final String p_ou_code;

  SSFGDT17_MENU({
    Key? key,
    required this.pWareCode,
    required this.pWareName,
    required this.p_ou_code,
  }) : super(key: key);

  @override
  _SSFGDT17_MENUState createState() => _SSFGDT17_MENUState();
}

class _SSFGDT17_MENUState extends State<SSFGDT17_MENU> {
  bool isLoading = false;
  String errorMessage = '';

  final String cardColor = '#FFFFFF';
  final String imagePath = 'assets/images/search_doc.png';
  final Map<String, String> item = {
    'card_value': 'ค้นหาเอกสาร',
  };

  @override
  void initState() {
    super.initState();
    print('=================================');
    print(gb.ATTR1);
    print('pWareCode: ${widget.pWareCode}');
    print('pWareName: ${widget.pWareName}');
    print('p_ou_code: ${widget.p_ou_code}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'Move Locator', showExitWarning: false),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          return isLoading
              ? Center(child: LoadingIndicator())
              // ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        'Error: $errorMessage',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isPortrait)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(),
                            ),
                          const SizedBox(height: 10),
                          Card(
                            color: Color.fromARGB(255, 231, 231, 231),
                            child: ListTile(
                              leading: Image.asset(
                                'assets/images/search_doc.png',
                                width: 40,
                                height: 40,
                              ),
                              title: Text('ค้นหาเอกสาร',
                                  style: TextStyle(fontSize: 18)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SSFGDT17_SEARCH(
                                      pWareCode: widget.pWareCode,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            color: Color.fromARGB(255, 231, 231, 231),
                            child: ListTile(
                              leading: Image.asset(
                                'assets/images/add_doc.png',
                                width: 40,
                                height: 40,
                              ),
                              title: Text('สร้างเอกสาร',
                                  style: TextStyle(fontSize: 18)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SSFGDT17_CREATE(
                                      pWareCode: widget.pWareCode,
                                      pWareName: widget.pWareName,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
        },
      ),
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}

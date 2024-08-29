import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_CREATE.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/bottombar.dart';
import 'SSFGDT17_MAIN.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: const CustomAppBar(title: 'Move Locator'),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          return isLoading
              ? const Center(child: CircularProgressIndicator())
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
                              child: Column(
                                  // Add your child widgets here
                                  ),
                            ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SSFGDT17_MAIN(pWareCode: widget.pWareCode),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                            ),
                            child: SizedBox(
                              width: double
                                  .infinity, // Make the card fill the screen width
                              child: Card(
                                elevation: 4.0,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        imagePath,
                                        width: 70.0,
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        item['card_value'] ?? 'No Name',
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SSFGDT17_CREATE(pWareCode: widget.pWareCode),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Card(
                                elevation: 4.0,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/add_doc.png',
                                        width: 70.0,
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        'สร้างเอกสาร',
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
        },
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

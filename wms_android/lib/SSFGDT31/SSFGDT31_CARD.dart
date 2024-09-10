import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/bottombar.dart';
import 'dart:convert';

import 'package:wms_android/custom_appbar.dart';

class SSFGDT31_CARD extends StatefulWidget {
  final String soNo;
  final String statusDesc;
  final String wareCode;
  final String? receiveDate;

  SSFGDT31_CARD({required this.soNo, required this.statusDesc, required this.wareCode, this.receiveDate});

  @override
  _SSFGDT31_CARDPageState createState() => _SSFGDT31_CARDPageState();
}

class _SSFGDT31_CARDPageState extends State<SSFGDT31_CARD> {
  List<dynamic> data = [];
  bool isLoading = true;
  String errorMessage = '';
  String? DateSend;
  

  String? nextLink;
  String? prevLink;

  @override
  void initState() {
    super.initState();
    DateSend = widget.receiveDate;
    if (DateSend != null) {
      DateSend = DateSend!.replaceAll('/', '-');
    }
    fetchData();
  }

  Future<void> fetchData([String? url]) async {
    final String apiUrl = url ?? "http://172.16.0.82:8888/apex/wms/SSFGDT31/Card_Test/${widget.soNo}/${widget.statusDesc}/${widget.wareCode}/$DateSend";
    
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(apiUrl);

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);

        setState(() {
          if (parsedResponse is Map && parsedResponse.containsKey('items')) {
            data = parsedResponse['items']; 
          } else {
            data = [];
          }
          
      
          List<dynamic> links = parsedResponse['links'];
          nextLink = getLink(links, 'next');
          prevLink = getLink(links, 'prev');

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: $apiUrl';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching data: $error';
        isLoading = false;
      });
    }
  }

  String? getLink(List<dynamic> links, String rel) {
    final link = links.firstWhere((item) => item['rel'] == rel, orElse: () => null);
    return link != null ? link['href'] : null;
  }

  void _loadNextPage() {
    if (nextLink != null) {
      setState(() {
        isLoading = true;
      });
      fetchData(nextLink);
    }
  }

  void _loadPrevPage() {
    if (prevLink != null) {
      setState(() {
        isLoading = true;
      });
      fetchData(prevLink); 
    }
  }

  Widget buildListTile(BuildContext context, Map<String, dynamic> item) {
 Map<String, Color> statusColors = {
  'ยืนยันการรับ': const Color.fromARGB(255, 146, 208, 80),
  'ระหว่างบันทึก': const Color.fromARGB(255, 246, 250, 112),
  'ยกเลิก': const Color.fromARGB(255, 208, 206, 206),
};

String iconImageYorN;

switch (item['qc_yn']) {
                    case 'Y':
                      iconImageYorN = 'assets/images/rt_machine_on.png';
                      break;
                    case 'N':
                      iconImageYorN = 'assets/images/rt_machine_off.png';
                      break;
                    default:
                      iconImageYorN = 'assets/images/rt_machine_off.png';
                  }

  Color statusColor = statusColors[item['card_status_desc']] ?? Colors.white;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    child:  Card(
  elevation: 8.0,
  margin: const EdgeInsets.symmetric(vertical: 8.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
  color: const Color.fromRGBO(204, 235, 252, 1.0),
  child: InkWell(
    onTap: () {
      // Add your onTap logic here
    },
    borderRadius: BorderRadius.circular(15.0),
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // Add logic if needed for the printer icon tap
                },
                child: Container(
                  width: 100,
                  height: 40,
                  child: Image.asset(
                    'assets/images/printer.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                '${item['po_date']} ${item['po_no']} ${item['item_stype_desc']}',
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        // Positioned widget for status and QC icon
        Positioned(
          top: 8.0,
          right: 8.0,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: statusColor, // Use the color from the map
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: statusColor, width: 2.0),
                ),
                child: Text(
                  item['card_status_desc'] ?? 'Unknown',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                width: 100,
                height: 40,
                child: Image.asset(
                  iconImageYorN,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
  );
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF17153B),
    appBar: const CustomAppBar(title: 'Move Locator'),
    body: OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (isPortrait)
                const SizedBox(height: 4),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                        ? Center(
                            child: Text(
                              'Error: $errorMessage',
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : data.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Data Available',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : ListView(
                                children: [
                                  // Build the list items
                                  ...data.map((item) => buildListTile(context, item)).toList(),
                                  // Add spacing if needed
                                  const SizedBox(height: 10),
                                  // Previous and Next buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: prevLink != null ? _loadPrevPage : null,
                                        child: const Text('Previous'),
                                      ),
                                      ElevatedButton(
                                        onPressed: nextLink != null ? _loadNextPage : null,
                                        child: const Text('Next'),
                                      ),
                                    ],
                                  ),
                                ],
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

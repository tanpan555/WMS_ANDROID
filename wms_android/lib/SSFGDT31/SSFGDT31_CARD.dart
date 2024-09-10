import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  @override
void initState() {
  super.initState();
  DateSend = widget.receiveDate;
  if (DateSend != null) {
    DateSend = DateSend!.replaceAll('/', '-');
    fetchData();
  }
  print(DateSend);
}


 Future<void> fetchData() async {
  final String apiUrl = "http://172.16.0.82:8888/apex/wms/SSFGDT31/Card_Test/${widget.soNo}/${widget.statusDesc}/${widget.wareCode}/$DateSend";
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
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = 'Failed to load data $apiUrl;';
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


  int _displayLimit = 15;
  final ScrollController _scrollController = ScrollController();

  void _loadMoreItems() {
    setState(() {
      _displayLimit += 15;
    });
  }

Widget buildListTile(BuildContext context, Map<String, dynamic> item) {
  Map<String, Color> statusColors = {
    'ยกเลิก': Colors.orange,
    'รับโอน': Colors.blue,
    'ปกติ': Colors.green,
  };

  Color statusColor = statusColors[item['card_status_desc']] ?? Colors.grey;

  TextStyle statusStyle = TextStyle(
    color: statusColor,
    fontWeight: FontWeight.bold,
  );

  BoxDecoration statusDecoration = BoxDecoration(
    border: Border.all(color: statusColor, width: 2.0),
    borderRadius: BorderRadius.circular(4.0),
  );

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    child: Card(
      color: const Color.fromRGBO(204, 235, 252, 1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5,
      child: Column(
        children: [
          ListTile(
            title: Center(
              child: Text(
                item['ap_name'] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      if (item['card_status_desc'] != null)
                        WidgetSpan(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            decoration: statusDecoration,
                            child: Text(
                              item['card_status_desc'] ?? 'No Status',
                              style: statusStyle,
                            ),
                          ),
                        ),
                      const TextSpan(
                        text: '\n \n',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      TextSpan(
                        text: '${item['po_date'] ?? 'No Date'} ${item['po_no']?? ''} ${item['item_stype_desc'] ?? 'No Item Type'}',
                        style: const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'รับคืนจากการเบิกผลิต'),
      backgroundColor: const Color(0xFF17153B),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          return isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text('Error: $errorMessage ',style: TextStyle(color: Colors.white),))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          if (isPortrait) const SizedBox(height: 4),
                          Expanded(
                            child: data.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No Data Available',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : ListView.builder(
                                    controller: _scrollController,
                                    itemCount: (_displayLimit < data.length)
                                        ? _displayLimit + 1
                                        : data.length,
                                    itemBuilder: (context, index) {
                                      if (index == _displayLimit) {
                                        return Center(
                                          child: ElevatedButton(
                                            onPressed: _loadMoreItems,
                                            child: const Text('แสดงเพิ่มเติม'),
                                          ),
                                        );
                                      }
                                      if (index < data.length) {
                                        final item = data[index];
                                        return buildListTile(context, item);
                                      }
                                      return Container();
                                    },
                                  ),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
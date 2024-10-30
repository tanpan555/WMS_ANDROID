import 'package:flutter/material.dart';
import 'ICON.dart';

class CustomContainerStyles {
  static Container styledContainer(String? itemValue,
      {double padding = 5.0, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: (itemValue != null && itemValue.trim().isNotEmpty)
            ? Colors.white
            : Colors.transparent,
      ),
      child: child,
    );
  }
}
// -----------------------------------------------------------------------------------

class AppStyles {
  static ButtonStyle ConfirmbuttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 212, 245, 212),
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  static TextStyle ConfirmbuttonTextStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static ButtonStyle cancelButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      minimumSize: const Size(70, 40),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }

  static ButtonStyle createButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.green, // Green background for the button
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // Rounded rectangle border
        side: const BorderSide(color: Colors.white, width: 2), // White outline
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5), // Padding to control button size
      minimumSize: const Size(80, 45), // Button size can be adjusted
    );
  }

  static ButtonStyle ClearButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.red, // Red background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // Rounded rectangle border
        side: const BorderSide(color: Colors.white, width: 2), // White outline
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5), // Padding for button size
      minimumSize: const Size(80, 45), // Button size
    );
  }

  static TextStyle CancelbuttonTextStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static ButtonStyle NextButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(60, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle CheckButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(60, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle ConfirmChecRecievekButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.green, width: 2),
      ),
      minimumSize: const Size(60, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle EraserButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minimumSize: const Size(100, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle SearchButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minimumSize: const Size(100, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle PreviousButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(90, 35),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle NextRecordDataButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(90, 35),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle DisablePreviousButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 23, 21, 59),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(90, 35),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle DisableNextRecordDataButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 23, 21, 59),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(90, 35),
      padding: const EdgeInsets.all(0),
    );
  }
}
// ----------------------------------------------------------------------------------- ButtonStyles  Previous & Next

class ButtonStyles {
  static final ButtonStyle nextButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(90, 35),
    padding: const EdgeInsets.all(0),
  );

  static Widget nextButtonContent() {
    return const Row(
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
          MyIcons.arrow_forward_ios_rounded,
          color: Colors.black,
          size: 20.0,
        ),
      ],
    );
  }

  static final ButtonStyle previousButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(90, 35),
    padding: const EdgeInsets.all(0),
  );

  static final Widget previousButtonContent = Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        MyIcons.arrow_back_ios_rounded,
        color: Colors.black,
        size: 20.0,
      ),
      const SizedBox(width: 7),
      const Text(
        'Previous',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    ],
  );

  static final ButtonStyle disableNextButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 23, 21, 59),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(90, 35),
    padding: const EdgeInsets.all(0),
  );

  static Widget disableNextButtonContent() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Next',
          style: TextStyle(
            color: Color.fromARGB(255, 23, 21, 59),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        SizedBox(width: 7),
        Icon(
          MyIcons.arrow_forward_ios_rounded,
          color: Color.fromARGB(255, 23, 21, 59),
          size: 20.0,
        ),
      ],
    );
  }

  static final ButtonStyle disablePreviousButtonStyle =
      ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 23, 21, 59),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(90, 35),
    padding: const EdgeInsets.all(0),
  );

  static final Widget disablePreviousButtonContent = Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        MyIcons.arrow_back_ios_rounded,
        color: Color.fromARGB(255, 23, 21, 59),
        size: 20.0,
      ),
      const SizedBox(width: 7),
      const Text(
        'Previous',
        style: TextStyle(
          color: Color.fromARGB(255, 23, 21, 59),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    ],
  );
}
// ----------------------------------------------------------------------------------- DialogStyles

class DialogStyles {
  // ---------------------------------------------------------------------  dialog แจ้งเตือนย้อนกลับ
  static AlertDialog warningNotSaveDialog(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Row(
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
                icon: const Icon(MyIcons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
      content: const Text('คุณต้องการออกจากหน้านี้โดยไม่บันทึกหรือไม่?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 4),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('OK'),
            ),
          ],
        )
      ],
    );
  }
  // ElevatedButton(
  // onPressed: () {
  //   showDialog(
  //     context: context,
  //     builder: (context) => DialogStyles.exitConfirmationDialog(context),
  //   );
  // },
  // child: const Text('Show Dialog'),
  // ---------------------------------------------------------------------  alertMessageDialog

  static AlertDialog alertMessageDialog({
    required BuildContext context,
    required Widget content,
    required VoidCallback onClose,
    required VoidCallback onConfirm,
  }) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
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
                icon: const Icon(MyIcons.close),
                onPressed: onClose,
              ),
            ],
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('ตกลง'),
            ),
          ],
        ),
      ],
    );
  }

// ----------------------------------------------------------------------

  static Dialog customLovSearchDialog({
    required BuildContext context,
    required String? headerText,
    required TextEditingController searchController,
    required List<dynamic> data,
    required String Function(dynamic item) docString,
    required String Function(Map<String, dynamic> item) titleText,
    required String Function(Map<String, dynamic> item) subtitleText,
    required void Function(Map<String, dynamic> item) onTap,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 300, // ปรับความสูงตามต้องการ
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      headerText.toString(),
                      style: const TextStyle(
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
                const SizedBox(height: 10),
                // ช่องค้นหา
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'ค้นหา',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) {
                    setState(() {}); // อัปเดตข้อมูลเมื่อมีการค้นหา
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final filteredItems = data.where((item) {
                        final docValue = docString(item).toLowerCase();
                        final searchQuery =
                            searchController.text.trim().toLowerCase();
                        return docValue.contains(searchQuery);
                      }).toList();

                      if (filteredItems.isEmpty) {
                        return const Center(
                          child: Text('No data found'),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              titleText(item),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(subtitleText(item)),
                            onTap: () => onTap(item),
                          );
                        },
                      );
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

  static Dialog customRequiredLovSearchDialog({
    required BuildContext context,
    required String headerText, // ปรับเป็น String
    required TextEditingController searchController,
    required List<dynamic> data,
    required String Function(dynamic item) docString,
    required String Function(Map<String, dynamic> item) titleText,
    required String Function(Map<String, dynamic> item) subtitleText,
    required void Function(Map<String, dynamic> item) onTap,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: headerText,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                        searchController.clear();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'ค้นหา',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) {
                    setState(() {}); // อัปเดตข้อมูลเมื่อมีการค้นหา
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final filteredItems = data.where((item) {
                        final docValue = docString(item).toLowerCase();
                        final searchQuery =
                            searchController.text.trim().toLowerCase();
                        return docValue.contains(searchQuery);
                      }).toList();

                      if (filteredItems.isEmpty) {
                        return const Center(
                          child: Text('No data found'),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              titleText(item),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(subtitleText(item)),
                            onTap: () => onTap(item),
                          );
                        },
                      );
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

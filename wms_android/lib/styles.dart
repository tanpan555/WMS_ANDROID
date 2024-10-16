import 'package:flutter/material.dart';

// class CustomContainerStyles {
//   // สร้าง style สำหรับ Container พร้อม padding
//   static Container styledContainer(String? itemValue,
//       {double padding = 5.0, required Widget child}) {
//     return Container(
//       padding: EdgeInsets.all(padding), // ใช้ค่าจากพารามิเตอร์ padding
//       decoration: BoxDecoration(
//         color: itemValue != null && itemValue.isNotEmpty
//             ? Colors.white // พื้นหลังสีขาวเมื่อมีข้อมูล
//             : Colors.transparent, // พื้นหลังโปร่งใสเมื่อไม่มีข้อมูล
//       ),
//       child: child, // เนื้อหาภายใน Container
//     );
//   }
// }

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
}

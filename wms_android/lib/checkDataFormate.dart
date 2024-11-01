import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class DateInputFormatter extends TextInputFormatter {
//   ValueNotifier<bool> noDateNotifier = ValueNotifier<bool>(false);
//   String day = '';
//   String month = '';
//   String year = '';

//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     String text = newValue.text;
//     text = text.replaceAll(RegExp(r'[^0-9]'), '');
//     int cursorPosition = newValue.selection.baseOffset;
//     int additionalOffset = 0;

//     if (text.length == 6) {
//       text =
//           '${text.substring(0, 1)}/${text.substring(1, 3)}/${text.substring(3, 6)}';
//       day = text.substring(0, 1);
//       month = text.substring(2, 4);
//       year = text.substring(5, 8);
//       noDateNotifier.value = !isValidDate(day, month, year);
//     } else if (text.length == 7) {
//       text = text.replaceAll('/', '');
//       noDateNotifier.value = true;
//     } else if (text.length == 8) {
//       text =
//           '${text.substring(0, 2)}/${text.substring(2, 4)}/${text.substring(4, 8)}';
//       day = text.substring(0, 2);
//       month = text.substring(3, 5);
//       year = text.substring(6, 8);
//       noDateNotifier.value = !isValidDate(day, month, year);
//     } else if (text.length > 1 || text.length < 6) {
//       noDateNotifier.value = true;
//     } else {
//       noDateNotifier.value = false;
//     }

//     return TextEditingValue(
//       text: text,
//       selection:
//           TextSelection.collapsed(offset: cursorPosition + additionalOffset),
//     );
//   }

//   bool isValidDate(String day, String month, String year) {
//     int dayInt = int.parse(day);
//     int monthInt = int.parse(month);
//     int yearInt = int.parse(year);

//     if (monthInt < 1 || monthInt > 12) {
//       return false;
//     }

//     List<int> daysInMonth = [
//       31,
//       isLeapYear(yearInt) ? 29 : 28,
//       31,
//       30,
//       31,
//       30,
//       31,
//       31,
//       30,
//       31,
//       30,
//       31
//     ];
//     int maxDays = daysInMonth[monthInt - 1];

//     if (dayInt < 1 || dayInt > maxDays) {
//       return false;
//     }

//     return true;
//   }

//   bool isLeapYear(int year) {
//     if (year % 4 == 0) {
//       if (year % 100 == 0) {
//         if (year % 400 == 0) {
//           return true;
//         } else {
//           return false;
//         }
//       } else {
//         return true;
//       }
//     } else {
//       return false;
//     }
//   }
// }

class DateInputFormatter extends TextInputFormatter {
  ValueNotifier<bool> noDateNotifier = ValueNotifier<bool>(false);
  String day = '';
  String month = '';
  String year = '';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    text = text.replaceAll(RegExp(r'[^0-9]'), '');
    int cursorPosition = newValue.selection.baseOffset;
    int additionalOffset = 0;

    if (text.isEmpty) {
      noDateNotifier.value = false;
    } else if (text.length <= 7) {
      text = text.replaceAll('/', '');
      noDateNotifier.value = true;
    } else if (text.length == 8) {
      text =
          '${text.substring(0, 2)}/${text.substring(2, 4)}/${text.substring(4, 8)}';
      day = text.substring(0, 2);
      month = text.substring(3, 5);
      year = text.substring(6, 8);
      noDateNotifier.value = !isValidDate(day, month, year);
    } else {
      noDateNotifier.value = false;
    }
    print('data text : $text');

    return TextEditingValue(
      text: text,
      selection:
          TextSelection.collapsed(offset: cursorPosition + additionalOffset),
    );
  }

  bool isValidDate(String day, String month, String year) {
    int dayInt = int.parse(day);
    int monthInt = int.parse(month);
    int yearInt = int.parse(year);

    if (monthInt < 1 || monthInt > 12) {
      return false;
    }

    List<int> daysInMonth = [
      31,
      isLeapYear(yearInt) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    int maxDays = daysInMonth[monthInt - 1];

    if (dayInt < 1 || dayInt > maxDays) {
      return false;
    }

    return true;
  }

  bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}

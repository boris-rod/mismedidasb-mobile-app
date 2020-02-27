import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mismedidasb/res/values/config.dart';

class CalendarUtils {
//  static String simpleFormat = "EEE, dd MMM yyyy";
  static String sample_1 = "MMM dd, yyyy";

//  static String sample_2 = "dd.MM.yy";
//  static String sample_3 = "MM/dd/yy";
  static String getTimeIdBasedSeconds() {
    final DateTime now = DateTime.now();
    return "${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}";
  }

  static String getTimeIdBasedDay() {
    final DateTime now = DateTime.now();
    return "${now.year}_${now.month}_${now.day}}";
  }

  static bool isWeekEnd(DateTime datetime) {
    return datetime.weekday == DateTime.saturday ||
        datetime.weekday == DateTime.sunday;
  }

  static bool isToDayOrAfter(DateTime datetime1, DateTime datetime2) {
    return isSameDay(datetime1, datetime2) || datetime1.isAfter(datetime2);
  }

  static bool isBeforeToDay(DateTime datetime1, DateTime datetime2) {
    return !isSameDay(datetime1, datetime2) && datetime1.isBefore(datetime2);
  }

  static bool isSameDay(DateTime datetime1, DateTime datetime2) {
    return isSameMonth(datetime1, datetime2) && datetime1.day == datetime2.day;
  }

  static bool isSameMonth(DateTime datetime1, DateTime datetime2) {
    return isSameYear(datetime1, datetime2) &&
        datetime1.month == datetime2.month;
  }

  static bool isSameYear(DateTime datetime1, DateTime datetime2) {
    return datetime1.year == datetime2.year;
  }

  static String showInFormat(String dateFormat, DateTime datetime) {
    DateFormat formatter = DateFormat(dateFormat, AppConfig.localeCode);
    return formatter.format(datetime);
  }

  static int compare(DateTime datetime1, DateTime datetime2) {
    if (datetime1.year != datetime2.year) {
      return datetime1.year > datetime2.year ? 1 : -1;
    } else if (datetime1.month != datetime2.month) {
      return datetime1.month > datetime2.month ? 1 : -1;
    } else if (datetime1.day != datetime2.day) {
      return datetime1.day > datetime2.day ? 1 : -1;
    } else
      return 0;
  }

  static DateTime getNewest(DateTime datetime1, DateTime datetime2) {
    final comp = compare(datetime1, datetime2);
    if (comp == 1)
      return datetime1;
    else
      return datetime2;
  }

  static DateTime getDateFromString(String strDate) {
    try {
      final dayStr = strDate.substring(0, 2);
      final monthStr = strDate.substring(3, 6);
      final yearStr = strDate.substring(7, 11);

      final day = int.tryParse(dayStr);
      final month = getMonthFromString(monthStr);
      final year = int.tryParse(yearStr);

      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }

  static int getMonthFromString(String month) {
    switch (month) {
      case "Jan":
        return 1;
      case "Feb":
        return 2;
      case "Mar":
        return 3;
      case "Apr":
        return 4;
      case "May":
        return 5;
      case "Jun":
        return 6;
      case "Jul":
        return 7;
      case "Aug":
        return 8;
      case "Sep":
        return 9;
      case "Oct":
        return 10;
      case "Nov":
        return 11;
      case "Dec":
        return 12;
    }
    return 1;
  }
}

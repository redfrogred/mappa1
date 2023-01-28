// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import './Config.dart';

class Utils {

  // timestamp stuff
  static int beginTimeStamp = DateTime.now().millisecondsSinceEpoch;

  static int getBeginTimeStamp() {
    return beginTimeStamp;
  }

  static int timeStamp () {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String timeDiff () {
    int diff = timeStamp() - getBeginTimeStamp();
    double diffNum = 0;
    if (diff < 0) {
      diffNum = 0;
    }
    else {
      diffNum = diff * .001;
    }
    return diffNum.toStringAsFixed(1) + ' sec';
  }

  //  return a simplified version of Config.appVersion
  //  Example: "1.0.a.003" becomes "1.0"
  static String getSimpleVersion () {
    final splitted = Config.appVersion.split('.');
    // return splitted[0] + '.' + splitted[1];
    return Config.appVersion;
  }


  //  The "log" accepts 3 parameters, the later 2 optional:
  //    1 - the String message to "log"
  //    2 - (optional) an int for "# of greater than signs" (2 is default)
  //    3 - (optional) a bool for "highlight" ("false" is default)  
  //
  //    If it is highlighted, it puts ""============" before and after...
  static void log(String message, [ int num = 2, bool highlight = false ]){
    
    List<String> start = [
      '',
      '> ',
      '>> ',
      '>>> '      
    ];

    // show highlighted?
    if ( highlight == true ) {
      if (kDebugMode) {
        print('${ start[num] } ====================================================');
      }
      Config.log += '${ start[num] } ================================\n';
    }

    // print the message
      if (kDebugMode) {
        print('${ start[num] } (${ timeDiff() }) $message');
      }
      Config.log += '${ start[num] } (${ timeDiff() }) $message\n';

    // show highlighted?
    if ( highlight == true ) {
      if (kDebugMode) {
        print('${ start[num] } ====================================================');
      }
      Config.log += '${ start[num] } ================================\n';
    }


  }

  static void clearLog() {
    Config.log = '';
  }

}
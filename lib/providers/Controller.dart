// ignore_for_file: prefer_conditional_assignment, file_names

import 'package:flutter/material.dart';
import '../classes/Config.dart';
import '../classes/Utils.dart';

class Controller with ChangeNotifier {

  Controller () {
    // Utils.log('( $_fileName ) class initialized (v.${ _version.toString() })'); 
    Utils.log('( Controller.dart ) class initialized)'); 
  }

}

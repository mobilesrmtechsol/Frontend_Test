import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static Future<bool> checkInternet() async {
    var connectivityResult  = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile) {
      print('Network mobile');
      return true;
    }
    else if(connectivityResult == ConnectivityResult.wifi) {
      print('Network wifi ');
      return true;
    }
    print('No network');
    return false;
  }

  static showToast(String msg) {
    Fluttertoast.showToast(msg: msg , toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
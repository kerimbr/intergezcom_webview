import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intergez_webview/home_page.dart';
import 'package:intergez_webview/no_network.dart';


class SplassScreen extends StatefulWidget {
  @override
  _SplassScreenState createState() => _SplassScreenState();
}

class _SplassScreenState extends State<SplassScreen> {


  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  bool isOnline=false;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  Widget build(BuildContext context) {


    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        setState(() {
          isOnline = false;

        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          isOnline = true;

        });
        break;
      case ConnectivityResult.wifi:
        setState(() {
          isOnline = true;
        });
    }



    return Scaffold(
      backgroundColor: Color(0xffB03242),
      body: FutureBuilder(
        future: _check(),
        builder: (c,ss){
          if(ss.hasData){
            if(isOnline) {
              return HomePage();
            }else{
              return NoNetwork();
            }
          }else{
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120,
                        height: 80,
                        child: Image.asset(
                          "assets/ig_logo.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(height: 80),

                      Container(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                     /* SizedBox(height: 20),
                      Text(
                          "İnternet Bağlantısı Kontrol Ediliyor...",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      SizedBox(height: 10),*/
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 30
                    ),
                    child: Container(
                      width: 110,
                      height: 40,
                      child: Image.asset(
                        "assets/intergez_logo.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Future<bool> _check() async{
    await Future.delayed(Duration(seconds: 3));
    return isOnline;
  }

}



class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
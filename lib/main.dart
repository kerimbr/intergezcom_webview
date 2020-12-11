import 'package:flutter/material.dart';
import 'package:intergez_webview/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();


  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.init(
      "b01aac9f-4dfe-47f8-b729-7bad50de81e3",
      iOSSettings: {
        OSiOSSettings.autoPrompt: false,
        OSiOSSettings.inAppLaunchUrl: false
      }
  );
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);



  runApp(InterGezApp());
}



class InterGezApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return RestartWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.white,
          primaryColor: Color(0xffB03242),
          primarySwatch: Colors.red,
          canvasColor: Colors.grey.shade900
        ),
        home: SplassScreen(),
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
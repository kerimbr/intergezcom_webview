import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String url = "https://www.intergez.com/";

  InAppWebViewController webView;
  double progress = 0;

  bool searchPanel = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () async{
        if(await webView.getUrl() == url){
          SystemNavigator.pop();
          return false;
        }
        webView.goBack();
        return false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          endDrawer: _buildDrawer(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(46),
            child: AppBar(
              backgroundColor: Color(0xffB03242),
              title: Text(
                  "İnterGez.com",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  CupertinoIcons.back
                ),
                onPressed: ()async{
                  print(await webView.getUrl());
                  if(await webView.getUrl() == url){
                    SystemNavigator.pop();
                  }
                  webView.goBack();
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(
                      AntDesign.home
                  ),
                  onPressed: ()async{
                    await webView.loadUrl(url: "https://www.intergez.com/");
                  },
                ),
                IconButton(
                  icon: Icon(
                      Icons.search
                  ),
                  onPressed: (){
                    setState(() {
                      searchPanel = !searchPanel;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                      MaterialCommunityIcons.reload
                  ),
                  onPressed: (){
                    webView.reload();
                  },
                ),
                IconButton(
                  icon: Icon(
                      Icons.menu
                  ),
                  onPressed: (){
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ],
            ),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                InAppWebView(
                  initialUrl: url,
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        debuggingEnabled: false,
                        useOnDownloadStart: true,
                      )
                  ),

                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },

                  onDownloadStart: (controller, url) async {
                    print("onDownloadStart $url");
                    final taskId = await FlutterDownloader.enqueue(
                      url: url,
                      savedDir: (await getExternalStorageDirectory()).path,
                      showNotification: true, // show download progress in status bar (for Android)
                      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                    );
                  },
                  onLoadStart: (InAppWebViewController controller, String currentURL) async {
                    if(currentURL.contains("intergez.com")) {

                    }else{
                      showModalBottomSheet(
                          context: context,
                          elevation: 5,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(),
                                            ),
                                            Expanded(
                                                child: Container(
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30),
                                                      color: Colors.grey.shade500),
                                                )),
                                            Expanded(
                                              child: Container(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "Harici Bir Bağlantı Algılandı",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.grey.shade400,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Bağlantı",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade300,
                                                  fontWeight: FontWeight.w400,
                                                  decoration: TextDecoration.underline
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 14),
                                            child: Text(
                                              "$currentURL",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w200
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        ListTile(
                                          title: Text(
                                            "Tarayıcıda Görüntüle",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade200,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                          onTap: (){
                                            _launchURL(currentURL);
                                          },
                                          leading: Icon(
                                            Foundation.web,
                                            color: Colors.pinkAccent,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            "Bağlantı Adresini Kopyala",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade200,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                          onTap: (){
                                            Clipboard.setData(
                                              new ClipboardData(text: "$currentURL"),
                                            );
                                            Navigator.pop(context);
                                            _scaffoldKey.currentState.showSnackBar(
                                                SnackBar(
                                                  content: Text("Kopyalandı"),
                                                  behavior: SnackBarBehavior.floating,
                                                  backgroundColor: Colors.orange,
                                                )
                                            );
                                          },
                                          leading: Icon(
                                            Entypo.copy,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            "Vazgeç",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade200,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          leading: Icon(
                                            CupertinoIcons.back,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(32),
                                        topLeft: Radius.circular(32),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          });
                      await webView.goBack();
                    }
                  },
                  onProgressChanged: (InAppWebViewController controller, int progress){
                    if(progress>75){
                      setState(() {
                        this.progress = progress/100;
                      });
                    }
                  },
                ),
                Positioned.fill(
                  child: Visibility(
                    visible: progress< 1.0,
                    child: Center(
                      child: CupertinoActivityIndicator(
                        radius: 18,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child:  Visibility(
                      visible: progress < 1.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 4,
                        child: LinearProgressIndicator(
                          value: progress,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                        ),
                      )
                  ),
                ),
                Visibility(
                  visible: searchPanel,
                  child: Positioned(
                    top: 4,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      child: Card(
                        color: Colors.grey.shade900,
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(),
                                ),
                                Expanded(
                                    child: Container(
                                      height: 5,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.grey.shade500),
                                    )),
                                Expanded(
                                  child: Container(),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:16),
                                  child: Text(
                                    "Arama Yap",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Entypo.circle_with_cross,
                                      color: Colors.grey,
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        searchPanel = false;
                                      });
                                    },
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:16),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey.shade300
                                ),
                                textInputAction: TextInputAction.search,
                                onFieldSubmitted: (value) async{
                                  setState(() {
                                    searchPanel = false;
                                  });
                                  await webView.loadUrl(url: "https://www.intergez.com/?s=$value");

                                },
                                decoration: InputDecoration(
                                  hintText: "Arama Yap...",
                                  hintStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 30,
                                    color: Colors.grey.shade300,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffB03242)
                                    )
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffB03242)
                                      )
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffB03242)
                                      )
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffB03242)
                                      )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffB03242)
                                      )
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffB03242)
                                      )
                                  )
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );

  }


  Drawer _buildDrawer() {
    return Drawer(
      child: Container(
        child: ListView(
          children: [
            Container(
              width: 160,
              height: 200,
              color: Color(0xffB03242),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/drawer_logo.png"),
                      fit: BoxFit.contain
                    )
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                await webView.loadUrl(url: "https://www.intergez.com/");
                Navigator.pop(context);
              },
              title: Text(
                "Ana Sayfa",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w400
                ),
              ),
              leading: Icon(
                AntDesign.home,
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: ()async{
                await webView.loadUrl(url: "https://www.intergez.com/hakkimizda");
                Navigator.pop(context);
              },
              title: Text(
                "Hakkımızda",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w400
                ),
              ),
              leading: Icon(
              CupertinoIcons.info,
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: ()async{
                await webView.loadUrl(url: "https://www.intergez.com/iletisim");
                Navigator.pop(context);
              },
              title: Text(
                "İletişim",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w400
                ),
              ),
              leading: Icon(
                Icons.call,
                color: Colors.white,
              ),
            ),
            Divider(
              color: Colors.grey.shade800,
            ),
            // Facebook
            ListTile(
              onTap: (){
                _launchURL("https://www.facebook.com/intergezcom");
              },
              title: Text(
                "Facebook",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w400
                ),
              ),
              leading: Icon(
                Feather.facebook,
                color: Color(0xff3b5998),
              ),
            ),
            // Twitter
            ListTile(
              onTap: (){
                _launchURL("https://twitter.com/intergezcom");
              },
              title: Text(
                "Twitter",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w400
                ),
              ),
              leading: Icon(
                Feather.twitter,
                color: Color(0xff1DA1F2),
              ),
            ),
            // Instagram
            ListTile(
              onTap: (){
                _launchURL("https://www.instagram.com/intergezcom/");
              },
              title: Text(
                "Instagram",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w400
                ),
              ),
              leading: Icon(
                Feather.instagram,
                color: Color(0xffC13584),
              ),
            ),
            // Youtube
            ListTile(
              onTap: (){
                _launchURL("https://www.youtube.com/channel/UCT0-y0be36W85pOJnGWX7Fw");
              },
              title: Text(
                "Youtube",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w400
                ),
              ),
              leading: Icon(
                Feather.youtube,
                color: Colors.red,
              ),
            ),

            Divider(
              color: Colors.grey.shade800,
            ),

            ListTile(
              onTap: (){
                _launchURL("mailto://iletisim@intergez.com");
              },
              title: Text(
                "Bize Ulaşın",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey
                ),
              ),
              subtitle: Text(
                "iletisim@intergez.com",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.orangeAccent
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

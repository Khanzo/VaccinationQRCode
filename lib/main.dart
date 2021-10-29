import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'connect.dart';
import 'qrread.dart';
import 'repo.dart';
import 'resources.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  InAppWebViewController _webViewController;
  String url = "";
  bool cod = false;
  bool web = false;
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.mainTitle),
        ),
        body: Container(
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(15.0),
              child: Text(url, softWrap: true, maxLines: 4)
            ),
            if (web)
              Container(
                  padding: EdgeInsets.all(5.0),
                  child: progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : SizedBox.shrink()
              ),
            if(web == cod)
              Expanded(
                child: Image(image: AssetImage('images/logo.png'))
              ),
            if (web)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                  child: InAppWebView(
                      initialUrl: url,
                      initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            debuggingEnabled: true,
                          )
                      ),
                      onWebViewCreated: (InAppWebViewController controller) {
                        _webViewController = controller;
                      },
                      onLoadStop: (InAppWebViewController controller, String url) async {
                        setState(() {
                          this.url = url;
                        });
                      },
                      onProgressChanged: (InAppWebViewController controller, int progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                    ),
                ),
              ),
            if(cod)
              Expanded(
                child: QRViewRead()
              ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonMinWidth: 100.0,
              children: <Widget>[
                RaisedButton(
                  child: Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    setState(() {
                      this.cod = true;
                      this.web = false;
                      this.url = '';
                      delCode();
                    });
                  },
                ),
                RaisedButton(
                  child: Icon(Icons.web),
                  onPressed: () {
                    readCode().then((value){
                      if(value != null) {
                        if(value.toLowerCase().indexOf(Strings.verifyUrl) != -1) {
                          NetworkCheck().check().then((intenet) {
                            if(intenet) {
                              NetworkCheck().checkYandex().then((connect) {
                                if(connect) {
                                  setState(() {
                                    this.web = true;
                                    this.cod = false;
                                    this.url = value.toLowerCase();
                                  });
                                  if (_webViewController != null) {
                                    _webViewController.reload();
                                  }
                                } else {
                                  setState(() {
                                    this.url = Strings.noInternet;
                                  });
                                }
                              });
                            } else {
                              setState(() {
                                this.url = Strings.noConnect;
                              });
                            }
                          });
                        } else {
                          setState(() {
                            this.web = false;
                            this.cod = false;
                            this.url =Strings.errorUrl;
                          });
                          delCode();
                        }
                      }
                    });
                  },
                ),
                if(web)
                  RaisedButton(
                    child: Icon(Icons.refresh),
                    onPressed: () {
                       if (_webViewController != null) {
                         _webViewController.reload();
                       }
                    },
                  ),
              ]
            ),
          ],
          ),
        ),
      ),
    );
  }

  Future<String>readCode() async{
    final repo = QRepo();
    return repo.getUrlCode();
  }

  delCode() {
    final repo = QRepo();
    return repo.removeUrlCode();
  }
}

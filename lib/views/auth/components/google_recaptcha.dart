import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../utils/app_config.dart';
import '../../../utils/device_info.dart';

class Captcha extends StatefulWidget {
  Function callback;
  Function? handleCaptcha;
  bool isIOS;


  Captcha(this.callback,{this.handleCaptcha,this.isIOS=false});

  @override
  State<StatefulWidget> createState() {
    return CaptchaState();
  }
}

class CaptchaState extends State<Captcha> {
  final WebViewController _webViewController = WebViewController();
  double zoomValue =2;

  @override
  initState() {
    google_recaptcha();
    print("Called Successfully");
    if(widget.isIOS){
      zoomValue=0.5;
    }
    super.initState();
  }



  google_recaptcha() {
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..loadRequest(Uri.parse("${AppConfig.BASE_URL}/google-recaptcha"))
      ..loadHtmlString(html(AppConfig.BASE_URL)).then((value) {
        _webViewController..addJavaScriptChannel(
          'Captcha',
          onMessageReceived: (JavaScriptMessage message) {
            //This is where you receive message from
            //javascript code and handle in Flutter/Dart
            //like here, the message is just being printed
            //in Run/LogCat window of android studio
            //print(message.message);
            setState(() {
              widget.callback(message.message);
            });
            print("aptcha message getted or not ${message.message}");
            //Navigator.of(context).pop();
          },
        )
          ..addJavaScriptChannel('CaptchaShowValidation', onMessageReceived: (JavaScriptMessage message) {
            //This is where you receive message from
            //javascript code and handle in Flutter/Dart
            //like here, the message is just being printed
            //in Run/LogCat window of android studio
            print("message.message");
            setState(() {
              bool value = message.message=="true";
              widget.handleCaptcha!(value);
            });
            // widget.callback(message.message);
            //Navigator.of(context).pop();
          },);
      });


  }

  @override
  void dispose() {
    // TODO: implement dispose
    _webViewController.removeJavaScriptChannel("CaptchaShowValidation");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DeviceInfo(context).width,
      height: 70,
      color: Colors.indigo,
      child: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }

  String html(url) {
    print(url);
    return '''
<!DOCTYPE html>
<html>
  <head>
    <title>Title of the document</title>
    <style>
      #wrap {
        width: 1000px;
        height: 1500px;
        padding: 0;
        overflow: hidden;
      }
      #scaled-frame {
        width: 1000px;
        height: 2000px;
        border: 0px;
      }
      #scaled-frame {
        zoom: 2;
        -moz-transform: scale(2);
        -moz-transform-origin: 0 0;
        -o-transform: scale(2);
        -o-transform-origin: 0 0;
        -webkit-transform: scale($zoomValue);
        -webkit-transform-origin: 0 0;
      }
      @media screen and (-webkit-min-device-pixel-ratio:0) {
        #scaled-frame {
          zoom: 1;
        }
      }
    </style>
  </head>
  <body>
    <div id="wrap">

	<iframe id="scaled-frame" src="${url}/google-recaptcha" allowfullscreen></iframe>
    </div>
  </body>
</html>
    ''';
  }
}
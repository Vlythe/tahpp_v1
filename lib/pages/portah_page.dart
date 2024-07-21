import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prototahpp/components/endDrawer.dart';
import 'package:prototahpp/components/route_generator.dart';
import 'package:prototahpp/util/customUI.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';

class PortahPage extends StatefulWidget {
  @override
  _PortahPageState createState() => _PortahPageState();
}

class _PortahPageState extends State<PortahPage> {
  InAppWebViewController? webViewController;
  InAppWebViewSettings setting = InAppWebViewSettings();
  String url =
      'https://www.google.com/';
  double progress = 0;
  final urlController = TextEditingController();
  bool errorRecibido = false;

  void showError() {
    print('ERROR EN FUNCION********************************: ');
    setState(() {
      errorRecibido = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'PORTAFOLIO',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) => IconButton(
              icon: SvgPicture.asset('assets/backButton.svg'),
              onPressed: () {
                errorRecibido = false;
                Future.delayed(Duration(milliseconds: 200), () {
                  Navigator.pop(context);
                  Navigator.of(context)
                      .push(RouteGenerator.createRouteHomePage());
                });
              },
            ),
          ),
          actions: const <Widget>[BurgerButton()],
        ),
        body: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: progress < 1.0
                  ? LinearProgressIndicator(
                      color: Theme.of(context).highlightColor, value: progress)
                  : null,
            ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(url)),
                onWebViewCreated: (InAppWebViewController controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                    errorRecibido = false;
                  });
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onReceivedError: (controller, request, error) {
                  print('ERROR EN HANDLER: $error');
                  showError();
                },
                onReceivedHttpError: (controller, request, error) {
                  
                  if (error.statusCode != 403 ) {
                    print('ERROR EN HANDLER: $error');
                         showError();
                        }
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
              ),
            ),
            errorRecibido
                ? Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.white),
                      child: SvgPicture.asset('assets/macintoshSad.svg',
                          width: 50, height: 50),
                    ),
                  )
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
        bottomNavigationBar: myBottomNavBar(webViewController),
        endDrawer: myEndDrawer(),
      ),
    );
  }
}

class myBottomNavBar extends StatefulWidget {
  final InAppWebViewController? webViewController;
  const myBottomNavBar(this.webViewController, {super.key});

  @override
  State<myBottomNavBar> createState() => _myBottomNavBarState();
}

class _myBottomNavBarState extends State<myBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: SvgPicture.asset('assets/backButton.svg'),
          onPressed: () {
            widget.webViewController?.goBack();
          },
        ),
        IconButton(
          icon: SvgPicture.asset('assets/frontButton.svg'),
          onPressed: () {
            widget.webViewController?.goForward();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.refresh_sharp,
            color: Color.fromARGB(255, 100, 100, 100),
          ),
          onPressed: () {
            widget.webViewController?.reload();
          },
        ),
        IconButton(
          icon: SvgPicture.asset('assets/shareButton.svg'),
          onPressed: () {
            Share.shareUri(WebUri(
                'https://www.google.com.mx/'));
          },
        ),
      ],
    );
  }
}

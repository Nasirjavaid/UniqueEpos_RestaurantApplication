import 'package:flutter/material.dart';
import 'package:retaurant_app/ui/CommomWidgets/loadingIndicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final title;
 
  WebViewContainer(this.url, this.title);
  @override
  createState() => _WebViewContainerState(this.url, this.title);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  var _title;
    bool isLoading=true;
  final _key = UniqueKey();
  _WebViewContainerState(this._url, this._title);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(_title,style: Theme.of(context).textTheme.button,),
      ),
      body:  Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl:_url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center( child:  LoadingIndicator(),)
                    : Stack(),
        ],
      ),
  
    );
  }
}

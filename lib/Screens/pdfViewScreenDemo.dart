import 'package:flutter/material.dart';

import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class pdfViewDemo extends StatelessWidget {
  const pdfViewDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(appBar: new AppBar(),
        body: Container(
          height: 680,
          width: 411,
          child: PDF(
            swipeHorizontal: true,
          ).cachedFromUrl('http://africau.edu/images/default/sample.pdf'),
        ),
      ),
    );
  }
}

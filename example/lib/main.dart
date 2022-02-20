

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_webgpu/flutter_webgpu.dart';
import 'package:flutter_webgpu_example/Example.dart';
import 'package:flutter_webgpu_example/ExampleCapture.dart';
import 'package:flutter_webgpu_example/ExampleCompute.dart';
import 'package:flutter_webgpu_example/ExampleTriangle.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}




class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  Uint8List? pixels;
  ui.Image? img;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  
    init();
  }

  init() {
    
    // pixels = Example.initWebGPU();

    // pixels = ExampleCapture.initWebGPU();
    // pixels = ExampleCompute.initWebGPU();
    pixels = ExampleTriangle.initWebGPU();

    if(pixels != null) {
      ui.decodeImageFromPixels(pixels!, 256, 256, ui.PixelFormat.rgba8888, (image) {
        setState(() {
          img = image;
        });
      });
    }
    
  }



  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await FlutterWebgpu.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text("render"),
          onPressed: () {
            init();
          },
        ),
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Container(
              child: Text('Running on: $_platformVersion\n'),
            ),
            Container(
              color: Colors.black,
              width: 256,
              height: 256,
              child: RawImage(image: img),
            )
          ],
        ),
      ),
    );
  }
}

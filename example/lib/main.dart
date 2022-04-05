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
import 'package:flutter_webgpu_example/rotateCube.dart';
import 'package:flutter_webgpu_example/TextureCube.dart';

import 'boids.dart';
import 'helloTriangle.dart';
import 'helloTriangleMSAA.dart';

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

  int width = 512;
  int height = 512;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    init();
  }

  init() {
    // pixels = Example.render(width, height);
    // pixels = ExampleCapture.render(width, height);
    // pixels = ExampleCompute.render(width, height);
    // pixels = ExampleTriangle.render(width, height);
    pixels = HelloTriangle.render(width, height);
    // pixels = HelloTriangleMSAA.render(width, height);
    // pixels = RotateCube.render(width, height);

    // crash TODO
    // pixels = TextureCube.render(width, height);
    // pixels = Boids.render(width, height);

    if (pixels != null) {
      ui.decodeImageFromPixels(pixels!, width, height, ui.PixelFormat.rgba8888,
          (image) {
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
              width: width.toDouble(),
              height: height.toDouble(),
              child: RawImage(image: img),
            )
          ],
        ),
      ),
    );
  }
}

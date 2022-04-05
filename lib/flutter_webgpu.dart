import 'dart:async';
import 'package:flutter/services.dart';

export './WebGPU_Binding.dart';
export 'package:flutter_webgpu/webgpu/index.dart';

class FlutterWebgpu {
  static const MethodChannel _channel = MethodChannel('flutter_webgpu');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

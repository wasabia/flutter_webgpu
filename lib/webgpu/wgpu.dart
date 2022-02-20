part of webgpu;

class Wgpu {
  static Wgpu? _instance;
  static Wgpu get instance {
    if(_instance == null) {
      _instance = Wgpu();
    }
    return _instance!;
  }

  late WebGPUBinding _webGPU;

  WebGPUBinding get webGPU => _webGPU;

  Wgpu() {
    final DynamicLibrary dynamicLibrary = Platform.isAndroid ? DynamicLibrary.open("libgreeter.so") : DynamicLibrary.process();

    _webGPU = WebGPUBinding(dynamicLibrary);
  }


}
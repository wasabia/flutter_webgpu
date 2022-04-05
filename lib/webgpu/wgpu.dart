part of webgpu;

class Wgpu {
  late WebGPUBinding _webGPU;
  WebGPUBinding get webGPU => _webGPU;

  static Wgpu? _instance;
  static Wgpu get instance {
    _instance ??= Wgpu();
    return _instance!;
  }

  static WebGPUBinding get binding => instance.webGPU;

  Wgpu() {
    final DynamicLibrary dynamicLibrary = Platform.isAndroid
        ? DynamicLibrary.open("libwgpu_native.so")
        : DynamicLibrary.process();

    _webGPU = WebGPUBinding(dynamicLibrary);
  }
}

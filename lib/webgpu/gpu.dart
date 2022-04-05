part of webgpu;

void wgpuRequestAdapterCallback(int status, WGPUAdapter received,
    Pointer<Int8> message, Pointer<Void> userdata) {
  Pointer<WGPUAdapter> _adapter = userdata.cast();
  _adapter.value = received;

  print(
      "wgpuRequestAdapterCallback success adapter: ${_adapter} ${_adapter.value}");
}

typedef WgpuRequestAdapterCallback = Void Function(
    Int32, WGPUAdapter, Pointer<Int8>, Pointer<Void>);

GPUAdapter requestAdapter(GPURequestAdapterOptions options) {
  Pointer<WGPUAdapter> adapter = ffi.calloc<WGPUAdapter>();
  var adapterCallback = Pointer.fromFunction<WgpuRequestAdapterCallback>(
      wgpuRequestAdapterCallback);

  Wgpu.binding.wgpuInstanceRequestAdapter(
      nullptr, options.pointer, adapterCallback, adapter.cast<Void>());

  return GPUAdapter(adapter);
}

class GPURequestAdapterOptions {
  late Pointer<WGPURequestAdapterOptions> pointer;

  GPURequestAdapterOptions(
      {int? powerPreference, bool forceFallbackAdapter = false}) {
    pointer = ffi.calloc<WGPURequestAdapterOptions>();
    var ref = pointer.ref;
    ref.nextInChain = nullptr;
    ref.compatibleSurface = nullptr;
    ref.powerPreference = powerPreference ?? GPUPowerPreference.Undefined;
    ref.forceFallbackAdapter = forceFallbackAdapter ? 1 : 0;
  }
}

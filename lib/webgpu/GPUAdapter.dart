part of webgpu;

void wgpuRequestDeviceCallback(int status, WGPUDevice received,
    Pointer<Char> message, Pointer<Void> userdata) {
  print(
      "wgpuRequestDeviceCallback status: ${status} received: ${received} message: ${message} userdata: ${userdata} ");
  Pointer<WGPUDevice> _device = userdata.cast();
  _device.value = received;
  print("wgpuRequestDeviceCallback  userdata: ${userdata} ");
}

typedef WgpuRequestDeviceCallback = Void Function(
    Int32, WGPUDevice, Pointer<Char>, Pointer<Void>);

class GPUAdapter {
  late Pointer<WGPUAdapter> adapter;
  GPUAdapter(this.adapter) {}

  GPUDevice requestDevice(GPUDeviceDescriptor descriptor) {
    var deviceCallback = Pointer.fromFunction<WgpuRequestDeviceCallback>(
        wgpuRequestDeviceCallback);

    Pointer<WGPUDevice> device = ffi.calloc<WGPUDevice>();

    Wgpu.binding.wgpuAdapterRequestDevice(
        adapter.value, descriptor.pointer, deviceCallback, device.cast<Void>());

    return GPUDevice(device);
  }
}

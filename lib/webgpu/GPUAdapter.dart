part of webgpu;



void wgpuRequestDeviceCallback(int status, WGPUDevice received, Pointer<Int8> message,
            Pointer<Void> userdata) {
  print("wgpuRequestDeviceCallback status: ${status} received: ${received} message: ${message} userdata: ${userdata} ");
  Pointer<WGPUDevice> _device = userdata.cast();
  _device.value = received;
  print("wgpuRequestDeviceCallback  userdata: ${userdata} ");
}
typedef WgpuRequestDeviceCallback = Void Function(Int32, WGPUDevice, Pointer<Int8>, Pointer<Void>);            



class GPUAdapter {
  late Pointer<WGPUAdapter> adapter;
  GPUAdapter(this.adapter) {

  }


  GPUDevice requestDevice(GPUDeviceDescriptor descriptor) {
    var deviceCallback = Pointer.fromFunction<WgpuRequestDeviceCallback>(wgpuRequestDeviceCallback);

    Pointer<WGPUDevice> device = ffi.calloc<WGPUDevice>();

    Wgpu.instance.webGPU.wgpuAdapterRequestDevice(
      adapter.value,
      descriptor.pointer,
      deviceCallback, device.cast<Void>());

    return GPUDevice(device);
  }


}
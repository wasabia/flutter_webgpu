part of webgpu;

class GPUDevice {
  late Pointer<WGPUDevice> device;

  get webGPU => Wgpu.binding;

  GPUQueue? _queue;

  GPUQueue get queue {
    if(_queue == null) {
      _queue = GPUQueue( webGPU.wgpuDeviceGetQueue(device.value) );
    }
    
    return _queue!;
  }
  
  GPUDevice(this.device) {
  
  }


  GPUCommandEncoder createCommandEncoder([GPUCommandEncoderDescriptor? descriptor]) {
    WGPUCommandEncoder encoder = webGPU.wgpuDeviceCreateCommandEncoder(device.value, (descriptor ?? GPUCommandEncoderDescriptor()).pointer);

    return GPUCommandEncoder(encoder);
  }

  GPUBuffer createBuffer(GPUBufferDescriptor descriptor) {
    WGPUBuffer outputBuffer = webGPU.wgpuDeviceCreateBuffer(device.value, descriptor.pointer);
    
    return GPUBuffer(outputBuffer);
  }

  GPUTexture createTexture(GPUTextureDescriptor descriptor) {
    
    WGPUTexture texture = webGPU.wgpuDeviceCreateTexture(device.value, descriptor.pointer);

    return GPUTexture(texture);
  }

  GPUSampler createSampler([GPUSamplerDescriptor? descriptor]) {
    WGPUSampler sampler = webGPU.wgpuDeviceCreateSampler(device.value, descriptor?.pointer ?? nullptr);
    return GPUSampler(sampler);
  }

  GPUShaderModule createShaderModule(GPUShaderModuleDescriptor descriptor) {
    WGPUShaderModule shader = webGPU.wgpuDeviceCreateShaderModule(device.value, descriptor.pointer);
    return GPUShaderModule(shader);
  }

  GPUPipelineLayout createPipelineLayout(GPUPipelineLayoutDescriptor descriptor) {
      WGPUPipelineLayout pipelineLayout = webGPU.wgpuDeviceCreatePipelineLayout(
      device.value, descriptor.pointer);

      return GPUPipelineLayout(pipelineLayout);
  }

  GPURenderPipeline createRenderPipeline(GPURenderPipelineDescriptor descriptor) {
    WGPURenderPipeline pipeline = webGPU.wgpuDeviceCreateRenderPipeline(
      device.value, descriptor.pointer);

    return GPURenderPipeline(pipeline);
  }

  GPUComputePipeline createComputePipeline(GPUComputePipelineDescriptor descriptor) {
    WGPUComputePipeline computePipeline = webGPU.wgpuDeviceCreateComputePipeline(
      device.value, descriptor.pointer);
    return GPUComputePipeline(computePipeline);
  }

  GPUBindGroupLayout createBindGroupLayout(GPUBindGroupLayoutDescriptor descriptor) {
    WGPUBindGroupLayout bindGroupLayout = webGPU.wgpuDeviceCreateBindGroupLayout(device.value, descriptor.pointer);
    return GPUBindGroupLayout(bindGroupLayout);
  }

  GPUBindGroup createBindGroup(GPUBindGroupDescriptor descriptor) {
    WGPUBindGroup bindGroup = webGPU.wgpuDeviceCreateBindGroup(device.value, descriptor.pointer);

    return GPUBindGroup(bindGroup);
  }


  poll([bool forceWait = true]) {
    webGPU.wgpuDevicePoll(device.value, forceWait);
  }


  setUncapturedErrorCallback() {
    var _callback = Pointer.fromFunction<HandleUncapturedErrorNative>(handleUncapturedError);
    webGPU.wgpuDeviceSetUncapturedErrorCallback(device.value, _callback, nullptr);
  }


  setDeviceLostCallback() {
    var _callback = Pointer.fromFunction<HandleDeviceLostNative>(handleDeviceLost);
    webGPU.wgpuDeviceSetDeviceLostCallback(device.value, _callback, nullptr);
  }
   


}

void handleDeviceLost(int reason, Pointer<Int8> message,
            Pointer<Void> userdata) {
  print("---------------- handleDeviceLost reason: ${reason} ");
}
void handleUncapturedError(int type, Pointer<Int8> message,
            Pointer<Void> userdata) {
  print("----------------- ErrorCallback type: ${type} ");
} 

typedef HandleDeviceLostNative = Void Function(Int32, Pointer<Int8>, Pointer<Void>);
typedef HandleUncapturedErrorNative = Void Function(Int32, Pointer<Int8>, Pointer<Void>);




class GPUDeviceDescriptor {
  late Pointer<WGPUDeviceDescriptor> pointer;
  GPUDeviceDescriptor({
    int maxBindGroups = 1
  }) {
    pointer = ffi.calloc<WGPUDeviceDescriptor>();
    var ref = pointer.ref;

    Pointer<WGPUChainedStruct> chain = ffi.calloc<WGPUChainedStruct>();
    WGPUChainedStruct _chain = chain.ref;
    _chain.next = nullptr;
    _chain.sType = WGPUNativeSType.WGPUSType_DeviceExtras;
  
    Pointer<WGPURequiredLimits> requiredLimits = ffi.calloc<WGPURequiredLimits>();
    WGPURequiredLimits _requiredLimits = requiredLimits.ref;
    _requiredLimits.nextInChain = nullptr;
    
    Pointer<WGPULimits> limits = ffi.calloc<WGPULimits>();
    WGPULimits _limits = limits.ref;
    _limits.maxBindGroups = maxBindGroups;

    _requiredLimits.limits = _limits;


    Pointer<WGPUDeviceExtras> deviceExtras = ffi.calloc<WGPUDeviceExtras>();
    WGPUDeviceExtras _deviceExtras = deviceExtras.ref;
    _deviceExtras.chain = _chain;
    _deviceExtras.label = "Device".toNativeUtf8().cast();
    _deviceExtras.tracePath = nullptr;


    ref.nextInChain = deviceExtras.cast();
    ref.label = "WGPUDeviceDescriptor".toNativeUtf8().cast();
    ref.requiredLimits = requiredLimits;
  }

}
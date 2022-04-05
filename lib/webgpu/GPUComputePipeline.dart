part of webgpu;

class GPUComputePipeline extends GPUObjectBase implements GPUPipelineBase {
  late WGPUComputePipeline computePipeline;

  GPUComputePipeline(this.computePipeline) {}

  @override
  GPUBindGroupLayout getBindGroupLayout(int index) {
    WGPUBindGroupLayout layout = Wgpu.binding
        .wgpuComputePipelineGetBindGroupLayout(computePipeline, index);
    return GPUBindGroupLayout(layout);
  }
}

class GPUComputePipelineDescriptor extends GPUPipelineDescriptorBase {
  late Pointer<WGPUComputePipelineDescriptor> pointer;

  GPUComputePipelineDescriptor(
      {required GPUProgrammableStage compute, GPUPipelineLayout? layout}) {
    pointer = ffi.calloc<WGPUComputePipelineDescriptor>();
    var ref = pointer.ref;
    ref.label = "GPUComputePipelineDescriptor".toNativeUtf8().cast();
    ref.nextInChain = nullptr;
    ref.layout = layout?.pipelineLayout ?? nullptr;
    ref.compute = compute.pointer.ref;
  }
}

class GPUProgrammableStage {
  late Pointer<WGPUProgrammableStageDescriptor> pointer;

  GPUProgrammableStage(
      {required GPUShaderModule module, required String entryPoint}) {
    pointer = ffi.calloc<WGPUProgrammableStageDescriptor>();
    var ref = pointer.ref;
    ref.nextInChain = nullptr;
    ref.module = module.shader;
    ref.entryPoint = entryPoint.toNativeUtf8().cast();
    ref.constantCount = 0;
    ref.constants = nullptr;
  }
}

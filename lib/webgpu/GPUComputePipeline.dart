part of webgpu;

class GPUComputePipeline {

  late WGPUComputePipeline computePipeline;

  GPUComputePipeline(this.computePipeline) {
    
  }


  GPUBindGroupLayout getBindGroupLayout(int index) {
    WGPUBindGroupLayout layout = Wgpu.instance.webGPU.wgpuComputePipelineGetBindGroupLayout(computePipeline, index);
    return GPUBindGroupLayout(layout);
  }

}


class GPUComputePipelineDescriptor {

  late Pointer<WGPUComputePipelineDescriptor> pointer;

  GPUComputePipelineDescriptor({
    required GPUProgrammableStageDescriptor compute,
    GPUPipelineLayout? layout
  }) {
    pointer = ffi.calloc<WGPUComputePipelineDescriptor>();
    var ref = pointer.ref;
    ref.label = "GPUComputePipelineDescriptor".toNativeUtf8().cast();
    ref.nextInChain = nullptr;
    ref.layout = layout?.pipelineLayout ?? nullptr;
    ref.compute = compute.pointer.ref;
  }


}


class GPUProgrammableStageDescriptor {
  late Pointer<WGPUProgrammableStageDescriptor> pointer;

  GPUProgrammableStageDescriptor({
    required GPUShaderModule module,
    required String entryPoint
  }) {
    pointer = ffi.calloc<WGPUProgrammableStageDescriptor>();
    var ref = pointer.ref;
    ref.nextInChain = nullptr;
    ref.module = module.shader;
    ref.entryPoint = entryPoint.toNativeUtf8().cast();
    ref.constantCount = 0;
    ref.constants = nullptr;
  }
}
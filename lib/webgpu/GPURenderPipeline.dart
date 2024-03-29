part of webgpu;

class GPURenderPipeline extends GPUObjectBase implements GPUPipelineBase {
  late WGPURenderPipeline pipeline;

  GPURenderPipeline(this.pipeline) {}

  @override
  GPUBindGroupLayout getBindGroupLayout(int index) {
    WGPUBindGroupLayout layout =
        Wgpu.binding.wgpuRenderPipelineGetBindGroupLayout(pipeline, index);
    return GPUBindGroupLayout(layout);
  }
}

class GPURenderPipelineDescriptor extends GPUPipelineDescriptorBase {
  late Pointer<WGPURenderPipelineDescriptor> pointer;

  GPURenderPipelineDescriptor(
      {GPUPipelineLayout? layout,
      required GPUVertexState vertex,
      required GPUPrimitiveState primitive,
      required GPUMultisampleState multisample,
      required GPUFragmentState fragment,
      GPUDepthStencilState? depthStencil}) {
    pointer = ffi.calloc<WGPURenderPipelineDescriptor>();
    var descriptor = pointer.ref;
    descriptor.label = "label".toNativeUtf8().cast();
    descriptor.layout = layout?.pipelineLayout ?? nullptr;
    descriptor.depthStencil = depthStencil?.pointer ?? nullptr;

    descriptor.vertex = vertex.pointer.ref;
    descriptor.primitive = primitive.pointer.ref;
    descriptor.multisample = multisample.pointer.ref;
    descriptor.fragment = fragment.pointer;
  }
}

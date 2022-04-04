part of webgpu;


class GPURenderPipeline {
  late WGPURenderPipeline pipeline;

  GPURenderPipeline(this.pipeline) {

  }

  GPUBindGroupLayout getBindGroupLayout(int index) {
    WGPUBindGroupLayout layout = Wgpu.instance.webGPU.wgpuRenderPipelineGetBindGroupLayout(pipeline, index);
    return GPUBindGroupLayout(layout);
  }

}


class GPURenderPipelineDescriptor {

  late Pointer<WGPURenderPipelineDescriptor> pointer;

  GPURenderPipelineDescriptor({
    GPUPipelineLayout? layout,
    required GPUVertexState vertex,
    required GPUPrimitiveState primitive,
    required GPUMultisampleState multisample,
    required GPUFragmentState fragment,
    GPUDepthStencilState? depthStencil

  }) {
    pointer = ffi.calloc<WGPURenderPipelineDescriptor>();
    var descriptor = pointer.ref;
    descriptor.label = "label".toNativeUtf8().cast();
    descriptor.layout = layout?.pipelineLayout ?? nullptr;
    descriptor.depthStencil = depthStencil?.pointer ?? nullptr;

    descriptor.vertex = vertex.pointer.ref;
    descriptor.primitive = primitive.pointer.ref;
    if( multisample != null ) descriptor.multisample = multisample.pointer.ref;
    descriptor.fragment = fragment.pointer;

  }


}

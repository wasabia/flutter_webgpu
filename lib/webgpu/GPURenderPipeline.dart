part of webgpu;


class GPURenderPipeline {
  late WGPURenderPipeline pipeline;

  GPURenderPipeline(this.pipeline) {

  }

}


class GPURenderPipelineDescriptor {

  late Pointer<WGPURenderPipelineDescriptor> pointer;

  GPURenderPipelineDescriptor({
    GPUPipelineLayout? layout,
    required GPUVertexState vertex,
    required GPUPrimitiveState primitive,
    GPUMultisampleState? multisample,
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
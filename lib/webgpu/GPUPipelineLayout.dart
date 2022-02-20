part of webgpu;

class GPUPipelineLayout {

  late WGPUPipelineLayout pipelineLayout;

  GPUPipelineLayout(this.pipelineLayout) {

  }



}


class GPUPipelineLayoutDescriptor {

  late Pointer<WGPUPipelineLayoutDescriptor> pointer;

  GPUPipelineLayoutDescriptor({
    GPUBindGroupLayout? bindGroupLayouts,
    int bindGroupLayoutCount = 0
  }) {
    pointer = ffi.calloc<WGPUPipelineLayoutDescriptor>();
    var descriptor = pointer.ref;

    descriptor.bindGroupLayouts = bindGroupLayouts == null ? nullptr : bindGroupLayouts.pointer;
    descriptor.bindGroupLayoutCount = bindGroupLayoutCount;
  }

}
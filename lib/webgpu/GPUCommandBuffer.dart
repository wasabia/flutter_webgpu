part of webgpu;


class GPUCommandBuffer extends GPUObjectBase {
  
  late Pointer<WGPUCommandBuffer> pointer;
  late WGPUCommandBuffer buffer;

  GPUCommandBuffer(this.buffer) {
    pointer = ffi.calloc<WGPUCommandBuffer>();
    pointer.value = buffer;
  }


}


class GPUCommandBufferDescriptor extends GPUObjectDescriptorBase {

  late Pointer<WGPUCommandBufferDescriptor> pointer;

  GPUCommandBufferDescriptor() {
    pointer = ffi.calloc<WGPUCommandBufferDescriptor>();
    WGPUCommandBufferDescriptor descriptor = pointer.ref;
    descriptor.label = nullptr;
  }

}



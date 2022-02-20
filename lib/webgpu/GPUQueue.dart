part of webgpu;


class GPUQueue {

  late WGPUQueue queue;

  GPUQueue(this.queue) {

  }

  // TODO
  // commandBuffers can be sequence<GPUCommandBuffer>
  // https://gpuweb.github.io/gpuweb/#dom-gpuqueue-submit
  void submit( GPUCommandBuffer commandBuffers ) {
    Wgpu.instance.webGPU.wgpuQueueSubmit(queue, 1, commandBuffers.pointer);
  }

  void writeBuffer(
    GPUBuffer buffer,
    int bufferOffset,
    Uint32List data,
    int size,) {
    
    // TODO 对应类型转对应类型的指针
    print("confirm convert to right pointer ..... ");
    final ptr = ffi.calloc<Uint32>(data.length);
    ptr.asTypedList(data.length).setAll(0, List<int>.from(data.map((e) => e.toInt())));


    Wgpu.instance.webGPU.wgpuQueueWriteBuffer(queue, buffer.buffer, bufferOffset, ptr.cast(), size);
  }

  void writeTexture(GPUImageCopyTexture destination,
        data,
        GPUTextureDataLayout dataLayout,
        GPUExtent3D size) {
    
    // TODO 对应类型转对应类型的指针
    print("confirm convert to right pointer ..... ");
    final ptr = ffi.calloc<Uint32>(data.length);
    ptr.asTypedList(data.length).setAll(0, List<int>.from(data.map((e) => e.toInt())));

    int dataSize = data.length;

    Wgpu.instance.webGPU.wgpuQueueWriteTexture(queue, destination.pointer, ptr.cast(), dataSize, dataLayout.pointer, size.pointer);
  }

}


typedef GPUImageDataLayout = GPUTextureDataLayout;
class GPUTextureDataLayout {
  late Pointer<WGPUTextureDataLayout> pointer;

  GPUTextureDataLayout({
    int offset = 0,
    int? bytesPerRow
  }) {
    pointer = ffi.calloc<WGPUTextureDataLayout>();
    var ref = pointer.ref;
    ref.offset = offset;
    if(bytesPerRow != null) ref.bytesPerRow = bytesPerRow;
  }

}

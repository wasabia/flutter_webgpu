part of webgpu;

class GPUQueue extends GPUObjectBase {
  late WGPUQueue queue;

  GPUQueue(this.queue) {}

  // TODO
  // commandBuffers can be sequence<GPUCommandBuffer>
  // https://gpuweb.github.io/gpuweb/#dom-gpuqueue-submit
  void submit(GPUCommandBuffer commandBuffers) {
    Wgpu.binding.wgpuQueueSubmit(queue, 1, commandBuffers.pointer);
  }

  void writeBuffer(
    GPUBuffer buffer,
    int bufferOffset,
    data,
    int size,
  ) {
    // TODO 对应类型转对应类型的指针
    print("GPUQueue writeBuffer confirm convert to right pointer ..... ");
    var ptr;

    if (data is Uint32List) {
      ptr = ffi.calloc<Uint32>(data.length);
      (ptr as Pointer<Uint32>)
          .asTypedList(data.length)
          .setAll(0, List<int>.from(data.map((e) => e.toInt())));
    } else if (data is Float32List) {
      ptr = ffi.calloc<Float>(data.length);
      (ptr as Pointer<Float>)
          .asTypedList(data.length)
          .setAll(0, List<double>.from(data.map((e) => e.toDouble())));
    } else {
      throw ("GPUQueue ${data.runtimeType} not support...... ");
    }

    Wgpu.binding.wgpuQueueWriteBuffer(
        queue, buffer.buffer, bufferOffset, ptr.cast<Void>(), size);
  }

  void writeTexture(GPUImageCopyTexture destination, data,
      GPUTextureDataLayout dataLayout, GPUExtent3D size) {
    // TODO 对应类型转对应类型的指针
    print("confirm convert to right pointer ..... ");
    final ptr = ffi.calloc<Uint32>(data.length);
    ptr
        .asTypedList(data.length)
        .setAll(0, List<int>.from(data.map((e) => e.toInt())));

    int dataSize = data.length;

    Wgpu.binding.wgpuQueueWriteTexture(queue, destination.pointer, ptr.cast(),
        dataSize, dataLayout.pointer, size.pointer);
  }
}

typedef GPUImageDataLayout = GPUTextureDataLayout;

class GPUTextureDataLayout {
  late Pointer<WGPUTextureDataLayout> pointer;

  GPUTextureDataLayout({int offset = 0, int? bytesPerRow}) {
    pointer = ffi.calloc<WGPUTextureDataLayout>();
    var ref = pointer.ref;
    ref.offset = offset;
    if (bytesPerRow != null) ref.bytesPerRow = bytesPerRow;
  }
}

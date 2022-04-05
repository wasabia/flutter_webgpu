part of webgpu;

void readBufferMap(int status, Pointer<Void> userdata) {
  print("  readBufferMap callback ....... ");
}

typedef ReadBufferMap = Void Function(Int32, Pointer<Void>);


class GPUBuffer {
  late WGPUBuffer buffer;
  late Pointer<WGPUBuffer> pointer;

  GPUBuffer(this.buffer) {
    pointer = ffi.calloc<WGPUBuffer>();
    pointer.value = buffer;
  }

  mapAsync({required int mode, int offset = 0, required int size}) {
    var readBufferMapCallback = Pointer.fromFunction<ReadBufferMap>(readBufferMap);
    Wgpu.binding.wgpuBufferMapAsync(buffer, WGPUMapMode.WGPUMapMode_Read, offset, size,
                      readBufferMapCallback, nullptr);
  }

  Pointer<Void> getMappedRange({int offset = 0, int? size}) {
    return Wgpu.binding.wgpuBufferGetMappedRange(buffer, offset, size ?? 0);
  }

  unmap() {
    Wgpu.binding.wgpuBufferUnmap(buffer);
  }

}

class GPUBufferDescriptor {

  late Pointer<WGPUBufferDescriptor> pointer;

  GPUBufferDescriptor({
    required int size,
    required int usage,
    bool mappedAtCreation = false
  }) {
    pointer = ffi.calloc<WGPUBufferDescriptor>();
    WGPUBufferDescriptor _descriptor = pointer.ref;
    _descriptor.nextInChain = nullptr;
    _descriptor.label = "Output Buffer".toNativeUtf8().cast();
    _descriptor.usage = usage;
    _descriptor.size = size;
    _descriptor.mappedAtCreation = mappedAtCreation ? 1 : 0;
  }

    

}
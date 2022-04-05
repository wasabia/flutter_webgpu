part of webgpu;

class GPUImageCopyBuffer {
  @override
  late Pointer<WGPUImageCopyBuffer> pointer;

  GPUImageCopyBuffer({required GPUBuffer buffer, required int bytesPerRow}) {
    pointer = ffi.calloc<WGPUImageCopyBuffer>();
    WGPUImageCopyBuffer _copyBuffer = pointer.ref;
    _copyBuffer.buffer = buffer.buffer;

    Pointer<WGPUTextureDataLayout> layout = ffi.calloc<WGPUTextureDataLayout>();
    WGPUTextureDataLayout _layout = layout.ref;
    _layout.offset = 0;
    _layout.bytesPerRow = bytesPerRow;
    _layout.rowsPerImage = 0;
    _copyBuffer.layout = _layout;
  }
}

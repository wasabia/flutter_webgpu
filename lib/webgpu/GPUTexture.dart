part of webgpu;

class GPUTexture extends GPUObjectBase {

  late WGPUTexture texture;

  GPUTexture(this.texture) {

  }

  GPUTextureView createView([GPUTextureViewDescriptor? descriptor]) {

    WGPUTextureView textureView = Wgpu.binding.wgpuTextureCreateView(texture, (descriptor ?? GPUTextureViewDescriptor()).pointer);

    return GPUTextureView(textureView);
  }

  destroy() {
    Wgpu.binding.wgpuTextureDestroy(texture);
  }

}


class GPUTextureDescriptor {

  late Pointer<WGPUTextureDescriptor> pointer;

  GPUTextureDescriptor({
    required GPUExtent3D size,
    int mipLevelCount = 1,
    int sampleCount = 1,
    int? dimension,
    required int format,
    required int usage
  }) {
    pointer = ffi.calloc<WGPUTextureDescriptor>();
    WGPUTextureDescriptor _descriptor = pointer.ref;
    _descriptor.nextInChain = nullptr;
    _descriptor.label = "WGPUTextureDescriptor".toNativeUtf8().cast();
    _descriptor.size = size.pointer.ref;
    _descriptor.mipLevelCount = mipLevelCount;
    _descriptor.sampleCount = sampleCount;
    _descriptor.dimension = dimension ?? GPUTextureDimension.TwoD;
    _descriptor.format = format;
    _descriptor.usage = usage;
  }

}
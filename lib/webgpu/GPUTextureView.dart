part of webgpu;


class GPUTextureView extends GPUObjectBase {

  late WGPUTextureView textureView;

  GPUTextureView(this.textureView) {

  }

}


class GPUTextureViewDescriptor extends GPUObjectDescriptorBase {

  late Pointer<WGPUTextureViewDescriptor> pointer;

  GPUTextureViewDescriptor({
    int? format,
    int baseMipLevel = 0,
    int mipLevelCount = 0,
    int? arrayLayerCount,
    int? aspect,
    int? baseArrayLayer,
    int? dimension
  }) {
    pointer = ffi.calloc<WGPUTextureViewDescriptor>();
    WGPUTextureViewDescriptor _descriptor = pointer.ref;
    _descriptor.nextInChain = nullptr;
    _descriptor.label = nullptr;
    _descriptor.format = format ?? GPUTextureFormat.Undefined;
    _descriptor.dimension = dimension ?? GPUTextureViewDimension.Undefined;
    _descriptor.aspect = aspect ?? WGPUTextureAspect.WGPUTextureAspect_All;
    _descriptor.arrayLayerCount = arrayLayerCount ?? 0;
    _descriptor.baseArrayLayer = baseArrayLayer ?? 0;
    _descriptor.baseMipLevel = baseMipLevel;
    _descriptor.mipLevelCount = mipLevelCount;
  }


}
part of webgpu;


class GPUImageCopyTexture {

  late Pointer<WGPUImageCopyTexture> pointer;

  GPUImageCopyTexture({
    required GPUTexture texture,
    int mipLevel = 0,
    GPUOrigin3D? origin,
    int aspect = GPUTextureAspect.All
  }) {
    pointer = ffi.calloc<WGPUImageCopyTexture>();
    WGPUImageCopyTexture _copyTexture = pointer.ref;
    _copyTexture.texture = texture.texture;
    _copyTexture.mipLevel = mipLevel;
    _copyTexture.origin = (origin ?? GPUOrigin3D()).pointer.ref;
  }


}
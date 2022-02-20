part of webgpu;

class GPUSampler {
  late WGPUSampler sampler;

  GPUSampler(this.sampler) {

  }

}

class GPUSamplerDescriptor extends GPUObjectDescriptorBase {
  late Pointer<WGPUSamplerDescriptor> pointer;

  GPUSamplerDescriptor({
    int addressModeU = GPUAddressMode.ClampToEdge,
    int addressModeV = GPUAddressMode.ClampToEdge,
    int addressModeW = GPUAddressMode.ClampToEdge,
    double lodMinClamp = 0.0,
    double lodMaxClamp = 32.0,
    int magFilter = GPUFilterMode.Nearest,
    int minFilter = GPUFilterMode.Nearest,
    int mipmapFilter = GPUFilterMode.Nearest,
    int maxAnisotropy = 1
  }) {
    pointer = ffi.calloc<WGPUSamplerDescriptor>();
    var ref = pointer.ref;
    ref.nextInChain = nullptr;
    ref.label = "WGPUSamplerDescriptor".toNativeUtf8().cast();
    ref.addressModeU = addressModeU;
    ref.addressModeV = addressModeV;
    ref.addressModeW = addressModeW;
    ref.lodMinClamp = lodMinClamp;
    ref.lodMaxClamp = lodMaxClamp;
    ref.magFilter = magFilter;
    ref.minFilter = minFilter;
    ref.mipmapFilter = mipmapFilter;
    ref.maxAnisotropy = maxAnisotropy;
  }


}
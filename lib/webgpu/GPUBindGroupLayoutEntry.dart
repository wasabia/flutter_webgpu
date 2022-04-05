part of webgpu;

class GPUBindGroupLayoutEntry {
  late Pointer<WGPUBindGroupLayoutEntry> pointer;

  GPUBindGroupLayoutEntry(
      {required int binding,
      required int visibility,
      required GPUBufferBindingLayout buffer}) {
    pointer = ffi.calloc<WGPUBindGroupLayoutEntry>();
    var state = pointer.ref;

    state.nextInChain = nullptr;
    state.binding = binding;
    state.visibility = visibility;
    state.buffer = buffer.pointer.ref;
    state.sampler =
        GPUSamplerBindingLayout(type: WGPUSamplerBindingType_Undefined)
            .pointer
            .ref;
    state.texture =
        GPUTextureBindingLayout(sampleType: WGPUTextureSampleType_Undefined)
            .pointer
            .ref;
    state.storageTexture = GPUStorageTextureBindingLayout(
            access: WGPUStorageTextureAccess_Undefined)
        .pointer
        .ref;
  }
}

part of webgpu;


class GPUBindGroupLayout {

  late Pointer<WGPUBindGroupLayout> pointer;
  late WGPUBindGroupLayout bindGroupLayout;

  GPUBindGroupLayout(this.bindGroupLayout) {
    pointer = ffi.calloc<WGPUBindGroupLayout>(1);
    pointer[0] = bindGroupLayout;
  }

}

class GPUBindGroupLayoutDescriptor {
  late Pointer<WGPUBindGroupLayoutDescriptor> pointer;

  GPUBindGroupLayoutDescriptor({
    required GPUBindGroupLayoutEntry entries,
    required int entryCount
  }) {
    pointer = ffi.calloc<WGPUBindGroupLayoutDescriptor>();
    var state = pointer.ref;
    state.label = "Bind Group Layout".toNativeUtf8().cast();
    state.entryCount = entryCount;
    state.entries = entries.pointer;
  }


}



class GPUBindGroupLayoutEntry {
  late Pointer<WGPUBindGroupLayoutEntry> pointer;

  GPUBindGroupLayoutEntry({
    required int binding,
    required int visibility
  }) {
    pointer = ffi.calloc<WGPUBindGroupLayoutEntry>();
    var state = pointer.ref;

    state.nextInChain = nullptr;
    state.binding = binding;
    state.visibility = visibility;
    state.buffer = GPUBufferBindingLayout(type: WGPUBufferBindingType_Storage).pointer.ref;
    state.sampler = GPUSamplerBindingLayout(type: WGPUSamplerBindingType_Undefined).pointer.ref;
    state.texture = GPUTextureBindingLayout(sampleType: WGPUTextureSampleType_Undefined).pointer.ref;
    state.storageTexture = GPUStorageTextureBindingLayout(access: WGPUStorageTextureAccess_Undefined).pointer.ref;

  }

  
}


class GPUBufferBindingLayout {
  late Pointer<WGPUBufferBindingLayout> pointer;

  GPUBufferBindingLayout({
    required int type
  }) {
    pointer = ffi.calloc<WGPUBufferBindingLayout>();
    var state = pointer.ref;
    state.type = type;
  }

}


class GPUSamplerBindingLayout {
  late Pointer<WGPUSamplerBindingLayout> pointer;

  GPUSamplerBindingLayout({
    required int type
  }) {
    pointer = ffi.calloc<WGPUSamplerBindingLayout>();
    var state = pointer.ref;
    state.type = type;
  }

}


class GPUTextureBindingLayout {
  late Pointer<WGPUTextureBindingLayout> pointer;

  GPUTextureBindingLayout({
    required int sampleType
  }) {
    pointer = ffi.calloc<WGPUTextureBindingLayout>();
    var state = pointer.ref;
    state.sampleType = sampleType;
  }

}



class GPUStorageTextureBindingLayout {
  late Pointer<WGPUStorageTextureBindingLayout> pointer;

  GPUStorageTextureBindingLayout({
    required int access
  }) {
    pointer = ffi.calloc<WGPUStorageTextureBindingLayout>();
    var state = pointer.ref;
    state.access = access;
  }

}
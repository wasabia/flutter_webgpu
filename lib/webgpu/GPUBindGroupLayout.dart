part of webgpu;

class GPUBindGroupLayout extends GPUObjectBase {
  late Pointer<WGPUBindGroupLayout> pointer;
  late WGPUBindGroupLayout bindGroupLayout;

  GPUBindGroupLayout(this.bindGroupLayout) {
    pointer = ffi.calloc<WGPUBindGroupLayout>(1);
    pointer[0] = bindGroupLayout;
  }

  GPUBindGroupLayout.pointer(this.pointer) {}
}

class GPUBindGroupLayoutDescriptor extends GPUObjectDescriptorBase {
  late Pointer<WGPUBindGroupLayoutDescriptor> pointer;

  GPUBindGroupLayoutDescriptor(
      {List<GPUBindGroupLayoutEntry>? entries}) {
    pointer = ffi.calloc<WGPUBindGroupLayoutDescriptor>();
    var state = pointer.ref;
    state.label = "Bind Group Layout".toNativeUtf8().cast();
    
    if (entries == null) {
      state.entries = nullptr;
    } else {
      // state.entries = entries[0].pointer;
      var entryPointers = ffi.calloc<WGPUBindGroupLayoutEntry>(entries.length);
      entries.asMap().forEach((index, entry) {
        var pointer = entryPointers[index];
        pointer.binding = entry.pointer.ref.binding;
        pointer.visibility = entry.pointer.ref.visibility;
        pointer.buffer = entry.pointer.ref.buffer;
        pointer.sampler = entry.pointer.ref.sampler;
        pointer.texture = entry.pointer.ref.texture;
        pointer.storageTexture = entry.pointer.ref.storageTexture;
      });
      
      state.entries = entryPointers;
      state.entryCount = entries.length;
    }
  }
}

class GPUBufferBindingLayout {
  late Pointer<WGPUBufferBindingLayout> pointer;

  GPUBufferBindingLayout({required int type, bool hasDynamicOffset = false, int? minBindingSize}) {
    pointer = ffi.calloc<WGPUBufferBindingLayout>();
    var state = pointer.ref;
    state.type = type;
    state.hasDynamicOffset = hasDynamicOffset;
    state.minBindingSize = minBindingSize ?? 0;
  }
}

class GPUSamplerBindingLayout {
  late Pointer<WGPUSamplerBindingLayout> pointer;

  GPUSamplerBindingLayout({required int type}) {
    pointer = ffi.calloc<WGPUSamplerBindingLayout>();
    var state = pointer.ref;
    state.type = type;
  }
}

class GPUTextureBindingLayout {
  late Pointer<WGPUTextureBindingLayout> pointer;

  GPUTextureBindingLayout({required int sampleType}) {
    pointer = ffi.calloc<WGPUTextureBindingLayout>();
    var state = pointer.ref;
    state.sampleType = sampleType;
  }
}

class GPUStorageTextureBindingLayout {
  late Pointer<WGPUStorageTextureBindingLayout> pointer;

  GPUStorageTextureBindingLayout({required int access}) {
    pointer = ffi.calloc<WGPUStorageTextureBindingLayout>();
    var state = pointer.ref;
    state.access = access;
  }
}

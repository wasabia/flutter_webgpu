part of webgpu;


class GPUBindGroupLayout {

  late Pointer<WGPUBindGroupLayout> pointer;
  late WGPUBindGroupLayout bindGroupLayout;

  GPUBindGroupLayout(this.bindGroupLayout) {
    pointer = ffi.calloc<WGPUBindGroupLayout>(1);
    pointer[0] = bindGroupLayout;
  }

  GPUBindGroupLayout.pointer(this.pointer) {
    
  }

}

class GPUBindGroupLayoutDescriptor {
  late Pointer<WGPUBindGroupLayoutDescriptor> pointer;

  GPUBindGroupLayoutDescriptor({
    List<GPUBindGroupLayoutEntry>? entries,
    required int entryCount
  }) {
    pointer = ffi.calloc<WGPUBindGroupLayoutDescriptor>();
    var state = pointer.ref;
    state.label = "Bind Group Layout".toNativeUtf8().cast();
    state.entryCount = entryCount;
    if(entries == null) {
      state.entries = nullptr;
    } else if(entries.length == 1) {
      state.entries = entries[0].pointer;
    } else {
      var entryPointers = ffi.calloc<WGPUBindGroupLayoutEntry>( entries.length );
      entries.asMap().forEach((index, entry) {
        var pointer = entryPointers[ index ];
        pointer.binding = entry.pointer.ref.binding;
        pointer.visibility = entry.pointer.ref.visibility;
        pointer.buffer = entry.pointer.ref.buffer;
        pointer.sampler = entry.pointer.ref.sampler;
        pointer.texture = entry.pointer.ref.texture;
        pointer.storageTexture = entry.pointer.ref.storageTexture;
      });
      print(" GPUBindGroupLayoutDescriptor entries: ${entries.length} ");
    }
   
  }


}



class GPUBindGroupLayoutEntry {
  late Pointer<WGPUBindGroupLayoutEntry> pointer;

  GPUBindGroupLayoutEntry({
    required int binding,
    required int visibility,
    required GPUBufferBindingLayout buffer
  }) {
    pointer = ffi.calloc<WGPUBindGroupLayoutEntry>();
    var state = pointer.ref;

    state.nextInChain = nullptr;
    state.binding = binding;
    state.visibility = visibility;
    state.buffer = buffer.pointer.ref;
    state.sampler = GPUSamplerBindingLayout(type: WGPUSamplerBindingType_Undefined).pointer.ref;
    state.texture = GPUTextureBindingLayout(sampleType: WGPUTextureSampleType_Undefined).pointer.ref;
    state.storageTexture = GPUStorageTextureBindingLayout(access: WGPUStorageTextureAccess_Undefined).pointer.ref;

  }

  
}


class GPUBufferBindingLayout {
  late Pointer<WGPUBufferBindingLayout> pointer;

  GPUBufferBindingLayout({
    required int type,
    int? minBindingSize
  }) {
    pointer = ffi.calloc<WGPUBufferBindingLayout>();
    var state = pointer.ref;
    state.type = type;
    state.minBindingSize = minBindingSize ?? 0;
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
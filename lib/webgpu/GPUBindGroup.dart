part of webgpu;

class GPUBindGroup {
  late WGPUBindGroup bindGroup;

  GPUBindGroup(this.bindGroup) {

  }
}


class GPUBindGroupDescriptor {

  late Pointer<WGPUBindGroupDescriptor> pointer;

  GPUBindGroupDescriptor({
    String? label,
    required GPUBindGroupLayout layout,
    entries,
    int entryCount = 1
  }) {
    pointer = ffi.calloc<WGPUBindGroupDescriptor>();
    var ref = pointer.ref;
    ref.nextInChain = nullptr;
    ref.label = (label ?? "GPUBindGroupDescriptor").toNativeUtf8().cast();
    
    ref.layout = layout.bindGroupLayout;

    if(entries != null) {
      ref.entries = entries.pointer;
      ref.entryCount = entryCount;
    }
  
  }

}


class GPUBindGroupEntry {
  late Pointer<WGPUBindGroupEntry> pointer;

  GPUBindGroupEntry({
    GPUBuffer? buffer,
    int? size,
    required int binding,
    GPUSampler? sampler,
    GPUTextureView? textureView,
    int offset = 0
  }) {
    pointer = ffi.calloc<WGPUBindGroupEntry>();
    var state = pointer.ref;

    state.nextInChain = nullptr;
    state.binding = binding;
    if(buffer != null) state.buffer = buffer.buffer;
    state.offset = offset;
    state.size = size!;
    if(sampler != null) state.sampler = sampler.sampler;
    if(textureView != null) state.textureView = textureView.textureView;
  }
}
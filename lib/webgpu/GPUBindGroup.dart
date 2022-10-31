part of webgpu;

class GPUBindGroup extends GPUObjectBase {
  late WGPUBindGroup bindGroup;

  GPUBindGroup(this.bindGroup) {}
}

class GPUBindGroupDescriptor {
  late Pointer<WGPUBindGroupDescriptor> pointer;

  GPUBindGroupDescriptor(
      {String? label,
      required GPUBindGroupLayout layout,
      List<GPUBindGroupEntry>? entries,
      int entryCount = 0}) {
    pointer = ffi.calloc<WGPUBindGroupDescriptor>();
    var ref = pointer.ref;
    ref.nextInChain = nullptr;
    ref.label = (label ?? "GPUBindGroupDescriptor").toNativeUtf8().cast();

    ref.layout = layout.bindGroupLayout;

    if (entries == null) {
      ref.entries = nullptr;
      ref.entryCount = 0;
    } else {
      print(" entries entryCount: ${entries.length}  ");

      var entryPointers = ffi.calloc<WGPUBindGroupEntry>(entries.length);
      entries.asMap().forEach((index, entry) {
        var pointer = entryPointers[index];
        pointer.binding = entry.pointer.ref.binding;
        pointer.offset = entry.pointer.ref.offset;
        pointer.buffer = entry.pointer.ref.buffer;
        pointer.size = entry.pointer.ref.size;
        pointer.sampler = entry.pointer.ref.sampler;
        pointer.textureView = entry.pointer.ref.textureView;
      });

      ref.entries = entryPointers;
      ref.entryCount = entries.length;
    }
  }
}

class GPUBindGroupEntry {
  late Pointer<WGPUBindGroupEntry> pointer;

  GPUBindGroupEntry(
      {GPUBuffer? buffer,
      int? size,
      required int binding,
      GPUSampler? sampler,
      GPUTextureView? textureView,
      int offset = 0}) {
    pointer = ffi.calloc<WGPUBindGroupEntry>();
    var state = pointer.ref;

    state.nextInChain = nullptr;
    state.binding = binding;
    if (buffer != null) state.buffer = buffer.buffer;
    state.offset = offset;
    state.size = size ?? 0;
    if (sampler != null) state.sampler = sampler.sampler;
    if (textureView != null) state.textureView = textureView.textureView;
  }
}

part of webgpu;

class GPUBlendComponent {
  late Pointer<WGPUBlendComponent> pointer;

  GPUBlendComponent({int? srcFactor, int? dstFactor, int? operation}) {
    pointer = ffi.calloc<WGPUBlendComponent>();
    var state = pointer.ref;
    state.srcFactor = srcFactor ?? GPUBlendFactor.One;
    state.dstFactor = dstFactor ?? GPUBlendFactor.Zero;
    state.operation = operation ?? GPUBlendOperation.Add;
  }
}

part of webgpu;

class GPURenderPassDescriptor extends GPUObjectDescriptorBase {
  late Pointer<WGPURenderPassDescriptor> pointer;

  GPURenderPassDescriptor({
    GPURenderPassColorAttachment? colorAttachments,
    GPURenderPassDepthStencilAttachment? depthStencilAttachment,
    // GPUQuerySet occlusionQuerySet,
    // GPURenderPassTimestampWrites timestampWrites = []
  }) {
    pointer = ffi.calloc<WGPURenderPassDescriptor>();
    WGPURenderPassDescriptor descriptor = pointer.ref;
    descriptor.colorAttachments = colorAttachments?.pointer ?? nullptr;
    descriptor.colorAttachmentCount = 1;
    descriptor.depthStencilAttachment =
        depthStencilAttachment?.pointer ?? nullptr;
  }

  get colorAttachments =>
      GPURenderPassColorAttachment.pointer(pointer.ref.colorAttachments);
  get depthStencilAttachment {
    print("depthStencilAttachment TODO ");
    return GPURenderPassDepthStencilAttachment.pointer(
        pointer.ref.depthStencilAttachment);
  }
}

part of webgpu;

class GPUCommandEncoder {

  late WGPUCommandEncoder encoder;

  GPUCommandEncoder(this.encoder) {

  }

  GPURenderPassEncoder beginRenderPass(GPURenderPassDescriptor descriptor) {

    WGPURenderPassEncoder renderPass = Wgpu.instance.webGPU.wgpuCommandEncoderBeginRenderPass(encoder, descriptor.pointer);

    return GPURenderPassEncoder(renderPass);
  }


  GPUComputePassEncoder beginComputePass([GPUComputePassDescriptor? descriptor]) {
    WGPUComputePassEncoder computePass = Wgpu.instance.webGPU.wgpuCommandEncoderBeginComputePass(
      encoder, descriptor?.pointer ?? nullptr );

    return GPUComputePassEncoder(computePass);
  }

  void copyTextureToBuffer(GPUImageCopyTexture source, GPUImageCopyBuffer destination, GPUExtent3D copySize) {
    Wgpu.instance.webGPU.wgpuCommandEncoderCopyTextureToBuffer(
      encoder, source.pointer, destination.pointer, copySize.pointer);
  }

  void copyBufferToBuffer(
        GPUBuffer source,
        int sourceOffset,
        GPUBuffer destination,
        int destinationOffset,
        int size) {
    Wgpu.instance.webGPU.wgpuCommandEncoderCopyBufferToBuffer(
      encoder, source.buffer, sourceOffset, destination.buffer, destinationOffset, size);
  }

  GPUCommandBuffer finish([GPUCommandBufferDescriptor? descriptor]) {
    WGPUCommandBuffer buffer = Wgpu.instance.webGPU.wgpuCommandEncoderFinish(encoder, descriptor?.pointer ?? nullptr);

    return GPUCommandBuffer(buffer);
  }

  

}



class GPUCommandEncoderDescriptor extends GPUObjectDescriptorBase {

  late Pointer<WGPUCommandEncoderDescriptor> pointer;

  GPUCommandEncoderDescriptor() {
    pointer = ffi.calloc<WGPUCommandEncoderDescriptor>();
    WGPUCommandEncoderDescriptor descriptor = pointer.ref;
    descriptor.label = nullptr;
  }

}


class GPURenderPassDescriptor {

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
    descriptor.depthStencilAttachment = depthStencilAttachment?.pointer ?? nullptr;
  }

  get colorAttachments => GPURenderPassColorAttachment.pointer(pointer.ref.colorAttachments);
  get depthStencilAttachment {
    print("depthStencilAttachment TODO ");
    return GPURenderPassDepthStencilAttachment.pointer(pointer.ref.depthStencilAttachment);
  }
 
}

class GPURenderPassColorAttachment {

  late Pointer<WGPURenderPassColorAttachment> pointer;

  GPURenderPassColorAttachment.pointer( Pointer<WGPURenderPassColorAttachment> pointer ) {
    this.pointer = pointer;
  }
  
  // view 本应该是required的但是为了配合three.js的后赋值 暂时改为optional
  GPURenderPassColorAttachment({
    GPUTextureView? view,
    GPUTextureView? resolveTarget,
    GPUColor? clearColor,
    required int loadOp,
    required int storeOp
  }) {
    pointer = ffi.calloc<WGPURenderPassColorAttachment>();
    WGPURenderPassColorAttachment _attach = pointer.ref;
    if(view != null) _attach.view = view.textureView;
    _attach.resolveTarget = nullptr;
    _attach.loadOp = loadOp;
    _attach.storeOp = storeOp;
    if(clearColor != null) {
      _attach.clearColor = clearColor.pointer.ref;
    }
  }

  set view(GPUTextureView value) {
    var ref = pointer.ref;
    ref.view = value.textureView;
  }

  set clearColor(GPUColor color) {
    pointer.ref.clearColor = color.pointer.ref;
  }

  set resolveTarget(GPUTextureView? view) {
    pointer.ref.resolveTarget = view?.textureView ?? nullptr;
  }

}




class GPURenderPassDepthStencilAttachment {
  late Pointer<WGPURenderPassDepthStencilAttachment> pointer;

  WGPURenderPassDepthStencilAttachment get ref => pointer.ref;

  GPURenderPassDepthStencilAttachment.pointer(this.pointer) {

  }

  GPURenderPassDepthStencilAttachment({
    GPUTextureView? view,
    int? depthStoreOp,
    int? stencilStoreOp
  }) {
    pointer = ffi.calloc<WGPURenderPassDepthStencilAttachment>();

    ref.depthReadOnly = 0;
    ref.stencilReadOnly = 0;
    if(view != null) ref.view = view.textureView;
    if(depthStoreOp != null) ref.depthStoreOp = depthStoreOp;
    if(stencilStoreOp != null) ref.stencilStoreOp = stencilStoreOp;
  }

  set view(GPUTextureView value) {
    print("depthStencilAttachment view TODO ");
    ref.view = value.textureView;
  }

  set depthLoadValue(int value) {
    ref.depthLoadOp = value;
  }

  set stencilLoadValue(int value) {
    ref.stencilLoadOp = value;
  }

  set clearDepth(double value) {
    ref.clearDepth = value;
  }

  set clearStencil(int value) {
    ref.clearStencil = value;
  }

}
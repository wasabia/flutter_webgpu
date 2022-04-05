part of webgpu;

class GPURenderPassEncoder implements GPUProgrammablePassEncoder {

  late WGPURenderPassEncoder encoder;

  GPURenderPassEncoder(this.encoder) {

  }

  void setPipeline(GPURenderPipeline pipeline) {
    Wgpu.binding.wgpuRenderPassEncoderSetPipeline(encoder, pipeline.pipeline);
  }

  void setVertexBuffer(int slot, GPUBuffer buffer, [int offset = 0, int? size]) {
    Wgpu.binding.wgpuRenderPassEncoderSetVertexBuffer(encoder, slot, buffer.buffer, offset, size ?? 0);
  }

  @override
  void setBindGroup(int v0, GPUBindGroup bindGroup, [int v1 = 0, v2]) {
    Wgpu.binding.wgpuRenderPassEncoderSetBindGroup(encoder, v0, bindGroup.bindGroup, v1, v2 ?? nullptr);
  }

  void draw(int vertexCount, [int instanceCount = 1,
    int firstVertex = 0, int firstInstance = 0]) {
      Wgpu.binding.wgpuRenderPassEncoderDraw(encoder, vertexCount, instanceCount, firstVertex, firstInstance);
  }

  endPass() {
    Wgpu.binding.wgpuRenderPassEncoderEnd(encoder);
  }

  setViewport(double x, double y,
                     double width, double height,
                     double minDepth, double maxDepth) {
    Wgpu.binding.wgpuRenderPassEncoderSetViewport(encoder, x, y, width, height, minDepth, maxDepth);
  }

  setScissorRect(int x, int y, int width, int height) {
    Wgpu.binding.wgpuRenderPassEncoderSetScissorRect(encoder, x, y, width, height);
  }

  setIndexBuffer(GPUBuffer buffer, int indexFormat, [ int offset = 0, int? size ] ) {
    Wgpu.binding.wgpuRenderPassEncoderSetIndexBuffer(encoder, buffer.buffer, indexFormat, offset, size ?? 0);
  }

  drawIndexed(int indexCount, [int instanceCount = 1, int firstIndex = 0, int baseVertex = 0, int firstInstance = 0]) {
    Wgpu.binding.wgpuRenderPassEncoderDrawIndexed(encoder, indexCount, instanceCount, firstIndex, baseVertex, firstInstance);
  }

}
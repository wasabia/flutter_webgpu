part of webgpu;

class GPURenderPassEncoder implements GPUProgrammablePassEncoder {

  late WGPURenderPassEncoder encoder;

  GPURenderPassEncoder(this.encoder) {

  }

  void setPipeline(GPURenderPipeline pipeline) {
    Wgpu.instance.webGPU.wgpuRenderPassEncoderSetPipeline(encoder, pipeline.pipeline);
  }

  @override
  void setBindGroup(int v0, GPUBindGroup bindGroup, [int v1 = 0, v2]) {
    Wgpu.instance.webGPU.wgpuRenderPassEncoderSetBindGroup(encoder, v0, bindGroup.bindGroup, v1, v2 ?? nullptr);
  }

  void draw(int vertexCount, [int instanceCount = 1,
    int firstVertex = 0, int firstInstance = 0]) {
      Wgpu.instance.webGPU.wgpuRenderPassEncoderDraw(encoder, vertexCount, instanceCount, firstVertex, firstInstance);
  }

  endPass() {
    Wgpu.instance.webGPU.wgpuRenderPassEncoderEndPass(encoder);
  }

  setViewport(double x, double y,
                     double width, double height,
                     double minDepth, double maxDepth) {
    Wgpu.instance.webGPU.wgpuRenderPassEncoderSetViewport(encoder, x, y, width, height, minDepth, maxDepth);
  }

  setScissorRect(int x, int y, int width, int height) {
    Wgpu.instance.webGPU.wgpuRenderPassEncoderSetScissorRect(encoder, x, y, width, height);
  }

}
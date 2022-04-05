part of webgpu;

abstract class GPURenderEncoderBase {

  void setPipeline(GPURenderPipeline pipeline);

  void setIndexBuffer(GPUBuffer buffer, int indexFormat, [int offset = 0, int? size]);
  void setVertexBuffer(int slot, GPUBuffer buffer, [int offset = 0, int? size]);

  void draw(int vertexCount, [int instanceCount = 1, int firstVertex = 0, int firstInstance = 0]);
  void drawIndexed(int indexCount, [int instanceCount = 1, int firstIndex = 0, int baseVertex = 0, int firstInstance = 0]);

  void drawIndirect(GPUBuffer indirectBuffer, int indirectOffset);
  void drawIndexedIndirect(GPUBuffer indirectBuffer, int indirectOffset);

}
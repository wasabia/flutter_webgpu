part of webgpu;

class GPUComputePassEncoder extends GPUObjectBase
    implements GPUProgrammablePassEncoder {
  late WGPUComputePassEncoder computePass;

  GPUComputePassEncoder(this.computePass) {}

  void setPipeline(GPUComputePipeline pipeline) {
    Wgpu.binding.wgpuComputePassEncoderSetPipeline(
        computePass, pipeline.computePipeline);
  }

  @override
  void setBindGroup(int v0, GPUBindGroup bindGroup, [int v1 = 0, v2]) {
    Wgpu.binding.wgpuComputePassEncoderSetBindGroup(
        computePass, v0, bindGroup.bindGroup, v1, v2 ?? nullptr);
  }

  // TODO
  void dispatchWorkgroups(int workgroupCountX,
      [int workgroupCountY = 1, int workgroupCountZ = 1]) {
    Wgpu.binding.wgpuComputePassEncoderDispatch(
        computePass, workgroupCountX, workgroupCountY, workgroupCountZ);
  }

  void end() {
    Wgpu.binding.wgpuComputePassEncoderEnd(computePass);
  }

}

class GPUComputePassDescriptor extends GPUObjectDescriptorBase {
  late Pointer<WGPUComputePassDescriptor> pointer;

  GPUComputePassDescriptor() {
    pointer = ffi.calloc<WGPUComputePassDescriptor>();
    var ref = pointer.ref;

    ref.label = "Compute Pass".toNativeUtf8().cast();
  }
}

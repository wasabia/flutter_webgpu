part of webgpu;


class GPUComputePassEncoder implements GPUProgrammablePassEncoder {

  late WGPUComputePassEncoder computePass;
  
  GPUComputePassEncoder(this.computePass) {

  }


  void setPipeline(GPUComputePipeline pipeline) {
    Wgpu.instance.webGPU.wgpuComputePassEncoderSetPipeline(computePass, pipeline.computePipeline);
  }

  @override
  void setBindGroup(int v0, GPUBindGroup bindGroup, [int v1 = 0, v2]) {
    Wgpu.instance.webGPU.wgpuComputePassEncoderSetBindGroup(computePass, v0, bindGroup.bindGroup, v1, v2 ?? nullptr);
  }

  void dispatch(int workgroupCountX, [int workgroupCountY = 1, int workgroupCountZ = 1]) {
    Wgpu.instance.webGPU.wgpuComputePassEncoderDispatch(computePass, workgroupCountX, workgroupCountY, workgroupCountZ);
  }

  void end() {
    Wgpu.instance.webGPU.wgpuComputePassEncoderEndPass(computePass);
  }

  void endPass() {
    end();
  }

}


class GPUComputePassDescriptor {

  late Pointer<WGPUComputePassDescriptor> pointer;

  GPUComputePassDescriptor() {
    pointer = ffi.calloc<WGPUComputePassDescriptor>();
    var ref = pointer.ref;

    ref.label = "Compute Pass".toNativeUtf8().cast();
    
  }

}
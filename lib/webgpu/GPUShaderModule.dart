part of webgpu;

class GPUShaderModule {

  late WGPUShaderModule shader;

  GPUShaderModule(this.shader) {

  }

}


class GPUShaderModuleDescriptor {
  late Pointer<WGPUShaderModuleDescriptor> pointer;

  GPUShaderModuleDescriptor({
    required String code
  }) {
    var wgslPointer = ffi.calloc<WGPUShaderModuleWGSLDescriptor>();
    var wgslRef = wgslPointer.ref;
    wgslRef.chain.next = nullptr;
    wgslRef.chain.sType = WGPUSType_ShaderModuleWGSLDescriptor;
    wgslRef.code = code.toNativeUtf8().cast();

    pointer = ffi.calloc<WGPUShaderModuleDescriptor>();
    var ref = pointer.ref;
    ref.nextInChain = wgslPointer.cast();
    ref.label = "shaderModule".toNativeUtf8().cast();
  }



}
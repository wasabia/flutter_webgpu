part of webgpu;

class GPUVertexState {
  late Pointer<WGPUVertexState> pointer;

  GPUVertexState(
      {required GPUShaderModule module,
      required String entryPoint,
      List<GPUVertexBufferLayout>? buffers}) {
    pointer = ffi.calloc<WGPUVertexState>();
    var state = pointer.ref;

    state.module = module.shader;
    state.entryPoint = entryPoint.toNativeUtf8().cast();
    state.bufferCount = buffers?.length ?? 0;

    if (buffers == null) {
      state.buffers = nullptr;
    } else if (buffers.length == 1) {
      state.buffers = buffers[0].pointer;
    } else {
      var buffersPointer = ffi.calloc<WGPUVertexBufferLayout>(buffers.length);

      buffers.asMap().forEach((key, value) {
        var _p = buffersPointer[key];
        _p = value.pointer.ref;

        _p.arrayStride = value.pointer.ref.arrayStride;
        _p.stepMode = value.pointer.ref.stepMode;
        _p.attributeCount = value.pointer.ref.attributeCount;
        _p.attributes = value.pointer.ref.attributes;
      });

      state.buffers = buffersPointer;
    }
  }
}

class GPUPrimitiveState {
  late Pointer<WGPUPrimitiveState> pointer;

  GPUPrimitiveState(
      {int? topology, int? stripIndexFormat, int? frontFace, int? cullMode}) {
    pointer = ffi.calloc<WGPUPrimitiveState>();
    var state = pointer.ref;
    state.topology = topology ?? GPUPrimitiveTopology.TriangleList;
    state.stripIndexFormat = stripIndexFormat ?? GPUIndexFormat.Undefined;
    state.frontFace = frontFace ?? GPUFrontFace.CCW;
    state.cullMode = cullMode ?? GPUCullMode.None;
  }
}

class GPUMultisampleState {
  late Pointer<WGPUMultisampleState> pointer;

  GPUMultisampleState(
      {int count = 1, int mask = ~0, bool alphaToCoverageEnabled = false}) {
    pointer = ffi.calloc<WGPUMultisampleState>();
    var state = pointer.ref;
    state.count = count;
    state.mask = mask;
    state.alphaToCoverageEnabled = alphaToCoverageEnabled;
  }
}

class GPUFragmentState {
  late Pointer<WGPUFragmentState> pointer;

  GPUFragmentState(
      {required GPUShaderModule module,
      required GPUColorTargetState targets,
      required String entryPoint}) {
    pointer = ffi.calloc<WGPUFragmentState>();
    var state = pointer.ref;

    state.module = module.shader;
    state.entryPoint = entryPoint.toNativeUtf8().cast();
    state.targetCount = 1;
    state.targets = targets.pointer;
  }
}

class GPUColorTargetState {
  late Pointer<WGPUColorTargetState> pointer;

  GPUColorTargetState(
      {GPUBlendState? blend,
      int writeMask = GPUColorWriteFlags.All,
      required int format}) {
    pointer = ffi.calloc<WGPUColorTargetState>();
    var state = pointer.ref;

    state.format = format;

    state.blend = blend?.pointer ?? nullptr;
    state.writeMask = writeMask;
  }
}

class GPUBlendState {
  late Pointer<WGPUBlendState> pointer;

  GPUBlendState({
    required GPUBlendComponent color,
    required GPUBlendComponent alpha,
  }) {
    pointer = ffi.calloc<WGPUBlendState>();
    var state = pointer.ref;
    state.color = color.pointer.ref;
    state.alpha = alpha.pointer.ref;
  }
}

class GPUDepthStencilState {
  late Pointer<WGPUDepthStencilState> pointer;

  GPUDepthStencilState(
      {required int format,
      bool depthWriteEnabled = false,
      int? depthCompare,
      required GPUStencilFaceState stencilFront,
      GPUStencilFaceState? stencilBack,
      int? stencilReadMask,
      int? stencilWriteMask,
      int? depthBias,
      double? depthBiasSlopeScale,
      double? depthBiasClamp}) {
    pointer = ffi.calloc<WGPUDepthStencilState>();
    var ref = pointer.ref;
    ref.format = format;
    ref.depthWriteEnabled = depthWriteEnabled;
    ref.depthCompare = depthCompare ?? GPUCompareFunction.Always;
    ref.stencilFront = stencilFront.pointer.ref;
    ref.stencilBack =
        (stencilBack ?? GPUStencilFaceState(compare: GPUCompareFunction.Always))
            .pointer
            .ref;
    ref.stencilReadMask = stencilReadMask ?? 0xFFFFFFFF;
    ref.stencilWriteMask = stencilWriteMask ?? 0xFFFFFFFF;
    ref.depthBias = depthBias ?? 0;
    ref.depthBiasSlopeScale = depthBiasSlopeScale ?? 0;
    ref.depthBiasClamp = depthBiasClamp ?? 0;
  }
}

class GPUStencilFaceState {
  late Pointer<WGPUStencilFaceState> pointer;

  GPUStencilFaceState(
      {int? compare, int? failOp, int? depthFailOp, int? passOp}) {
    pointer = ffi.calloc<WGPUStencilFaceState>();
    var ref = pointer.ref;

    ref.compare = compare ?? GPUCompareFunction.Always;

    ref.failOp = failOp ?? GPUStencilOperation.Keep;
    ref.depthFailOp = depthFailOp ?? GPUStencilOperation.Keep;
    ref.passOp = passOp ?? GPUStencilOperation.Keep;
  }
}

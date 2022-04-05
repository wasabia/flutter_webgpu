part of webgpu;

class GPUVertexBufferLayout {
  late Pointer<WGPUVertexBufferLayout> pointer;

  GPUVertexBufferLayout(
      {required int arrayStride,
      int stepMode = GPUVertexStepMode.Vertex,
      required List<GPUVertexAttribute> attributes}) {
    pointer = ffi.calloc<WGPUVertexBufferLayout>();
    var ref = pointer.ref;
    ref.arrayStride = arrayStride;
    ref.attributeCount = attributes.length;
    ref.stepMode = stepMode;

    if (attributes.length == 1) {
      ref.attributes = attributes[0].pointer;
    } else {
      var attributesPointer =
          ffi.calloc<WGPUVertexAttribute>(attributes.length);

      attributes.asMap().forEach((key, value) {
        var _p = attributesPointer[key];
        _p.format = value.pointer.ref.format;
        _p.offset = value.pointer.ref.offset;
        _p.shaderLocation = value.pointer.ref.shaderLocation;
      });

      ref.attributes = attributesPointer;
    }
  }
}

class GPUVertexAttribute {
  late Pointer<WGPUVertexAttribute> pointer;
  GPUVertexAttribute(
      {required int format, required int offset, required int shaderLocation}) {
    pointer = ffi.calloc<WGPUVertexAttribute>();
    var ref = pointer.ref;

    ref.format = format;
    ref.offset = offset;
    ref.shaderLocation = shaderLocation;
  }
}

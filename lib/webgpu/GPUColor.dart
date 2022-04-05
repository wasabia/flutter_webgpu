part of webgpu;

class GPUColor {
  late Pointer<WGPUColor> pointer;

  GPUColor(
      {required double r,
      required double g,
      required double b,
      required double a}) {
    pointer = ffi.calloc<WGPUColor>();
    WGPUColor _color = pointer.ref;
    _color.r = r;
    _color.g = g;
    _color.b = b;
    _color.a = a;
  }
}

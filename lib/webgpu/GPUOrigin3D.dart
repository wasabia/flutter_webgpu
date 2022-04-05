part of webgpu;

class GPUOrigin3D {
  late Pointer<WGPUOrigin3D> pointer;

  GPUOrigin3D({int x = 0, int y = 0, int z = 0}) {
    pointer = ffi.calloc<WGPUOrigin3D>();
    WGPUOrigin3D _origin = pointer.ref;
    _origin.x = x;
    _origin.y = y;
    _origin.z = z;
  }
}

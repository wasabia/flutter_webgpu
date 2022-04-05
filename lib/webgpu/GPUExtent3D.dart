part of webgpu;

class GPUExtent3D {
  late Pointer<WGPUExtent3D> pointer;

  late int width;
  late int height;

  GPUExtent3D({this.width = 1, this.height = 1, int depthOrArrayLayers = 1}) {
    pointer = ffi.calloc<WGPUExtent3D>();
    WGPUExtent3D _extent = pointer.ref;
    _extent.width = width;
    _extent.height = height;
    _extent.depthOrArrayLayers = depthOrArrayLayers;
  }
}

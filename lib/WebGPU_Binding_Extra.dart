import 'WebGPU_Binding.dart' as WEBGPUBIND;
import 'dart:ffi' as ffi;


typedef BoolTrue = ffi.Int32 Function(ffi.Pointer<ffi.Int32>);

int boolTrue(ffi.Pointer<ffi.Int32> value) {
  return 1;
} 




class WebgpuBinding {




}
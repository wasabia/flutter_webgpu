part of webgpu;

final int WGPUMapMode_Read = WGPUMapMode.WGPUMapMode_Read;

final int WGPUSType_ShaderModuleWGSLDescriptor =
    WGPUSType.WGPUSType_ShaderModuleWGSLDescriptor;

final int WGPUPrimitiveTopology_TriangleList =
    WGPUPrimitiveTopology.WGPUPrimitiveTopology_TriangleList;

final int WGPUIndexFormat_Undefined = WGPUIndexFormat.WGPUIndexFormat_Undefined;

final int WGPUFrontFace_CCW = WGPUFrontFace.WGPUFrontFace_CCW;

class GPUCullMode {
  static const int None = WGPUCullMode.WGPUCullMode_None;
  static const int Back = WGPUCullMode.WGPUCullMode_Back;
  static const int Front = WGPUCullMode.WGPUCullMode_Front;
}

class GPUFrontFace {
  static const int CW = WGPUFrontFace.WGPUFrontFace_CW;

  static const int CCW = WGPUFrontFace.WGPUFrontFace_CCW;
}

final int WGPUColorWriteMask_All = WGPUColorWriteMask.WGPUColorWriteMask_All;

final int WGPUBlendFactor_One = WGPUBlendFactor.WGPUBlendFactor_One;
final int WGPUBlendFactor_Zero = WGPUBlendFactor.WGPUBlendFactor_Zero;

final int WGPUBlendOperation_Add = WGPUBlendOperation.WGPUBlendOperation_Add;

class GPUBufferBindingType {
  static const int Storage =
      WGPUBufferBindingType.WGPUBufferBindingType_Storage;
  static const int Uniform =
      WGPUBufferBindingType.WGPUBufferBindingType_Uniform;
}

final int WGPUSamplerBindingType_Undefined =
    WGPUSamplerBindingType.WGPUSamplerBindingType_Undefined;

final int WGPUTextureSampleType_Undefined =
    WGPUTextureSampleType.WGPUTextureSampleType_Undefined;

final int WGPUStorageTextureAccess_Undefined =
    WGPUStorageTextureAccess.WGPUStorageTextureAccess_Undefined;

class GPUPowerPreference {
  static const int Undefined =
      WGPUPowerPreference.WGPUPowerPreference_Undefined;
  static const int LowPower = WGPUPowerPreference.WGPUPowerPreference_LowPower;
  static const int HighPerformance =
      WGPUPowerPreference.WGPUPowerPreference_HighPerformance;
  static const int Force32 = WGPUPowerPreference.WGPUPowerPreference_Force32;
}

class GPUTextureFormat {
  static const int Undefined = WGPUTextureFormat.WGPUTextureFormat_Undefined;

  static const int Depth32Float =
      WGPUTextureFormat.WGPUTextureFormat_Depth32Float;

  static const int RGBA8Unorm = WGPUTextureFormat.WGPUTextureFormat_RGBA8Unorm;
  static const int BGRA8Unorm = WGPUTextureFormat.WGPUTextureFormat_BGRA8Unorm;

  static const int RGBA8UnormSrgb =
      WGPUTextureFormat.WGPUTextureFormat_RGBA8UnormSrgb;
  static const int Depth24PlusStencil8 =
      WGPUTextureFormat.WGPUTextureFormat_Depth24PlusStencil8;

  static const int Depth24Plus =
      WGPUTextureFormat.WGPUTextureFormat_Depth24Plus;

  static const int BC1RGBAUnorm =
      WGPUTextureFormat.WGPUTextureFormat_BC1RGBAUnorm;
  static const int BC1RGBAUnormSRGB =
      WGPUTextureFormat.WGPUTextureFormat_BC1RGBAUnormSrgb;
  static const int BC2RGBAUnorm =
      WGPUTextureFormat.WGPUTextureFormat_BC2RGBAUnorm;
  static const int BC2RGBAUnormSRGB =
      WGPUTextureFormat.WGPUTextureFormat_BC2RGBAUnormSrgb;
  static const int BC3RGBAUnorm =
      WGPUTextureFormat.WGPUTextureFormat_BC3RGBAUnorm;
  static const int BC3RGBAUnormSRGB =
      WGPUTextureFormat.WGPUTextureFormat_BC3RGBAUnormSrgb;
  static const int BC4RUnorm = WGPUTextureFormat.WGPUTextureFormat_BC4RUnorm;
  static const int BC4RSNorm = WGPUTextureFormat.WGPUTextureFormat_BC4RSnorm;
  static const int BC5RGUnorm = WGPUTextureFormat.WGPUTextureFormat_BC5RGUnorm;
  static const int BC6HRGBUFloat =
      WGPUTextureFormat.WGPUTextureFormat_BC6HRGBUfloat;
  static const int BC7RGBAUnorm =
      WGPUTextureFormat.WGPUTextureFormat_BC7RGBAUnorm;
  static const int BC5RGSnorm = WGPUTextureFormat.WGPUTextureFormat_BC5RGSnorm;

  static const int BC6HRGBFloat =
      WGPUTextureFormat.WGPUTextureFormat_BC6HRGBFloat;
  static const int BC7RGBAUnormSRGB =
      WGPUTextureFormat.WGPUTextureFormat_BC7RGBAUnormSrgb;

  static const int R8Unorm = WGPUTextureFormat.WGPUTextureFormat_R8Unorm;
  static const int R16Float = WGPUTextureFormat.WGPUTextureFormat_R16Float;
  static const int RG8Unorm = WGPUTextureFormat.WGPUTextureFormat_RG8Unorm;
  static const int RG16Float = WGPUTextureFormat.WGPUTextureFormat_RG16Float;
  static const int R32Float = WGPUTextureFormat.WGPUTextureFormat_R32Float;
  static const int RGBA8UnormSRGB =
      WGPUTextureFormat.WGPUTextureFormat_RGBA8UnormSrgb;
  static const int RG32Float = WGPUTextureFormat.WGPUTextureFormat_RG32Float;
  static const int RGBA16Float =
      WGPUTextureFormat.WGPUTextureFormat_RGBA16Float;
  static const int RGBA32Float =
      WGPUTextureFormat.WGPUTextureFormat_RGBA32Float;

  static const int Stencil8 = WGPUTextureFormat.WGPUTextureFormat_Stencil8;
}

class GPUTextureUsage {
  static const int RenderAttachment =
      WGPUTextureUsage.WGPUTextureUsage_RenderAttachment;
  static const int TextureBinding =
      WGPUTextureUsage.WGPUTextureUsage_TextureBinding;
  static const int CopyDst = WGPUTextureUsage.WGPUTextureUsage_CopyDst;
  static const int CopySrc = WGPUTextureUsage.WGPUTextureUsage_CopySrc;
}

class GPUIndexFormat {
  static const int Uint16 = WGPUIndexFormat.WGPUIndexFormat_Uint16;
  static const int Uint32 = WGPUIndexFormat.WGPUIndexFormat_Uint32;
  static const int Undefined = WGPUIndexFormat.WGPUIndexFormat_Undefined;
}

class GPUBufferUsage {
  static const int MapRead = WGPUBufferUsage.WGPUBufferUsage_MapRead;
  static const int CopyDst = WGPUBufferUsage.WGPUBufferUsage_CopyDst;
  static const int Storage = WGPUBufferUsage.WGPUBufferUsage_Storage;
  static const int CopySrc = WGPUBufferUsage.WGPUBufferUsage_CopySrc;
  static const int Index = WGPUBufferUsage.WGPUBufferUsage_Index;
  static const int Vertex = WGPUBufferUsage.WGPUBufferUsage_Vertex;
  static const int Uniform = WGPUBufferUsage.WGPUBufferUsage_Uniform;
}

class GPUAddressMode {
  static const int ClampToEdge = WGPUAddressMode.WGPUAddressMode_ClampToEdge;
  static const int Repeat = WGPUAddressMode.WGPUAddressMode_Repeat;
  static const int MirrorRepeat = WGPUAddressMode.WGPUAddressMode_MirrorRepeat;
}

class GPULoadOp {
  static const int Undefined = WGPULoadOp.WGPULoadOp_Undefined;
  static const int Clear = WGPULoadOp.WGPULoadOp_Clear;
  static const int Load = WGPULoadOp.WGPULoadOp_Load;
  static const int Force32 = WGPULoadOp.WGPULoadOp_Force32;
}

class GPUVertexFormat {
  static const int Uint8x4 = WGPUVertexFormat.WGPUVertexFormat_Uint8x4;
  static const int Uint16x4 = WGPUVertexFormat.WGPUVertexFormat_Uint16x4;
  static const int Uint32x4 = WGPUVertexFormat.WGPUVertexFormat_Uint32x4;
  static const int Uint32x2 = WGPUVertexFormat.WGPUVertexFormat_Uint32x2;
  static const int Uint32x3 = WGPUVertexFormat.WGPUVertexFormat_Uint32x3;
  static const int Uint32 = WGPUVertexFormat.WGPUVertexFormat_Uint32;

  static const int Uint16x2 = WGPUVertexFormat.WGPUVertexFormat_Uint16x2;
  static const int Uint8x2 = WGPUVertexFormat.WGPUVertexFormat_Uint8x2;

  static const int Sint32x4 = WGPUVertexFormat.WGPUVertexFormat_Sint32x4;
  static const int Sint16x4 = WGPUVertexFormat.WGPUVertexFormat_Sint16x4;
  static const int Sint8x4 = WGPUVertexFormat.WGPUVertexFormat_Sint8x4;
  static const int Sint32x3 = WGPUVertexFormat.WGPUVertexFormat_Sint32x3;
  static const int Sint32x2 = WGPUVertexFormat.WGPUVertexFormat_Sint32x2;
  static const int Sint16x2 = WGPUVertexFormat.WGPUVertexFormat_Sint16x2;
  static const int Sint8x2 = WGPUVertexFormat.WGPUVertexFormat_Sint8x2;
  static const int Sint32 = WGPUVertexFormat.WGPUVertexFormat_Sint32;
  static const int Float32x4 = WGPUVertexFormat.WGPUVertexFormat_Float32x4;
  static const int Float16x4 = WGPUVertexFormat.WGPUVertexFormat_Float16x4;
  static const int Float32x3 = WGPUVertexFormat.WGPUVertexFormat_Float32x3;
  static const int Float32x2 = WGPUVertexFormat.WGPUVertexFormat_Float32x2;
  static const int Float16x2 = WGPUVertexFormat.WGPUVertexFormat_Float16x2;
  static const int Float32 = WGPUVertexFormat.WGPUVertexFormat_Float32;
}

class GPUStencilOperation {
  static const int DecrementWrap =
      WGPUStencilOperation.WGPUStencilOperation_DecrementWrap;
  static const int IncrementWrap =
      WGPUStencilOperation.WGPUStencilOperation_IncrementWrap;
  static const int IncrementClamp =
      WGPUStencilOperation.WGPUStencilOperation_IncrementClamp;
  static const int DecrementClamp =
      WGPUStencilOperation.WGPUStencilOperation_DecrementClamp;

  static const int Invert = WGPUStencilOperation.WGPUStencilOperation_Invert;
  static const int Replace = WGPUStencilOperation.WGPUStencilOperation_Replace;
  static const int Zero = WGPUStencilOperation.WGPUStencilOperation_Zero;
  static const int Keep = WGPUStencilOperation.WGPUStencilOperation_Keep;
}

class GPUCompareFunction {
  static const int NotEqual = WGPUCompareFunction.WGPUCompareFunction_NotEqual;
  static const int Greater = WGPUCompareFunction.WGPUCompareFunction_Greater;
  static const int GreaterEqual =
      WGPUCompareFunction.WGPUCompareFunction_GreaterEqual;
  static const int Equal = WGPUCompareFunction.WGPUCompareFunction_Equal;
  static const int LessEqual =
      WGPUCompareFunction.WGPUCompareFunction_LessEqual;

  static const int Less = WGPUCompareFunction.WGPUCompareFunction_Less;
  static const int Always = WGPUCompareFunction.WGPUCompareFunction_Always;
  static const int Never = WGPUCompareFunction.WGPUCompareFunction_Never;
}

class GPUPrimitiveTopology {
  static const int TriangleList =
      WGPUPrimitiveTopology.WGPUPrimitiveTopology_TriangleList;
  static const int PointList =
      WGPUPrimitiveTopology.WGPUPrimitiveTopology_PointList;
  static const int LineList =
      WGPUPrimitiveTopology.WGPUPrimitiveTopology_LineList;
  static const int LineStrip =
      WGPUPrimitiveTopology.WGPUPrimitiveTopology_LineStrip;
  static const int TriangleStrip =
      WGPUPrimitiveTopology.WGPUPrimitiveTopology_TriangleStrip;
}

class GPUColorWriteFlags {
  static const int All = WGPUColorWriteMask.WGPUColorWriteMask_All;
  static const int None = WGPUColorWriteMask.WGPUColorWriteMask_None;
}

class GPUBlendFactor {
  static const int One = WGPUBlendFactor.WGPUBlendFactor_One;
  static const int Zero = WGPUBlendFactor.WGPUBlendFactor_Zero;

  static const int OneMinusSrcAlpha =
      WGPUBlendFactor.WGPUBlendFactor_OneMinusSrcAlpha;
  static const int OneMinusSrcColor =
      WGPUBlendFactor.WGPUBlendFactor_OneMinusSrc;

  static const int OneMinusDstColor =
      WGPUBlendFactor.WGPUBlendFactor_OneMinusSrc;
  static const int OneMinusDstAlpha =
      WGPUBlendFactor.WGPUBlendFactor_OneMinusDstAlpha;

  static const int SrcColor = WGPUBlendFactor.WGPUBlendFactor_Src;
  static const int SrcAlpha = WGPUBlendFactor.WGPUBlendFactor_SrcAlpha;

  static const int DstColor = WGPUBlendFactor.WGPUBlendFactor_Dst;
  static const int DstAlpha = WGPUBlendFactor.WGPUBlendFactor_DstAlpha;

  static const int SrcAlphaSaturated =
      WGPUBlendFactor.WGPUBlendFactor_SrcAlphaSaturated;
}

class GPUBlendOperation {
  static const int Add = WGPUBlendOperation.WGPUBlendOperation_Add;
  static const int Subtract = WGPUBlendOperation.WGPUBlendOperation_Subtract;

  static const int ReverseSubtract =
      WGPUBlendOperation.WGPUBlendOperation_ReverseSubtract;
  static const int Min = WGPUBlendOperation.WGPUBlendOperation_Min;
  static const int Max = WGPUBlendOperation.WGPUBlendOperation_Max;
}

class GPUVertexStepMode {
  static const int Instance = WGPUVertexStepMode.WGPUVertexStepMode_Instance;
  static const int Vertex = WGPUVertexStepMode.WGPUVertexStepMode_Vertex;
}

class GPUInputStepMode {
  static const int Instance = WGPUVertexStepMode.WGPUVertexStepMode_Instance;
  static const int Vertex = WGPUVertexStepMode.WGPUVertexStepMode_Vertex;
}

class GPUFilterMode {
  static const int Nearest = WGPUFilterMode.WGPUFilterMode_Nearest;
  static const int Linear = WGPUFilterMode.WGPUFilterMode_Linear;
  static const int Force32 = WGPUFilterMode.WGPUFilterMode_Force32;
}

class GPUTextureDimension {
  static const int TwoD = WGPUTextureDimension.WGPUTextureDimension_2D;
  static const int ThreeD = WGPUTextureDimension.WGPUTextureDimension_3D;
}

class GPUTextureAspect {
  static const int All = WGPUTextureAspect.WGPUTextureAspect_All;
}

class GPUShaderStage {
  static const int Compute = WGPUShaderStage.WGPUShaderStage_Compute;
  static const int None = WGPUShaderStage.WGPUShaderStage_None;
  static const int Vertex = WGPUShaderStage.WGPUShaderStage_Vertex;
  static const int Fragment = WGPUShaderStage.WGPUShaderStage_Fragment;
  static const int Force32 = WGPUShaderStage.WGPUShaderStage_Force32;
}

class GPUStoreOp {
  static const int Undefined = WGPUStoreOp.WGPUStoreOp_Undefined;
  static const int Store = WGPUStoreOp.WGPUStoreOp_Store;
  static const int Discard = WGPUStoreOp.WGPUStoreOp_Discard;
  static const int Force32 = WGPUStoreOp.WGPUStoreOp_Force32;
}

class GPUTextureViewDimension {
  static const int Undefined =
      WGPUTextureViewDimension.WGPUTextureViewDimension_Undefined;
  static const int OneD = WGPUTextureViewDimension.WGPUTextureViewDimension_1D;
  static const int TwoD = WGPUTextureViewDimension.WGPUTextureViewDimension_2D;
}

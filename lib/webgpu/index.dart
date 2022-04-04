library webgpu;


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_webgpu/WebGPU_Binding.dart' hide bool;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';


part 'gpu.dart';
part 'GPUAdapter.dart';
part 'GPUDevice.dart';
part 'wgpu.dart';
part 'GPUCommandEncoder.dart';
part 'GPUTexture.dart';
part 'GPUBuffer.dart';
part 'GPUExtent3D.dart';
part 'GPUTextureView.dart';
part 'GPURenderPassEncoder.dart';
part 'GPUColor.dart';
part 'GPUImageCopyTexture.dart';
part 'GPUImageCopyBuffer.dart';
part 'GPUOrigin3D.dart';
part 'GPUQueue.dart';
part 'GPUCommandBuffer.dart';
part 'constant.dart';
part 'GPUShaderModule.dart';
part 'GPUPipelineLayout.dart';
part 'GPURenderPipeline.dart';
part 'GPUState.dart';
part 'GPUBlendComponent.dart';
part 'GPUBindGroupLayout.dart';
part 'GPUBindGroup.dart';
part 'GPUComputePipeline.dart';
part 'GPUComputePassEncoder.dart';
part 'GPUObjectBase.dart';
part 'GPUSampler.dart';
part 'GPUProgrammablePassEncoder.dart';
part 'GPUVertexBufferLayout.dart';

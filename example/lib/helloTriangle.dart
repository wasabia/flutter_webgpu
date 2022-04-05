import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter_webgpu/flutter_webgpu.dart';

class HelloTriangle {
  static render(int width, int height) {
  
    int bytes_per_pixel = Uint32List.bytesPerElement;
    int unpadded_bytes_per_row = width * bytes_per_pixel;
    int align = 256;
    int padded_bytes_per_row_padding =
        (align - unpadded_bytes_per_row % align) % align;
    int padded_bytes_per_row =
        unpadded_bytes_per_row + padded_bytes_per_row_padding;

    int bufferSize = padded_bytes_per_row * height;

    var adapter = requestAdapter(GPURequestAdapterOptions());
    var device = adapter.requestDevice(GPUDeviceDescriptor());

    device.setUncapturedErrorCallback();

    print("device.value: ${device.device.value} device: ${device.device} ");
    print("adapter.value: ${adapter.adapter.value} adapter: ${adapter.adapter} ");




    var pipeline = device.createRenderPipeline(GPURenderPipelineDescriptor(
        layout: device.createPipelineLayout(
        GPUPipelineLayoutDescriptor(
            bindGroupLayouts: null, bindGroupLayoutCount: 0)),
        vertex: GPUVertexState(
          module: device.createShaderModule(GPUShaderModuleDescriptor(
            code: """
[[stage(vertex)]]
fn main([[builtin(vertex_index)]] VertexIndex : u32)
     -> [[builtin(position)]] vec4<f32> {
  var pos = array<vec2<f32>, 3>(
      vec2<f32>(0.0, 0.5),
      vec2<f32>(-0.5, -0.5),
      vec2<f32>(0.5, -0.5));

  return vec4<f32>(pos[VertexIndex], 0.0, 1.0);
}
""",
          )),
          entryPoint: 'main',
        ),
        fragment: GPUFragmentState(
          module: device.createShaderModule(GPUShaderModuleDescriptor(
            code: """
[[stage(fragment)]]
fn main() -> [[location(0)]] vec4<f32> {
  return vec4<f32>(1.0, 0.0, 0.0, 1.0);
}
""",
          )),
          entryPoint: 'main',
          targets: GPUColorTargetState(
            format: GPUTextureFormat.RGBA8Unorm,
          ),
        ),
        primitive: GPUPrimitiveState(),
        multisample: GPUMultisampleState(),
      )
    );


    print(" HelloTriangle pipeline: ${pipeline.pipeline}  ");



    var commandEncoder = device.createCommandEncoder();


    var _textureExtent = GPUExtent3D(width: width, height: height);
    var textureDesc = GPUTextureDescriptor(
      format: GPUTextureFormat.RGBA8Unorm,
      size: _textureExtent,
      usage: GPUTextureUsage.RenderAttachment | GPUTextureUsage.CopySrc
    );

    var texture = device.createTexture(textureDesc);
    GPUTextureView textureView = texture.createView(GPUTextureViewDescriptor());
   

    var renderPassDescriptor = GPURenderPassDescriptor(
      colorAttachments: GPURenderPassColorAttachment(
        view: textureView,
        clearColor: GPUColor( r: 0.0, g: 0.0, b: 0.0, a: 1.0 ),
        loadOp: GPULoadOp.Clear,
        storeOp: GPUStoreOp.Store
      )

    );

    var passEncoder = commandEncoder.beginRenderPass(renderPassDescriptor);
    passEncoder.setPipeline(pipeline);
    passEncoder.draw(3, 1, 0, 0);
    passEncoder.end();



    var copyTexture =
        GPUImageCopyTexture(texture: texture, origin: GPUOrigin3D());

    var bufferDesc = GPUBufferDescriptor(
        size: bufferSize,
        usage: GPUBufferUsage.MapRead | GPUBufferUsage.CopyDst);
    var outputBuffer = device.createBuffer(bufferDesc);
    var copyBuffer = GPUImageCopyBuffer(
        buffer: outputBuffer, bytesPerRow: padded_bytes_per_row);

    commandEncoder.copyTextureToBuffer(copyTexture, copyBuffer, _textureExtent);


    var commandBuffer = commandEncoder.finish(GPUCommandBufferDescriptor());
    device.queue.submit(commandBuffer);

    outputBuffer.mapAsync(mode: WGPUMapMode_Read, size: bufferSize);

    device.poll(true);

    var data = outputBuffer.getMappedRange(offset: 0, size: bufferSize);
    Pointer<Uint8> pixles = data.cast<Uint8>();
    outputBuffer.unmap();

    return pixles.asTypedList(bufferSize);
  }
}

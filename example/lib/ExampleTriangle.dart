import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter_webgpu/flutter_webgpu.dart';

class ExampleTriangle {
  static render(int width, int height) {
    Uint32List numbers = Uint32List.fromList([1, 2, 3, 4]);
    int numbersSize = numbers.length * Uint8List.bytesPerElement;
    int numbersLength = numbersSize ~/ Uint8List.bytesPerElement;

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
    print(
        "adapter.value: ${adapter.adapter.value} adapter: ${adapter.adapter} ");

    String shaderStr = """
[[stage(vertex)]]
fn vs_main([[builtin(vertex_index)]] in_vertex_index: u32) -> [[builtin(position)]] vec4<f32> {
    let x = f32(i32(in_vertex_index) - 1);
    let y = f32(i32(in_vertex_index & 1u) * 2 - 1);
    return vec4<f32>(x, y, 0.0, 1.0);
}

[[stage(fragment)]]
fn fs_main() -> [[location(0)]] vec4<f32> {
    return vec4<f32>(1.0, 1.0, 0.5, 0.2);
}
    """;

    GPUShaderModuleDescriptor shaderSource =
        GPUShaderModuleDescriptor(code: shaderStr);
    var shader = device.createShaderModule(shaderSource);

    var pipelineLayout = device.createPipelineLayout(
        GPUPipelineLayoutDescriptor(
            bindGroupLayouts: null, bindGroupLayoutCount: 0));

    var _fragment = GPUFragmentState(
        module: shader,
        targets: GPUColorTargetState(
            format: GPUTextureFormat.RGBA8Unorm,
            writeMask: WGPUColorWriteMask_All,
            blend: GPUBlendState(
              color: GPUBlendComponent(
                  srcFactor: WGPUBlendFactor_One,
                  dstFactor: WGPUBlendFactor_Zero,
                  operation: WGPUBlendOperation_Add),
              alpha: GPUBlendComponent(
                  srcFactor: WGPUBlendFactor_One,
                  dstFactor: WGPUBlendFactor_Zero,
                  operation: WGPUBlendOperation_Add),
            )),
        entryPoint: 'fs_main');

    var _depthStencilState = GPUDepthStencilState(
      format: GPUTextureFormat.RGBA8Unorm,
      depthWriteEnabled: false,
      depthCompare: GPUCompareFunction.Never,
      stencilFront: GPUStencilFaceState(
        compare: GPUCompareFunction.Always
      ),
      stencilBack: GPUStencilFaceState(
        compare: GPUCompareFunction.Always
      ),
    );


    var pipeline = device.createRenderPipeline(GPURenderPipelineDescriptor(
        layout: pipelineLayout,
        vertex: GPUVertexState(
            module: shader, entryPoint: "vs_main"),
        primitive: GPUPrimitiveState(),
        multisample: GPUMultisampleState(),
        // depthStencil: _depthStencilState,
        fragment: _fragment));


    var _textureExtent = GPUExtent3D(width: width, height: height);
    var textureDesc = GPUTextureDescriptor(
      format: GPUTextureFormat.RGBA8Unorm,
      size: _textureExtent,
      usage: GPUTextureUsage.RenderAttachment | GPUTextureUsage.CopySrc
    );



    var texture = device.createTexture(textureDesc);
    GPUTextureView nextTexture = texture.createView(GPUTextureViewDescriptor(
      format: GPUTextureFormat.Undefined,
      mipLevelCount: 0,
      baseMipLevel: 0
    ));
    var encoder = device.createCommandEncoder(GPUCommandEncoderDescriptor());

    var color = GPUColor(r: 1.0, g: 0.5, b: 0.3, a: 0.9);
    var attach =
        GPURenderPassColorAttachment(
          view: nextTexture, 
          clearColor: color,
          loadOp: GPULoadOp.Clear,
          storeOp: GPUStoreOp.Store
        );

    var renderPass = encoder.beginRenderPass(GPURenderPassDescriptor(
      colorAttachments: attach,
      // depthStencilAttachment: GPURenderPassDepthStencilAttachment(
      //   view: nextTexture, 
      // )
    ));

 

    renderPass.setPipeline(pipeline);
       
    renderPass.draw(3, 1, 0, 0);
  
    renderPass.endPass();

    var copyTexture =
        GPUImageCopyTexture(texture: texture, origin: GPUOrigin3D());

    var bufferDesc = GPUBufferDescriptor(
        size: bufferSize,
        usage: GPUBufferUsage.MapRead | GPUBufferUsage.CopyDst);
    var outputBuffer = device.createBuffer(bufferDesc);
    var copyBuffer = GPUImageCopyBuffer(
        buffer: outputBuffer, bytesPerRow: padded_bytes_per_row);

    encoder.copyTextureToBuffer(copyTexture, copyBuffer, _textureExtent);

    var queue = device.queue;

    var commandBuffer = encoder.finish(GPUCommandBufferDescriptor());
    queue.submit(commandBuffer);

    outputBuffer.mapAsync(mode: WGPUMapMode_Read, size: bufferSize);

    device.poll(true);

    print(" wgpuBufferGetMappedRange bufferSize ${bufferSize} ");
    var data = outputBuffer.getMappedRange(offset: 0, size: bufferSize);
    print(" data ${data} ");
    print(data);

    Pointer<Uint8> pixles = data.cast<Uint8>();

    outputBuffer.unmap();

    return pixles.asTypedList(bufferSize);
  }
}

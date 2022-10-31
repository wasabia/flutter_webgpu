import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter_webgpu/flutter_webgpu.dart';

class HelloTriangle2 {
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
    print(
        "adapter.value: ${adapter.adapter.value} adapter: ${adapter.adapter} ");


    String vert = """
struct PositionColorInput {
  @location(0) in_position_2d: vec2<f32>,
  @location(1) in_color_rgba: vec4<f32>,
};

struct PositionColorOutput {
  @builtin(position) coords_output: vec4<f32>,
  @location(0) color_output: vec4<f32>,
};


struct Uniforms {
  uniform_color2: vec4<f32>,
  uniform_color: vec4<f32>,
};

@binding(0) @group(0) var<uniform> uniforms: Uniforms;
@binding(1) @group(0) var<uniform> uniforms2: Uniforms;

@vertex
fn main_vs(input: PositionColorInput)
     -> PositionColorOutput {
  var output: PositionColorOutput;
  output.color_output = input.in_color_rgba;
  output.coords_output = vec4<f32>(input.in_position_2d, 0.0, 1.0);
  return output;
}

@fragment
fn main_fs(output: PositionColorOutput) -> @location(0) vec4<f32> {
  // return output.color_output;
  return uniforms2.uniform_color2;
}
""";


  var vbodata = new Float32List.fromList([
    // 坐标 xy      // 颜色 RGBA
    0.0, 0.5,     1.0, 0.0, 0.0, 1.0, // ← 顶点 1
    -0.5, -0.5,      0.0, 1.0, 0.0, 1.0, // ← 顶点 2
    0.5, -0.5,      0.0, 0.0, 1.0, 1.0  // ← 顶点 3
  ]);
  var verticesBuffer = device.createBuffer(GPUBufferDescriptor(
    size: vbodata.lengthInBytes,
    usage: GPUBufferUsage.Vertex,
    mappedAtCreation: true,
  ));

  var pointer =
      verticesBuffer.getMappedRange(size: vbodata.lengthInBytes);
  Float32List _list =
      (pointer.cast<Float>()).asTypedList(vbodata.length);
  _list.setAll(0, vbodata);
  verticesBuffer.unmap();


    var shaderModule = device.createShaderModule(GPUShaderModuleDescriptor(
      code: vert,
    ));


    var bindGroupLayout = device.createBindGroupLayout(
      GPUBindGroupLayoutDescriptor(
        entries: [
          GPUBindGroupLayoutEntry(
            binding: 0,
            visibility: GPUShaderStage.Fragment,
            buffer: GPUBufferBindingLayout(
              type: GPUBufferBindingType.Uniform
            )
          ),
          GPUBindGroupLayoutEntry(
            binding: 1,
            visibility: GPUShaderStage.Fragment,
            buffer: GPUBufferBindingLayout(
              type: GPUBufferBindingType.Uniform
            )
          )
        ]
      )
    );




    var pipelineLayout = device.createPipelineLayout(GPUPipelineLayoutDescriptor(
          bindGroupLayouts: bindGroupLayout, bindGroupLayoutCount: 1));



    var pipeline = device.createRenderPipeline(GPURenderPipelineDescriptor(
      layout: pipelineLayout,
      vertex: GPUVertexState(
        module: shaderModule,
        entryPoint: 'main_vs',
        buffers: [
          GPUVertexBufferLayout(arrayStride: (2 + 4) * Float32List.bytesPerElement, attributes: [
            GPUVertexAttribute(
                format: GPUVertexFormat.Float32x2,
                offset: 0,
                shaderLocation: 0),
            GPUVertexAttribute(
                format: GPUVertexFormat.Float32x4,
                offset: 2 * Float32List.bytesPerElement,
                shaderLocation: 1)
          ])
        ]
      ),
      fragment: GPUFragmentState(
        module: shaderModule,
        entryPoint: 'main_fs',
        targets: GPUColorTargetState(
          format: GPUTextureFormat.RGBA8Unorm,
        ),
      ),
      primitive: GPUPrimitiveState(),
      multisample: GPUMultisampleState(),
    ));


  Float32List uniforms = Float32List.fromList([
    1.0, 1.0, 0.0, 1.0,
    0.5, 0.5, 0.0, 1.0
  ]);
  var uniformsBuffer = device.createBuffer(GPUBufferDescriptor(
    size: uniforms.lengthInBytes,
    usage: GPUBufferUsage.Uniform,
    mappedAtCreation: true,
  ));

  var pointer2 =
      uniformsBuffer.getMappedRange(size: uniforms.lengthInBytes);
  (pointer2.cast<Float>()).asTypedList(uniforms.length).setAll(0, uniforms);

  uniformsBuffer.unmap();


  Float32List uniforms2 = Float32List.fromList([
    0.0, 1.0, 1.0, 1.0,
    0.0, 0.5, 0.5, 1.0
  ]);
  var uniformsBuffer2 = device.createBuffer(GPUBufferDescriptor(
    size: uniforms2.lengthInBytes,
    usage: GPUBufferUsage.Uniform,
    mappedAtCreation: true,
  ));

  var pointer22 =
      uniformsBuffer2.getMappedRange(size: uniforms2.lengthInBytes);
  (pointer22.cast<Float>()).asTypedList(uniforms2.length).setAll(0, uniforms2);

  uniformsBuffer2.unmap();


 

  var bindGroup = device.createBindGroup(
    GPUBindGroupDescriptor(
      layout: bindGroupLayout, 
      entries: [
        GPUBindGroupEntry(binding: 0, buffer: uniformsBuffer),
        GPUBindGroupEntry(binding: 1, buffer: uniformsBuffer2)
      ],
      entryCount: 2
    )
  );



    var commandEncoder = device.createCommandEncoder();

    var _textureExtent = GPUExtent3D(width: width, height: height);
    var textureDesc = GPUTextureDescriptor(
        format: GPUTextureFormat.RGBA8Unorm,
        size: _textureExtent,
        usage: GPUTextureUsage.RenderAttachment | GPUTextureUsage.CopySrc);

    var texture = device.createTexture(textureDesc);
    GPUTextureView textureView = texture.createView(GPUTextureViewDescriptor());

    var renderPassDescriptor = GPURenderPassDescriptor(
        colorAttachments: GPURenderPassColorAttachment(
            view: textureView,
            clearColor: GPUColor(r: 0.0, g: 0.0, b: 0.0, a: 1.0),
            loadOp: GPULoadOp.Clear,
            storeOp: GPUStoreOp.Store));



    var passEncoder = commandEncoder.beginRenderPass(renderPassDescriptor);
    passEncoder.setPipeline(pipeline);
    passEncoder.setBindGroup(0, bindGroup);
    passEncoder.setVertexBuffer(0, verticesBuffer);
    passEncoder.draw(3, 1, 0, 0);
    passEncoder.end();


    var commandBuffer = commandEncoder.finish(GPUCommandBufferDescriptor());
    device.queue.submit(commandBuffer);

    // device.poll(true);


    var commandEncoder2 = device.createCommandEncoder();
    var copyTexture =
        GPUImageCopyTexture(texture: texture, origin: GPUOrigin3D());

    var bufferDesc = GPUBufferDescriptor(
        size: bufferSize,
        usage: GPUBufferUsage.MapRead | GPUBufferUsage.CopyDst);
    var outputBuffer = device.createBuffer(bufferDesc);
    var copyBuffer = GPUImageCopyBuffer(
        buffer: outputBuffer, bytesPerRow: padded_bytes_per_row);

    commandEncoder2.copyTextureToBuffer(copyTexture, copyBuffer, _textureExtent);

    

    var commandBuffer2 = commandEncoder2.finish(GPUCommandBufferDescriptor());
    device.queue.submit(commandBuffer2);

    outputBuffer.mapAsync(mode: WGPUMapMode_Read, size: bufferSize);

    device.poll(true);

    var data = outputBuffer.getMappedRange(offset: 0, size: bufferSize);
    Pointer<Uint8> pixles = data.cast<Uint8>();
    outputBuffer.unmap();

    return pixles.asTypedList(bufferSize);
  }
}

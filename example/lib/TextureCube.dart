import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webgpu/flutter_webgpu.dart';

class TextureCube {

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


    // prettier-ignore
    var cubeVertexArray = Float32List.fromList([
      // float4 position, float4 color, float2 uv,
      1, -1, 1, 1,   1, 0, 1, 1,  1, 1,
      -1, -1, 1, 1,  0, 0, 1, 1,  0, 1,
      -1, -1, -1, 1, 0, 0, 0, 1,  0, 0,
      1, -1, -1, 1,  1, 0, 0, 1,  1, 0,
      1, -1, 1, 1,   1, 0, 1, 1,  1, 1,
      -1, -1, -1, 1, 0, 0, 0, 1,  0, 0,

      1, 1, 1, 1,    1, 1, 1, 1,  1, 1,
      1, -1, 1, 1,   1, 0, 1, 1,  0, 1,
      1, -1, -1, 1,  1, 0, 0, 1,  0, 0,
      1, 1, -1, 1,   1, 1, 0, 1,  1, 0,
      1, 1, 1, 1,    1, 1, 1, 1,  1, 1,
      1, -1, -1, 1,  1, 0, 0, 1,  0, 0,

      -1, 1, 1, 1,   0, 1, 1, 1,  1, 1,
      1, 1, 1, 1,    1, 1, 1, 1,  0, 1,
      1, 1, -1, 1,   1, 1, 0, 1,  0, 0,
      -1, 1, -1, 1,  0, 1, 0, 1,  1, 0,
      -1, 1, 1, 1,   0, 1, 1, 1,  1, 1,
      1, 1, -1, 1,   1, 1, 0, 1,  0, 0,

      -1, -1, 1, 1,  0, 0, 1, 1,  1, 1,
      -1, 1, 1, 1,   0, 1, 1, 1,  0, 1,
      -1, 1, -1, 1,  0, 1, 0, 1,  0, 0,
      -1, -1, -1, 1, 0, 0, 0, 1,  1, 0,
      -1, -1, 1, 1,  0, 0, 1, 1,  1, 1,
      -1, 1, -1, 1,  0, 1, 0, 1,  0, 0,

      1, 1, 1, 1,    1, 1, 1, 1,  1, 1,
      -1, 1, 1, 1,   0, 1, 1, 1,  0, 1,
      -1, -1, 1, 1,  0, 0, 1, 1,  0, 0,
      -1, -1, 1, 1,  0, 0, 1, 1,  0, 0,
      1, -1, 1, 1,   1, 0, 1, 1,  1, 0,
      1, 1, 1, 1,    1, 1, 1, 1,  1, 1,

      1, -1, -1, 1,  1, 0, 0, 1,  1, 1,
      -1, -1, -1, 1, 0, 0, 0, 1,  0, 1,
      -1, 1, -1, 1,  0, 1, 0, 1,  0, 0,
      1, 1, -1, 1,   1, 1, 0, 1,  1, 0,
      1, -1, -1, 1,  1, 0, 0, 1,  1, 1,
      -1, 1, -1, 1,  0, 1, 0, 1,  0, 0,
    ]);

    // Create a vertex buffer from the cube data.
    var verticesBuffer = device.createBuffer(GPUBufferDescriptor(
      size: cubeVertexArray.lengthInBytes,
      usage: GPUBufferUsage.Vertex,
      mappedAtCreation: true,
    ));
    
    var pointer = verticesBuffer.getMappedRange(size: cubeVertexArray.lengthInBytes);
    Float32List _list = (pointer.cast<ffi.Float>()).asTypedList(cubeVertexArray.length);
    _list.setAll(0, cubeVertexArray);
    verticesBuffer.unmap();

  String vert1 = """
struct Uniforms {
  modelViewProjectionMatrix : mat4x4<f32>;
};
[[binding(0), group(0)]] var<uniform> uniforms : Uniforms;

struct VertexOutput {
  [[builtin(position)]] Position : vec4<f32>;
  [[location(0)]] fragUV : vec2<f32>;
  [[location(1)]] fragPosition: vec4<f32>;
};

[[stage(vertex)]]
fn main([[location(0)]] position : vec4<f32>,
        [[location(1)]] uv : vec2<f32>) -> VertexOutput {
  var output : VertexOutput;
  output.Position = uniforms.modelViewProjectionMatrix * position;
  output.fragUV = uv;
  output.fragPosition = 0.5 * (position + vec4<f32>(1.0, 1.0, 1.0, 1.0));
  return output;
}
""";

  String frag1 = """
[[group(0), binding(1)]] var mySampler: sampler;
[[group(0), binding(2)]] var myTexture: texture_2d<f32>;

[[stage(fragment)]]
fn main([[location(0)]] fragUV: vec2<f32>,
        [[location(1)]] fragPosition: vec4<f32>) -> [[location(0)]] vec4<f32> {
  return textureSample(myTexture, mySampler, fragUV) * fragPosition;
}
""";

      
    int cubeVertexSize = 4 * 10; // Byte size of one cube vertex.
    int cubePositionOffset = 0;
    int cubeColorOffset = 4 * 4; // Byte offset of cube vertex color attribute.
    int cubeUVOffset = 4 * 8;
    int cubeVertexCount = 36;

    var vertModule = device.createShaderModule(GPUShaderModuleDescriptor(
      code: vert1,
    ));

    var fragModule = device.createShaderModule(GPUShaderModuleDescriptor(
      code: frag1,
    ));

    var vertex3 = GPUVertexState(
      module: vertModule,
      entryPoint: 'main',
      buffers: [
        GPUVertexBufferLayout(
          arrayStride: cubeVertexSize,
          attributes: [
            GPUVertexAttribute(format: GPUVertexFormat.Float32x4, offset: cubePositionOffset, shaderLocation: 0),
            GPUVertexAttribute(format: GPUVertexFormat.Float32x2, offset: cubeUVOffset, shaderLocation: 1)
          ]
        )
      ]
    );

    var uniformGroupLayout = device.createBindGroupLayout( GPUBindGroupLayoutDescriptor(
        entries: [
          GPUBindGroupLayoutEntry(
            binding: 0,
            visibility: GPUShaderStage.Vertex,
            buffer: GPUBufferBindingLayout(
              type: GPUBufferBindingType.Uniform
            )
          ),
          GPUBindGroupLayoutEntry(
            binding: 1,
            visibility: GPUShaderStage.Fragment,
            buffer: GPUBufferBindingLayout(type: GPUBufferBindingType.Uniform)
          ),
          GPUBindGroupLayoutEntry(
            binding: 2,
            visibility: GPUShaderStage.Fragment,
            buffer: GPUBufferBindingLayout(type: GPUBufferBindingType.Uniform)
          )
        ],
        entryCount: 1
     ) );

    var layout = device.createPipelineLayout(
          GPUPipelineLayoutDescriptor(
            bindGroupLayouts: uniformGroupLayout, bindGroupLayoutCount: 1));

    var desc = GPURenderPipelineDescriptor(
      layout: layout,
      vertex: vertex3,
      fragment: GPUFragmentState(
        module: fragModule,
        entryPoint: 'main',
        targets: GPUColorTargetState(
          format: GPUTextureFormat.RGBA8Unorm,
        ),
      ),
      primitive: GPUPrimitiveState(
        cullMode: GPUCullMode.Back,
        frontFace: GPUFrontFace.CCW
      ),
      multisample: GPUMultisampleState(),
      depthStencil: GPUDepthStencilState(
        depthWriteEnabled: true,
        depthCompare: GPUCompareFunction.Greater,
        format: GPUTextureFormat.Depth24Plus,
        stencilFront: GPUStencilFaceState(
          compare:  GPUCompareFunction.Always
        ),
        stencilBack: GPUStencilFaceState(compare: GPUCompareFunction.Always),
        depthBias: 2,
        depthBiasSlopeScale: 2.0,
        depthBiasClamp: 0.0
      )
    );


    var pipeline = device.createRenderPipeline( desc );


    var presentationSize = GPUExtent3D(width: width, height: height);

    var depthTexture = device.createTexture(GPUTextureDescriptor(
      size: presentationSize,
      format: GPUTextureFormat.Depth24Plus,
      usage: GPUTextureUsage.RenderAttachment
    ));

    var uniformBufferSize = 4 * 16; // 4x4 matrix
    var uniformBuffer = device.createBuffer(GPUBufferDescriptor(
      size: uniformBufferSize,
      usage: GPUBufferUsage.Uniform | GPUBufferUsage.CopyDst,
    ));

    GPUTexture cubeTexture = device.createTexture(GPUTextureDescriptor(
      size: presentationSize,
      format: GPUTextureFormat.RGBA8Unorm,
      usage:  GPUTextureUsage.TextureBinding | GPUTextureUsage.CopyDst | GPUTextureUsage.RenderAttachment
    ));

    var pixels = Uint8List(width * height * 4);
   
    device.queue.writeTexture(GPUImageCopyTexture(texture: cubeTexture), pixels, GPUTextureDataLayout(bytesPerRow: width * 4, offset: 0), presentationSize);

    var sampler = device.createSampler(GPUSamplerDescriptor(
      magFilter: GPUFilterMode.Linear,
      minFilter: GPUFilterMode.Linear
    ));


    var bindGroupLayout = pipeline.getBindGroupLayout(0);
  

    var uniformBindGroup = device.createBindGroup(GPUBindGroupDescriptor(
      layout: bindGroupLayout,
      entries: [
        GPUBindGroupEntry(
          binding: 0,
          buffer: uniformBuffer,
        ),
        GPUBindGroupEntry(
          binding: 1,
          sampler: sampler,
        ),
        GPUBindGroupEntry(
          binding: 2,
          textureView: cubeTexture.createView(),
        ),
      ],
    ));





    Float32List transformationMatrix = Float32List.fromList([
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0, 0, 1, 0,
      0, 0, 0, 1
    ]);

    Matrix4 _mat = Matrix4.rotationX(0.36);
    _mat.rotateY(0.2);
    _mat.scale(0.5, 0.5, 0.5);

    transformationMatrix = Float32List.fromList(_mat.storage);


    // var mp = calloc<Float>(transformationMatrix.length);
    // Float32List _list2 = (mp as Pointer<Float>).asTypedList(transformationMatrix.length);
    // _list2.setAll(0, transformationMatrix);

    device.queue.writeBuffer(
      uniformBuffer,
      0,
      transformationMatrix,
      transformationMatrix.lengthInBytes
    );
   

    var commandEncoder = device.createCommandEncoder();


    var _textureExtent = GPUExtent3D(width: width, height: height);
    var textureDesc = GPUTextureDescriptor(
      format: GPUTextureFormat.RGBA8Unorm,
      size: _textureExtent,
      usage: GPUTextureUsage.RenderAttachment | GPUTextureUsage.CopySrc
    );

    var texture = device.createTexture(textureDesc);
    GPUTextureView textureView = texture.createView(GPUTextureViewDescriptor());
   

    var texture0 = device.createTexture(GPUTextureDescriptor(
      format: GPUTextureFormat.RGBA8Unorm,
      size: _textureExtent,
      usage: GPUTextureUsage.RenderAttachment | GPUTextureUsage.CopySrc,
      sampleCount: 1
    ));
    GPUTextureView textureView0 = texture0.createView(GPUTextureViewDescriptor());

    var renderPassDescriptor = GPURenderPassDescriptor(
      colorAttachments: GPURenderPassColorAttachment(
        // view: textureView0,
        // resolveTarget: textureView,
        view: textureView,
        clearColor: GPUColor( r: 0.5, g: 0.5, b: 0.0, a: 0.5 ),
        storeOp: GPUStoreOp.Store,
        loadOp: GPULoadOp.Clear
      ),
      depthStencilAttachment: GPURenderPassDepthStencilAttachment(
        view: depthTexture.createView(GPUTextureViewDescriptor()),
        // depthLoadOp: GPULoadOp.Clear,
        // depthStoreOp: GPUStoreOp.Store,
        // depthClearValue: 0.0,
        // stencilLoadOp: GPULoadOp.Clear,
        // stencilStoreOp: GPUStoreOp.Store,
        // stencilClearValue: 0,
      ),
    );


    var passEncoder = commandEncoder.beginRenderPass(renderPassDescriptor);
    passEncoder.setPipeline(pipeline);
    passEncoder.setBindGroup(0, uniformBindGroup);
    passEncoder.setVertexBuffer(0, verticesBuffer);
    passEncoder.draw(cubeVertexCount, 1, 0, 0);
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

    var data = outputBuffer.getMappedRange(offset: 0);
    ffi.Pointer<ffi.Uint8> pixles = data.cast<ffi.Uint8>();
    outputBuffer.unmap();

    return pixles.asTypedList(bufferSize);
  }
}

import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webgpu/flutter_webgpu.dart';


  String shaderStr = """
struct PrimeIndices {
    data: [[stride(4)]] array<u32>;
}; // this is used as both input and output for convenience

[[group(0), binding(0)]]
var<storage, read_write> v_indices: PrimeIndices;

// The Collatz Conjecture states that for any integer n:
// If n is even, n = n/2
// If n is odd, n = 3n+1
// And repeat this process for each new n, you will always eventually reach 1.
// Though the conjecture has not been proven, no counterexample has ever been found.
// This function returns how many times this recurrence needs to be applied to reach 1.
fn collatz_iterations(n_base: u32) -> u32{
    var n: u32 = n_base;
    var i: u32 = 0u;
    loop {
        if (n <= 1u) {
            break;
        }
        if (n % 2u == 0u) {
            n = n / 2u;
        }
        else {
            // Overflow? (i.e. 3*n + 1 > 0xffffffffu?)
            if (n >= 1431655765u) {   // 0x55555555u
                return 4294967295u;   // 0xffffffffu
            }

            n = 3u * n + 1u;
        }
        i = i + 1u;
    }
    return i;
}

[[stage(compute), workgroup_size(1)]]
fn main([[builtin(global_invocation_id)]] global_id: vec3<u32>) {
    v_indices.data[global_id.x] = collatz_iterations(v_indices.data[global_id.x]);
}
    """;

  String computeWGSL = """
struct Particle {
  pos : vec2<f32>;
  vel : vec2<f32>;
};

struct SimParams {
  deltaT : f32;
  rule1Distance : f32;
  rule2Distance : f32;
  rule3Distance : f32;
  rule1Scale : f32;
  rule2Scale : f32;
  rule3Scale : f32;
};

[[group(0), binding(0)]] var<uniform> params : SimParams;
[[group(0), binding(1)]] var<storage, read> particlesSrc : array<Particle>;
[[group(0), binding(2)]] var<storage, read_write> particlesDst : array<Particle>;

[[stage(compute), workgroup_size(64)]]
fn main([[builtin(global_invocation_id)]] global_invocation_id: vec3<u32>) {
  let total = arrayLength(&particlesSrc);
  let index = global_invocation_id.x;
  if (index >= total) {
    return;
  }

  var vPos : vec2<f32> = particlesSrc[index].pos;
  var vVel : vec2<f32> = particlesSrc[index].vel;

  var cMass : vec2<f32> = vec2<f32>(0.0, 0.0);
  var cVel : vec2<f32> = vec2<f32>(0.0, 0.0);
  var colVel : vec2<f32> = vec2<f32>(0.0, 0.0);
  var cMassCount : i32 = 0;
  var cVelCount : i32 = 0;

  var i : u32 = 0u;
  loop {
    if (i >= total) {
      break;
    }
    if (i == index) {
      continue;
    }

    let pos = particlesSrc[i].pos;
    let vel = particlesSrc[i].vel;

    if (distance(pos, vPos) < params.rule1Distance) {
      cMass = cMass + pos;
      cMassCount = cMassCount + 1;
    }
    if (distance(pos, vPos) < params.rule2Distance) {
      colVel = colVel - (pos - vPos);
    }
    if (distance(pos, vPos) < params.rule3Distance) {
      cVel = cVel + vel;
      cVelCount = cVelCount + 1;
    }

    continuing {
      i = i + 1u;
    }
  }
  if (cMassCount > 0) {
    cMass = cMass * (1.0 / f32(cMassCount)) - vPos;
  }
  if (cVelCount > 0) {
    cVel = cVel * (1.0 / f32(cVelCount));
  }

  vVel = vVel + (cMass * params.rule1Scale) +
      (colVel * params.rule2Scale) +
      (cVel * params.rule3Scale);

  // clamp velocity for a more pleasing simulation
  vVel = normalize(vVel) * clamp(length(vVel), 0.0, 0.1);

  // kinematic update
  vPos = vPos + vVel * params.deltaT;

  // Wrap around boundary
  if (vPos.x < -1.0) {
    vPos.x = 1.0;
  }
  if (vPos.x > 1.0) {
    vPos.x = -1.0;
  }
  if (vPos.y < -1.0) {
    vPos.y = 1.0;
  }
  if (vPos.y > 1.0) {
    vPos.y = -1.0;
  }

  // Write back
  particlesDst[index] = Particle(vPos, vVel);
}

""";

  String drawWGSL = """
[[stage(vertex)]]
fn main_vs(
    [[location(0)]] particle_pos: vec2<f32>,
    [[location(1)]] particle_vel: vec2<f32>,
    [[location(2)]] position: vec2<f32>,
) -> [[builtin(position)]] vec4<f32> {
    let angle = -atan2(particle_vel.x, particle_vel.y);
    let pos = vec2<f32>(
        position.x * cos(angle) - position.y * sin(angle),
        position.x * sin(angle) + position.y * cos(angle)
    );
    return vec4<f32>(pos + particle_pos, 0.0, 1.0);
}

[[stage(fragment)]]
fn main_fs() -> [[location(0)]] vec4<f32> {
    return vec4<f32>(1.0, 1.0, 1.0, 1.0);
}

""";

int NUM_PARTICLES = 1500;
int PARTICLES_PER_GROUP = 64;


class Boids {

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
 
    var compute_shader = device.createShaderModule(GPUShaderModuleDescriptor(
      code: computeWGSL,
    ));

    return null;


    var draw_shader = device.createShaderModule(GPUShaderModuleDescriptor(
      code: drawWGSL,
    ));


    var sim_param_data = Float32List.fromList([
      0.04, // deltaT
      0.1,     // rule1Distance
      0.025,   // rule2Distance
      0.025,   // rule3Distance
      0.02,    // rule1Scale
      0.05,    // rule2Scale
      0.005,   // rule3Scale
    ]);

    var sim_param_buffer = device.createBuffer(GPUBufferDescriptor(
      size: sim_param_data.lengthInBytes,
      usage: GPUBufferUsage.Vertex,
      mappedAtCreation: true,
    ));
    
    var pointer = sim_param_buffer.getMappedRange(size: sim_param_data.lengthInBytes);
    Float32List _list = (pointer.cast<ffi.Float>()).asTypedList(sim_param_data.length);
    _list.setAll(0, sim_param_data);
    sim_param_buffer.unmap();


    var compute_bind_group_layout = device.createBindGroupLayout( GPUBindGroupLayoutDescriptor(
        entries: [
          GPUBindGroupLayoutEntry(
            binding: 0,
            visibility: GPUShaderStage.Compute,
            buffer: GPUBufferBindingLayout(
              type: GPUBufferBindingType.Uniform,
              minBindingSize: sim_param_data.lengthInBytes
            )
          ),
          GPUBindGroupLayoutEntry(
            binding: 1,
            visibility: GPUShaderStage.Compute,
            buffer: GPUBufferBindingLayout(
              type: GPUBufferBindingType.Storage,
              minBindingSize: NUM_PARTICLES * 16
            )
          ),
          GPUBindGroupLayoutEntry(
            binding: 2,
            visibility: GPUShaderStage.Compute,
            buffer: GPUBufferBindingLayout(
              type: GPUBufferBindingType.Storage,
              minBindingSize: NUM_PARTICLES * 16
            )
          )
        ],
        entryCount: 3
     ) );


    var compute_pipeline_layout = device.createPipelineLayout(
          GPUPipelineLayoutDescriptor(
            bindGroupLayouts: compute_bind_group_layout, bindGroupLayoutCount: 1));

    var render_pipeline_layout = device.createPipelineLayout(
          GPUPipelineLayoutDescriptor(
            bindGroupLayouts: compute_bind_group_layout, bindGroupLayoutCount: 1));

    var desc = GPURenderPipelineDescriptor(
      layout: render_pipeline_layout,
      vertex: GPUVertexState(
        module: draw_shader,
        entryPoint: 'main_vs',
        buffers: [
          GPUVertexBufferLayout(
            arrayStride: 4*4,
            stepMode: GPUInputStepMode.Instance,
            attributes: [
              GPUVertexAttribute(format: GPUVertexFormat.Float32x2, offset: 0, shaderLocation: 0),
              GPUVertexAttribute(format: GPUVertexFormat.Float32x2, offset: 0, shaderLocation: 1)
            ]
          ),
          GPUVertexBufferLayout(
            arrayStride: 4*2,
            stepMode: GPUInputStepMode.Instance,
            attributes: [
              GPUVertexAttribute(format: GPUVertexFormat.Float32x2, offset: 0, shaderLocation: 2),
            ]
          )
        ]
      ),
      fragment: GPUFragmentState(
        module: draw_shader,
        entryPoint: 'main_fs',
        targets: GPUColorTargetState(
          format: GPUTextureFormat.RGBA8Unorm,
        ),
      ),
      primitive: GPUPrimitiveState(
        cullMode: GPUCullMode.Back,
        frontFace: GPUFrontFace.CCW
      ),
      multisample: GPUMultisampleState(),
      // depthStencil: GPUDepthStencilState(
      //   depthWriteEnabled: true,
      //   depthCompare: GPUCompareFunction.Greater,
      //   format: GPUTextureFormat.Depth24Plus,
      //   stencilFront: GPUStencilFaceState(
      //     compare:  GPUCompareFunction.Always
      //   ),
      //   stencilBack: GPUStencilFaceState(compare: GPUCompareFunction.Always),
      //   depthBias: 2,
      //   depthBiasSlopeScale: 2.0,
      //   depthBiasClamp: 0.0
      // )
    );



    var compute_pipeline = device.createComputePipeline(
      GPUComputePipelineDescriptor(layout: compute_pipeline_layout, compute: GPUProgrammableStage(module: compute_shader, entryPoint: 'main'))
    );


    var vertex_buffer_data = Float32List.fromList([-0.01, -0.02, 0.01, -0.02, 0.00, 0.02]);
    var vertices_buffer = device.createBuffer(GPUBufferDescriptor(
      size: sim_param_data.lengthInBytes,
      usage: GPUBufferUsage.Vertex,
      mappedAtCreation: true,
    ));
    
    var pointer1 = vertices_buffer.getMappedRange(size: vertex_buffer_data.lengthInBytes);
    Float32List _list1 = (pointer1.cast<ffi.Float>()).asTypedList(vertex_buffer_data.length);
    _list1.setAll(0, vertex_buffer_data);
    vertices_buffer.unmap();


    var initial_particle_data = Float32List(4 * NUM_PARTICLES);


    var particle_buffers0 = device.createBuffer(GPUBufferDescriptor(
      size: initial_particle_data.lengthInBytes,
      usage: GPUBufferUsage.Vertex,
      mappedAtCreation: true,
    ));
    var particle_buffers1 = device.createBuffer(GPUBufferDescriptor(
      size: initial_particle_data.lengthInBytes,
      usage: GPUBufferUsage.Vertex,
      mappedAtCreation: true,
    ));
    var _pointer0 = particle_buffers0.getMappedRange(size: initial_particle_data.lengthInBytes);
    Float32List _plist0 = (_pointer0.cast<ffi.Float>()).asTypedList(initial_particle_data.length);
    _plist0.setAll(0, initial_particle_data);
    particle_buffers0.unmap();

    var _pointer1 = particle_buffers1.getMappedRange(size: initial_particle_data.lengthInBytes);
    Float32List _plist1 = (_pointer1.cast<ffi.Float>()).asTypedList(initial_particle_data.length);
    _plist1.setAll(0, initial_particle_data);
    particle_buffers1.unmap();


    var particle_bind_groups0 = device.createBindGroup(GPUBindGroupDescriptor(
      layout: compute_bind_group_layout,
      entries: [
        GPUBindGroupEntry(
          binding: 0,
          buffer: sim_param_buffer,
        ),
        GPUBindGroupEntry(
          binding: 1,
          buffer: particle_buffers0,
        ),
        GPUBindGroupEntry(
          binding: 2,
          buffer: particle_buffers1,
        ),
      ],
    ));

    var particle_bind_groups1 = device.createBindGroup(GPUBindGroupDescriptor(
      layout: compute_bind_group_layout,
      entries: [
        GPUBindGroupEntry(
          binding: 0,
          buffer: sim_param_buffer,
        ),
        GPUBindGroupEntry(
          binding: 1,
          buffer: particle_buffers1,
        ),
        GPUBindGroupEntry(
          binding: 2,
          buffer: particle_buffers0,
        ),
      ],
    ));

    int work_group_count = (NUM_PARTICLES / PARTICLES_PER_GROUP).ceil();




    var render_pipeline = device.createRenderPipeline( desc );


    var presentationSize = GPUExtent3D(width: width, height: height);

    var depthTexture = device.createTexture(GPUTextureDescriptor(
      size: presentationSize,
      format: GPUTextureFormat.Depth24Plus,
      usage: GPUTextureUsage.RenderAttachment
    ));



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
        depthLoadOp: GPULoadOp.Clear,
        depthStoreOp: GPUStoreOp.Store,
        depthClearValue: 0.0,
        // stencilLoadOp: GPULoadOp.Clear,
        // stencilStoreOp: GPUStoreOp.Store,
        // stencilClearValue: 0,
      ),
    );


    var passEncoder = commandEncoder.beginComputePass();
    passEncoder.setPipeline(compute_pipeline);
    passEncoder.setBindGroup(0, particle_bind_groups0);
    // passEncoder.draw(cubeVertexCount, 1, 0, 0);
    passEncoder.dispatch(work_group_count);
    passEncoder.endPass();


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

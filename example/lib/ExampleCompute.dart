import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter_webgpu/flutter_webgpu.dart';



class ExampleCompute {


  static render(int width, int height) {
    Uint32List numbers = Uint32List.fromList(
      [
        1, 2, 3, 4
      ]);
    int numbersSize = numbers.length * Uint32List.bytesPerElement;
    int numbersLength = numbersSize ~/ Uint32List.bytesPerElement;
    
    var adapter = requestAdapter( GPURequestAdapterOptions() );
    var device = adapter.requestDevice( GPUDeviceDescriptor() );


    device.setUncapturedErrorCallback();

    print("device.value: ${device.device.value} device: ${device.device} ");
    print("adapter.value: ${adapter.adapter.value} adapter: ${adapter.adapter} ");

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

    GPUShaderModuleDescriptor shaderSource = GPUShaderModuleDescriptor(code: shaderStr);
    var shader = device.createShaderModule(shaderSource);

    var bufferDesc0 = GPUBufferDescriptor(size: numbersSize, usage: GPUBufferUsage.MapRead | GPUBufferUsage.CopyDst);
    var stagingBuffer = device.createBuffer(bufferDesc0);

    print("numbersSize: ${numbersSize} ");

    var bufferDesc1 = GPUBufferDescriptor(size: numbersSize, usage: GPUBufferUsage.Storage | GPUBufferUsage.CopyDst |
                           GPUBufferUsage.CopySrc | GPUBufferUsage.MapRead | GPUBufferBindingType.Uniform);
    var storageBuffer = device.createBuffer(bufferDesc1);

    var _bindGroupLayoutDesc = GPUBindGroupLayoutDescriptor(
      entries: [GPUBindGroupLayoutEntry(
        binding: 0,
        visibility: GPUShaderStage.Compute,
        buffer: GPUBufferBindingLayout( type: GPUBufferBindingType.Storage )
      )],
      entryCount: 1
    );
    
    var bindGroupLayout = device.createBindGroupLayout( _bindGroupLayoutDesc );
    var pipelineLayout = device.createPipelineLayout(GPUPipelineLayoutDescriptor(
      bindGroupLayouts: bindGroupLayout,
      bindGroupLayoutCount: 1
    ));

    var computePipeline = device.createComputePipeline(GPUComputePipelineDescriptor(
      layout: pipelineLayout,
      compute: GPUProgrammableStageDescriptor(module: shader, entryPoint: 'main')
    ));

    var encoder = device.createCommandEncoder( GPUCommandEncoderDescriptor() );

    var computePass = encoder.beginComputePass( GPUComputePassDescriptor() );

    
    computePass.setPipeline(computePipeline);


    var bindGroup = device.createBindGroup(GPUBindGroupDescriptor(
      label: "Bind Group",
      layout: bindGroupLayout,
      entries: [GPUBindGroupEntry(
        binding: 0,
        buffer: storageBuffer)],
      entryCount: 1
    ));
 
    computePass.setBindGroup(0, bindGroup, 0, null);
    computePass.dispatch(numbersLength, 1, 1);
    computePass.end();

    

    encoder.copyBufferToBuffer(storageBuffer, 0, stagingBuffer, 0, numbersSize);
                                       
    
    var queue = device.queue;
    
    var commandBuffer = encoder.finish( GPUCommandBufferDescriptor() );

    queue.writeBuffer(storageBuffer, 0, numbers, numbersSize);
    queue.submit(commandBuffer);


    stagingBuffer.mapAsync(mode: WGPUMapMode_Read, size: numbersSize);

    device.poll(true);

    print(" wgpuBufferGetMappedRange ");
    var data = stagingBuffer.getMappedRange(offset: 0, size: numbersSize);
    print(" data ${data} ");

    Pointer<Uint32> pixles = data.cast<Uint32>();

    print(" compute result: ");
    print( pixles.asTypedList(numbers.length) );

    stagingBuffer.unmap();

    return null;


  }

}
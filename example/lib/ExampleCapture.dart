import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter_webgpu/flutter_webgpu.dart';



class ExampleCapture {


  static render(int width, int height) {

    var adapter = requestAdapter( GPURequestAdapterOptions() );
    var device = adapter.requestDevice( GPUDeviceDescriptor() );

 
    int bytes_per_pixel = Uint32List.bytesPerElement;
    int unpadded_bytes_per_row = width * bytes_per_pixel;
    int align = 256;
    int padded_bytes_per_row_padding = (align - unpadded_bytes_per_row % align) % align;
    int padded_bytes_per_row = unpadded_bytes_per_row + padded_bytes_per_row_padding;

    int bufferSize = padded_bytes_per_row * height;


    var bufferDesc = GPUBufferDescriptor(size: bufferSize, usage: GPUBufferUsage.MapRead | GPUBufferUsage.CopyDst);
    var outputBuffer = device.createBuffer(bufferDesc);

    var textureExtent = GPUExtent3D(width: width, height: height);

   
    var textureDesc = GPUTextureDescriptor(
      size: textureExtent,
      format: GPUTextureFormat.RGBA8UnormSrgb,
      usage: GPUTextureUsage.RenderAttachment | GPUTextureUsage.CopyDst | GPUTextureUsage.CopySrc
    );
    var texture = device.createTexture(textureDesc);

    var encoder = device.createCommandEncoder( GPUCommandEncoderDescriptor() );

    var outputAttachment = texture.createView(GPUTextureViewDescriptor(
      format: GPUTextureFormat.Undefined
    ));

    var color = GPUColor(r: 1.0, g: 0.0, b: 0.0, a: 1.0);

    var attach =  GPURenderPassColorAttachment(
      view: outputAttachment,
      clearColor: color,
      loadOp: GPULoadOp.Clear,
      storeOp: GPUStoreOp.Store
    );

    var renderPass = encoder.beginRenderPass(GPURenderPassDescriptor(
      colorAttachments: attach
    ));
    renderPass.endPass();
    
    print(" end pass .... ");

    var copyTexture = GPUImageCopyTexture(texture: texture, origin: GPUOrigin3D());
    var copyBuffer = GPUImageCopyBuffer(buffer: outputBuffer, bytesPerRow: padded_bytes_per_row);

    encoder.copyTextureToBuffer(copyTexture, copyBuffer, textureExtent);


    var queue = device.queue;
    
    var commandBuffer = encoder.finish( GPUCommandBufferDescriptor() );

    queue.submit(commandBuffer);

    outputBuffer.mapAsync(mode: WGPUMapMode_Read, size: bufferSize);

    device.poll(true);

    var data = outputBuffer.getMappedRange(offset: 0, size: bufferSize);
    outputBuffer.unmap();

    
    print(" data ${data} ");
  

    Pointer<Uint8> pixles = data.cast<Uint8>();


    return pixles.asTypedList(width * height * 4);

  }

}
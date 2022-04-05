import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter_webgpu/flutter_webgpu.dart';

void wgpuRequestAdapterCallback(int status, WGPUAdapter received,
    Pointer<Int8> message, Pointer<Void> userdata) {
  print(
      "wgpuRequestAdapterCallback  status: ${status} received: ${received} message: ${message} userdata: ${userdata} ");

  Pointer<WGPUAdapter> _adapter = userdata.cast();
  _adapter.value = received;

  print("wgpuRequestAdapterCallback  userdata: ${userdata} ");
}

typedef WgpuRequestAdapterCallback = Void Function(
    Int32, WGPUAdapter, Pointer<Int8>, Pointer<Void>);

void wgpuRequestDeviceCallback(int status, WGPUDevice received,
    Pointer<Int8> message, Pointer<Void> userdata) {
  print(
      "wgpuRequestDeviceCallback status: ${status} received: ${received} message: ${message} userdata: ${userdata} ");
  Pointer<WGPUDevice> _device = userdata.cast();
  _device.value = received;
  print("wgpuRequestDeviceCallback  userdata: ${userdata} ");
}

typedef WgpuRequestDeviceCallback = Void Function(
    Int32, WGPUDevice, Pointer<Int8>, Pointer<Void>);

void readBufferMap(int status, Pointer<Void> userdata) {
  print("  readBufferMap callback ....... ");
}

typedef ReadBufferMap = Void Function(Int32, Pointer<Void>);

class Example {
  static render(int width, int height) {
    var _webGPU = Wgpu.binding;

    Pointer<WGPURequestAdapterOptions> options =
        ffi.calloc<WGPURequestAdapterOptions>();
    WGPURequestAdapterOptions wrao = options.ref;
    wrao.nextInChain = nullptr;
    wrao.compatibleSurface = nullptr;

    Pointer<WGPUAdapter> adapter = ffi.calloc<WGPUAdapter>();

    var adapterCallback = Pointer.fromFunction<WgpuRequestAdapterCallback>(
        wgpuRequestAdapterCallback);

    _webGPU.wgpuInstanceRequestAdapter(
        nullptr, options, adapterCallback, adapter.cast<Void>());

    Pointer<WGPUChainedStruct> chain = ffi.calloc<WGPUChainedStruct>();
    WGPUChainedStruct _chain = chain.ref;
    _chain.next = nullptr;
    _chain.sType = WGPUNativeSType.WGPUSType_DeviceExtras;

    Pointer<WGPURequiredLimits> requiredLimits =
        ffi.calloc<WGPURequiredLimits>();
    WGPURequiredLimits _requiredLimits = requiredLimits.ref;
    _requiredLimits.nextInChain = nullptr;

    Pointer<WGPULimits> limits = ffi.calloc<WGPULimits>();
    WGPULimits _limits = limits.ref;
    _limits.maxBindGroups = 1;

    _requiredLimits.limits = _limits;

    Pointer<WGPUDeviceExtras> deviceExtras = ffi.calloc<WGPUDeviceExtras>();
    WGPUDeviceExtras _deviceExtras = deviceExtras.ref;
    _deviceExtras.chain = _chain;
    _deviceExtras.label = "Device".toNativeUtf8().cast();
    _deviceExtras.tracePath = nullptr;

    Pointer<WGPUDeviceDescriptor> descriptor =
        ffi.calloc<WGPUDeviceDescriptor>();
    WGPUDeviceDescriptor _descriptor = descriptor.ref;
    _descriptor.nextInChain = deviceExtras.cast();
    _descriptor.label = "WGPUDeviceDescriptor".toNativeUtf8().cast();
    _descriptor.requiredLimits = requiredLimits;

    var deviceCallback = Pointer.fromFunction<WgpuRequestDeviceCallback>(
        wgpuRequestDeviceCallback);

    Pointer<WGPUDevice> device = ffi.calloc<WGPUDevice>();

    print("adapter.value: ${adapter.value} adapter: ${adapter} ");

    _webGPU.wgpuAdapterRequestDevice(
        adapter.value, descriptor, deviceCallback, device.cast<Void>());

    int bytes_per_pixel = Uint32List.bytesPerElement;
    int unpadded_bytes_per_row = width * bytes_per_pixel;
    int align = 256;
    int padded_bytes_per_row_padding =
        (align - unpadded_bytes_per_row % align) % align;
    int padded_bytes_per_row =
        unpadded_bytes_per_row + padded_bytes_per_row_padding;

    int bufferSize = padded_bytes_per_row * height;

    print("bufferSize: ${bufferSize} ");

    Pointer<WGPUBufferDescriptor> desc = ffi.calloc<WGPUBufferDescriptor>();
    WGPUBufferDescriptor _desc = desc.ref;
    _desc.nextInChain = nullptr;
    _desc.label = "Output Buffer".toNativeUtf8().cast();
    _desc.usage = WGPUBufferUsage.WGPUBufferUsage_MapRead |
        WGPUBufferUsage.WGPUBufferUsage_CopyDst;
    _desc.size = bufferSize;
    _desc.mappedAtCreation = 0;

    WGPUBuffer outputBuffer =
        _webGPU.wgpuDeviceCreateBuffer(device.value, desc);

    Pointer<WGPUExtent3D> _textureExtent = ffi.calloc<WGPUExtent3D>();
    WGPUExtent3D textureExtent = _textureExtent.ref;
    textureExtent.width = width;
    textureExtent.height = height;
    textureExtent.depthOrArrayLayers = 1;

    Pointer<WGPUTextureDescriptor> desc2 = ffi.calloc<WGPUTextureDescriptor>();
    WGPUTextureDescriptor _desc2 = desc2.ref;
    _desc2.nextInChain = nullptr;
    _desc2.label = "WGPUTextureDescriptor".toNativeUtf8().cast();
    _desc2.size = textureExtent;
    _desc2.mipLevelCount = 1;
    _desc2.sampleCount = 1;
    _desc2.dimension = WGPUTextureDimension.WGPUTextureDimension_2D;
    _desc2.format = WGPUTextureFormat.WGPUTextureFormat_RGBA8UnormSrgb;
    _desc2.usage = WGPUTextureUsage.WGPUTextureUsage_RenderAttachment |
        WGPUTextureUsage.WGPUTextureUsage_CopySrc;

    WGPUTexture texture = _webGPU.wgpuDeviceCreateTexture(device.value, desc2);

    Pointer<WGPUCommandEncoderDescriptor> desc3 =
        ffi.calloc<WGPUCommandEncoderDescriptor>();
    WGPUCommandEncoderDescriptor _desc3 = desc3.ref;
    _desc3.label = nullptr;
    WGPUCommandEncoder encoder =
        _webGPU.wgpuDeviceCreateCommandEncoder(device.value, desc3);

    Pointer<WGPUTextureViewDescriptor> desc4 =
        ffi.calloc<WGPUTextureViewDescriptor>();
    WGPUTextureViewDescriptor _desc4 = desc4.ref;
    _desc4.nextInChain = nullptr;
    _desc4.label = nullptr;
    _desc4.format = WGPUTextureFormat.WGPUTextureFormat_Undefined;
    _desc4.dimension =
        WGPUTextureViewDimension.WGPUTextureViewDimension_Undefined;
    _desc4.aspect = WGPUTextureAspect.WGPUTextureAspect_All;
    _desc4.arrayLayerCount = 0;
    _desc4.baseArrayLayer = 0;
    _desc4.baseMipLevel = 0;
    _desc4.mipLevelCount = 0;

    WGPUTextureView outputAttachment =
        _webGPU.wgpuTextureCreateView(texture, desc4);

    Pointer<WGPUColor> color = ffi.calloc<WGPUColor>();
    WGPUColor _color = color.ref;
    _color.r = 1.0;
    _color.g = 0.5;
    _color.b = 0.3;
    _color.a = 0.2;

    Pointer<WGPURenderPassColorAttachment> attach =
        ffi.calloc<WGPURenderPassColorAttachment>();
    WGPURenderPassColorAttachment _attach = attach.ref;
    _attach.view = outputAttachment;
    _attach.resolveTarget = nullptr;
    _attach.loadOp = WGPULoadOp.WGPULoadOp_Clear;
    _attach.storeOp = WGPUStoreOp.WGPUStoreOp_Store;
    _attach.clearValue = _color;

    Pointer<WGPURenderPassDescriptor> desc5 =
        ffi.calloc<WGPURenderPassDescriptor>();
    WGPURenderPassDescriptor _desc5 = desc5.ref;
    _desc5.colorAttachments = attach;
    _desc5.colorAttachmentCount = 1;
    _desc5.depthStencilAttachment = nullptr;

    WGPURenderPassEncoder renderPass =
        _webGPU.wgpuCommandEncoderBeginRenderPass(encoder, desc5);
    _webGPU.wgpuRenderPassEncoderEnd(renderPass);

    Pointer<WGPUOrigin3D> origin = ffi.calloc<WGPUOrigin3D>();
    WGPUOrigin3D _origin = origin.ref;
    _origin.x = 0;
    _origin.y = 0;
    _origin.z = 0;

    Pointer<WGPUImageCopyTexture> copyTexture =
        ffi.calloc<WGPUImageCopyTexture>();
    WGPUImageCopyTexture _copyTexture = copyTexture.ref;
    _copyTexture.texture = texture;
    _copyTexture.mipLevel = 0;
    _copyTexture.origin = _origin;

    Pointer<WGPUTextureDataLayout> layout = ffi.calloc<WGPUTextureDataLayout>();
    WGPUTextureDataLayout _layout = layout.ref;
    _layout.offset = 0;
    _layout.bytesPerRow = padded_bytes_per_row;
    _layout.rowsPerImage = 0;

    Pointer<WGPUImageCopyBuffer> copyBuffer = ffi.calloc<WGPUImageCopyBuffer>();
    WGPUImageCopyBuffer _copyBuffer = copyBuffer.ref;
    _copyBuffer.buffer = outputBuffer;
    _copyBuffer.layout = _layout;

    _webGPU.wgpuCommandEncoderCopyTextureToBuffer(
        encoder, copyTexture, copyBuffer, _textureExtent);

    WGPUQueue queue = _webGPU.wgpuDeviceGetQueue(device.value);

    Pointer<WGPUCommandBufferDescriptor> desc6 =
        ffi.calloc<WGPUCommandBufferDescriptor>();
    WGPUCommandBufferDescriptor _desc6 = desc6.ref;
    _desc6.label = nullptr;

    WGPUCommandBuffer cmdBuffer =
        _webGPU.wgpuCommandEncoderFinish(encoder, desc6);
    Pointer<WGPUCommandBuffer> cmdBufferPointer =
        ffi.calloc<WGPUCommandBuffer>();
    cmdBufferPointer.value = cmdBuffer;
    _webGPU.wgpuQueueSubmit(queue, 1, cmdBufferPointer);

    var readBufferMapCallback =
        Pointer.fromFunction<ReadBufferMap>(readBufferMap);

    _webGPU.wgpuBufferMapAsync(outputBuffer, WGPUMapMode.WGPUMapMode_Read, 0,
        bufferSize, readBufferMapCallback, nullptr);

    _webGPU.wgpuDevicePoll(device.value, true);

    print(" wgpuBufferGetMappedRange ");
    var data = _webGPU.wgpuBufferGetMappedRange(outputBuffer, 0, bufferSize);
    print(" data ${data} ");
    print(data);

    Pointer<Uint8> pixles = data.cast<Uint8>();

    _webGPU.wgpuBufferUnmap(outputBuffer);

    return pixles.asTypedList(width * height * 4);
  }
}

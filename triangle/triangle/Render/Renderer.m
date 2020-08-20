//
//  Renderer.m
//  triangle
//
//  Created by JH on 2020/8/20.
//  Copyright © 2020 JH. All rights reserved.
//

#import "Renderer.h"
#import "ShaderTypes.h"

@implementation Renderer
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    
    //渲染管线状态，含有顶点函数和片元函数
    id<MTLRenderPipelineState> _renderPipelineState;
    
    vector_uint2 _viewportSize;
}

-(instancetype)initWithMetalKitView:(MTKView *)mtkView{
    self = [super init];
    if (self) {
    
        _device = mtkView.device;
        
        //加载metal文件
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        
        //顶点函数
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
        //片元函数
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];
        
        //渲染管线描述符，是传递给_renderPipelineState的一个参数
        MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineDescriptor.label = @"pipeline";
        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        //创建渲染管线对象
        _renderPipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:NULL];
        if (!_renderPipelineState) {
            return nil;
        }
         _commandQueue = [_device newCommandQueue];
    }
    return self;
}

//视口发生改变
-(void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size{
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

//绘制view的内容
-(void)drawInMTKView:(MTKView *)view{
    
    //顶点坐标和颜色的结构体数组
    static const Vertex triangle[] ={
        { {  0.5, -0.25, 0.0, 1.0 }, { 1, 0, 0, 1 } },
        { { -0.5, -0.25, 0.0, 1.0 }, { 0, 1, 0, 1 } },
        { { -0.0f, 0.25, 0.0, 1.0 }, { 0, 0, 1, 1 } },
    };
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"command";
    //渲染过程，用于保存渲染过程的结果
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"renderEncoder";
        
        MTLViewport viewPort = {
            0.0,0.0,_viewportSize.x,_viewportSize.y, -1.0,1.0
        };
        [renderEncoder setViewport:viewPort];
        //设置当前的渲染管线状态
        [renderEncoder setRenderPipelineState:_renderPipelineState];
        
        //顶点函数中，顶点数据传入缓存中的位置，通过metal中的buffer读取
        [renderEncoder setVertexBytes:triangle length:sizeof(triangle) atIndex:VertexInputIndexVertices];
        //顶点函数中，视口大小传入缓冲中的位置，通过metal中的buffer读取
        [renderEncoder setVertexBytes:&_viewportSize length:sizeof(triangle) atIndex:VertexInputIndexViewportSize];
        
        //画图元
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
        [renderEncoder endEncoding];
        //准备绘制
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    //提交命令到GPU，开始绘制
    [commandBuffer commit];
}

@end

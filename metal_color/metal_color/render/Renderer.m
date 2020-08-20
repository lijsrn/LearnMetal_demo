//
//  Renderer.m
//  metal_color
//
//  Created by JH on 2020/8/20.
//  Copyright © 2020 JH. All rights reserved.
//

#import "Renderer.h"

typedef struct {
    float red, green , blue, alpha;
}Color;

@implementation Renderer
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
}


-(id)initWithMetalKitView:(MTKView *)mtkView{
    
    self = [super init];
    if (self) {
        _device = mtkView.device;
        
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

//颜色
-(Color)makeFancyColor{
    static BOOL growing = YES;
    static NSUInteger primaryChannel = 0;
    
    static float colorChannels[] = {1.0,0.0,0.0,1.0};
    const float DynamicColorRate = 0.015;
    if (growing) {
        NSUInteger dynamicChannelIndex = (primaryChannel +1)%3;
        
        colorChannels[dynamicChannelIndex] += DynamicColorRate;
        
        if (  colorChannels[dynamicChannelIndex]>=1) {
            growing = NO;
            
            primaryChannel = dynamicChannelIndex;
        }
    }else{
        NSUInteger dynamicChannelIndex = (primaryChannel +2)%3;
               
       colorChannels[dynamicChannelIndex] -= DynamicColorRate;
       
        if (  colorChannels[dynamicChannelIndex]<= 0.0) {
           growing = YES;
           
          
       }
    }
    
    Color color;
    
    color.red = colorChannels[0];
    color.green = colorChannels[1];
    color.blue = colorChannels[2];
    color.alpha = colorChannels[3];
    
    return color;
}

//画view的内容，这个代理方法会按帧率执行
-(void)drawInMTKView:(MTKView *)view{
    //获取颜色
    Color color = [self makeFancyColor];
    //设置背景色
    view.clearColor = MTLClearColorMake(color.red, color.green, color.blue, color.alpha);
    
    //创建一个命令缓冲区
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"mycommand";
    
    //渲染过程，用于保存渲染过程的结果
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    
    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"myrenderEncoder";
        
        //结束编码
        [renderEncoder endEncoding];
        
        //注册一个可绘制图像
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    //提交命令到GPU
    [commandBuffer commit];
}

//视口发生变化会被调用
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}


@end

//
//  Shaders.metal
//  triangle
//
//  Created by JH on 2020/8/20.
//  Copyright © 2020 JH. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "ShaderTypes.h"

//作为顶点函数的输入，片元函数的输入的结构体
typedef struct {
    float4 clipSpacePosition [[position]]; //position声明为顶点，与OpenGL 中的gl_Position类似
    float4 color;
}RasterizerData;

//顶点函数
//vertex声明为顶点函数
//RasterizerData 返回类型
//vertexShader 函数名
vertex RasterizerData vertexShader(uint vertexID [[vertex_id]], //顶点索引，三角形有是三个顶点，那就是0,1,2
                                     //顶点数组，通过   [renderEncoder setVertexBytes:triangle length:sizeof(triangle) atIndex:VertexInputIndexVertices];传入缓存中的位置，通过buffer读取位置
                                   constant Vertex *vertices[[buffer(VertexInputIndexVertices)]],
                                 //视口大小，通过 [renderEncoder setVertexBytes:&_viewportSize length:sizeof(triangle) atIndex:VertexInputIndexViewportSize];传入缓存中的位置，通过buffer读取位置
                                   constant vector_uint2 *viewportSizePointer [[buffer(VertexInputIndexViewportSize)]]
                                   //视口大小
                                   ){
    RasterizerData out;
    out.clipSpacePosition = vertices[vertexID].position;
    out.color =  vertices[vertexID].color;
    return out;
}
//片元函数，
//fragment 声明为片元函数
// float4 返回类型
// fragmentShader 函数名称
//参数 in 是 顶点函数返回RasterizerData，经过图元装配，光栅化，后到片元函数，作为其入参
fragment float4 fragmentShader(RasterizerData in [[stage_in]]){
    return  in.color;
}

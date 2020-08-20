//
//  ShaderTypes.h
//  triangle
//
//  Created by JH on 2020/8/20.
//  Copyright © 2020 JH. All rights reserved.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h
//该头文件可以在oc和meal文件中使用
//缓冲区索引
typedef enum VertexInputIndex{
    VertexInputIndexVertices = 0,   //顶点索引，顶点函数的第二个入参
    VertexInputIndexViewportSize =1,  //视口大小索引，顶点函数的第三个入参
}VertexInputIndex;

typedef struct {
    vector_float4 position; //顶点坐标
    vector_float4 color; //颜色
}Vertex;

#endif /* ShaderTypes_h */

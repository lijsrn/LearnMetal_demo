//
//  Renderer.h
//  triangle
//
//  Created by JH on 2020/8/20.
//  Copyright © 2020 JH. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MetalKit;
NS_ASSUME_NONNULL_BEGIN

@interface Renderer : NSObject<MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;
@end

NS_ASSUME_NONNULL_END

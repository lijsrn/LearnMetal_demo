//
//  ViewController.m
//  metal_color
//
//  Created by JH on 2020/8/20.
//  Copyright © 2020 JH. All rights reserved.
//

#import "ViewController.h"
@import MetalKit;
#import "Renderer.h"

@interface ViewController (){
    MTKView *_mtkview;
    Renderer *_renderer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mtkview = (MTKView *)self.view;
    _mtkview.device = MTLCreateSystemDefaultDevice();
   
    _renderer = [[Renderer alloc] initWithMetalKitView:_mtkview];
    _mtkview.delegate = _renderer;
}


@end

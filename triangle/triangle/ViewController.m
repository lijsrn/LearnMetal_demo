//
//  ViewController.m
//  triangle
//
//  Created by JH on 2020/8/20.
//  Copyright © 2020 JH. All rights reserved.
//

#import "ViewController.h"
#import "Render/Renderer.h"

@interface ViewController ()
{
    Renderer *_render;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MTKView *mtkView =(MTKView *) self.view;
    
    mtkView.device = MTLCreateSystemDefaultDevice();
    _render = [[Renderer alloc] initWithMetalKitView:mtkView];
    [_render mtkView:mtkView drawableSizeWillChange:mtkView.drawableSize];
    mtkView.delegate = _render;
}


@end

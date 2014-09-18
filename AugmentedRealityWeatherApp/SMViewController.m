//
//  SMViewController.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/2/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMViewController.h"
#import <GPUImage.h>

@interface SMViewController ()

@end

@implementation SMViewController {
    GPUImageiOSBlurFilter *_blurFilter;
    GPUImageGaussianBlurFilter *_gausianBlurFilter;
    GPUImageBoxBlurFilter *_boxBlur;
//    SMBlurredCameraBackgroundView *_blurredCameraView;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _blurredCameraView = [[SMBlurredCameraBackgroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:_blurredCameraView];
	   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

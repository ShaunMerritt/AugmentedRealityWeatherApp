//
//  SMBlurredCameraBackgroundView.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/9/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMBlurredCameraBackgroundView.h"
#import <GPUImage.h>

@implementation SMBlurredCameraBackgroundView {
    GPUImageGaussianBlurFilter *_gausianBlurFilterForBackground;
    GPUImageVideoCamera *_videoCamera;
    GPUImageView *_finalFilteredImageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        
        _gausianBlurFilterForBackground = [[GPUImageGaussianBlurFilter alloc] init];
        
        _finalFilteredImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height)];
        
        _gausianBlurFilterForBackground.texelSpacingMultiplier = 1.7;
        _gausianBlurFilterForBackground.blurRadiusInPixels = 5;
        
        [self addSubview:_finalFilteredImageView];
        
        [_videoCamera addTarget:_gausianBlurFilterForBackground];
        [_gausianBlurFilterForBackground addTarget:_finalFilteredImageView];
        
        [_videoCamera startCameraCapture];

        
    }
    return self;
}

@end

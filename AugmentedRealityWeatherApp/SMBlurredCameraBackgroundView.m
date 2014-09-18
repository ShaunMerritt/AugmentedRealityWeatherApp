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
    GPUImageGaussianBlurFilter *_gausianBlurFilter;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initiate the GPUImageVideoCameraView
        videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
        videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        
        // Initiate the GPUImageGausianBlurFilter
        _gausianBlurFilter = [[GPUImageGaussianBlurFilter alloc] init];
        
        // Create the GPUImageView
        filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height)];
        
        // Adjust level of blur applied to video
        _gausianBlurFilter.texelSpacingMultiplier = 1.7;
        _gausianBlurFilter.blurRadiusInPixels = 5;
        
        
        // Add the filteredView so it is visible
        [self addSubview:filteredVideoView];
        
        // Add the gausianBlur to the camera
        [videoCamera addTarget:_gausianBlurFilter];
        [_gausianBlurFilter addTarget:filteredVideoView];
        
        // Start the camera
        [videoCamera startCameraCapture];

        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

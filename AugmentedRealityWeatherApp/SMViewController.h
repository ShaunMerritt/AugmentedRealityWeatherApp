//
//  SMViewController.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/2/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "SMBlurredCameraBackgroundView.h"


@interface SMViewController : UIViewController {
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageView *filteredVideoView;
}


@property (nonatomic, strong) SMBlurredCameraBackgroundView *blurredCameraView;

@end

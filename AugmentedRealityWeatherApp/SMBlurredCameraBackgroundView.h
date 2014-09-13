//
//  SMBlurredCameraBackgroundView.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/9/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface SMBlurredCameraBackgroundView : UIView {
    GPUImageVideoCamera *videoCamera;
    GPUImageView *filteredVideoView;
}

@end

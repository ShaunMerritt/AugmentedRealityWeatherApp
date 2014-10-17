//
//  SMLoadView.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMWeatherInfo.h"

@interface SMInitialLoadingView : UIView

@property (nonatomic, copy) void(^cardCreated)(BOOL isComplete);

@end

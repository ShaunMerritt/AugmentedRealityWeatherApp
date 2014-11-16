//
//  SMLoadView.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMWeatherInfo.h"

@class SMInitialLoadingView;

@protocol SMInitialLoadingViewDelegate <NSObject>
- (void)didCreateCard:(BOOL)isComplete;
@end

@interface SMInitialLoadingView : UIView
@property (nonatomic, weak) id<SMInitialLoadingViewDelegate> delegate;
@end

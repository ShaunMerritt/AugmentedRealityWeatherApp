//
//  SMWelcomeView.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMWelcomeView;
@protocol SMWelcomeProtocol <NSObject>

- (void)beginButtonPressed;

@end

@interface SMWelcomeView : UIView

@property (nonatomic, strong) id<SMWelcomeProtocol> delegate;

@end

//
//  SMDirectionsForPointingPhoneView.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMDirectionsForPointingPhoneDelegate <NSObject>

- (void)continueButtonPressed;

@end

@interface SMDirectionsForPointingPhoneView : UIView

@property (nonatomic, strong) id <SMDirectionsForPointingPhoneDelegate>delegate;

@end

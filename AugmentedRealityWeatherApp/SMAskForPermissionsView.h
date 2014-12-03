//
//  SMAskForPermissionsView.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/23/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMAskForPermissionsViewDelegate <NSObject>

- (void) sayYesButtonPressed;

@end

@interface SMAskForPermissionsView : UIView

@property (nonatomic, strong) id<SMAskForPermissionsViewDelegate> delegate;

@end

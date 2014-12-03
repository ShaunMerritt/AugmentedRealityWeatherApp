//
//  SMWeatherInfoView.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/25/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMWeatherInfo.h"

@interface SMWeatherInfoCardView : UIView

- (void) createLabelsWithWeatherObject:(SMWeatherInfo *)weatherInfo withCityName:(NSString *)cityName;

@property (nonatomic, strong) NSString *test;

@end

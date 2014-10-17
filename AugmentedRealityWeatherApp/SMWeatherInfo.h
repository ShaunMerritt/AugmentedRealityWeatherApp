//
//  SMWeatherInfo.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMWeatherInfo : NSObject

@property (strong, nonatomic) NSString *base;
@property (strong, nonatomic) NSDictionary *clouds;
@property (strong, nonatomic) NSNumber *cod;
@property (strong, nonatomic) NSDictionary *coordinates;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSNumber *dt;
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *humidity;
@property (strong, nonatomic) NSNumber *pressure;
@property (strong, nonatomic) NSString *temperature;
@property (strong, nonatomic) NSString *maxTemperature;
@property (strong, nonatomic) NSString *minTemperature;
@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *sunrise;
@property (strong, nonatomic) NSString *sunset;

@end

//
//  SMLocationModel.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/7/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMLocationModel : NSObject <NSCoding>

@property (readwrite, retain) NSString *cityName;
@property (assign) float cityLocationLatitude;
@property (assign) float cityLocationLongitude;
@property (assign) float degreesFromNorth;

-(instancetype) initWithCityName:(NSString *)cityName latitude:(float)latitude longitude:(float)longitude degreesFromNorth:(float)degrees;

@end

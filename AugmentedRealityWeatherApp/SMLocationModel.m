//
//  SMLocationModel.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/7/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMLocationModel.h"

@interface SMLocationModel () {
    
    

    
}

@end

@implementation SMLocationModel

-(instancetype) initWithCityName:(NSString *)cityName latitude:(float)latitude longitude:(float)longitude degreesFromNorth:(float)degrees
{
    self = [super init];
    if (self) {
        _cityName = cityName;
        _cityLocationLatitude = latitude;
        _cityLocationLongitude = longitude;
        _degreesFromNorth = degrees;
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.cityName = [decoder decodeObjectForKey:@"cityName"];
    _cityLocationLatitude = [decoder decodeFloatForKey:@"latitude"];
    _cityLocationLongitude = [decoder decodeFloatForKey:@"longitude"];
    _degreesFromNorth = [decoder decodeFloatForKey:@"degrees"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_cityName forKey:@"cityName"];
    [encoder encodeFloat:_cityLocationLatitude forKey:@"latitude"];
    [encoder encodeFloat:_cityLocationLongitude forKey:@"longitude"];
    [encoder encodeFloat:_degreesFromNorth forKey:@"degrees"];
}

@end

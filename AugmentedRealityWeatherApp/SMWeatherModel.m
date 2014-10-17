//
//  SMWeatherModel.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMWeatherModel.h"
#import "SMWeatherInfo.h"
#import <JSONKit.h>

@interface SMWeatherModel () {
    
    NSData *_jsonData;
    NSMutableArray *_weatherDetailsList;
    
}

//@property (strong, nonatomic) NSMutableArray *weatherDetailsList;

@end

@implementation SMWeatherModel

- (instancetype) initWithJSONData:(NSData *)jsonData {
    self = [super init];
    if (self)
    {
        _jsonData = jsonData;
        _weatherDetailsList = [[NSMutableArray alloc] init];

    }
    return self;
}

- (NSArray *)generateWeatherDetailsList {
    
    NSString *receivedDataString = [[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *deserializedData = [receivedDataString objectFromJSONString];
    NSLog(@"%@", [deserializedData description]);
    
    SMWeatherInfo *weatherInfo = [SMWeatherInfo alloc];
    
    // TODO: Still have more to implement
    weatherInfo.base = [deserializedData objectForKey:@"base"];
    weatherInfo.cod = [deserializedData objectForKey:@"cod"];
    weatherInfo.latitude = [[deserializedData objectForKey:@"coord"] objectForKey:@"lat"];
    weatherInfo.longitude = [[deserializedData objectForKey:@"coord"] objectForKey:@"lon"];
    weatherInfo.humidity = [[deserializedData objectForKey:@"main"] objectForKey:@"humidity"];
    weatherInfo.pressure = [[deserializedData objectForKey:@"main"] objectForKey:@"pressure"];
    weatherInfo.temperature = [[deserializedData objectForKey:@"main"] objectForKey:@"temp"];
    weatherInfo.maxTemperature = [[deserializedData objectForKey:@"main"] objectForKey:@"temp_max"];
    weatherInfo.minTemperature = [[deserializedData objectForKey:@"main"] objectForKey:@"temp_min"];
    weatherInfo.cityName = [deserializedData objectForKey:@"name"];
    
    [_weatherDetailsList addObject:weatherInfo];
    
    return [self existingWeatherDetailsList];
}

- (NSArray *)existingWeatherDetailsList {
    return _weatherDetailsList;
}


@end

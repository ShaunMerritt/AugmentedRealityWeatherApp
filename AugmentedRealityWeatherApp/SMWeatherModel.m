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
    
}

@property (strong, nonatomic) NSMutableArray *weatherDetailsList;

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

- (NSArray *)weatherResults {
    
    NSString *receivedDataString = [[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *deserializedData = [receivedDataString objectFromJSONString];
    NSLog(@"%@", [deserializedData description]);
    
    __weak SMWeatherModel *weakSelf = self;

    SMWeatherInfo *_weatherInfo = [SMWeatherInfo alloc];
    
    // TODO: Still have more to implement
    _weatherInfo.base = [deserializedData objectForKey:@"base"];
    _weatherInfo.cod = [deserializedData objectForKey:@"cod"];
    _weatherInfo.latitude = [[deserializedData objectForKey:@"coord"] objectForKey:@"lat"];
    _weatherInfo.longitude = [[deserializedData objectForKey:@"coord"] objectForKey:@"lon"];
    _weatherInfo.humidity = [[deserializedData objectForKey:@"main"] objectForKey:@"humidity"];
    _weatherInfo.pressure = [[deserializedData objectForKey:@"main"] objectForKey:@"pressure"];
    _weatherInfo.temperature = [[deserializedData objectForKey:@"main"] objectForKey:@"temp"];
    _weatherInfo.maxTemperature = [[deserializedData objectForKey:@"main"] objectForKey:@"temp_max"];
    _weatherInfo.minTemperature = [[deserializedData objectForKey:@"main"] objectForKey:@"temp_min"];
    _weatherInfo.cityName = [deserializedData objectForKey:@"name"];
    
    [weakSelf.weatherDetailsList addObject:_weatherInfo];
    
    return self.weatherDetailsList;
}


@end

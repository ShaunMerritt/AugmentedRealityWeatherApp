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
    NSString *main = [[[deserializedData objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];

    NSLog(@"MAin:%@",main);
    if ([main isEqualToString:@"11n"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-tstorm"];
    } else if ([main isEqualToString:@"11d"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-tstorm"];
    } else if ([main isEqualToString:@"50n"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-mist"];
    } else if ([main isEqualToString:@"50d"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-mist"];
    } else if ([main isEqualToString:@"02n"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-few-night"];
    } else if ([main isEqualToString:@"02d"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-few"];
    } else if ([main isEqualToString:@"03n"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-broken"];
    } else if ([main isEqualToString:@"03d"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-broken"];
    } else if ([main isEqualToString:@"04n"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-broken"];
    } else if ([main isEqualToString:@"04d"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-broken"];
    } else if ([main isEqualToString:@"09n"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-shower"];
    } else if ([main isEqualToString:@"09d"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-shower"];
    } else if ([main isEqualToString:@"10n"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-rain-night"];
    } else if ([main isEqualToString:@"10d"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-rain"];
    } else if ([main isEqualToString:@"13n"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-snow"];
    } else if ([main isEqualToString:@"13d"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-snow"];
    } else if ([main isEqualToString:@"50n"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-mist"];
    } else if ([main isEqualToString:@"50d"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-mist"];
    } else if ([main isEqualToString:@"01n"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-moon"];
    } else if ([main isEqualToString:@"01d"]) {
        weatherInfo.weatherImage = [UIImage imageNamed:@"weather-clear"];
    }
    
    [_weatherDetailsList addObject:weatherInfo];
    
    return [self existingWeatherDetailsList];
}

- (NSArray *)existingWeatherDetailsList {
    return _weatherDetailsList;
}


@end

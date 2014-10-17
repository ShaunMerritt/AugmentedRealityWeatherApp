//
//  SMWeatherModel.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMWeatherInfo.h"

@interface SMWeatherModel : NSObject

-(instancetype) initWithJSONData: (NSData *) jsonData;
- (NSArray *)generateWeatherDetailsList;
- (NSArray *)existingWeatherDetailsList;



@end

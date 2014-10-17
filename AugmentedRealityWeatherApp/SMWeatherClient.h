//
//  SMWeatherClient.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMWeatherClient : NSObject

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;

@end

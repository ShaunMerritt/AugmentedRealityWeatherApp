//
//  SMWeatherClient.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMWeatherClient.h"

@implementation SMWeatherClient

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"Error Here: %@", [error localizedDescription]);
        }
        else{
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    [task resume];
    
}

@end

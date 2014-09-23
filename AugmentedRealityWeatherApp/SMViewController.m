//
//  SMViewController.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/2/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMViewController.h"
#import "SMAppDelegate.h"
#import "SMBlurredCameraBackgroundView.h"
#import "SMWeatherClient.h"
#import "SMWeatherModel.h"
#import "SMWeatherInfo.h"
#import <JSONKit.h>

@interface SMViewController () {
    SMBlurredCameraBackgroundView *_blurredBackgroundCameraView;
    NSArray *_currentWeatherInfoArray;
}

- (void)getWeatherInfo;

@end

@implementation SMViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _blurredBackgroundCameraView = [[SMBlurredCameraBackgroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:_blurredBackgroundCameraView];
    
    _currentWeatherInfoArray = [[NSArray alloc] init];
    
    [self getWeatherInfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Weather Retrieval
- (void)getWeatherInfo {
    
    // TODO: This is just a quick test to see if it works.
    NSString *URLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=London,uk&units=imperial"];
    NSURL *url = [NSURL URLWithString:URLString];
    
    [SMWeatherClient downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            
            NSError *error;
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                
                SMWeatherModel *weatherParser = [[SMWeatherModel alloc] initWithJSONData:data];
                _currentWeatherInfoArray = [[weatherParser weatherResults] mutableCopy];
                
                // TODO: Here is just basic testing
                SMWeatherInfo *_currentWeatherInfoForCity = _currentWeatherInfoArray[0];
                NSLog(@"HERE: %@", _currentWeatherInfoForCity.cityName);

            }
        }

    }];

}



@end

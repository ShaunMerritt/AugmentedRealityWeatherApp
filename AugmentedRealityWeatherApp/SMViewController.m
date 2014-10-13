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
#import "SMInitialLoadingView.h"
#import "SMWeatherInfoCardView.h"
#import <JSONKit.h>


@interface SMViewController () {
    SMBlurredCameraBackgroundView *_blurredBackgroundCameraView;
    NSArray *_currentWeatherInfoArray;
    SMInitialLoadingView *_initialLoadingView;
    SMWeatherInfo *_currentWeatherInfoForCity;
    SMWeatherInfoCardView *_infoView;
    
}

- (void)getWeatherInfo;

@end

@implementation SMViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _blurredBackgroundCameraView = [[SMBlurredCameraBackgroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:_blurredBackgroundCameraView];
        
    [self getWeatherInfo];
    
    _initialLoadingView = [[SMInitialLoadingView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 100, 100)];
    _initialLoadingView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _initialLoadingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_initialLoadingView];
    
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
                _currentWeatherInfoArray = [[weatherParser generateWeatherDetailsList] mutableCopy];
                
                // TODO: Here is just basic testing
                _currentWeatherInfoForCity = _currentWeatherInfoArray[0];
                NSLog(@"Temperature For City: %@", _currentWeatherInfoForCity.temperature);
                
                // Called upon completion of animation
                __weak SMViewController *self_ = self;
                _initialLoadingView.cardCreated = ^(BOOL isCreated){
                    if (isCreated == YES) {
                        [self_ cardHasBeenCreated:_currentWeatherInfoForCity];
                    } else {
                        // TODO: Add handles for if a view wasn't created.
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"View Not Created" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
                        [alert show];
                    }
                };

            }
        }

    }];

}

- (void)cardHasBeenCreated: (SMWeatherInfo *)weatherInfo {
    
    _infoView = [[SMWeatherInfoCardView alloc] initWithFrame:_initialLoadingView.frame];
    [_infoView createLabelsWithWeatherObject:weatherInfo];
    [self.view addSubview:_infoView];
    
}

@end

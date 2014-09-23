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

@interface SMViewController () {
    SMBlurredCameraBackgroundView *_blurredBackgroundCameraView;
    NSArray *weather;
}

- (void)getWeatherInfo;

@end

@implementation SMViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _blurredBackgroundCameraView = [[SMBlurredCameraBackgroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:_blurredBackgroundCameraView];
    
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
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"%@", [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] class]);
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                NSMutableDictionary *_returnedWeatherDictionary = [[NSMutableDictionary alloc] init];
                _returnedWeatherDictionary = returnedDict;
                NSLog(@"Current Weather: %@", [[_returnedWeatherDictionary objectForKey:@"main"] objectForKey:@"temp"]);
            }
        }

    }];

}



@end

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
#import "INTULocationManager.h"


@interface SMViewController () {
    SMBlurredCameraBackgroundView *_blurredBackgroundCameraView;
    NSArray *_currentWeatherInfoArray;
    SMInitialLoadingView *_initialLoadingView;
    SMWeatherInfo *_currentWeatherInfoForCity;
    SMWeatherInfoCardView *_infoView;
    NSString *_currentLatitude;
    NSString *_currentLongitude;
    
}

@property (assign, nonatomic) INTULocationAccuracy desiredAccuracy;
@property (assign, nonatomic) NSTimeInterval timeout;

@property (assign, nonatomic) NSInteger locationRequestID;


- (void)getWeatherInfo;

@end

@implementation SMViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    
    
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                                                 // currentLocation contains the device's current location.
                                                 
                                                 NSLog(@"y");
                                                 
                                                 _currentLongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                                                 _currentLatitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
                                                 
                                                 
                                                 [self getWeatherInfo];
                                                 
                                                 NSLog(@"%@", _currentLongitude);
                                                 NSLog(@"%@",_currentLatitude);
                                                 
                                             }
                                             else if (status == INTULocationStatusTimedOut) {
                                                 // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                                                 // However, currentLocation contains the best location available (if any) as of right now,
                                                 // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                                             }
                                             else {
                                                 // An error occurred, more info is available by looking at the specific status returned.
                                             }
                                         }];
    
    
    
    
    
    
    NSLog(@"NOOO");
    

    
    
    
    
    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _blurredBackgroundCameraView = [[SMBlurredCameraBackgroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:_blurredBackgroundCameraView];
        
    
    _initialLoadingView = [[SMInitialLoadingView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 100, 100)];
    _initialLoadingView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _initialLoadingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_initialLoadingView];
    
}

#pragma mark - Weather Retrieval
- (void)getWeatherInfo {
    
    NSString *URLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&units=imperial", _currentLongitude, _currentLatitude];
    NSLog(@"url: %@", URLString);
    
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

#pragma mark - Helper Methods

- (void) getCurrentLocation {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)cardHasBeenCreated: (SMWeatherInfo *)weatherInfo {
    
    _infoView = [[SMWeatherInfoCardView alloc] initWithFrame:_initialLoadingView.frame];
    [_infoView createLabelsWithWeatherObject:weatherInfo];
    [self.view addSubview:_infoView];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)setLocationRequestID:(NSInteger)locationRequestID
{
    _locationRequestID = locationRequestID;
    
    BOOL isProcessingLocationRequest = (locationRequestID != NSNotFound);
    
}


@end

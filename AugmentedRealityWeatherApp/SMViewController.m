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
#import <CoreLocation/CoreLocation.h>
#import "INTULocationManager.h"
#import "SMWeatherLocationsViewController.h"
#import <POP.h>
#import "SMAddLocationsView.h"
#import "CLLocation+Bearing.h"

static NSString *kKeyForUserDefaults = @"savedLocationsArray";

@interface SMViewController () <CLLocationManagerDelegate> {
    SMBlurredCameraBackgroundView *_blurredBackgroundCameraView;
    NSArray *_currentWeatherInfoArray;
    SMInitialLoadingView *_initialLoadingView;
    SMWeatherInfo *_currentWeatherInfoForCity;
    SMWeatherInfoCardView *_infoView;
    NSString *_currentLatitude;
    NSString *_currentLongitude;
    CLLocationManager *_locationManager;
    NSMutableArray *_quadrantOneLocations;
    NSMutableArray *_quadrantTwoLocations;
    NSMutableArray *_quadrantThreeLocations;
    NSMutableArray *_quadrantFourLocations;
    NSMutableArray *_savedLocations;
    CLLocation *_currentUsersLocation;
    NSArray *_arrayOfCitiesInDirectionOfPhoneHeading;

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
    
    _quadrantOneLocations = [[NSMutableArray alloc] init];
    _quadrantTwoLocations = [[NSMutableArray alloc] init];
    _quadrantThreeLocations = [[NSMutableArray alloc] init];
    _quadrantFourLocations = [[NSMutableArray alloc] init];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];

    [self getWeatherInfo];
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedArray = [currentDefaults objectForKey:kKeyForUserDefaults];
    if (savedArray != nil)
    {
        NSArray *arrayOfSavedLocationObjects = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        if (arrayOfSavedLocationObjects != nil) {
            _savedLocations = [[NSMutableArray alloc] initWithArray:arrayOfSavedLocationObjects];
            
            [self calculateBearing];
            
        } else {
            _savedLocations = [[NSMutableArray alloc] init];
        }
    }

    self.view.backgroundColor = [UIColor blackColor];
    
    _blurredBackgroundCameraView = [[SMBlurredCameraBackgroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:_blurredBackgroundCameraView];
        
    
    _initialLoadingView = [[SMInitialLoadingView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 100, 100)];
    _initialLoadingView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _initialLoadingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_initialLoadingView];
    
    [self addGesturesToView];
    
}

#pragma mark - CLLocationDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    _currentUsersLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    float heading = newHeading.trueHeading;
    
    if (heading > 0 && heading <= 90) {
        if (![_arrayOfCitiesInDirectionOfPhoneHeading isEqualToArray:_quadrantOneLocations]) {
            _arrayOfCitiesInDirectionOfPhoneHeading = _quadrantOneLocations;
            [self createCardStack];
        }
    } else if (heading > 90 && heading <= 180) {
        if (![_arrayOfCitiesInDirectionOfPhoneHeading isEqualToArray:_quadrantTwoLocations]) {
            _arrayOfCitiesInDirectionOfPhoneHeading = _quadrantTwoLocations;
            [self createCardStack];
        }
    } else if (heading > 180 && heading <= 270) {
        if (![_arrayOfCitiesInDirectionOfPhoneHeading isEqualToArray:_quadrantThreeLocations]) {
            _arrayOfCitiesInDirectionOfPhoneHeading = _quadrantThreeLocations;
            [self createCardStack];
        }
    } else {
        if (![_arrayOfCitiesInDirectionOfPhoneHeading isEqualToArray:_quadrantFourLocations]) {
            _arrayOfCitiesInDirectionOfPhoneHeading = _quadrantFourLocations;
            [self createCardStack];
        }
    }
}



- (void) viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

#pragma mark - Weather Retrieval
- (void)getWeatherInfo {
    
    NSString *lat = [NSString stringWithFormat:@"%f",[_locationManager location].coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",[_locationManager location].coordinate.longitude];

    
    NSString *URLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&units=imperial", lat, lon];
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

- (void) calculateBearing {
    
    for (SMLocationModel *currentLocationObject in _savedLocations) {
        
        CLLocation *distantLocation = [[CLLocation alloc] initWithLatitude:currentLocationObject.cityLocationLatitude longitude:currentLocationObject.cityLocationLongitude];
        
        CLLocationBearing bearing = [[_locationManager location] bearingToLocation: distantLocation];
        switch (bearing) {
            case CLLocationBearingEast:
                [_quadrantOneLocations addObject:currentLocationObject];
                break;
            case CLLocationBearingNorth:
                [_quadrantFourLocations addObject:currentLocationObject];
                break;
            case CLLocationBearingNorthEast:
                [_quadrantOneLocations addObject:currentLocationObject];
                break;
            case CLLocationBearingNorthWest:
                [_quadrantFourLocations addObject:currentLocationObject];
                break;
            case CLLocationBearingSouth:
                [_quadrantTwoLocations addObject:currentLocationObject];
                break;
            case CLLocationBearingSouthEast:
                [_quadrantTwoLocations addObject:currentLocationObject];
                break;
            case CLLocationBearingSouthWest:
                [_quadrantThreeLocations addObject:currentLocationObject];
                break;
            case CLLocationBearingWest:
                [_quadrantThreeLocations addObject:currentLocationObject];
                break;
            case CLLocationBearingUnknown:
                NSLog(@"Unknown");
                break;
            default:
                NSLog(@"Unknown");
                break;
        }
    }
}

- (void) createCardStack {
    
    //TODO: make it so this reads from _arrayOfCitiesInDirectionOfPhoneHeading and shows appropriate locations
    
    [UIView animateWithDuration:1 animations:^{
        _infoView.frame = CGRectMake(0, self.view.frame.size.height, _infoView.frame.size.width, _infoView.frame.size.height);
        
    }];
    
}

- (void)addGesturesToView {
    
    UISwipeGestureRecognizer *swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToSwipeDownGesture)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
    
}

- (void) respondToSwipeDownGesture {
    
    SMAddLocationsView *addLocationsView = [[SMAddLocationsView alloc] initWithFrame: CGRectMake(0, -1 * self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:addLocationsView];
    
    [UIView animateWithDuration:0.8 delay:0
         usingSpringWithDamping:0.7 initialSpringVelocity:0 options:0 animations:^{
             
             [addLocationsView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
             
         } completion:^(BOOL finished) {
             
             SMWeatherLocationsViewController *weatherLocationsViewController = [[SMWeatherLocationsViewController alloc] init];
             [[self navigationController] pushViewController:weatherLocationsViewController animated:NO];

         }];
    
}

- (void)cardHasBeenCreated: (SMWeatherInfo *)weatherInfo {
    
    _infoView = [[SMWeatherInfoCardView alloc] initWithFrame:_initialLoadingView.frame];
    [_infoView createLabelsWithWeatherObject:weatherInfo];
    [self.view addSubview:_infoView];
    
    [_initialLoadingView removeFromSuperview];
    
}

#pragma mark - Location

- (void)findCurrentLocation {
    INTULocationManager *locationManager = [INTULocationManager sharedInstance];
    [locationManager requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                                                 // currentLocation contains the device's current location.
                                                 
                                                 
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

}

@end

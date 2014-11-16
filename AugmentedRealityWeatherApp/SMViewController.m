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
    NSMutableArray *_arrayOfCitiesInDirectionOfPhoneHeading;
    SMWeatherInfoCardView *_frontCardView;
    SMWeatherInfoCardView *_backCardView;
    CGRect _frameOfFrontCard;
}

@end

@implementation SMViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _quadrantOneLocations = [[NSMutableArray alloc] init];
    _quadrantTwoLocations = [[NSMutableArray alloc] init];
    _quadrantThreeLocations = [[NSMutableArray alloc] init];
    _quadrantFourLocations = [[NSMutableArray alloc] init];
    
    [self setLocationManager];
    
    [self getWeatherInfo];
    
    [self createSavedLocationsArray];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _blurredBackgroundCameraView = [[SMBlurredCameraBackgroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:_blurredBackgroundCameraView];
        
    _initialLoadingView = [[SMInitialLoadingView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 100, 100)];
    _initialLoadingView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _initialLoadingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_initialLoadingView];
    
    [self addGesturesToView];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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


#pragma mark - Weather Retrieval
- (void)getWeatherInfo {
    
    NSString *lat = [NSString stringWithFormat:@"%f",[_locationManager location].coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",[_locationManager location].coordinate.longitude];

    NSString *URLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&units=imperial", lat, lon];
    NSURL *url = [NSURL URLWithString:URLString];
    
    [SMWeatherClient downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *error;
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                
                SMWeatherModel *weatherParser = [[SMWeatherModel alloc] initWithJSONData:data];
                _currentWeatherInfoArray = [[weatherParser generateWeatherDetailsList] mutableCopy];
                
                SMWeatherInfo *weatherInfoForCurrentCity = _currentWeatherInfoArray[0];
                
                // Called upon completion of animation
                __weak SMViewController *self_ = self;
                _initialLoadingView.cardCreated = ^(BOOL isCreated){
                    if (isCreated == YES) {
                        [self_ cardHasBeenCreated:weatherInfoForCurrentCity];
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

#pragma mark - UILayout 

- (void) animateCardsIn {
    
    if (_arrayOfCitiesInDirectionOfPhoneHeading.count != 0) {
        
        _frontCardView = [[SMWeatherInfoCardView alloc] initWithFrame:CGRectMake(self.view.frame.size.width + 50, _frameOfFrontCard.origin.y, _frameOfFrontCard.size.width, _frameOfFrontCard.size.height)];
        [self.view addSubview:_frontCardView];
        
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/6);
        _frontCardView.transform = transform;

        POPSpringAnimation *rotate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        rotate.toValue = @(0);
        rotate.springBounciness = 3;
        rotate.springSpeed = 5.0f;
        [_frontCardView.layer pop_addAnimation:rotate forKey:@"rotate"];
        
        POPSpringAnimation *move =
        [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        move.toValue = [NSValue valueWithCGRect:_frameOfFrontCard];;
        move.springBounciness = 4;
        move.springSpeed = 5.0f;
        [_frontCardView.layer pop_addAnimation:move forKey:@"position"];
        
        move.completionBlock = ^(POPAnimation *frame, BOOL finished) {
            NSString *lat = [NSString stringWithFormat:@"%f", [_arrayOfCitiesInDirectionOfPhoneHeading[0] cityLocationLatitude]];
            NSString *lon = [NSString stringWithFormat:@"%f", [_arrayOfCitiesInDirectionOfPhoneHeading[0] cityLocationLongitude]];
            
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
                        SMWeatherInfo *weatherInfoForCurrentCity = _currentWeatherInfoArray[0];
                        NSLog(@"Temperature For City: %@", _currentWeatherInfoForCity.temperature);
                        
                        [_frontCardView createLabelsWithWeatherObject:weatherInfoForCurrentCity];
                    }
                    
                }
                
            }];
        };
        

        
        if (_arrayOfCitiesInDirectionOfPhoneHeading.count >= 1) {
            SMWeatherInfoCardView *backViewForAnimating = [self createBackCard];
            
            CGRect backCardFrame = backViewForAnimating.frame;
            
            backViewForAnimating.frame = CGRectMake(backCardFrame.origin.x + self.view.frame.size.width + 100, backCardFrame.origin.y, backCardFrame.size.width, backCardFrame.size.height);
            [self.view addSubview:backViewForAnimating];
            
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/6);
            backViewForAnimating.transform = transform;
            
            POPSpringAnimation *rotate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            rotate.toValue = @(0);
            rotate.springBounciness = 3;
            rotate.springSpeed = 5.0f;
            rotate.beginTime = CACurrentMediaTime() + .2;
            [backViewForAnimating.layer pop_addAnimation:rotate forKey:@"rotate"];
            
            POPSpringAnimation *move =
            [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            move.toValue = [NSValue valueWithCGRect:backCardFrame];;
            move.springBounciness = 4;
            move.springSpeed = 5.0f;
            move.beginTime = CACurrentMediaTime() + .2;
            [backViewForAnimating.layer pop_addAnimation:move forKey:@"position"];
            

            
        }
        
        
        
    }
}

- (void) createCardStack {
    

    
    POPSpringAnimation *rotate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotate.toValue = @((M_PI/6)*-1);
    rotate.springBounciness = 3;
    rotate.springSpeed = 1.0f;
    //rotate.beginTime = CACurrentMediaTime() + .2;
    [_infoView.layer pop_addAnimation:rotate forKey:@"rotate"];
    [_frontCardView.layer pop_addAnimation:rotate forKey:@"rotate"];
    [_backCardView.layer pop_addAnimation:rotate forKey:@"rotate"];

    
    POPSpringAnimation *move =
    [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    move.toValue = [NSValue valueWithCGRect:CGRectMake(- 100, self.view.frame.size.height + 80, _frameOfFrontCard.size.width, _frameOfFrontCard.size.height)];;
    move.springBounciness = 4;
    move.springSpeed = 1.0f;
    //move.beginTime = CACurrentMediaTime() + .2;
    [_frontCardView.layer pop_addAnimation:move forKey:@"position"];
    [_backCardView.layer pop_addAnimation:move forKey:@"position"];
    [_infoView.layer pop_addAnimation:move forKey:@"position"];
    
    SMWeatherInfoCardView *frontView = _frontCardView;
    SMWeatherInfoCardView *backView = _backCardView;
    
    [self animateCardsIn];


    move.completionBlock = ^(POPAnimation *moved, BOOL finished) {
        
                [_infoView removeFromSuperview];
                [frontView removeFromSuperview];
                [backView removeFromSuperview];

        

    };
    
}


- (SMWeatherInfoCardView *)createBackCard {
    CGRect rectForCard = CGRectMake(_frameOfFrontCard.origin.x + 10, _frameOfFrontCard.origin.y + 15, _frameOfFrontCard.size.width - 20, _frameOfFrontCard.size.height);
    _backCardView = [[SMWeatherInfoCardView alloc] initWithFrame:rectForCard];
    _backCardView.alpha = .4;
    return _backCardView;
}

- (void) animateBackCardIn {
    
    CGRect frameForFront = _frontCardView.frame;
    
    _frontCardView = _backCardView;
    
    SMWeatherInfoCardView *backCardView = [self createBackCard];
    backCardView.frame = frameForFront;
    
    [self.view addSubview:backCardView];
    
    [UIView animateWithDuration:.5 animations:^{
        backCardView.frame = CGRectMake(_frameOfFrontCard.origin.x + 10, _frameOfFrontCard.origin.y + 15, _frameOfFrontCard.size.width - 20, _frameOfFrontCard.size.height);
    }];
    
    NSString *lat = [NSString stringWithFormat:@"%f", [_arrayOfCitiesInDirectionOfPhoneHeading[0] cityLocationLatitude]];
    NSString *lon = [NSString stringWithFormat:@"%f", [_arrayOfCitiesInDirectionOfPhoneHeading[0] cityLocationLongitude]];
    
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
                SMWeatherInfo *weatherInfoForCurrentCity = _currentWeatherInfoArray[0];
                NSLog(@"Temperature For City: %@", _currentWeatherInfoForCity.temperature);
                
                [_frontCardView createLabelsWithWeatherObject:weatherInfoForCurrentCity];
            }
        }
        
    }];
    
}


#pragma mark - Location Related Methods

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


#pragma mark - Helper Methods

- (void) setLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager startUpdatingLocation];
}

- (void) createSavedLocationsArray {
    
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
    
}




- (void)addGesturesToView {
    
    UISwipeGestureRecognizer *swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToSwipeDownGesture)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeleftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToLeftSwipe)];
    swipeleftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleftGesture];
    
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToRightSwipe)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];

    
}

- (void) respondToLeftSwipe {
    
    [UIView animateWithDuration:0.5 animations:^{
        _frontCardView.alpha = 0.0;
        _backCardView.frame = _frontCardView.frame;
        _frontCardView.center = CGPointMake(_frontCardView.frame.size.width / 2 *-1, _frontCardView.center.y + 10);
        _backCardView.alpha = 1.0;
        id object = [_arrayOfCitiesInDirectionOfPhoneHeading objectAtIndex:0];
        [_arrayOfCitiesInDirectionOfPhoneHeading removeObjectAtIndex:0];
        [_arrayOfCitiesInDirectionOfPhoneHeading insertObject:object atIndex:_arrayOfCitiesInDirectionOfPhoneHeading.count];
    } completion:^(BOOL finished) {
        
        [self animateBackCardIn];

        
    }];
    
}



- (void) respondToRightSwipe {
    
    [UIView animateWithDuration:0.5 animations:^{
        _frontCardView.alpha = 0.0;
        _backCardView.frame = _frontCardView.frame;
        _frontCardView.center = CGPointMake(_frontCardView.frame.size.width * 2, _frontCardView.center.y + 10);
        _backCardView.alpha = 1.0;
        id object = [_arrayOfCitiesInDirectionOfPhoneHeading objectAtIndex:0];
        [_arrayOfCitiesInDirectionOfPhoneHeading removeObjectAtIndex:0];
        [_arrayOfCitiesInDirectionOfPhoneHeading insertObject:object atIndex:_arrayOfCitiesInDirectionOfPhoneHeading.count];
    } completion:^(BOOL finished) {
        
        [self animateBackCardIn];
        
    }];
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
    _frameOfFrontCard = _infoView.frame;
    [_locationManager startUpdatingHeading];

    [_initialLoadingView removeFromSuperview];
    
}

@end

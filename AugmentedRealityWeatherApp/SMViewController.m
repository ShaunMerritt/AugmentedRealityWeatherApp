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
#import "SMWeatherLocationsViewController.h"
#import <POP.h>
#import "SMAddLocationsView.h"
#import "CLLocation+Bearing.h"
#import "SMExistingLocationsView.h"
#import "SMExistingLocationsViewController.h"
#import "UIButton+SMBackgroundColorForButton.h"
#import "PCAngularActivityIndicatorView.h"
#import "SMStyleKit.h"
#import "Flurry.h"

static NSString *kKeyForUserDefaults = @"savedLocationsArray";

@interface SMViewController () <CLLocationManagerDelegate, SMInitialLoadingViewDelegate> {
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
    SMWeatherInfo *_weatherInfoForCurrentCity;
    BOOL _doubleTappedToPauseUpdateHeading;
    float _degreeLastPointedTo;
    float _degreeCurrentlyPointingTo;
    BOOL _lookingAtCurrentLocation;
    UIButton *_doneLookingAtCurrentLocation;
    UISwipeGestureRecognizer *_swipeUpGesture;
    UISwipeGestureRecognizer *_swipeDownGestureRecognizer;
    UISwipeGestureRecognizer *_swipeRightGesture;
    UISwipeGestureRecognizer *_swipeLeftGesture;
    UILabel *_bottomInstructionsLabel;
    UIImageView *_directionPointingImage;
    UIImageView *_rightArrow;
    UIImageView *_leftArrow;
    PCAngularActivityIndicatorView *_activityIndicator;
    NSTimer *_waitForAnimationsTimer;
    BOOL _timerInSession;
    NSString* _currentCityName;
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
    _initialLoadingView.delegate = self;
    
    [self addGesturesToView];
    
}

-(UIImage *) getImageWithInvertedPixelsOfImage:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 2);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor whiteColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIButton *)buttonToReturnToApp {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height - 80, 200, 50)];
    button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height + 50);
    button.alpha = 1;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 2.0;
    button.titleLabel.text = @"Back to app";
    [button setTitle:@"Back to app" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlEventTouchDown | UIControlEventTouchDown];
    [button setBackgroundImage:[UIButton imageFromColor:[UIColor whiteColor]] forState:UIControlEventTouchDown | UIControlEventTouchDown];
    button.titleLabel.font = [UIFont fontWithName:@"Avenir" size:22.0];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    return button;

}

- (UILabel *)bottomInstructionLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Swipe up for current local weather";
    label.font = [UIFont fontWithName:@"Avenir Next Ultra Light" size:(15)];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    return label;
}

- (void) displayBottomInstruction:(BOOL)display {
        // Current Location Label
        
        _bottomInstructionsLabel = [self bottomInstructionLabel];
        _bottomInstructionsLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height + 40);
        [self.view addSubview:_bottomInstructionsLabel];
        POPSpringAnimation *moveLabelUp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        moveLabelUp.toValue = @(self.view.frame.size.height - 40);
        moveLabelUp.springSpeed = 2;
        moveLabelUp.springBounciness = 4;
        [_bottomInstructionsLabel pop_addAnimation:moveLabelUp forKey:@"moveDirectionsViewIn"];
    
}

- (void) showButtonToReturn {
    _doneLookingAtCurrentLocation = [self buttonToReturnToApp];

    [_doneLookingAtCurrentLocation addTarget:self action:@selector(continueButtonLiftedUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_doneLookingAtCurrentLocation];

    
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
    
    _degreeCurrentlyPointingTo = heading;
    if (_timerInSession == NO) {
        
    
        if (heading >= 315 || heading < 45) {
            
            float degreesAfterSubtraction = 135 - heading;
            if (degreesAfterSubtraction < 45) {
                float degreesAfterDivision = degreesAfterSubtraction/90;
                float final = degreesAfterDivision/10;
                _leftArrow.alpha = final;
                _rightArrow.alpha = 1.0-final;
            }
            
            if (heading >= 315) {
                float degrees = 405 - heading;
                float newValue = degrees/90;
                _leftArrow.alpha = newValue;
                _rightArrow.alpha = 1.0 - newValue;
            } else {
                float degrees = 45 - heading;
                float newValue = degrees/90;
                _rightArrow.alpha = 1.0 - newValue;
                _leftArrow.alpha = newValue;
            }
            
            _directionPointingImage.image = [UIImage imageNamed:@"North"];
            _directionPointingImage.center = CGPointMake(self.view.center.x, _leftArrow.center.y);
            [self.view addSubview: _directionPointingImage];
            if (![_arrayOfCitiesInDirectionOfPhoneHeading isEqualToArray:_quadrantOneLocations]) {
                _arrayOfCitiesInDirectionOfPhoneHeading = _quadrantOneLocations;
                [self createCardStack];
            }
        } else if (heading >= 45 && heading < 135) {
            
            float degreesAfterSubtraction = 135 - heading;
            if (degreesAfterSubtraction < 135) {
                float degrees = degreesAfterSubtraction/90;
                float newValue = degrees;
                _leftArrow.alpha = newValue;
                _rightArrow.alpha = 1.0-newValue;
            }
            
            _directionPointingImage.image = [UIImage imageNamed:@"East"];
            _directionPointingImage.center = CGPointMake(self.view.center.x, _leftArrow.center.y);
            if (![_arrayOfCitiesInDirectionOfPhoneHeading isEqualToArray:_quadrantTwoLocations]) {
                _arrayOfCitiesInDirectionOfPhoneHeading = _quadrantTwoLocations;
                [self createCardStack];
            }
        } else if (heading >= 135 && heading < 225) {
            
            float degreesAfterSubtraction = 225 - heading;
            if (degreesAfterSubtraction < 225) {
                float degrees = degreesAfterSubtraction/90;
                float newValue = degrees;
                _leftArrow.alpha = newValue;
                _rightArrow.alpha = 1.0-newValue;
            }
            
            _directionPointingImage.image = [UIImage imageNamed:@"South"];
            _directionPointingImage.center = CGPointMake(self.view.center.x, _leftArrow.center.y);
            if (![_arrayOfCitiesInDirectionOfPhoneHeading isEqualToArray:_quadrantThreeLocations]) {
                _arrayOfCitiesInDirectionOfPhoneHeading = _quadrantThreeLocations;
                [self createCardStack];
            }
        } else {
            
            float degreesAfterSubtraction = 315 - heading;
            if (degreesAfterSubtraction < 315) {
                float degrees = degreesAfterSubtraction/90;
                float newValue = degrees;
                _leftArrow.alpha = newValue;
                _rightArrow.alpha = 1.0-newValue;
            }
            
            _directionPointingImage.image = [UIImage imageNamed:@"West"];
            _directionPointingImage.center = CGPointMake(self.view.center.x, _leftArrow.center.y);
            if (![_arrayOfCitiesInDirectionOfPhoneHeading isEqualToArray:_quadrantFourLocations]) {
                _arrayOfCitiesInDirectionOfPhoneHeading = _quadrantFourLocations;
                [self createCardStack];
            }
        }
        
        _degreeLastPointedTo = heading;

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
                _weatherInfoForCurrentCity = _currentWeatherInfoArray[0];
            }
        }

    }];

}

#pragma mark - UILayout 

- (void) animateCardsIn {
    
    if (_arrayOfCitiesInDirectionOfPhoneHeading.count != 0) {
        
        [Flurry logEvent:@"New_Cards_Created"];

        
        _timerInSession = YES;
        
        if (_degreeLastPointedTo - _degreeCurrentlyPointingTo > 90 ) {
            _frontCardView = [[SMWeatherInfoCardView alloc] initWithFrame:CGRectMake(self.view.frame.size.width + 50, _frameOfFrontCard.origin.y, _frameOfFrontCard.size.width, _frameOfFrontCard.size.height)];
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/6);
            _frontCardView.transform = transform;
        } else if (_degreeLastPointedTo - _degreeCurrentlyPointingTo < -90) {
            _frontCardView = [[SMWeatherInfoCardView alloc] initWithFrame:CGRectMake(-200, _frameOfFrontCard.origin.y, _frameOfFrontCard.size.width, _frameOfFrontCard.size.height)];
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/-6);
            _frontCardView.transform = transform;
        } else if (_degreeLastPointedTo < _degreeCurrentlyPointingTo) {
            _frontCardView = [[SMWeatherInfoCardView alloc] initWithFrame:CGRectMake(self.view.frame.size.width + 50, _frameOfFrontCard.origin.y, _frameOfFrontCard.size.width, _frameOfFrontCard.size.height)];
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/6);
            _frontCardView.transform = transform;
        } else {
            _frontCardView = [[SMWeatherInfoCardView alloc] initWithFrame:CGRectMake(-200, _frameOfFrontCard.origin.y, _frameOfFrontCard.size.width, _frameOfFrontCard.size.height)];
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/-6);
            _frontCardView.transform = transform;
        }
        
        [self.view addSubview:_frontCardView];
        
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
        
        if (_arrayOfCitiesInDirectionOfPhoneHeading.count > 0) {
            [_frontCardView.layer pop_addAnimation:move forKey:@"position"];
            
            move.completionBlock = ^(POPAnimation *frame, BOOL finished) {
                NSString *lat = [NSString stringWithFormat:@"%f", [_arrayOfCitiesInDirectionOfPhoneHeading[0] cityLocationLatitude]];
                NSString *lon = [NSString stringWithFormat:@"%f", [_arrayOfCitiesInDirectionOfPhoneHeading[0] cityLocationLongitude]];

                NSString *URLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&units=imperial", lat, lon];
                //NSLog(@"url: %@", URLString);
                
                NSURL *url = [NSURL URLWithString:URLString];
                
                _activityIndicator = [[PCAngularActivityIndicatorView alloc] initWithActivityIndicatorStyle:PCAngularActivityIndicatorViewStyleLarge];
                _activityIndicator.color = [UIColor whiteColor];
                _activityIndicator.center = CGPointMake(self.view.center.x, self.view.frame.size.height*.6);
                [_activityIndicator startAnimating];
                [self.view addSubview:_activityIndicator];
                
                [SMWeatherClient downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
                    if (data != nil) {
                        
                        [_activityIndicator stopAnimating];
                        _timerInSession = NO;

                        NSError *error;
                        
                        if (error != nil) {
                            NSLog(@"%@", [error localizedDescription]);
                        }
                        else{
                            
                            SMWeatherModel *weatherParser = [[SMWeatherModel alloc] initWithJSONData:data];
                            _currentWeatherInfoArray = [[weatherParser generateWeatherDetailsList] mutableCopy];
                            
                            // TODO: Here is just basic testing
                            
                            if (_arrayOfCitiesInDirectionOfPhoneHeading.count > 0) {
                                SMWeatherInfo *weatherInfoForCurrentCity = _currentWeatherInfoArray[0];
                                NSLog(@"Name of city here! = %@", [_arrayOfCitiesInDirectionOfPhoneHeading[0] cityName]);
                                //NSLog(@"Temperature For City: %@", _currentWeatherInfoForCity.temperature);
                                
                                [_frontCardView createLabelsWithWeatherObject:weatherInfoForCurrentCity withCityName:[_arrayOfCitiesInDirectionOfPhoneHeading[0] cityName]];
                            }
                            
                        }
                        
                    }
                    
                }];
            };

        }
        

        
        if (_arrayOfCitiesInDirectionOfPhoneHeading.count > 1) {
            
            _backCardView = [self createBackCard];
            CGRect backCardFrame = _backCardView.frame;
            
            if (_degreeLastPointedTo - _degreeCurrentlyPointingTo > 90 ) {
                _backCardView.frame = CGRectMake(self.view.frame.origin.x + 200, _frameOfFrontCard.origin.y, _frameOfFrontCard.size.width - 20, _frameOfFrontCard.size.height);
                CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/6);
                _backCardView.transform = transform;
            } else if (_degreeLastPointedTo - _degreeCurrentlyPointingTo < -90) {
                _backCardView = [[SMWeatherInfoCardView alloc] initWithFrame:CGRectMake(-200, _frameOfFrontCard.origin.y, backCardFrame.size.width, backCardFrame.size.height)];
                CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/-6);
                _backCardView.transform = transform;
            } else if (_degreeLastPointedTo < _degreeCurrentlyPointingTo) {
                _backCardView.frame = CGRectMake(self.view.frame.origin.x + 200, _frameOfFrontCard.origin.y, _frameOfFrontCard.size.width - 20, _frameOfFrontCard.size.height);
                CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/6);
                _backCardView.transform = transform;
            } else {
                _backCardView = [[SMWeatherInfoCardView alloc] initWithFrame:CGRectMake(-200, _frameOfFrontCard.origin.y, backCardFrame.size.width, backCardFrame.size.height)];
                CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/-6);
                _backCardView.transform = transform;
            }
        
            [self.view addSubview:_backCardView];
            _backCardView.alpha = .4;
            
            POPSpringAnimation *rotate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            rotate.toValue = @(0);
            rotate.springBounciness = 3;
            rotate.springSpeed = 5.0f;
            rotate.beginTime = CACurrentMediaTime() + .2;
            [_backCardView.layer pop_addAnimation:rotate forKey:@"rotate"];
            
            POPSpringAnimation *moveBackCardToTheSide = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
            moveBackCardToTheSide.toValue = @(self.view.center.x);
            moveBackCardToTheSide.springSpeed = 2;
            moveBackCardToTheSide.springBounciness = 4;
            [_backCardView pop_addAnimation:moveBackCardToTheSide forKey:@"moveIn"];
            
            POPSpringAnimation *moveBackCardDown = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
            moveBackCardDown.toValue = @(_frameOfFrontCard.origin.y + _backCardView.frame.size.height*.48);
            moveBackCardDown.springSpeed = 2;
            moveBackCardDown.springBounciness = 4;
            [_backCardView pop_addAnimation:moveBackCardDown forKey:@"moveDown"];
            
            _swipeLeftGesture.enabled = YES;
            _swipeRightGesture.enabled = YES;
            
        } else {
            _swipeLeftGesture.enabled = NO;
            _swipeRightGesture.enabled = NO;
        }
        
    }
    
    
}

- (void) createCardStack {

    POPSpringAnimation *rotate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotate.toValue = @((M_PI/6)*-1);
    rotate.springBounciness = 3;
    rotate.springSpeed = 1.0f;
    [_frontCardView.layer pop_addAnimation:rotate forKey:@"rotate"];
    [_backCardView.layer pop_addAnimation:rotate forKey:@"rotate"];

    
    POPSpringAnimation *move =
    [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    move.toValue = [NSValue valueWithCGRect:CGRectMake(- 100, self.view.frame.size.height* 1.5, _frameOfFrontCard.size.width, _frameOfFrontCard.size.height)];;
    move.springBounciness = 4;
    move.springSpeed = 1.0f;
    [_frontCardView.layer pop_addAnimation:move forKey:@"position"];
    [_backCardView.layer pop_addAnimation:move forKey:@"position"];
    [_infoView.layer pop_addAnimation:move forKey:@"position"];
    
    SMWeatherInfoCardView *frontView = _frontCardView;
    SMWeatherInfoCardView *backView = _backCardView;
    
    [self animateCardsIn];

    move.completionBlock = ^(POPAnimation *moved, BOOL finished) {
        
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
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    _activityIndicator = [[PCAngularActivityIndicatorView alloc] initWithActivityIndicatorStyle:PCAngularActivityIndicatorViewStyleLarge];
    _activityIndicator.color = [UIColor whiteColor];
    _activityIndicator.center = CGPointMake(self.view.center.x, self.view.frame.size.height*.6);
    [_activityIndicator startAnimating];
    [self.view addSubview:_activityIndicator];
    
    [SMWeatherClient downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            
            [_activityIndicator stopAnimating];
            
            NSError *error;
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                
                SMWeatherModel *weatherParser = [[SMWeatherModel alloc] initWithJSONData:data];
                _currentWeatherInfoArray = [[weatherParser generateWeatherDetailsList] mutableCopy];
                
                // TODO: Here is just basic testing
                SMWeatherInfo *weatherInfoForCurrentCity = _currentWeatherInfoArray[0];
                //NSLog(@"Temperature For City: %@", _currentWeatherInfoForCity.temperature);
                
                [_frontCardView createLabelsWithWeatherObject:weatherInfoForCurrentCity withCityName:[_arrayOfCitiesInDirectionOfPhoneHeading[0] cityName]];
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

- (void)doubleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%s", __FUNCTION__);
    if (_doubleTappedToPauseUpdateHeading == NO) {
        [_locationManager stopUpdatingHeading];
        _doubleTappedToPauseUpdateHeading = YES;
    } else {
        [_locationManager startUpdatingHeading];
        _doubleTappedToPauseUpdateHeading = NO;
    }
}

- (void)addGesturesToView {
    
    // double tap gesture recognizer
    UITapGestureRecognizer *dtapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
    dtapGestureRecognize.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:dtapGestureRecognize];
    
    _swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToSwipeDownGesture)];
    _swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:_swipeDownGestureRecognizer];
    
    _swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToLeftSwipe)];
    _swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:_swipeLeftGesture];
    
    _swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToRightSwipe)];
    _swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeRightGesture];
    
    _swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToUpSwipe:)];
    _swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:_swipeUpGesture];


    
}

- (void) respondToUpSwipe: (UISwipeGestureRecognizer *)recognizer {
    
    [Flurry logEvent:@"Swipe_Up"];

    
    POPSpringAnimation *moveBottomInstructionLabelUp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveBottomInstructionLabelUp.toValue = @(self.view.frame.size.height + 40);
    moveBottomInstructionLabelUp.springSpeed = 2;
    moveBottomInstructionLabelUp.springBounciness = 4;
    [_bottomInstructionsLabel pop_addAnimation:moveBottomInstructionLabelUp forKey:@"moveDirectionsViewIn"];
    
    POPSpringAnimation *moveCardsUp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveCardsUp.toValue = @(_frontCardView.frame.origin.y + 60);
    moveCardsUp.springSpeed = 2;
    moveCardsUp.springBounciness = 4;
    [_frontCardView pop_addAnimation:moveCardsUp forKey:@"moveDirectionsViewIn"];
    [_backCardView pop_addAnimation:moveCardsUp forKey:@"moveDirectionsViewIn"];
    
    POPSpringAnimation *moveCardsToTheSide = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveCardsToTheSide.toValue = @(self.view.frame.size.width * 1.5 + _frontCardView.frame.size.width);
    moveCardsToTheSide.springSpeed = 2;
    moveCardsToTheSide.springBounciness = 4;
    [_frontCardView pop_addAnimation:moveCardsToTheSide forKey:@"moveDirectionsViewOut"];
    [_backCardView pop_addAnimation:moveCardsToTheSide forKey:@"moveDirectionsViewOut"];
    [_bottomInstructionsLabel pop_addAnimation:moveCardsToTheSide forKey:@"moveDirectionsViewOut"];
    
    
    POPSpringAnimation *spin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    spin.toValue = @(M_PI/6);
    spin.springBounciness = 15;
    spin.springSpeed = 5.0f;
    [_frontCardView.layer pop_addAnimation:spin forKey:@"spin"];
    [_backCardView.layer pop_addAnimation:spin forKey:@"rotationAnimation"];
    [_bottomInstructionsLabel.layer pop_addAnimation:spin forKey:@"rotate"];
    
    [_locationManager stopUpdatingHeading];
    
    POPSpringAnimation *moveCurrentIn = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveCurrentIn.toValue = @((_frameOfFrontCard.origin.y + _frameOfFrontCard.size.height/2));
    moveCurrentIn.springSpeed = 2;
    moveCurrentIn.springBounciness = 4;
    [_infoView pop_addAnimation:moveCurrentIn forKey:@"moveCurrentIn"];
    
    POPSpringAnimation *moveCurrentX = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveCurrentX.toValue = @(self.view.center.x);
    moveCurrentX.springSpeed = 2;
    moveCurrentX.springBounciness = 4;
    [_infoView pop_addAnimation:moveCurrentX forKey:@"moveCurrentX"];
    
    POPSpringAnimation *moveButtonUp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveButtonUp.toValue = @(self.view.frame.size.height - 40);
    moveButtonUp.springSpeed = 2;
    moveButtonUp.springBounciness = 4;
    [_doneLookingAtCurrentLocation pop_addAnimation:moveButtonUp forKey:@"moveButtonUp"];
    
    _swipeUpGesture.enabled = NO;
    _swipeLeftGesture.enabled = NO;
    _swipeRightGesture.enabled = NO;
    _swipeDownGestureRecognizer.enabled = NO;

}

- (void)continueButtonLiftedUp:(UIButton*)button {
    
    [Flurry logEvent:@"Done_Looking_At_Current_Location"];

    
    POPSpringAnimation *moveBottomInstructionLabelUp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveBottomInstructionLabelUp.toValue = @(self.view.frame.size.height - 40);
    moveBottomInstructionLabelUp.springSpeed = 2;
    moveBottomInstructionLabelUp.springBounciness = 4;
    [_bottomInstructionsLabel pop_addAnimation:moveBottomInstructionLabelUp forKey:@"moveDirectionsViewIn"];
    
    POPSpringAnimation *moveCardsDown = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveCardsDown.toValue = @(_frameOfFrontCard.origin.y + _frameOfFrontCard.size.height / 2);
    moveCardsDown.springSpeed = 2;
    moveCardsDown.springBounciness = 4;
    [_frontCardView pop_addAnimation:moveCardsDown forKey:@"moveDirectionsViewIn"];
    [_backCardView pop_addAnimation:moveCardsDown forKey:@"moveDirectionsViewIn"];
    
    POPSpringAnimation *moveCardsToTheSide = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveCardsToTheSide.toValue = @(self.view.frame.size.width / 2);
    moveCardsToTheSide.springSpeed = 2;
    moveCardsToTheSide.springBounciness = 4;
    [_frontCardView pop_addAnimation:moveCardsToTheSide forKey:@"moveDirectionsViewOut"];
    [_backCardView pop_addAnimation:moveCardsToTheSide forKey:@"moveDirectionsViewOut"];
    [_bottomInstructionsLabel pop_addAnimation:moveCardsToTheSide forKey:@"moveDirectionsViewOut"];

    
    
    POPSpringAnimation *spin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    spin.toValue = @(0);
    spin.springBounciness = 15;
    spin.springSpeed = 5.0f;
    [_frontCardView.layer pop_addAnimation:spin forKey:@"spin"];
    [_backCardView.layer pop_addAnimation:spin forKey:@"rotationAnimation"];
    [_bottomInstructionsLabel.layer pop_addAnimation:spin forKey:@"rotate"];

    
    
    [_locationManager startUpdatingHeading];
    
    POPSpringAnimation *moveCurrentIn = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveCurrentIn.toValue = @((_frameOfFrontCard.origin.y + _frameOfFrontCard.size.height * 2 ));
    moveCurrentIn.springSpeed = 2;
    moveCurrentIn.springBounciness = 4;
    [_infoView pop_addAnimation:moveCurrentIn forKey:@"moveCurrentIn"];
    
    POPSpringAnimation *moveCurrentX = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveCurrentX.toValue = @(self.view.center.x );
    moveCurrentX.springSpeed = 2;
    moveCurrentX.springBounciness = 4;
    [_infoView pop_addAnimation:moveCurrentX forKey:@"moveCurrentX"];
    
    POPSpringAnimation *moveButtonUp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveButtonUp.toValue = @(self.view.frame.size.height + 40);
    moveButtonUp.springSpeed = 2;
    moveButtonUp.springBounciness = 4;
    [_doneLookingAtCurrentLocation pop_addAnimation:moveButtonUp forKey:@"moveButtonUp"];
    
    
    _swipeUpGesture.enabled = YES;
    _swipeLeftGesture.enabled = YES;
    _swipeRightGesture.enabled = YES;
    _swipeDownGestureRecognizer.enabled = YES;
}

- (void) respondToLeftSwipe {
    if (_arrayOfCitiesInDirectionOfPhoneHeading.count > 0) {

        [UIView animateWithDuration:0.5 animations:^{
            _frontCardView.alpha = 0.0;
            _backCardView.frame = _frontCardView.frame;
            _frontCardView.center = CGPointMake(_frontCardView.frame.size.width / 2 *-1, _frontCardView.center.y + 10);
            _backCardView.alpha = 1.0;
            id object = [_arrayOfCitiesInDirectionOfPhoneHeading objectAtIndex:0];
            [_arrayOfCitiesInDirectionOfPhoneHeading removeObjectAtIndex:0];
            [_arrayOfCitiesInDirectionOfPhoneHeading insertObject:object atIndex:_arrayOfCitiesInDirectionOfPhoneHeading.count];
        } completion:^(BOOL finished) {
            [Flurry logEvent:@"Swipe_Left"];

            [self animateBackCardIn];

            
        }];
    }
}

- (void) respondToRightSwipe {
    
    if (_arrayOfCitiesInDirectionOfPhoneHeading.count > 0) {
        
        
        
        [UIView animateWithDuration:0.5 animations:^{
            _frontCardView.alpha = 0.0;
            _backCardView.frame = _frontCardView.frame;
            _frontCardView.center = CGPointMake(_frontCardView.frame.size.width * 2, _frontCardView.center.y + 10);
            _backCardView.alpha = 1.0;
            id object = [_arrayOfCitiesInDirectionOfPhoneHeading objectAtIndex:0];
            [_arrayOfCitiesInDirectionOfPhoneHeading removeObjectAtIndex:0];
            [_arrayOfCitiesInDirectionOfPhoneHeading insertObject:object atIndex:_arrayOfCitiesInDirectionOfPhoneHeading.count];
        } completion:^(BOOL finished) {
            [Flurry logEvent:@"Swipe_Right"];

            [self animateBackCardIn];
            
        }];
            
    }
}

- (void) respondToSwipeDownGesture {
    
    
    SMExistingLocationsView *addLocationsView = [[SMExistingLocationsView alloc]  initWithFrame: CGRectMake(0, -1 * self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
     [self.view addSubview:addLocationsView];
    
    [UIView animateWithDuration:0.8 delay:0
         usingSpringWithDamping:0.7 initialSpringVelocity:0 options:0 animations:^{
             
             [addLocationsView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
             
         } completion:^(BOOL finished) {
             [Flurry logEvent:@"Swipe_Down"];

             SMExistingLocationsViewController *weatherLocationsViewController = [[SMExistingLocationsViewController alloc] init];
             [[self navigationController] pushViewController:weatherLocationsViewController animated:NO];

         }];
    
}

#pragma mark - SMInitialInfoViewDelegate 

- (void) didCreateCard:(BOOL)isComplete {
    
    if (isComplete == YES) {
        _infoView = [[SMWeatherInfoCardView alloc] initWithFrame:CGRectMake(_initialLoadingView.frame.origin.x, _initialLoadingView.frame.origin.y + 100, _initialLoadingView.frame.size.width, _initialLoadingView.frame.size.height)];
        
        
        CLGeocoder *coder = [[CLGeocoder alloc]init];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:_currentUsersLocation.coordinate.latitude longitude:_currentUsersLocation.coordinate.longitude]; //insert your coordinates
        
        
        [coder reverseGeocodeLocation: loc completionHandler:
         ^(NSArray *placemarks, NSError *error) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             _currentCityName = [NSString stringWithFormat:@"%@",placemark.locality];
             [_infoView createLabelsWithWeatherObject:_weatherInfoForCurrentCity withCityName:_currentCityName];
             [self.view addSubview:_infoView];
             _frameOfFrontCard = _infoView.frame;
             [_locationManager startUpdatingHeading];
             
             [_initialLoadingView removeFromSuperview];
             
             _lookingAtCurrentLocation = YES;
             [self displayBottomInstruction:_lookingAtCurrentLocation];
             
             _doneLookingAtCurrentLocation = [self buttonToReturnToApp];
             [_doneLookingAtCurrentLocation addTarget:self action:@selector(continueButtonLiftedUp:) forControlEvents:UIControlEventTouchUpInside];
             [self.view addSubview:_doneLookingAtCurrentLocation];
             
             _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Right Arrow"]];
             _rightArrow.frame = CGRectMake(self.view.frame.size.width - 40 - _rightArrow.frame.size.width, 60, _rightArrow.frame.size.width, _rightArrow.frame.size.height);
             [self.view addSubview:_rightArrow];
             _rightArrow.alpha = .2;
             
             _leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Left Arrow"]];
             _leftArrow.frame = CGRectMake(30, 60, _rightArrow.frame.size.width, _rightArrow.frame.size.height);
             [self.view addSubview:_leftArrow];
             _leftArrow.alpha = .2;
             
             _directionPointingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"West"]];
             _directionPointingImage.center = CGPointMake(-100, -100);
             _directionPointingImage.contentMode = UIViewContentModeScaleAspectFit;
             [self.view addSubview:_directionPointingImage];
             
         }];
         
        
        

        
    }
    
}

@end

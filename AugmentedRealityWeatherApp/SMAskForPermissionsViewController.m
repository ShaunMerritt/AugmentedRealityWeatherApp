//
//  SMAskForPermissionsViewController.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/23/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMAskForPermissionsViewController.h"
#import "SMAskForPermissionsView.h"
#import "SMDirectionsForAddingLocationsView.h"
#import "SMDirectionsForAddingLocationsViewController.h"
#import <POP.h>
#import <CoreLocation/CoreLocation.h>

@interface SMAskForPermissionsViewController ()<SMAskForPermissionsViewDelegate, CLLocationManagerDelegate> {
    SMAskForPermissionsView *_askForPermissionsView;
    CLLocationManager *_locationManager;
}

@end

@implementation SMAskForPermissionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _askForPermissionsView = [[SMAskForPermissionsView alloc] initWithFrame:self.view.frame];
    _askForPermissionsView.delegate = self;
    [self.view addSubview:_askForPermissionsView];
    
}

- (void) sayYesButtonPressed {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager requestWhenInUseAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {

        [self moveToNextScreen];
        
    } else if (status == kCLAuthorizationStatusDenied) {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ok..." message:@"The app won't work entirely without your location. If you change your mind, the option to allow location privelages is in settings." delegate:nil cancelButtonTitle:@"Got It!" otherButtonTitles: nil];
        [alertView show];
        
        [self moveToNextScreen];

    }
}

- (void) moveToNextScreen {
    
    POPSpringAnimation *moveDirectionsViewDown = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveDirectionsViewDown.toValue = @(self.view.frame.size.height + _askForPermissionsView.frame.size.height/2);
    moveDirectionsViewDown.springSpeed = 2;
    moveDirectionsViewDown.springBounciness = 2;
    [_askForPermissionsView pop_addAnimation:moveDirectionsViewDown forKey:@"moveDirectionsViewDown"];
    
    SMDirectionsForAddingLocationsView *directionsForAddingLocationsView = [[SMDirectionsForAddingLocationsView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
    directionsForAddingLocationsView.center = CGPointMake(self.view.frame.size.width/2, -200);
    [self.view addSubview:directionsForAddingLocationsView];
    
    POPSpringAnimation *moveDirectionsViewIn = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveDirectionsViewIn.toValue = @(directionsForAddingLocationsView.frame.size.height/2);
    moveDirectionsViewIn.springSpeed = 2;
    moveDirectionsViewIn.springBounciness = 4;
    [directionsForAddingLocationsView pop_addAnimation:moveDirectionsViewIn forKey:@"moveDirectionsViewIn"];
    
    moveDirectionsViewDown.completionBlock = ^(POPAnimation *fade, BOOL finished) {
        SMDirectionsForAddingLocationsViewController *viewController = [[SMDirectionsForAddingLocationsViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:NO];
    };

    
}

@end

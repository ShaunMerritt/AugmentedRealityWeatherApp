//
//  SMSwipeExplanationViewController.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/26/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMSwipeExplanationViewController.h"
#import "SMSwipeExplanationView.h"
#import "SMDirectionsForPointingPhoneView.h"
#import "SMAskForPermissionsView.h"
#import "SMAskForPermissionsViewController.h"
#import <POP.h>

@interface SMSwipeExplanationViewController () {
    SMSwipeExplanationView *_swipeExplanationView;
}

@end

@implementation SMSwipeExplanationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UISwipeGestureRecognizer *swipeleftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipe)];
    swipeleftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleftGesture];
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipe)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
    
    _swipeExplanationView = [[SMSwipeExplanationView alloc] initWithFrame:self.view.frame];
    _swipeExplanationView.center = CGPointMake(self.view.frame.size.width/2, _swipeExplanationView.frame.size.height/2);
    [self.view addSubview:_swipeExplanationView];
}

- (void) respondToSwipe {
    
    POPSpringAnimation *moveDirectionsViewDown = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveDirectionsViewDown.toValue = @(self.view.frame.size.height + _swipeExplanationView.frame.size.height/2);
    moveDirectionsViewDown.springSpeed = 2;
    moveDirectionsViewDown.springBounciness = 2;
    [_swipeExplanationView pop_addAnimation:moveDirectionsViewDown forKey:@"moveDirectionsViewDown"];

    
    SMAskForPermissionsView *directionsForAddingLocationsView = [[SMAskForPermissionsView alloc] initWithFrame:self.view.frame];
    directionsForAddingLocationsView.center = CGPointMake(self.view.frame.size.width/2, -200);
    [self.view addSubview:directionsForAddingLocationsView];

    POPSpringAnimation *moveDirectionsViewIn = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveDirectionsViewIn.toValue = @(directionsForAddingLocationsView.frame.size.height/2);
    moveDirectionsViewIn.springSpeed = 2;
    moveDirectionsViewIn.springBounciness = 4;
    [directionsForAddingLocationsView pop_addAnimation:moveDirectionsViewIn forKey:@"moveDirectionsViewIn"];

    moveDirectionsViewDown.completionBlock = ^(POPAnimation *fade, BOOL finished) {
        SMAskForPermissionsViewController *viewController = [[SMAskForPermissionsViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    };
}

@end

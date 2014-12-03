//
//  SMDirectionsForPointingPhoneViewController.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMDirectionsForPointingPhoneViewController.h"
#import "SMDirectionsForPointingPhoneView.h"
#import <POP.h>
#import "SMDirectionsForAddingLocationsView.h"
#import "SMDirectionsForAddingLocationsViewController.h"
#import "SMAskForPermissionsView.h"
#import "SMAskForPermissionsViewController.h"
#import "SMSwipeExplanationView.h"
#import "SMSwipeExplanationViewController.h"

@interface SMDirectionsForPointingPhoneViewController () <SMDirectionsForPointingPhoneDelegate> {
    SMDirectionsForPointingPhoneView *_directionsView;
    SMSwipeExplanationView *_swipeExplanationView;
}

@end

@implementation SMDirectionsForPointingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:1.0];
    
    _directionsView = [[SMDirectionsForPointingPhoneView alloc] initWithFrame:self.view.frame];
    _directionsView.delegate = self;
    [self.view addSubview:_directionsView];
}

- (void)continueButtonPressed {
    
    POPSpringAnimation *moveDirectionsViewDown = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveDirectionsViewDown.toValue = @(self.view.frame.size.height + _directionsView.frame.size.height/2);
    moveDirectionsViewDown.springSpeed = 2;
    moveDirectionsViewDown.springBounciness = 2;
    [_directionsView pop_addAnimation:moveDirectionsViewDown forKey:@"moveDirectionsViewDown"];
    
    _swipeExplanationView = [[SMSwipeExplanationView alloc] initWithFrame:self.view.frame];
    _swipeExplanationView.center = CGPointMake(self.view.frame.size.width/2, -200);
    [self.view addSubview:_swipeExplanationView];
    _swipeExplanationView.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        _swipeExplanationView.alpha = 1;
    }];
    
    POPSpringAnimation *moveDirectionsViewIn = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveDirectionsViewIn.toValue = @(_swipeExplanationView.frame.size.height/2);
    moveDirectionsViewIn.springSpeed = 2;
    moveDirectionsViewIn.springBounciness = 4;
    [_swipeExplanationView pop_addAnimation:moveDirectionsViewIn forKey:@"moveDirectionsViewIn"];

    moveDirectionsViewDown.completionBlock = ^(POPAnimation *fade, BOOL finished) {
        SMSwipeExplanationViewController *viewController = [[SMSwipeExplanationViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:NO];
    };
    
}

@end

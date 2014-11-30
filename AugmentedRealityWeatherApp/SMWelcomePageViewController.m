//
//  SMWelcomePageViewController.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMWelcomePageViewController.h"
#import "SMWelcomeView.h"
#import "SMDirectionsForPointingPhoneViewController.h"

@interface SMWelcomePageViewController () <SMWelcomeProtocol> {
    SMWelcomeView *_welcomeView;
}

@end

@implementation SMWelcomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _welcomeView = [[SMWelcomeView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    _welcomeView.delegate = self;
    [self.view addSubview:_welcomeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) beginButtonPressed {
    SMDirectionsForPointingPhoneViewController *weatherLocationsViewController = [[SMDirectionsForPointingPhoneViewController alloc] init];
    [[self navigationController] pushViewController:weatherLocationsViewController animated:NO];
}

@end

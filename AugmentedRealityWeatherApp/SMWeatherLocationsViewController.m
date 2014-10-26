//
//  SMWeatherLocationsViewController.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 10/19/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMWeatherLocationsViewController.h"
#import "SMAddLocationsView.h"

@interface SMWeatherLocationsViewController () {
    SMAddLocationsView *_addLocationsView;
}

@end

@implementation SMWeatherLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _addLocationsView = [[SMAddLocationsView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    self.view = _addLocationsView;
    
}


@end

//
//  SMDirectionsForAddingLocationsViewController.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/23/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMDirectionsForAddingLocationsViewController.h"
#import "SMDirectionsForAddingLocationsView.h"
#import "SMExistingLocationsView.h"
#import "SMExistingLocationsViewController.h"
#import "Flurry.h"

@interface SMDirectionsForAddingLocationsViewController ()

@end

@implementation SMDirectionsForAddingLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notFirstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:1.0];

    SMDirectionsForAddingLocationsView *directionsForAddingLocationsView = [[SMDirectionsForAddingLocationsView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
    directionsForAddingLocationsView.center = CGPointMake(self.view.frame.size.width/2, directionsForAddingLocationsView.frame.size.height/2);
    [self.view addSubview:directionsForAddingLocationsView];
    
    UISwipeGestureRecognizer *swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                                            initWithTarget:self action:@selector(respondToSwipeDownGesture)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];

}

- (void) respondToSwipeDownGesture {
    
    SMExistingLocationsView *addLocationsView = [[SMExistingLocationsView alloc]  initWithFrame: CGRectMake(0, -1 * self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:addLocationsView];
    
    [UIView animateWithDuration:0.8 delay:0
         usingSpringWithDamping:0.7 initialSpringVelocity:0 options:0 animations:^{
             
             [addLocationsView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
             
         } completion:^(BOOL finished) {
             
             [Flurry logEvent:@"Finished_Walktrhough"];
             
             SMExistingLocationsViewController *weatherLocationsViewController = [[SMExistingLocationsViewController alloc] init];
             [[self navigationController] pushViewController:weatherLocationsViewController animated:NO];
             
         }];
    
}

@end

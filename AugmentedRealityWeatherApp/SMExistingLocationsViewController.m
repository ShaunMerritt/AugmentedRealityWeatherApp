//
//  SMExistingLocationsViewController.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/15/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMExistingLocationsViewController.h"
#import "SMExistingLocationsView.h"
#import "SMLocationModel.h"
#import "SMAddNewLocationsViewController.h"



static NSString *kKeyForUserDefaults = @"savedLocationsArray";

@interface SMExistingLocationsViewController () <SMExistingLocationsDelegate> {
    SMExistingLocationsView *_existingLocationsView;
    NSMutableArray *_dataToDisplayOnTableViewArray;
    NSMutableArray *_savedLocations;
}

@end

@implementation SMExistingLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self accessStoredData];

    _existingLocationsView = [[SMExistingLocationsView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    _existingLocationsView.dataForTableView = _dataToDisplayOnTableViewArray;
    
    [_existingLocationsView.tableViewContainingSavedCities performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    _existingLocationsView.delegate = self;
    [_existingLocationsView.tableViewContainingSavedCities reloadData];
    
    self.view = _existingLocationsView;

}

- (void) accessStoredData {
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedArray = [currentDefaults objectForKey:kKeyForUserDefaults];
    if (savedArray != nil) {
        NSArray *arrayOfSavedLocationObjects = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        if (arrayOfSavedLocationObjects != nil) {
            _savedLocations = [[NSMutableArray alloc] initWithArray:arrayOfSavedLocationObjects];
            _dataToDisplayOnTableViewArray = _savedLocations;
        } else {
            _savedLocations = [[NSMutableArray alloc] init];
            _dataToDisplayOnTableViewArray = [[NSMutableArray alloc] init];
        }
    }
}

- (void)addCityButtonPressed {
    SMAddNewLocationsViewController *weatherLocationsViewController = [[SMAddNewLocationsViewController alloc] init];
    [[self navigationController] pushViewController:weatherLocationsViewController animated:NO];
}

@end

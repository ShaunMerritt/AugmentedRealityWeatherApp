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
#import "SMViewController.h"
#import "Flurry.h"



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

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self accessStoredData];
    _existingLocationsView.dataForTableView = _dataToDisplayOnTableViewArray;
    [_existingLocationsView.tableViewContainingSavedCities performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

    
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
            _savedLocations = [[NSMutableArray alloc] initWithArray:arrayOfSavedLocationObjects];
            _dataToDisplayOnTableViewArray = _savedLocations;
        }
    }
}

- (void)addCityButtonPressed {
    SMAddNewLocationsViewController *weatherLocationsViewController = [[SMAddNewLocationsViewController alloc] init];
    [[self navigationController] pushViewController:weatherLocationsViewController animated:NO];
}

- (void) doneButtonClicked {
 
    [UIView animateWithDuration:1.0 animations:^{
        _existingLocationsView.frame = CGRectMake(0, self.view.frame.size.height, _existingLocationsView.frame.size.width, _existingLocationsView.frame.size.width);
        
    } completion:^(BOOL finished) {
        
        [Flurry logEvent:@"Return_To_Weather"];

        
        SMViewController *weatherLocationsViewController = [[SMViewController alloc] init];
        [[self navigationController] pushViewController:weatherLocationsViewController animated:NO];
    }];
    
    
}

- (void) removeCellAtIndex:(NSInteger)row {
    
    [_dataToDisplayOnTableViewArray removeObjectAtIndex:row];
    _existingLocationsView.dataForTableView = _dataToDisplayOnTableViewArray;
    [_existingLocationsView.tableViewContainingSavedCities performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_dataToDisplayOnTableViewArray] forKey:kKeyForUserDefaults];

    [Flurry logEvent:@"Removed_Location"];

}


@end

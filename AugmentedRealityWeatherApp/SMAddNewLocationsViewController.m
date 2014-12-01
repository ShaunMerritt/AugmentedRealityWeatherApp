//
//  SMAddNewLocationsViewController.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/16/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMAddNewLocationsViewController.h"
#import "SMAddNewLocationView.h"
#import "SMLocationModel.h"
#import <CoreLocation/CoreLocation.h>
#import "SMExistingLocationsView.h"
#import <POP.h>
#import "UIColor+SMAugmentedRealityAppColors.h"
#import "SMExistingLocationsViewController.h"

static NSString *kKeyForUserDefaults = @"savedLocationsArray";


@interface SMAddNewLocationsViewController () <UITextFieldDelegate, SMAddNewLocationsDelegate> {
    SMAddNewLocationView *_addLocationsView;
    NSMutableArray *_dataToDisplayOnTableViewArray;
    NSMutableArray *_searchResultArray;
    CLGeocoder *_geocoder;
    float _latitude;
    float _longitude;
    NSMutableArray *_savedLocations;

}

@end

@implementation SMAddNewLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.8902 green:0.8902 blue:0.8902 alpha:1.0];
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedArray = [currentDefaults objectForKey:kKeyForUserDefaults];
    if (savedArray != nil)
    {
        NSArray *arrayOfSavedLocationObjects = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        if (arrayOfSavedLocationObjects != nil) {
            _savedLocations = [[NSMutableArray alloc] initWithArray:arrayOfSavedLocationObjects];
            _dataToDisplayOnTableViewArray = _savedLocations;
        } else {
            _savedLocations = [[NSMutableArray alloc] init];
            _dataToDisplayOnTableViewArray = [[NSMutableArray alloc] init];
        }
    }
    
    _addLocationsView = [[SMAddNewLocationView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    [_addLocationsView.tableViewContainingSearchResults performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    _addLocationsView.delegate = self;
    self.view = _addLocationsView;
    
    _addLocationsView.searchBar.delegate = self;
    [_addLocationsView.searchBar addTarget:self action:@selector(getCurrentTextFieldText:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)getCurrentTextFieldText:(id)sender {
    
    NSLog(@"meememe");
    
    NSString *textForTheSearch = [((UITextField *)sender).text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *searchString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(cities)&language=EN&key=AIzaSyBD_lHt-93q3G8kHWmq_eQKqLjLcwhM0wE", textForTheSearch];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:searchString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                NSError *errors = nil;
                NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (errors != nil) {
                    NSLog(@"Error parsing JSON.");
                }
                else {
                    
                    NSArray *returnedResultArray = [NSArray arrayWithObject:jsonArray[@"predictions"]];
                    
                    _dataToDisplayOnTableViewArray  = [[NSMutableArray alloc] initWithArray:returnedResultArray[0]];
                    _addLocationsView.dataForTableView = _dataToDisplayOnTableViewArray;
                    NSArray *addressArray = [[returnedResultArray valueForKey:@"description"] firstObject];
                    _searchResultArray = [[NSMutableArray alloc] init];
                    
                    for (NSString *cityName in addressArray) {
                        SMLocationModel *locationModelObject = [[SMLocationModel alloc] initWithCityName:cityName latitude:0 longitude:0 degreesFromNorth:0];
                        NSLog(@"NAme here: %@", locationModelObject.cityName);
                        [_searchResultArray addObject: locationModelObject];
                        if (_searchResultArray.count == addressArray.count) {
                            
                            _addLocationsView.dataForTableView = _searchResultArray;
                            [_addLocationsView.tableViewContainingSearchResults performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                        }
                    }
                    
                    if (addressArray.count == 0) {
                        NSLog(@"YEP");
                        SMLocationModel *locationModelObject = [[SMLocationModel alloc] initWithCityName:@"" latitude:0 longitude:0 degreesFromNorth:0];
                        NSLog(@"NAme here: %@", locationModelObject.cityName);
                        [_searchResultArray addObject: locationModelObject];
                        
                            _addLocationsView.dataForTableView = _searchResultArray;
                            [_addLocationsView.tableViewContainingSearchResults performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                        

                    }
                }
                
            }] resume];
    
}

- (void) createWithLocationAndSaveToDataStore:(SMLocationModel *)location {
    
    NSString *cityName = location.cityName;
    
    if(_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    [_geocoder geocodeAddressString:cityName completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(placemarks.count > 0) {
            
            NSLog(@"Added");
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *locationAutocompleted = placemark.location;
            
            _latitude = locationAutocompleted.coordinate.latitude;
            _longitude = locationAutocompleted.coordinate.longitude;
            
            SMLocationModel *selectedLocation = [[SMLocationModel alloc] initWithCityName:cityName latitude:_latitude longitude:_longitude degreesFromNorth:0];
            
            if (_savedLocations == nil) {
                _savedLocations = [[NSMutableArray alloc]initWithObjects:selectedLocation, nil];
            } else {
                [_savedLocations addObject:selectedLocation];
            }
            
            
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:kKeyForUserDefaults]) {
                NSLog(@"Once");
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_savedLocations] forKey:kKeyForUserDefaults];
            } else {
                NSLog(@"First");
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_savedLocations] forKey:kKeyForUserDefaults];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_savedLocations] forKey:kKeyForUserDefaults];

                [[NSUserDefaults standardUserDefaults] synchronize];
                
        }

            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_savedLocations] forKey:kKeyForUserDefaults];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            

            // TODO: Animations for popping back to existingloactionsviewcontroller
            [self.navigationController popViewControllerAnimated:NO];
            
            
        }
    }];
    
}

- (void)cancelButtonPressedReturnToExisting {
    
    SMExistingLocationsView *existingLocationsView = [[SMExistingLocationsView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view insertSubview:existingLocationsView atIndex:0];
    
    [UIView animateWithDuration:.5 animations:^{
        _addLocationsView.xShape.image = [_addLocationsView.xShape.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_addLocationsView.xShape setTintColor:[UIColor colorWithRed:0.9725 green:0.9725 blue:0.9725 alpha:1.0]];
    }];
    
    POPSpringAnimation *scaleXShape = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleXShape.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    scaleXShape.springBounciness = 2;
    scaleXShape.springSpeed = 2.0f;
    [_addLocationsView.xShape pop_addAnimation:scaleXShape forKey:@"scaleXShape"];
    
    POPSpringAnimation *moveXAlongXAxis =
    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveXAlongXAxis.toValue = @(existingLocationsView.plusShape.frame.origin.x + _addLocationsView.xShape.frame.size.width/2);
    moveXAlongXAxis.springBounciness = 5;
    moveXAlongXAxis.springSpeed = 2.0f;
    [_addLocationsView.xShape.layer pop_addAnimation:moveXAlongXAxis forKey:@"position"];
    
    POPSpringAnimation *moveXAlongYAxis =
    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveXAlongYAxis.toValue = @(35);
    moveXAlongYAxis.springBounciness = 5;
    moveXAlongYAxis.springSpeed = 2.0f;
    [_addLocationsView.xShape.layer pop_addAnimation:moveXAlongYAxis forKey:@"positiony"];
    
    POPSpringAnimation *spin =
    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    spin.toValue = @(0);
    spin.springBounciness = 15;
    spin.springSpeed = 5.0f;
    [_addLocationsView.xShape.layer pop_addAnimation:spin forKey:@"spin"];
    
    UIView *whiteCircle = [[UIView alloc] initWithFrame:CGRectMake(-200, -200, self.view.frame.size.height * 1.8, self.view.frame.size.height * 1.8)];
    whiteCircle.backgroundColor = [UIColor slightlyLessWhiteThanWhite];
    whiteCircle.layer.cornerRadius = whiteCircle.frame.size.width/2;
    [_addLocationsView insertSubview:whiteCircle atIndex:[self.view subviews].count];
    whiteCircle.layer.cornerRadius = whiteCircle.frame.size.width/2;

    
    [UIView animateWithDuration:.5 animations:^{
        whiteCircle.layer.cornerRadius = whiteCircle.frame.size.width/2;

        whiteCircle.frame = CGRectMake(-100, -100, 20, 20);

        
    }completion:^(BOOL finished) {
        SMExistingLocationsViewController *weatherLocationsViewController = [[SMExistingLocationsViewController alloc] init];
        [[self navigationController] pushViewController:weatherLocationsViewController animated:NO];

    }];
    
    POPSpringAnimation *searchBarAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    searchBarAnimation.toValue = @(self.view.frame.origin.x - _addLocationsView.searchBar.frame.size.width / 2);
    searchBarAnimation.springBounciness = 2;
    searchBarAnimation.springSpeed = 2.0f;
    [_addLocationsView.searchBar.layer pop_addAnimation:searchBarAnimation forKey:@"positionx"];
    
    
    POPSpringAnimation *moveTableViewAlongXAxis =
    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveTableViewAlongXAxis.toValue = @(0 - _addLocationsView.tableViewContainingSearchResults.frame.size.width);
    moveTableViewAlongXAxis.springBounciness = 5;
    moveTableViewAlongXAxis.springSpeed = 2.0f;
    [_addLocationsView.tableViewContainingSearchResults.layer pop_addAnimation:moveTableViewAlongXAxis forKey:@"positionForTableView"];
    
    
    
    
}

@end

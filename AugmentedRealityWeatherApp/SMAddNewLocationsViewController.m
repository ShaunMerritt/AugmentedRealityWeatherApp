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
                    
                    NSArray *returnedResultArray = [NSArray arrayWithObject:[jsonArray objectForKey:@"predictions"]];
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
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *locationAutocompleted = placemark.location;
            
            _latitude = locationAutocompleted.coordinate.latitude;
            _longitude = locationAutocompleted.coordinate.longitude;
            
            SMLocationModel *selectedLocation = [[SMLocationModel alloc] initWithCityName:cityName latitude:_latitude longitude:_longitude degreesFromNorth:0];
            
            [_savedLocations addObject:selectedLocation];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_savedLocations] forKey:kKeyForUserDefaults];
            

            // TODO: Animations for popping back to existingloactionsviewcontroller
            [self.navigationController popViewControllerAnimated:NO];
            
            
        }
    }];
    
}

@end

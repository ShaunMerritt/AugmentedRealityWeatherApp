//
//  SMWeatherLocationsViewController.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 10/19/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMWeatherLocationsViewController.h"
#import "SMAddLocationsView.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "INTULocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "SMLocationModel.h"

static NSString *kKeyForUserDefaults = @"savedLocationsArray";

@interface SMWeatherLocationsViewController () <UITextFieldDelegate, SMAddLocationsDelegate> {
    SMAddLocationsView *_addLocationsView;
    NSMutableArray *_searchResultArray;
    NSMutableArray *_dataToDisplayOnTableViewArray;
    CLGeocoder *_geocoder;
    float _latitude;
    float _longitude;
    NSMutableArray *_savedLocations;
}

@end

@implementation SMWeatherLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    _addLocationsView = [[SMAddLocationsView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    _addLocationsView.dataForTableView = _dataToDisplayOnTableViewArray;
    
    [_addLocationsView.tableViewContainingCities performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    _addLocationsView.delegate = self;

    self.view = _addLocationsView;
    
    _addLocationsView.searchField.delegate = self;
    [_addLocationsView.searchField addTarget:self action:@selector(getCurrentTextFieldText:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)animateDataChangeForTableView {
    
    [UIView transitionWithView: _addLocationsView.tableViewContainingCities
                      duration: 0.35f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void) {
                                    [_addLocationsView.tableViewContainingCities performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                 } completion: ^(BOOL isFinished) {
                                     
                                 }];

    
}

- (void)getCurrentTextFieldText:(id)sender {
    
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
                        [_searchResultArray addObject: locationModelObject];
                        if (_searchResultArray.count == addressArray.count) {
                            _addLocationsView.dataForTableView = _searchResultArray;
                             [_addLocationsView.tableViewContainingCities performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                        }
                    }
                }
                
            }] resume];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_addLocationsView.searchField setText:@""];
}

- (void) createWithLocation:(SMLocationModel *)location {
    
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
            
            _addLocationsView.dataForTableView = _savedLocations;
            [_addLocationsView.tableViewContainingCities performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            _addLocationsView.searchField.text = @"Add City";
            [_addLocationsView.searchField resignFirstResponder];
            
        }
    }];
    
}


@end

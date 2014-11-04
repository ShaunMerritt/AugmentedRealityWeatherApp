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

@interface SMWeatherLocationsViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate> {
    SMAddLocationsView *_addLocationsView;
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    
    CLLocation *location;
    
    CLGeocoder *_geocoder;

}

@end

@implementation SMWeatherLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _addLocationsView = [[SMAddLocationsView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    self.view = _addLocationsView;
    
    _addLocationsView.searchField.delegate = self;
    _addLocationsView.tableViewContainingCities.delegate = self;
    _addLocationsView.tableViewContainingCities.dataSource = self;
    
    [_addLocationsView.searchField addTarget:self action:@selector(getCurrentTextFieldText:) forControlEvents:UIControlEventEditingChanged];
    
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (void)getCurrentTextFieldText:(id)sender {
    
    NSLog(@"typed");
    
    NSString *string = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(cities)&language=EN&key=AIzaSyBD_lHt-93q3G8kHWmq_eQKqLjLcwhM0wE", ((UITextField *)sender).text];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:string]
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
                    
                    
                    NSArray *addressArray = [[returnedResultArray valueForKey:@"description"] firstObject];
                    NSString * addressString = [NSString stringWithFormat:@"%@", [addressArray objectAtIndex:0]];
                    
                    if(_geocoder == nil)
                    {
                        _geocoder = [[CLGeocoder alloc] init];
                    }
                    
                    [_geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
                        
                        if(placemarks.count > 0)
                        {
                            CLPlacemark *placemark = [placemarks objectAtIndex:0];
                            
                            CLLocation *locationAutocompleted = placemark.location;
                            NSLog(@"Lat: %f", locationAutocompleted.coordinate.latitude);
                            NSLog(@"Lat: %f", locationAutocompleted.coordinate.longitude);

                            
                            NSLog(@"Placemark: %@", placemark.location.description);
                        }
                    }];
                    
                    
                }
                
            }] resume];
    
    
    
//    INTULocationManager *locationManager = [INTULocationManager sharedInstance];
//    [locationManager requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
//                                                timeout:10.0
//                                   delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
//                                                  block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
//                                                      if (status == INTULocationStatusSuccess) {
//                                                          
//                                                          location = currentLocation;
//                                                          
//                                                          
//                                                          
//                                                          // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
//                                                          // currentLocation contains the device's current location.
//                                                          
//                                                      }
//                                                      else if (status == INTULocationStatusTimedOut) {
//                                                          // Wasn't able to locate the user with the requested accuracy within the timeout interval.
//                                                          // However, currentLocation contains the best location available (if any) as of right now,
//                                                          // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
//                                                      }
//                                                      else {
//                                                          // An error occurred, more info is available by looking at the specific status returned.
//                                                      }
//                                                  }];
//
//    
//    
//    
//    searchQuery.location = location.coordinate;
//    searchQuery.input = ((UITextField *)sender).text;
//    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
//        NSLog(@"Places returned %@", places);
//    }];
//    NSLog(@"WHYYYY");
    
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [searchResultPlaces count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithRed:0.1765 green:0.1765 blue:0.1765 alpha:.6];
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_addLocationsView.searchField setText:@"NANANA"];
    
    
}






@end

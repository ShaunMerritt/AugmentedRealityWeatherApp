//
//  SMExistingLocationsView.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/15/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMExistingLocationsDelegate <NSObject>

- (void)addCityButtonPressed;
- (void)doneButtonClicked;
- (void)removeCellAtIndex:(NSInteger)row;

@end

@interface SMExistingLocationsView : UIView

@property (nonatomic, strong) NSMutableArray *dataForTableView;
@property (nonatomic, retain) UITableView *tableViewContainingSavedCities;
@property (nonatomic, strong) UIImageView *plusShape;
@property (nonatomic, strong) id<SMExistingLocationsDelegate> delegate;

@end

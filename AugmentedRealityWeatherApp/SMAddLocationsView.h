//
//  SMAddLocationsView.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 10/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLocationModel.h"

@class SMAddLocationsView;

@protocol SMAddLocationsDelegate <NSObject>
- (void)createWithLocation: (SMLocationModel *)location;
@end

@interface SMAddLocationsView : UIView

@property (nonatomic, retain) UITextField *searchField;
@property (nonatomic, retain) UITableView *tableViewContainingCities;
@property (nonatomic, strong) NSMutableArray *dataForTableView;
@property (nonatomic, weak) id<SMAddLocationsDelegate>delegate;



@end

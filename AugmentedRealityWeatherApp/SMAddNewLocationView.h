//
//  SMAddNewLocationView.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/16/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLocationModel.h"

@class SMAddNewLocationView;


@protocol SMAddNewLocationsDelegate <NSObject>
- (void)createWithLocationAndSaveToDataStore: (SMLocationModel *)location;
- (void)cancelButtonPressedReturnToExisting;
@end


@interface SMAddNewLocationView : UIView

@property (nonatomic, strong) UITableView *tableViewContainingSearchResults;

@property (nonatomic, strong) NSArray *dataForTableView;
@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UIImageView *xShape;

@property (nonatomic, weak) id<SMAddNewLocationsDelegate>delegate;



@end

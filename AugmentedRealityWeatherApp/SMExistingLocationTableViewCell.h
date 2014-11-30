//
//  SMExistingLocationTableViewCell.h
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/16/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMExistingLocationTableViewCell;

@protocol SMExistingLocationsCellDelegate <NSObject>
- (void)deleteButtonPressedInCell: (SMExistingLocationTableViewCell *)cell;
@end
@interface SMExistingLocationTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *cityNameLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *backgroundViews;
@property (nonatomic, strong) UIButton *xButton;

@property (nonatomic, weak) id<SMExistingLocationsCellDelegate>delegate;


@end

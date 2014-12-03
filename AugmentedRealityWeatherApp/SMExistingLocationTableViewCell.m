//
//  SMExistingLocationTableViewCell.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/16/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMExistingLocationTableViewCell.h"
#import "UIColor+SMAugmentedRealityAppColors.h"

@implementation SMExistingLocationTableViewCell

@synthesize cityNameLabel = _cityNameLabel;
@synthesize deleteButton = _deleteButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
        self.cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 300, 30)];
        self.cityNameLabel.textColor = [UIColor darkGrayColorForBackgroundsAndText];
        self.cityNameLabel.font = [UIFont fontWithName:@"Arial" size:20.0f];
        self.cityNameLabel.text = @"Test";
        [self.contentView addSubview:self.cityNameLabel];

        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, self.cityNameLabel.frame.origin.y, 30, 30)];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"Rectangle 5"] forState:UIControlStateNormal];
        self.deleteButton.imageView.contentMode = UIViewContentModeCenter;
        
        for (UIView *view in self.deleteButton.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view setContentMode:UIViewContentModeCenter];
            }
        }
        
        [self.deleteButton addTarget:self
                         action:@selector(deleteButtonPressed:)
               forControlEvents:UIControlEventTouchDown];
        
        [self.contentView addSubview:self.deleteButton];
        
        _xButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width, self.backgroundViews.bounds.origin.y + 20, 24, 24)];
        
        [_xButton setBackgroundImage:[UIImage imageNamed:@"XShape"] forState:UIControlStateNormal];
        
        for (UIView *view in _xButton.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view setContentMode:UIViewContentModeCenter];
            }
        }

        
        _backgroundViews = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, self.bounds.origin.y, 100, 100)];
        _backgroundViews.backgroundColor = [UIColor darkGrayColorForBackgroundsAndText];
        _backgroundViews.layer.cornerRadius = _backgroundViews.frame.size.width / 2;
        
        self.contentView.backgroundColor = [UIColor lightGrayColorForCellBackgrounds];
    }
    return self;
}

-(void)deleteButtonPressed:(UIButton*)button
{
    NSLog(@"indexPath.row value : %d", button.tag);
    [_delegate deleteButtonPressedInCell:self];
}

@end

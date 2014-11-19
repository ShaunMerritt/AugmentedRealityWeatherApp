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
        
        
        self.contentView.backgroundColor = [UIColor lightGrayColorForCellBackgrounds];
    }
    return self;
}

-(IBAction)deleteButtonPressed:(UIButton*)button
{
    NSLog(@"indexPath.row value : %d", button.tag);
    [_delegate deleteButtonPressedInCell:self];
}

@end

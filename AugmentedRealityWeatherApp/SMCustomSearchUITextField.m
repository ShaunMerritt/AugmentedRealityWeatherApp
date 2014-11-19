//
//  SMCustomSearchUITextField.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/16/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMCustomSearchUITextField.h"

@implementation SMCustomSearchUITextField

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor: [UIColor colorWithRed:0.8941 green:0.8941 blue:0.8941 alpha:1.0]];
        
        self.layer.cornerRadius = 5;
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchIcon"]];
        searchIcon.contentMode = UIViewContentModeCenter;
        searchIcon.frame = CGRectInset(searchIcon.frame, -10, 0);
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = searchIcon;
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    
    UIColor *color = [UIColor colorWithRed:0.4588 green:0.4588 blue:0.4588 alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"Avenir" size:30];

    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSForegroundColorAttributeName: color};

    [[self placeholder] drawInRect:rect withAttributes:attributes];
    
}

@end

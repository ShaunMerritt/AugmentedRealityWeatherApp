//
//  SMPlusShapeView.m
//  Elu+Code
//
//  Created by Shaun Merritt on 10/29/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMPlusShapeView.h"

@implementation SMPlusShapeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alpha = 1;
        [self createViews];
        
    }
    return self;
}

- (void) createViews {
    
    UIView *horizontalBlock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 5)];
    horizontalBlock.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9529 alpha:1.0];
    horizontalBlock.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);

    [self addSubview:horizontalBlock];
    
    
    
    UIView *verticalBlock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 5, self.frame.size.height)];
    verticalBlock.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);

    verticalBlock.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9529 alpha:1.0];
    [self addSubview:verticalBlock];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

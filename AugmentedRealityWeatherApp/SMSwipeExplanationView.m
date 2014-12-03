//
//  SMSwipeExplanationView.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/26/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMSwipeExplanationView.h"

@implementation SMSwipeExplanationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:1.0];
        [self createViews];
    }
    return self;
}

- (void) createViews {
    
    UIImageView *cardsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cards For Swiping + Double Tap + Swipe To Move"]];
    cardsView.frame = CGRectMake((self.frame.size.width - cardsView.frame.size.width) / 2, 100, cardsView.frame.size.width, cardsView.frame.size.height);
    [self addSubview:cardsView];
    
    UIImageView *swipeToContinue = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Swipe To Continue + Swipe Arrows"]];
    swipeToContinue.bounds = CGRectMake(0,self.frame.size.height - 80, swipeToContinue.frame.size.width, swipeToContinue.frame.size.height);
    swipeToContinue.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 60);
    [self addSubview:swipeToContinue];
                                    
}

@end

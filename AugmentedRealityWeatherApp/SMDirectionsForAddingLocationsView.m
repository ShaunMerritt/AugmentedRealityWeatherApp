//
//  SMDirectionsForAddingLocationsView.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/23/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMDirectionsForAddingLocationsView.h"

@implementation SMDirectionsForAddingLocationsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *direcetionsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow And Directional Text"]];
        direcetionsImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        direcetionsImageView.frame = CGRectMake(self.bounds.origin.x, 0, direcetionsImageView.frame.size.width, direcetionsImageView.frame.size.height);
        [self addSubview:direcetionsImageView];
        
    }
    return self;
}

@end

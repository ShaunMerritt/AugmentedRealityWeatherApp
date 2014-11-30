//
//  SMAskForPermissionsView.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/23/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMAskForPermissionsView.h"
#import "UIButton+SMBackgroundColorForButton.h"
#import <POP.h>

static const CGFloat kSpringSpeedValueForAnimation = 2.0;
static const CGFloat kSpringBouncinessValueForAnimation = 2.0;

@interface SMAskForPermissionsView () {
    UIImageView *_explanationImageView;
    UIButton *_sayYesButton;
}

@end

@implementation SMAskForPermissionsView

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
    
    // Stars
    _explanationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"We Need Some Info + Location Icon And Description"]];
    _explanationImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _explanationImageView.alpha = 1;
    [self addSubview:_explanationImageView];
  
    // Say yes button
    _sayYesButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100, self.frame.size.height - 80, 200, 50)];
    _sayYesButton.alpha = 1;
    _sayYesButton.layer.borderColor = [UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0].CGColor;
    _sayYesButton.layer.borderWidth = 2.0;
    _sayYesButton.titleLabel.text = @"Say Yes!";
    [_sayYesButton setTitle:@"Say Yes!" forState:UIControlStateNormal];
    _sayYesButton.titleLabel.textColor = [UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0];
    [_sayYesButton setTitleColor:[UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0] forState:UIControlStateNormal];
    [_sayYesButton setTitleColor:[UIColor whiteColor] forState:UIControlEventTouchDown | UIControlEventTouchDown];
    [_sayYesButton setBackgroundImage:[UIButton imageFromColor:[UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0]] forState:UIControlEventTouchDown | UIControlEventTouchDown];
    _sayYesButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:22.0];
    _sayYesButton.layer.cornerRadius = 5;
    _sayYesButton.clipsToBounds = YES;
    [_sayYesButton addTarget:self action:@selector(sayYesButtonLiftedUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sayYesButton];
    
}

- (void)sayYesButtonLiftedUp:(UIButton*)button
{
    [self.delegate sayYesButtonPressed];
}

- (void) animateViews {
    
    [UIView animateWithDuration:.4 animations:^{
        _explanationImageView.alpha = 1.0;
        _sayYesButton.alpha = 1.0;
    }];
    
    POPSpringAnimation *moveToBottomOfScreen = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveToBottomOfScreen.toValue = @(self.frame.size.height/2);
    moveToBottomOfScreen.springSpeed = kSpringSpeedValueForAnimation;
    moveToBottomOfScreen.springBounciness = kSpringBouncinessValueForAnimation;
    [_explanationImageView.layer pop_addAnimation:moveToBottomOfScreen forKey:@"moveStartsToTopOfScreen"];
    
    POPSpringAnimation *moveToBottomOfScreenButton = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveToBottomOfScreenButton.toValue = @(self.frame.size.height - 60);
    moveToBottomOfScreenButton.springSpeed = kSpringSpeedValueForAnimation;
    moveToBottomOfScreenButton.springBounciness = kSpringBouncinessValueForAnimation;
    [_sayYesButton.layer pop_addAnimation:moveToBottomOfScreenButton forKey:@"moveButtonToBottomOfScreen"];
}

@end

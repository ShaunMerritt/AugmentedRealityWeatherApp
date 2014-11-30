//
//  SMWelcomeView.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMWelcomeView.h"
#import <POP.h>
#import "SMStyleKit.h"
#import "UIButton+SMBackgroundColorForButton.h"

static const CGFloat kSpringSpeedValueForAnimation = 2.0;
static const CGFloat kSpringBouncinessValueForAnimation = 2.0;

@interface SMWelcomeView () {
    UIImageView *_starsImage;
    UIImageView *_specialStarImage;
    UIImageView *_firstCardToDisplay;
    CAShapeLayer *_bezier;
    UIButton *_startButton;
}

@end

@implementation SMWelcomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void) createViews {
    
    // Background Image
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background For FirstPage Walkthrough"]];
    backgroundImage.frame = self.frame;
    [self addSubview:backgroundImage];
    
    // Stars
    _starsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Stars"]];
    _starsImage.center = CGPointMake(self.frame.size.width/2, self.frame.size.height + _starsImage.frame.size.height);
    _starsImage.alpha = 0;
    [self addSubview:_starsImage];
    
    // Special Star
    _specialStarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Special Star"]];
    _specialStarImage.center = _starsImage.center;
    _specialStarImage.alpha = 0.0;
    [self addSubview:_specialStarImage];
    
    // First Card
    _firstCardToDisplay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"First Card To Display"]];
    _firstCardToDisplay.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height + (_firstCardToDisplay.frame.size.height / 2));
    _firstCardToDisplay.userInteractionEnabled = YES;
    [self addSubview:_firstCardToDisplay];
    
    _startButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100, self.frame.size.height - 80, 200, 50)];
    _startButton.alpha = 1;
    _startButton.layer.borderColor = [UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0].CGColor;
    _startButton.layer.borderWidth = 2.0;
    _startButton.titleLabel.text = @"Begin";
    [_startButton setTitle:@"Begin" forState:UIControlStateNormal];
    _startButton.titleLabel.textColor = [UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0];
    [_startButton setTitleColor:[UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0] forState:UIControlStateNormal];
    [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlEventTouchDown | UIControlEventTouchDown];
    [_startButton setBackgroundImage:[UIButton imageFromColor:[UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0]] forState:UIControlEventTouchDown | UIControlEventTouchDown];
    _startButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:22.0];
    _startButton.layer.cornerRadius = 5;
    _startButton.clipsToBounds = YES;
    [_startButton addTarget:self action:@selector(continueButtonLiftedUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_startButton];
    
    // Animate Views
    [self animateViews];
}

- (void) animateViews {
    
    [UIView animateWithDuration:.4 animations:^{
        _specialStarImage.alpha = 1.0;
        _starsImage.alpha = 1.0;
    }];

    POPSpringAnimation *moveToTopOfScreen = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveToTopOfScreen.toValue = @(60);
    moveToTopOfScreen.springSpeed = kSpringSpeedValueForAnimation;
    moveToTopOfScreen.springBounciness = kSpringBouncinessValueForAnimation;
    [_starsImage.layer pop_addAnimation:moveToTopOfScreen forKey:@"moveStartsToTopOfScreen"];
    [_specialStarImage.layer pop_addAnimation:moveToTopOfScreen forKey:@"moveSpecialStarToTopOfScreen"];
    
    POPSpringAnimation *moveSpecialStarToRightSide = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveSpecialStarToRightSide.toValue = @(self.frame.size.width - 50);
    moveSpecialStarToRightSide.springBounciness = kSpringSpeedValueForAnimation;
    moveSpecialStarToRightSide.springSpeed = kSpringBouncinessValueForAnimation;
    [_specialStarImage pop_addAnimation:moveSpecialStarToRightSide forKey:@"moveSpecialStarToTheRight"];
    
    POPSpringAnimation *moveCardUp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveCardUp.toValue = @(self.frame.size.height - _firstCardToDisplay.frame.size.height /2);
    moveCardUp.springSpeed = kSpringSpeedValueForAnimation;
    moveCardUp.springBounciness = kSpringBouncinessValueForAnimation;
    [_firstCardToDisplay pop_addAnimation:moveCardUp forKey:@"moveFirstCardAlongY"];
}

- (void)continueButtonLiftedUp: (UIButton *)button{
    
    [UIView animateWithDuration:.4 animations:^{
        _specialStarImage.transform = CGAffineTransformMakeRotation(M_PI_2);
    }];
    
    POPSpringAnimation *scaleTheLocationIconOffScreen = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleTheLocationIconOffScreen.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    scaleTheLocationIconOffScreen.springBounciness = kSpringBouncinessValueForAnimation; // Between 0-20
    scaleTheLocationIconOffScreen.springSpeed = kSpringSpeedValueForAnimation; // Between 0-20
    scaleTheLocationIconOffScreen.dynamicsMass = 10;
    [_specialStarImage pop_addAnimation:scaleTheLocationIconOffScreen forKey:@"scaleTheLocationIconOffScreen"];
    
    POPSpringAnimation *moveCardDown = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveCardDown.toValue = @(self.frame.size.height + _firstCardToDisplay.frame.size.height /2);
    moveCardDown.springSpeed = kSpringSpeedValueForAnimation;
    moveCardDown.springBounciness = kSpringBouncinessValueForAnimation;
    [_firstCardToDisplay pop_addAnimation:moveCardDown forKey:@"moveFirstCardAlongYDown"];
    [_startButton pop_addAnimation:moveCardDown forKey:@"move"];
    
    moveCardDown.completionBlock = ^(POPAnimation *move, BOOL finished) {
        [self.delegate beginButtonPressed];
    };

}


@end

//
//  SMDirectionsForPointingPhoneView.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMDirectionsForPointingPhoneView.h"
#import "SMStyleKit.h"
#import "UIButton+SMBackgroundColorForButton.h"
#import <POP.h>

static const CGFloat kSpringSpeedValueForAnimation = 2.0;
static const CGFloat kSpringBouncinessValueForAnimation = 2.0;

@interface SMDirectionsForPointingPhoneView () {
    CAShapeLayer *_bezier;
    UIImageView *_explanationLabel;
    UIImageView *_arrows;
    UIButton *_continueButton;
    UIView *_viewContainingiPhone;
}

@end

@implementation SMDirectionsForPointingPhoneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:1.0];
        [self drawiPhone];
        [self createViews];
        
    }
    return self;
}

- (void) createViews {
    
    // Stars
    _explanationLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Find Phone "]];
    _explanationLabel.center = CGPointMake(self.frame.size.width/2, -100);
    _explanationLabel.alpha = 0;
    [self addSubview:_explanationLabel];
    
    // Special Star
    _arrows = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pointing Arrows"]];
    _arrows.center = _explanationLabel.center;
    _arrows.alpha = 0.0;
    [self addSubview:_arrows];
    
    // Continue Button
    _continueButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    _continueButton.center = _explanationLabel.center;
    _continueButton.alpha = 0;
    _continueButton.layer.borderColor = [UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0].CGColor;
    _continueButton.layer.borderWidth = 2.0;
    _continueButton.titleLabel.text = @"Continue";
    [_continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    _continueButton.titleLabel.textColor = [UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0];
    [_continueButton setTitleColor:[UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0] forState:UIControlStateNormal];
    [_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlEventTouchDown | UIControlEventTouchDown];
    [_continueButton setBackgroundImage:[UIButton imageFromColor:[UIColor colorWithRed:0.4980 green:0.7373 blue:0.9020 alpha:1.0]] forState:UIControlEventTouchDown | UIControlEventTouchDown];
    _continueButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:22.0];
    _continueButton.layer.cornerRadius = 5;
    _continueButton.clipsToBounds = YES;
    [_continueButton addTarget:self action:@selector(continueButtonLiftedUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_continueButton];
    [self animateViews];
    
}

- (void)continueButtonLiftedUp:(UIButton*)button
{
    [self.delegate continueButtonPressed];
}

- (void) animateViews {
    
    [UIView animateWithDuration:.4 animations:^{
        _explanationLabel.alpha = 1.0;
        _arrows.alpha = 1.0;
        _continueButton.alpha = 1.0;
    }];
    
    POPSpringAnimation *moveToBottomOfScreen = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveToBottomOfScreen.toValue = @(_viewContainingiPhone.frame.size.height + _viewContainingiPhone.bounds.origin.y );
    moveToBottomOfScreen.springSpeed = kSpringSpeedValueForAnimation;
    moveToBottomOfScreen.springBounciness = kSpringBouncinessValueForAnimation;
    [_explanationLabel.layer pop_addAnimation:moveToBottomOfScreen forKey:@"moveStartsToTopOfScreen"];
    
    POPSpringAnimation *moveToBottomOfScreenButton = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveToBottomOfScreenButton.toValue = @(self.frame.size.height - 60);
    moveToBottomOfScreenButton.springSpeed = kSpringSpeedValueForAnimation;
    moveToBottomOfScreenButton.springBounciness = kSpringBouncinessValueForAnimation;
    [_continueButton.layer pop_addAnimation:moveToBottomOfScreenButton forKey:@"moveButtonToBottomOfScreen"];
    
    POPSpringAnimation *moveArrows = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveArrows.toValue = @(_viewContainingiPhone.bounds.origin.y + 60);
    moveArrows.springBounciness = kSpringBouncinessValueForAnimation;
    moveArrows.springSpeed = kSpringSpeedValueForAnimation;
    [_arrows pop_addAnimation:moveArrows forKey:@"moveSpecialStarToTheRight"];
}


- (void) drawiPhone {
    
    NSArray *bezierPaths = [SMStyleKit drawiPhone];
    _viewContainingiPhone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 440)];
    _viewContainingiPhone.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 30);
    _viewContainingiPhone.backgroundColor = [UIColor clearColor];
    [self addSubview:_viewContainingiPhone];
    for (UIBezierPath *bezierPath in bezierPaths) {
        
        bezierPath.lineCapStyle = kCGLineCapRound;
        _bezier = [[CAShapeLayer alloc] init];
        _bezier.path          = bezierPath.CGPath;
        _bezier.strokeColor   = [UIColor colorWithRed: 0.257 green: 0.257 blue: 0.257 alpha: 1].CGColor;
        _bezier.fillColor     = [UIColor clearColor].CGColor;
        _bezier.lineWidth     = 5.4;
        _bezier.strokeStart   = 0.0;
        _bezier.strokeEnd     = 1.0;
        [_viewContainingiPhone.layer addSublayer:_bezier];
        
        CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animateStrokeEnd.duration  = 3;
        animateStrokeEnd.delegate = self;
        animateStrokeEnd.fromValue = [NSNumber numberWithFloat:0.0f];
        animateStrokeEnd.toValue   = [NSNumber numberWithFloat:1.0f];
        [animateStrokeEnd setValue:_bezier forKey:@"layer"];
        [_bezier addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
    }
}

@end

//
//  SMWeatherInfoView.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 9/25/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMWeatherInfoCardView.h"
#import "SMWeatherInfo.h"
#import <POP.h>

@interface SMWeatherInfoCardView() {
    UILabel *_currentTemperatureLabel;
    UILabel *_currentLocationLabel;
    UILabel *_maxTemperatureForDayLabel;
    UILabel *_minTemperatureForDayLabel;
    NSString *_nameOfCurrentCity;
    NSString *_currentTemperature;
    NSString *_currentCityLowTemperature;
    NSString *_currentCityHighTemperature;
}

@end

@implementation SMWeatherInfoCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 18;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 5;
        
        
        
    }
    return self;
    
}

- (void) createLabelsWithWeatherObject:(SMWeatherInfo *)weatherInfo {
    
    _nameOfCurrentCity = weatherInfo.cityName;
    _currentTemperature = weatherInfo.temperature;
    _currentCityLowTemperature = weatherInfo.minTemperature;
    _currentCityHighTemperature = weatherInfo.maxTemperature;
    
    NSLog(@"YES: %@", _nameOfCurrentCity);
    
    [self setFrameForWeatherInfoLabels];
    [self aniamteWeatherInfoLabels];
    
}


- (void)setFrameForWeatherInfoLabels {
    
    // TODO: As of now, I just hard coded the labels text, but it will be from the actual weather query in the future

    // Current Temperature Label
    _currentTemperatureLabel = [[UILabel alloc] init];
    _currentTemperatureLabel.text = [NSString stringWithFormat:@"%d", [_currentTemperature intValue]];
    _currentTemperatureLabel.font = [UIFont fontWithName:@"Avenir Next Ultra Light" size:(120.0)];
    
    _currentTemperatureLabel.backgroundColor = [UIColor clearColor];
    _currentTemperatureLabel.textColor = [UIColor whiteColor];
    
    _currentTemperatureLabel.textAlignment = NSTextAlignmentCenter;
    [_currentTemperatureLabel sizeToFit];
    
    [self addSubview:_currentTemperatureLabel];
    _currentTemperatureLabel.center = CGPointMake(self.center.x, self.frame.origin.y - 100);
    
    // Current Location Label
    _currentLocationLabel = [[UILabel alloc] init];
    _currentLocationLabel.text = _nameOfCurrentCity;
    _currentLocationLabel.font = [UIFont fontWithName:@"Avenir Next Ultra Light" size:(20)];
    
    _currentLocationLabel.backgroundColor = [UIColor clearColor];
    _currentLocationLabel.textColor = [UIColor whiteColor];
    
    _currentLocationLabel.textAlignment = NSTextAlignmentCenter;
    [_currentLocationLabel sizeToFit];
    
    [self addSubview:_currentLocationLabel];
    _currentLocationLabel.center = CGPointMake(self.center.x, self.frame.origin.y - 100);
    
    // Current Max Temperature Label
    _maxTemperatureForDayLabel = [[UILabel alloc] init];
    _maxTemperatureForDayLabel.text = [NSString stringWithFormat:@"˦  %@°", _currentCityHighTemperature];
    _maxTemperatureForDayLabel.font = [UIFont fontWithName:@"Avenir Next Ultra Light" size:(23)];
    
    _maxTemperatureForDayLabel.backgroundColor = [UIColor clearColor];
    _maxTemperatureForDayLabel.textColor = [UIColor whiteColor];
    
    _maxTemperatureForDayLabel.textAlignment = NSTextAlignmentCenter;
    [_maxTemperatureForDayLabel sizeToFit];
    
    [self addSubview:_maxTemperatureForDayLabel];
    _maxTemperatureForDayLabel.center = CGPointMake(self.center.x, self.frame.origin.y - 100);
    
    // Current Min Temperature Label
    _minTemperatureForDayLabel = [[UILabel alloc] init];
    _minTemperatureForDayLabel.text = [NSString stringWithFormat:@"˨  %@°", _currentCityLowTemperature];
    _minTemperatureForDayLabel.font = [UIFont fontWithName:@"Avenir Next Ultra Light" size:(23)];
    
    _minTemperatureForDayLabel.backgroundColor = [UIColor clearColor];
    _minTemperatureForDayLabel.textColor = [UIColor whiteColor];
    
    _minTemperatureForDayLabel.textAlignment = NSTextAlignmentCenter;
    [_minTemperatureForDayLabel sizeToFit];
    
    [self addSubview:_minTemperatureForDayLabel];
    _minTemperatureForDayLabel.center = CGPointMake(self.center.x, self.frame.origin.y - 100);
    
    
    
    
}

- (void)aniamteWeatherInfoLabels {
    
    // Animations for current temperature label
    POPSpringAnimation *moveTemperatureLabelAlongY = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveTemperatureLabelAlongY.fromValue = @(_currentTemperatureLabel.frame.origin.y);
    moveTemperatureLabelAlongY.toValue = @(self.frame.origin.y + 180);
    moveTemperatureLabelAlongY.springBounciness = 2;
    moveTemperatureLabelAlongY.springSpeed = 5.0f;
    [_currentTemperatureLabel.layer pop_addAnimation:moveTemperatureLabelAlongY forKey:@"moveTemperatureLabelAlongY"];
    
    POPSpringAnimation *moveTemperatureLabelAlongX = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveTemperatureLabelAlongX.fromValue = @(_currentTemperatureLabel.frame.origin.x);
    moveTemperatureLabelAlongX.toValue = @(self.center.x);
    moveTemperatureLabelAlongX.springBounciness = 2;
    moveTemperatureLabelAlongX.springSpeed = 5.0f;
    [_currentTemperatureLabel.layer pop_addAnimation:moveTemperatureLabelAlongX forKey:@"moveTemperatureLabelAlongX"];

    POPSpringAnimation *scaleTemperatureLabel = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleTemperatureLabel.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.5, 1.5)];
    scaleTemperatureLabel.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    scaleTemperatureLabel.springBounciness = 2;
    scaleTemperatureLabel.springSpeed = 5.0f;
    [_currentTemperatureLabel pop_addAnimation:scaleTemperatureLabel forKey:@"scaleTemperatureLabel"];

    // Animations for current location label
    POPSpringAnimation *moveLocationLabelAlongY = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveLocationLabelAlongY.fromValue = @(_currentLocationLabel.frame.origin.y);
    moveLocationLabelAlongY.toValue = @(self.bounds.origin.y + 30);
    moveLocationLabelAlongY.springBounciness = 2;
    moveLocationLabelAlongY.springSpeed = 5.0f;
    [_currentLocationLabel.layer pop_addAnimation:moveLocationLabelAlongY forKey:@"moveLocationLabelAlongY"];
    
    POPSpringAnimation *moveLocationLabelAlongX = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveLocationLabelAlongX.fromValue = @(_currentLocationLabel.frame.origin.x);
    moveLocationLabelAlongX.toValue = @(self.center.x);
    moveLocationLabelAlongX.springBounciness = 2;
    moveLocationLabelAlongX.springSpeed = 5.0f;
    [_currentLocationLabel.layer pop_addAnimation:moveLocationLabelAlongX forKey:@"moveLocationLabelAlongX"];
    
    POPSpringAnimation *scaleLocationLabel = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleLocationLabel.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.5, 1.5)];
    scaleLocationLabel.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    scaleLocationLabel.springBounciness = 2;
    scaleLocationLabel.springSpeed = 5.0f;
    [_currentLocationLabel pop_addAnimation:scaleLocationLabel forKey:@"scaleLocationLabel"];
    
    // Animations for min temperature label
    POPSpringAnimation *moveMinTemperatureLabelAlongY = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveMinTemperatureLabelAlongY.fromValue = @(_minTemperatureForDayLabel.frame.origin.y);
    moveMinTemperatureLabelAlongY.toValue = @(self.bounds.size.height / 2 - 5);
    moveMinTemperatureLabelAlongY.springBounciness = 2;
    moveMinTemperatureLabelAlongY.springSpeed = 5.0f;
    [_minTemperatureForDayLabel.layer pop_addAnimation:moveMinTemperatureLabelAlongY forKey:@"moveMinTemperatureLabelAlongY"];
    
    POPSpringAnimation *moveMinTemperatureLabelAlongX = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveMinTemperatureLabelAlongX.fromValue = @(_currentTemperatureLabel.frame.origin.x);
    moveMinTemperatureLabelAlongX.toValue = @(self.center.x - 50);
    moveMinTemperatureLabelAlongX.springBounciness = 2;
    moveMinTemperatureLabelAlongX.springSpeed = 5.0f;
    [_minTemperatureForDayLabel.layer pop_addAnimation:moveMinTemperatureLabelAlongX forKey:@"moveMinTemperatureLabelAlongX"];
    
    POPSpringAnimation *scaleMinTemperatureLabel = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleMinTemperatureLabel.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.5, 1.5)];
    scaleMinTemperatureLabel.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    scaleMinTemperatureLabel.springBounciness = 2;
    scaleMinTemperatureLabel.springSpeed = 5.0f;
    [_minTemperatureForDayLabel pop_addAnimation:scaleMinTemperatureLabel forKey:@"scaleMinTemperatureLabel"];
    
    // Animations for max temperature label
    POPSpringAnimation *moveMaxTemperatureLabelAlongY = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveMaxTemperatureLabelAlongY.fromValue = @(_minTemperatureForDayLabel.frame.origin.y);
    moveMaxTemperatureLabelAlongY.toValue = @(self.bounds.size.height / 2 - 5);
    moveMaxTemperatureLabelAlongY.springBounciness = 2;
    moveMaxTemperatureLabelAlongY.springSpeed = 5.0f;
    [_maxTemperatureForDayLabel.layer pop_addAnimation:moveMaxTemperatureLabelAlongY forKey:@"moveMaxTemperatureLabelAlongY"];
    
    POPSpringAnimation *moveMaxTemperatureLabelAlongX = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveMaxTemperatureLabelAlongX.fromValue = @(_currentTemperatureLabel.frame.origin.x);
    moveMaxTemperatureLabelAlongX.toValue = @(self.center.x + 40);
    moveMaxTemperatureLabelAlongX.springBounciness = 2;
    moveMaxTemperatureLabelAlongX.springSpeed = 5.0f;
    [_maxTemperatureForDayLabel.layer pop_addAnimation:moveMaxTemperatureLabelAlongX forKey:@"moveMaxTemperatureLabelAlongX"];
    
    POPSpringAnimation *scaleMaxTemperatureLabel = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleMaxTemperatureLabel.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.5, 1.5)];
    scaleMaxTemperatureLabel.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    scaleMaxTemperatureLabel.springBounciness = 2;
    scaleMaxTemperatureLabel.springSpeed = 5.0f;
    [_maxTemperatureForDayLabel pop_addAnimation:scaleMaxTemperatureLabel forKey:@"scaleMaxTemperatureLabel"];

}

@end

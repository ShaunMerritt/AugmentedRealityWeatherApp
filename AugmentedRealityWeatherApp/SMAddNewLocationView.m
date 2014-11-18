//
//  SMAddNewLocationView.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/16/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMAddNewLocationView.h"
#import <POP.h>
#import "UIColor+SMAugmentedRealityAppColors.h"
#import "SMLocationModel.h"

@interface SMAddNewLocationView () <UITableViewDelegate, UITableViewDataSource> {
    UIImageView *_xShape;
}
@end

@implementation SMAddNewLocationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _dataForTableView = [[NSArray alloc] init];
        [self createViewLayout];
        
    }
    return self;
}

- (void) createViewLayout {
    
    _xShape = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 40, 40)];
    _xShape.image = [UIImage imageNamed:@"Rectangle 2 + Rectangle 3"];
    _xShape.userInteractionEnabled = YES;
    UITapGestureRecognizer *plusButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(cancelButtonPressed:)];
    [_xShape addGestureRecognizer:plusButtonTap];
    [self addSubview:_xShape];
    
    [UIView animateWithDuration:.5 animations:^{
        _xShape.image = [_xShape.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_xShape setTintColor:[UIColor colorWithRed:0.3255 green:0.3255 blue:0.3255 alpha:1.0]];
    }];
    
    POPSpringAnimation *scaleXShape = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleXShape.toValue = [NSValue valueWithCGPoint:CGPointMake(.8, .8)];
    scaleXShape.springBounciness = 2;
    scaleXShape.springSpeed = 2.0f;
    [_xShape pop_addAnimation:scaleXShape forKey:@"scaleXShape"];
    
    POPSpringAnimation *moveXAlongXAxis =
    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveXAlongXAxis.toValue = @(self.frame.size.width - 35);
    moveXAlongXAxis.springBounciness = 5;
    moveXAlongXAxis.springSpeed = 2.0f;
    [_xShape.layer pop_addAnimation:moveXAlongXAxis forKey:@"position"];
    
    POPSpringAnimation *moveXAlongYAxis =
    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveXAlongYAxis.toValue = @(40);
    moveXAlongYAxis.springBounciness = 5;
    moveXAlongYAxis.springSpeed = 2.0f;
    [_xShape.layer pop_addAnimation:moveXAlongYAxis forKey:@"positiony"];
    
    POPSpringAnimation *spin =
    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    spin.toValue = @(M_PI/4);
    spin.springBounciness = 15;
    spin.springSpeed = 5.0f;
    [_xShape.layer pop_addAnimation:spin forKey:@"spin"];
    
    UIView *whiteCircle = [[UIView alloc] initWithFrame:CGRectMake(-10, -10, 10, 10)];
    whiteCircle.backgroundColor = [UIColor slightlyLessWhiteThanWhite];
    whiteCircle.layer.cornerRadius = whiteCircle.frame.size.width/2;
    [self insertSubview:whiteCircle atIndex:[self subviews].count-1];
    
    POPSpringAnimation *scaleWhiteCircle = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleWhiteCircle.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width, self.frame.size.width)];
    scaleWhiteCircle.springBounciness = 2;
    scaleWhiteCircle.springSpeed = 2.0f;
    scaleWhiteCircle.dynamicsMass = 10.0f;
    [whiteCircle pop_addAnimation:scaleWhiteCircle forKey:@"scaleWhiteCircle"];
    
    _searchBar = [self textField];
    [self addSubview:_searchBar];

    [moveXAlongXAxis setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
        POPSpringAnimation *searchBarAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        searchBarAnimation.toValue = @(self.frame.origin.x + 20 + _searchBar.frame.size.width / 2);
        searchBarAnimation.springBounciness = 2;
        searchBarAnimation.springSpeed = 2.0f;
        [_searchBar.layer pop_addAnimation:searchBarAnimation forKey:@"positionx"];
        
        _tableViewContainingSearchResults = [self createTableView];
        [_tableViewContainingSearchResults registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityCell"];
        [self addSubview:_tableViewContainingSearchResults];
    }];

    
}

-(UITableView *)createTableView {
    UITableView *tableViewForCities = [[UITableView alloc]initWithFrame:CGRectMake(0, 75, self.frame.size.width, self.frame.size.height - 75) style:UITableViewStylePlain];
    
    tableViewForCities.rowHeight = 45;
    tableViewForCities.scrollEnabled = YES;
    tableViewForCities.showsVerticalScrollIndicator = NO;
    tableViewForCities.userInteractionEnabled = YES;
    tableViewForCities.bounces = YES;
    tableViewForCities.delegate = self;
    tableViewForCities.dataSource = self;
    tableViewForCities.backgroundColor = [UIColor clearColor];
    
    
    return tableViewForCities;
}

- (UITextField *)textField {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * -1, 20, self.frame.size.width - 80, _xShape.frame.size.height)];
    [textField setBackgroundColor: [UIColor colorWithRed:0.8941 green:0.8941 blue:0.8941 alpha:1.0]];
    textField.layer.cornerRadius = 5;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchIcon"]];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.frame = CGRectInset(searchIcon.frame, -10, 0);
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = searchIcon;
    [textField setTextColor:[UIColor colorWithRed:0.4588 green:0.4588 blue:0.4588 alpha:1.0]];
    [textField setFont:[UIFont fontWithName:@"Avenir" size:25]];
    [textField setClearsOnBeginEditing:YES];
    
    UIColor *color = [UIColor colorWithRed:0.4588 green:0.4588 blue:0.4588 alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"Avenir" size:25];
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSForegroundColorAttributeName: color};
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:attributes];
    
    return textField;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataForTableView count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SMLocationModel *newLocation = [_dataForTableView objectAtIndex:indexPath.row];
    NSString *string = newLocation.cityName;
    
    cell.textLabel.text = string;
    cell.textLabel.textColor = [UIColor colorWithRed:0.4588 green:0.4588 blue:0.4588 alpha:1.0];
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMLocationModel *newLocation = [_dataForTableView objectAtIndex:indexPath.row];
    [self.delegate createWithLocationAndSaveToDataStore:newLocation];
}


- (void)cancelButtonPressed: (UITapGestureRecognizer *)recognizer {
    //TODO: Add implementation for cancel button
}

@end

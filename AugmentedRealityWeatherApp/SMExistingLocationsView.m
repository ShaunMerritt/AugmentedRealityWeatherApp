//
//  SMExistingLocationsView.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/15/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMExistingLocationsView.h"
#import "UIColor+SMAugmentedRealityAppColors.h"
#import "SMPlusShapeView.h"
#import "SMLocationModel.h"
#import "SMExistingLocationTableViewCell.h"
#import <POP.h>
#import "SMCustomSearchUITextField.h"
#import "SMAddNewLocationView.h"
#import "SMAddNewLocationsViewController.h"

@interface SMExistingLocationsView () <UITableViewDelegate, UITableViewDataSource, SMExistingLocationsDelegate>{
    
    UIView *_navBar;
    UIImageView *_plusShape;
    UILabel *_titleLabelForNavBar;
    UIButton *_doneButton;
    int _deleteButtonCellIndex;
}

@end

@implementation SMExistingLocationsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //        _blurredBackgroundCameraView = [[SMBlurredCameraBackgroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height)];
        //        [self addSubview:_blurredBackgroundCameraView];
        _dataForTableView = [[NSMutableArray alloc] init];
        
        [self createViewLayout];
        
    }
    return self;
}

- (void)handlePlusButtonTap: (UITapGestureRecognizer *)recognizer {
    
    [self.delegate addCityButtonPressed];
    
    
//    [UIView animateWithDuration:.5 animations:^{
//        _plusShape.image = [_plusShape.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        [_plusShape setTintColor:[UIColor colorWithRed:0.3255 green:0.3255 blue:0.3255 alpha:1.0]];
//    }];
//    
//    POPSpringAnimation *scaleMinTemperatureLabel = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    scaleMinTemperatureLabel.toValue = [NSValue valueWithCGPoint:CGPointMake(.8, .8)];
//    scaleMinTemperatureLabel.springBounciness = 2;
//    scaleMinTemperatureLabel.springSpeed = 2.0f;
//    [_plusShape pop_addAnimation:scaleMinTemperatureLabel forKey:@"scaleMinTemperatureLabel"];
//    
//    POPSpringAnimation *move =
//    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
//    move.toValue = @(self.frame.size.width - 35);
//    move.springBounciness = 5;
//    move.springSpeed = 2.0f;
//    [_plusShape.layer pop_addAnimation:move forKey:@"position"];
//    
//    POPSpringAnimation *moveY =
//    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    moveY.toValue = @(40);
//    moveY.springBounciness = 5;
//    moveY.springSpeed = 2.0f;
//    [_plusShape.layer pop_addAnimation:moveY forKey:@"positiony"];
//    
//    POPSpringAnimation *spin =
//    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
//    spin.toValue = @(M_PI/4);
//    spin.springBounciness = 15;
//    spin.springSpeed = 5.0f;
//    [_plusShape.layer pop_addAnimation:spin forKey:@"spin"];
//    
//    UIView *whiteCircle = [[UIView alloc] initWithFrame:CGRectMake(-10, -10, 10, 10)];
//    whiteCircle.backgroundColor = [UIColor slightlyLessWhiteThanWhite];
//    whiteCircle.layer.cornerRadius = whiteCircle.frame.size.width/2;
//    [self insertSubview:whiteCircle atIndex:[self subviews].count-1];
//    
//    POPSpringAnimation *scaleWhiteCircle = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    scaleWhiteCircle.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width, self.frame.size.width)];
//    scaleWhiteCircle.springBounciness = 2;
//    scaleWhiteCircle.springSpeed = 2.0f;
//    scaleWhiteCircle.dynamicsMass = 10.0f;
//    [whiteCircle pop_addAnimation:scaleWhiteCircle forKey:@"scaleMinTemperatureLabel"];
//    
//    [move setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//        SMCustomSearchUITextField *customSearch = [[SMCustomSearchUITextField alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * -1, 20, self.frame.size.width - 80, _plusShape.frame.size.height)];
//        customSearch.placeholder = @"Search";
//        [self insertSubview:customSearch atIndex:[self subviews].count];
//        
//        
//        
//        
//        POPSpringAnimation *moveTextField =
//        [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
//        moveTextField.toValue = @(self.frame.origin.x + 20 + customSearch.frame.size.width / 2);
//        moveTextField.springBounciness = 5;
//        moveTextField.springSpeed = 2.0f;
//        [customSearch.layer pop_addAnimation:moveTextField forKey:@"position"];
//        NSLog(@"DOOOOONE");
//    }];

//    SMAddNewLocationView *addLocationsView = [[SMAddNewLocationView alloc] initWithFrame:self.frame];
//    [self addSubview:addLocationsView];

    
}

- (void) createViewLayout {
    
    _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 70)];
    _navBar.backgroundColor = [UIColor lightBlackColor];
    [self addSubview:_navBar];
    
    
    
    _titleLabelForNavBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    _titleLabelForNavBar.text = @"Locations";
    _titleLabelForNavBar.font = [UIFont fontWithName:@"Avenir" size:30];
    [_titleLabelForNavBar sizeToFit];
    _titleLabelForNavBar.center = CGPointMake(self.frame.size.width / 2, _navBar.frame.size.height - 20);
    _titleLabelForNavBar.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabelForNavBar];
    
    _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, _titleLabelForNavBar.frame.origin.y, 50, 50)];
    [_doneButton setTitle: @"Done" forState: UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _doneButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [self addSubview:_doneButton];
    
    _tableViewContainingSavedCities = [self createTableView];
    [_tableViewContainingSavedCities registerClass:[SMExistingLocationTableViewCell class] forCellReuseIdentifier:@"cityCell"];
    [self addSubview:_tableViewContainingSavedCities];
    
    _plusShape = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 40, 40)];
    _plusShape.image = [UIImage imageNamed:@"Rectangle 2 + Rectangle 3"];
    _plusShape.userInteractionEnabled = YES;
    UITapGestureRecognizer *plusButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handlePlusButtonTap:)];
    [_plusShape addGestureRecognizer:plusButtonTap];
    [self addSubview:_plusShape];
    
    
}

-(UITableView *)createTableView {
    UITableView *tableViewForCities = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height - 75) style:UITableViewStylePlain];
    
    tableViewForCities.rowHeight = 60;
    tableViewForCities.scrollEnabled = YES;
    tableViewForCities.showsVerticalScrollIndicator = NO;
    tableViewForCities.userInteractionEnabled = YES;
    tableViewForCities.bounces = NO;
    tableViewForCities.delegate = self;
    tableViewForCities.dataSource = self;
    tableViewForCities.backgroundColor = [UIColor lightGrayColorForCellBackgrounds];
    
    return tableViewForCities;
}

#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataForTableView count];
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cityCell";
    
    // Similar to UITableViewCell, but
    SMExistingLocationTableViewCell *cell = (SMExistingLocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SMExistingLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Just want to test, so I hardcode the data
    
    SMLocationModel *newLocation = [_dataForTableView objectAtIndex:indexPath.row];
    NSString *string = newLocation.cityName;
    
    cell.cityNameLabel.text = string;
    
    cell.deleteButton.tag = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

- (void) deleteButtonPressed: (UIButton*) button {
    
    CGPoint buttonCentre = [button convertPoint:[button center] toView:[self tableViewContainingSavedCities]];
    
    NSLog(@"Button 1 Pressed on row %ld", (long)[[[self tableViewContainingSavedCities] indexPathForRowAtPoint:buttonCentre] row]);
    
    UIButton *tf=(UIButton *)[_tableViewContainingSavedCities viewWithTag:101];
    [tf setTitle: [NSString stringWithFormat:@"Button 1 "] forState:UIControlStateNormal];
    
}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [_dataForTableView count];
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"cityCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    else{
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    
//    SMLocationModel *newLocation = [_dataForTableView objectAtIndex:indexPath.row];
//    NSString *string = newLocation.cityName;
//    
//    cell.textLabel.text = string;
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.backgroundColor = [UIColor colorWithRed:0.1765 green:0.1765 blue:0.1765 alpha:.6];
//    
//    return cell;
//    
//}

- (void) deleteButtonPressedInCell:(SMExistingLocationTableViewCell *)cell index:(int)index {
    
    //cell.contentView.backgroundColor = [UIColor blackColor];
    
    cell.deleteButton.alpha = 0;
    
    UIView *backgroundViews = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, cell.bounds.origin.y, 100, 100)];
    backgroundViews.backgroundColor = [UIColor darkGrayColorForBackgroundsAndText];
    backgroundViews.layer.cornerRadius = backgroundViews.frame.size.width / 2;
    
    [cell.contentView insertSubview:backgroundViews atIndex:0];
    cell.cityNameLabel.textColor = [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:1.0];
    
    [cell.contentView.superview setClipsToBounds:YES];
    
    POPSpringAnimation *scaleMinTemperatureLabel = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleMinTemperatureLabel.toValue = [NSValue valueWithCGPoint:CGPointMake(10, 10)];
    scaleMinTemperatureLabel.springBounciness = 2;
    scaleMinTemperatureLabel.springSpeed = 2.0f;
    [backgroundViews pop_addAnimation:scaleMinTemperatureLabel forKey:@"scaleMinTemperatureLabel"];
    backgroundViews.layer.cornerRadius = cell.deleteButton.frame.size.width / 2;
    
    POPSpringAnimation *move =
    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    move.toValue = @(-10);
    move.springBounciness = 15;
    move.springSpeed = 2.0f;
    [backgroundViews.layer pop_addAnimation:move forKey:@"position"];
    
    cell.deleteButton.layer.cornerRadius = cell.deleteButton.frame.size.width / 2;
    
    
    UIButton *xButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width, backgroundViews.bounds.origin.y + 20, 24, 24)];
    
    [xButton setBackgroundImage:[UIImage imageNamed:@"XShape"] forState:UIControlStateNormal];
    
    for (UIView *view in xButton.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view setContentMode:UIViewContentModeCenter];
        }
    }
    
    _deleteButtonCellIndex = index;

    
    [xButton addTarget:self
                          action:@selector(deleteCellButtonPressed:)
                forControlEvents:UIControlEventTouchDown];
    
    [cell.contentView insertSubview:xButton atIndex:1];
    
    xButton.transform = CGAffineTransformMakeRotation(M_PI/6);

    
    POPSpringAnimation *moveDeleteButton =
    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveDeleteButton.toValue = @(self.frame.size.width - xButton.frame.size.width);
    moveDeleteButton.springBounciness = 10;
    moveDeleteButton.springSpeed = 2.0f;
    [xButton.layer pop_addAnimation:moveDeleteButton forKey:@"position"];

    POPSpringAnimation *spin =
    [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    spin.toValue = @(0);
    spin.springBounciness = 10;
    spin.springSpeed = 5.0f;
    [xButton.layer pop_addAnimation:spin forKey:@"spin"];
}

- (void) deleteCellButtonPressed: (int *)indexPath {
    
    NSLog(@"At index: %d", _deleteButtonCellIndex);
    
}


@end

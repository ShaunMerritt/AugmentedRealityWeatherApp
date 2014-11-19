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
    [_doneButton addTarget:self
                    action:@selector(doneButtonClicked)
       forControlEvents:UIControlEventTouchUpInside];
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
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void) deleteButtonPressedInCell:(SMExistingLocationTableViewCell *)cell{
    
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

- (void) deleteCellButtonPressed: (id)sender {

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableViewContainingSavedCities];
    NSIndexPath *indexPath = [self.tableViewContainingSavedCities indexPathForRowAtPoint:buttonPosition];
    
    [self.delegate removeCellAtIndex:indexPath.row];
    
}

- (void) doneButtonClicked {
    
    [self.delegate doneButtonClicked];
    
}


@end

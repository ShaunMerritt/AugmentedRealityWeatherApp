//
//  SMAddLocationsView.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 10/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMAddLocationsView.h"
#import "SMBlurredCameraBackgroundView.h"

@interface SMAddLocationsView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    SMBlurredCameraBackgroundView *_blurredBackgroundCameraView;
    UITableView *_tableViewContainingCities;
    UITextField *_searchField;

}

@end

@implementation SMAddLocationsView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _blurredBackgroundCameraView = [[SMBlurredCameraBackgroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:_blurredBackgroundCameraView];
        
        [self createViewLayout];
        
    }
    return self;
}

- (void) createViewLayout {
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 55)];
    _searchField.backgroundColor = [UIColor colorWithRed:0.1765 green:0.1765 blue:0.1765 alpha:.7];
    _searchField.textColor = [UIColor whiteColor];
    _searchField.textAlignment = NSTextAlignmentCenter;
    _searchField.delegate = self;
    _searchField.text = @"Search For City";
    [self addSubview:_searchField];
    
    _tableViewContainingCities = [self createTableView];
    [_tableViewContainingCities registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityCell"];
    [self addSubview:_tableViewContainingCities];
    
}

-(UITableView *)createTableView
{
    UITableView *tableViewForCities = [[UITableView alloc]initWithFrame:CGRectMake(0, 75, self.frame.size.width, self.frame.size.height - 75) style:UITableViewStylePlain];
    
    tableViewForCities.rowHeight = 45;
    tableViewForCities.scrollEnabled = YES;
    tableViewForCities.showsVerticalScrollIndicator = YES;
    tableViewForCities.userInteractionEnabled = YES;
    tableViewForCities.bounces = YES;
    
    tableViewForCities.delegate = self;
    tableViewForCities.dataSource = self;
    tableViewForCities.backgroundColor = [UIColor clearColor];
    
    return tableViewForCities;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
    cell.backgroundColor = [UIColor colorWithRed:0.1765 green:0.1765 blue:0.1765 alpha:.6];
    cell.textLabel.text=[NSString stringWithFormat:@"Cell %d",indexPath.row+1];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_searchField setText:@""];
}



@end

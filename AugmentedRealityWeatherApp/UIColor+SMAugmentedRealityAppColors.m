//
//  UIColor+SMAugmentedRealityAppColors.m
//  AugmentedRealityWeatherApp
//
//  Created by Shaun Merritt on 11/15/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "UIColor+SMAugmentedRealityAppColors.h"

@implementation UIColor (SMAugmentedRealityAppColors)


+(UIColor *)lightBlackColor {
    return [UIColor colorWithRed:0.1216 green:0.1098 blue:0.0863 alpha:1.0];
}

+(UIColor *)lightGrayColorForCellBackgrounds {
    return [UIColor colorWithRed:0.8902 green:0.8902 blue:0.8902 alpha:1.0];
}

+(UIColor *)darkGrayColorForBackgroundsAndText {
    return [UIColor colorWithRed:0.3255 green:0.3255 blue:0.3255 alpha:1.0];
}

+(UIColor *)slightlyLessWhiteThanWhite {
    return [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:1.0];
}

+(UIColor *)grayColorForText {
    return [UIColor colorWithRed:0.4588 green:0.4588 blue:0.4588 alpha:1.0];
}

@end

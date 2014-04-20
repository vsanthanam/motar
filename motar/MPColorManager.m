//
//  MPColorManager.m
//  motar
//
//  Created by Varun Santhanam on 4/14/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPColorManager.h"

@implementation MPColorManager

+ (UIColor *)lightColor {
    
    return [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    
}

+ (UIColor *)darkColor {
    
    return [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    
}

+ (UIColor *)darkColorLessAlpha {
    
    return [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.4];
    
}

@end

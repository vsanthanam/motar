//
//  MPReturnTimeView.m
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPReturnTimeView.h"

@implementation MPReturnTimeView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0 green: 0.657 blue: 0 alpha: 0.3];
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 280, 155) cornerRadius: 4];
    [color setFill];
    [roundedRectanglePath fill];

    
}


@end

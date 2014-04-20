//
//  MPShortInfoBubble.m
//  motar
//
//  Created by Varun Santhanam on 4/12/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPShortInfoBubble.h"

@implementation MPShortInfoBubble

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        
        
    }
    return self;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0 green: 0.657 blue: 0 alpha: 0.3];
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 280, 100) cornerRadius: 4];
    [color setFill];
    [roundedRectanglePath fill];

    
}


@end

//
//  MPParkStatusMeter.m
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPParkStatusMeter.h"

@implementation MPParkStatusMeter

@synthesize parkImage = _parkImage;

#pragma mark - Overridden Instance Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setNotParked];
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
    
}

- (void)drawRect:(CGRect)rect {
    
    if (self.parkImage == MPParkImageParked) {
        
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* borderColor = [UIColor colorWithRed: 0.571 green: 1 blue: 0.571 alpha: 1];
        UIColor* color = [UIColor colorWithRed: 0.114 green: 1 blue: 0.114 alpha: 0.6];
        UIColor* color2 = [UIColor colorWithRed: 0 green: 0.657 blue: 0.219 alpha: 0.6];
        
        //// Gradient Declarations
        NSArray* gradientColors = @[(id)color.CGColor,
                                   (id)color2.CGColor];
        CGFloat gradientLocations[] = {0, 1};
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        
        //// Abstracted Attributes
        NSString* textContent = @"parked.";
        
        
        //// Rounded Rectangle Drawing
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.5, 0.5, 199, 49) cornerRadius: 4];
        CGContextSaveGState(context);
        [roundedRectanglePath addClip];
        CGContextDrawLinearGradient(context, gradient, CGPointMake(100, 0.5), CGPointMake(100, 49.5), 0);
        CGContextRestoreGState(context);
        [borderColor setStroke];
        roundedRectanglePath.lineWidth = 1;
        [roundedRectanglePath stroke];
        
        
        //// Text Drawing
        CGRect textRect = CGRectMake(34, 5, 133, 39);
        NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [textStyle setAlignment: NSTextAlignmentCenter];
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Thin" size: 32], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: textStyle};
        
        [textContent drawInRect: textRect withAttributes: textFontAttributes];
        
        
        //// Cleanup
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        
    } else {
        
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* borderColor = [UIColor colorWithRed: 1 green: 0.571 blue: 0.571 alpha: 1];
        UIColor* color = [UIColor colorWithRed: 1 green: 0.114 blue: 0.114 alpha: 0.6];
        UIColor* color2 = [UIColor colorWithRed: 0.657 green: 0 blue: 0 alpha: 0.6];
        
        //// Gradient Declarations
        NSArray* gradientColors = @[(id)color.CGColor,
                                   (id)color2.CGColor];
        CGFloat gradientLocations[] = {0, 1};
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        
        //// Abstracted Attributes
        NSString* textContent = @"not parked.";
        
        
        //// Rounded Rectangle Drawing
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.5, 0.5, 199, 49) cornerRadius: 4];
        CGContextSaveGState(context);
        [roundedRectanglePath addClip];
        CGContextDrawLinearGradient(context, gradient, CGPointMake(100, 0.5), CGPointMake(100, 49.5), 0);
        CGContextRestoreGState(context);
        [borderColor setStroke];
        roundedRectanglePath.lineWidth = 1;
        [roundedRectanglePath stroke];
        
        
        //// Text Drawing
        CGRect textRect = CGRectMake(17, 5, 167, 39);
        NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [textStyle setAlignment: NSTextAlignmentCenter];
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Thin" size: 32], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: textStyle};
        
        [textContent drawInRect: textRect withAttributes: textFontAttributes];
        
        //// Cleanup
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        
    }
    
}

#pragma mark - Public Instance Methods

- (void)setParked {
    
    self->_parkImage = MPParkImageParked;
    [self setNeedsDisplay];
    
}

- (void)setNotParked {
    
    self->_parkImage = MPParkImageNotParked;
    [self setNeedsDisplay];
    
}

@end

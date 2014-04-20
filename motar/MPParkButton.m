//
//  MPParkButton.m
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPParkButton.h"

@implementation MPParkButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    if (self.isHighlighted) {
        
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* innerDark = [UIColor colorWithRed: 0.302 green: 0.302 blue: 0.302 alpha: 1];
        UIColor* innerLight = [UIColor colorWithRed: 0.69 green: 0.69 blue: 0.69 alpha: 1];
        
        //// Gradient Declarations
        NSArray* innerGradientColors = [NSArray arrayWithObjects:
                                        (id)innerDark.CGColor,
                                        (id)innerLight.CGColor, nil];
        CGFloat innerGradientLocations[] = {0, 1};
        CGGradientRef innerGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)innerGradientColors, innerGradientLocations);
        
        //// Image Declarations
        UIImage* parkImage = [UIImage imageNamed: @"parkImage"];
        UIColor* parkImagePattern = [UIColor colorWithPatternImage: parkImage];
        
        //// Abstracted Attributes
        NSString* textContent = @"Park Here";
        
        
        //// outerOval Drawing
        UIBezierPath* outerOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0.5, 0.5, 127, 127)];
        CGContextSaveGState(context);
        [outerOvalPath addClip];
        CGContextDrawLinearGradient(context, innerGradient, CGPointMake(64, 0.5), CGPointMake(64, 127.5), 0);
        CGContextRestoreGState(context);
        [[UIColor blackColor] setStroke];
        outerOvalPath.lineWidth = 0.5;
        [outerOvalPath stroke];
        
        
        //// innerOval Drawing
        UIBezierPath* innerOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(10, 9, 110, 110)];
        CGContextSaveGState(context);
        [innerOvalPath addClip];
        CGContextDrawLinearGradient(context, innerGradient, CGPointMake(65, 9), CGPointMake(65, 119), 0);
        CGContextRestoreGState(context);
        
        
        //// parkImageShape Drawing
        UIBezierPath* parkImageShapePath = [UIBezierPath bezierPathWithRect: CGRectMake(32, 20, 64, 64)];
        CGContextSaveGState(context);
        CGContextSetPatternPhase(context, CGSizeMake(32, 20));
        [parkImagePattern setFill];
        [parkImageShapePath fill];
        CGContextRestoreGState(context);
        
        
        //// Text Drawing
        CGRect textRect = CGRectMake(26, 89, 77, 14);
        NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [textStyle setAlignment: NSTextAlignmentCenter];
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" size: [UIFont systemFontSize]], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: textStyle};
        
        [textContent drawInRect: textRect withAttributes: textFontAttributes];
        
        
        //// Cleanup
        CGGradientRelease(innerGradient);
        CGColorSpaceRelease(colorSpace);

        
    } else {
        
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* outerLight = [UIColor colorWithRed: 0.966 green: 0.966 blue: 0.966 alpha: 1];
        UIColor* outerDark = [UIColor colorWithRed: 0.525 green: 0.525 blue: 0.525 alpha: 1];
        UIColor* innerDark = [UIColor colorWithRed: 0.302 green: 0.302 blue: 0.302 alpha: 1];
        UIColor* innerLight = [UIColor colorWithRed: 0.692 green: 0.692 blue: 0.692 alpha: 1];
        
        //// Gradient Declarations
        NSArray* outerGradientColors = [NSArray arrayWithObjects:
                                        (id)outerLight.CGColor,
                                        (id)outerDark.CGColor, nil];
        CGFloat outerGradientLocations[] = {0, 1};
        CGGradientRef outerGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)outerGradientColors, outerGradientLocations);
        NSArray* innerGradientColors = [NSArray arrayWithObjects:
                                        (id)innerDark.CGColor,
                                        (id)innerLight.CGColor, nil];
        CGFloat innerGradientLocations[] = {0, 1};
        CGGradientRef innerGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)innerGradientColors, innerGradientLocations);
        
        //// Image Declarations
        UIImage* parkImage = [UIImage imageNamed: @"parkImage"];
        UIColor* parkImagePattern = [UIColor colorWithPatternImage: parkImage];
        
        //// Abstracted Attributes
        NSString* textContent = @"Park Here";
        
        
        //// outerOval Drawing
        UIBezierPath* outerOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0.5, 0.5, 127, 127)];
        CGContextSaveGState(context);
        [outerOvalPath addClip];
        CGContextDrawLinearGradient(context, outerGradient, CGPointMake(64, 0.5), CGPointMake(64, 127.5), 0);
        CGContextRestoreGState(context);
        [[UIColor blackColor] setStroke];
        outerOvalPath.lineWidth = 0.5;
        [outerOvalPath stroke];
        
        
        //// innerOval Drawing
        UIBezierPath* innerOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(9, 9, 110, 110)];
        CGContextSaveGState(context);
        [innerOvalPath addClip];
        CGContextDrawLinearGradient(context, innerGradient, CGPointMake(64, 9), CGPointMake(64, 119), 0);
        CGContextRestoreGState(context);
        
        
        //// parkImageShape Drawing
        UIBezierPath* parkImageShapePath = [UIBezierPath bezierPathWithRect: CGRectMake(32, 20, 64, 64)];
        CGContextSaveGState(context);
        CGContextSetPatternPhase(context, CGSizeMake(32, 20));
        [parkImagePattern setFill];
        [parkImageShapePath fill];
        CGContextRestoreGState(context);
        
        
        //// Text Drawing
        CGRect textRect = CGRectMake(26, 89, 77, 14);
        NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [textStyle setAlignment: NSTextAlignmentCenter];
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" size: [UIFont systemFontSize]], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: textStyle};
        
        [textContent drawInRect: textRect withAttributes: textFontAttributes];
        
        
        //// Cleanup
        CGGradientRelease(outerGradient);
        CGGradientRelease(innerGradient);
        CGColorSpaceRelease(colorSpace);
        
    }
    
}

- (void)setHighlighted:(BOOL)highlighted {
    
    [self setNeedsDisplay];
    [super setHighlighted:highlighted];
    
}
@end

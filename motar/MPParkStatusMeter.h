//
//  MPParkStatusMeter.h
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    MPParkImageParked,
    MPParkImageNotParked
    
} MPParkImage;

@interface MPParkStatusMeter : UIButton

@property (nonatomic, readonly, assign) MPParkImage parkImage;

- (void)setParked;
- (void)setNotParked;


@end

//
//  MPAutoParkManager.h
//  motar
//
//  Created by Varun Santhanam on 4/13/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface MPAutoParkManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) CMMotionActivityManager *activityManager;
@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, assign, readonly, getter = isTracking) BOOL tracking;
@property (nonatomic, readonly, getter = canTrack) BOOL trackingAvailable;
@property (nonatomic, strong, readonly) CMMotionActivity *activity;
@property (nonatomic, strong, readonly) CLLocation *location;

+ (BOOL)canTrack;

- (void)waitForPark;
- (void)waitForDrive;
- (void)stopTracking;

@end

//
//  MPAutoParkManager.h
//  motar
//
//  Created by Varun Santhanam on 5/24/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import "MPConstants.h"
#import "Flurry.h"

@class MPAutoParkManager;

@protocol MPAutoParkManagerDelegate <NSObject>

- (BOOL)autoParkManagerShouldTrack:(MPAutoParkManager *)manager;

@optional
- (void)autoParkManagerDidStartTracking:(MPAutoParkManager *)manager;
- (void)autoParkManagerDidStopTracking:(MPAutoParkManager *)manager;
- (void)autoParkManager:(MPAutoParkManager *)manager didTrackNewActivity:(CMMotionActivity *)activity;
- (void)autoParkManager:(MPAutoParkManager *)manager didTrackNewLocation:(CLLocation *)location;
- (void)autoParkManagerThinksUserParked:(MPAutoParkManager *)manager;

@end

@interface MPAutoParkManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) CLLocation *trackedLocation;
@property (nonatomic, strong, readonly) CMMotionActivity *trackedActivity;
@property (nonatomic, assign, getter = isTracking) BOOL tracking;
@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, strong, readonly) CMMotionActivityManager *activityManager;
@property (assign) id<MPAutoParkManagerDelegate> delegate;
@property (nonatomic, readonly, getter = canFlurry) BOOL flurry;

+ (BOOL)canTrack;
+ (MPAutoParkManager *)managerWithDelegate:(id<MPAutoParkManagerDelegate>)delegate;

- (void)startTracking;
- (void)stopTracking;

@end

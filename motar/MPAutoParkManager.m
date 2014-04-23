//
//  MPAutoParkManager.m
//  motar
//
//  Created by Varun Santhanam on 4/13/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPAutoParkManager.h"

@implementation MPAutoParkManager {
    
    CMMotionActivity *_previous;
    
}

@synthesize locationManager = _locationManager;
@synthesize activityManager = _activityManager;
@synthesize tracking = _tracking;
@synthesize activity = _activity;
@synthesize location = _location;

#pragma mark - Public Class Methods

+ (BOOL)canTrack {
    
    return [CMMotionActivityManager isActivityAvailable];
    
}

#pragma mark - Property Access Instance Methods

- (CLLocationManager *)locationManager {
    
    if (!self->_locationManager) {
        
        self->_locationManager = [[CLLocationManager alloc] init];
        self->_locationManager.pausesLocationUpdatesAutomatically = NO;
        self->_locationManager.delegate = self;
        
    }
    
    return self->_locationManager;
    
}

- (CMMotionActivityManager *)activityManager {
    
    if (!self->_activityManager) {
        
        self->_activityManager = [[CMMotionActivityManager alloc] init];
        
    }
    
    return self->_activityManager;
    
}

- (BOOL)canTrack {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoParkKey"] && [MPAutoParkManager canTrack];
    
}

#pragma mark - CLLocationManagerDelegate Protocol Instance Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self->_location = [locations lastObject];
    NSLog(@"AUTOPARK: %@", self.location);
    
}

#pragma mark - Overridden Instance Methods

- (id)init {
    
    if (self = [super init]) {
        
        self->_tracking = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APStop" object:self];
        
    }
    
    return self;
    
}

#pragma mark - Private Instance Methods

- (void)askUser {
    
    UILocalNotification *autoParkReminder = [[UILocalNotification alloc] init];
    autoParkReminder.fireDate = [[NSDate date] dateByAddingTimeInterval:2];
    autoParkReminder.timeZone = [NSTimeZone defaultTimeZone];
    autoParkReminder.soundName = UILocalNotificationDefaultSoundName;
    autoParkReminder.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    if (self->_previous.automotive) {
        
        autoParkReminder.alertBody = @"Did you park your car?";
        autoParkReminder.userInfo = @{@"key": @"autopark", @"kind": @"park"};
        
    } else {
        
        autoParkReminder.alertBody = @"Did you un-park your car?";
        autoParkReminder.userInfo = @{@"key": @"autopark", @"kind": @"un-parked"};
        
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:autoParkReminder];
    [self pauseTracking];
    
}

- (void)pauseTracking {
    
    [self.activityManager stopActivityUpdates];
    [self.locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APStop" object:self];
    
}

#pragma mark - Public Instance Methods

- (void)waitForDrive {
    
    if ([self canTrack]) {
        
        if (![self isTracking]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"APStart" object:self];
            self->_tracking = YES;
            self.locationManager.desiredAccuracy = 3000;
            [self.locationManager startUpdatingLocation];
            [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMMotionActivity *activity) {
                
                if ([self canTrack]) {
                    
                    self->_activity = activity;
                    NSLog(@"%@", activity);
                    
                    if (!self->_previous) {
                        
                        if ((activity.walking || activity.running) && (activity.confidence == CMMotionActivityConfidenceMedium || activity.confidence == CMMotionActivityConfidenceHigh)) {
                            
                            self->_previous = activity;
                            
                        }
                        
                    } else {
                        
                        if (activity.automotive && (activity.confidence == CMMotionActivityConfidenceMedium || activity.confidence == CMMotionActivityConfidenceHigh)) {
                            
                            [self askUser];
                            
                        }
                        
                    }
                    
                } else {
                    
                    [self stopTracking];
                    
                }
                
            }];
            
        }
        
    }
    
}

- (void)waitForPark {
    
    if ([self canTrack]) {
        
        if (![self isTracking]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"APStart" object:nil];
            self->_tracking = YES;
            self.locationManager.desiredAccuracy = 3000;
            [self.locationManager startUpdatingLocation];
            [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMMotionActivity *activity) {
                
                if ([self canTrack]) {
                    
                    self->_activity = activity;
                    NSLog(@"%@", activity);
                    
                    if (!self->_previous) {
                        
                        if (activity.automotive && (activity.confidence == CMMotionActivityConfidenceMedium || activity.confidence == CMMotionActivityConfidenceHigh)) {
                            
                            self->_previous = activity;
                            
                        }
                        
                    } else {
                        
                        if ((activity.walking || activity.running) && (activity.confidence == CMMotionActivityConfidenceMedium || activity.confidence == CMMotionActivityConfidenceHigh)) {
                            
                            [self askUser];
                            
                        }
                        
                    }
                    
                } else {
                    
                    [self stopTracking];
                    
                }
                
            }];
            
        }
        
    }
    
}

- (void)stopTracking {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APStop" object:self];
    [self.activityManager stopActivityUpdates];
    [self.locationManager stopUpdatingLocation];
    self->_tracking = NO;
    
}

@end

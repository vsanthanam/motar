//
//  MPAutoParkManager.m
//  motar
//
//  Created by Varun Santhanam on 5/24/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPAutoParkManager.h"

@implementation MPAutoParkManager {
    
    CMMotionActivity *_pivot;
    
}

@synthesize trackedActivity = _trackedActivity;
@synthesize trackedLocation = _trackedLocation;
@synthesize tracking = _tracking;
@synthesize locationManager = _locationManager;
@synthesize activityManager = _activityManager;

#pragma mark - Overridden Class Methods

+ (void)initialize {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"3.0.2" forKey:MPAutoParkVersionNumberKey];
    
}



#pragma mark - Public Class Methods

+ (BOOL)canTrack {
    
    return [CMMotionActivityManager isActivityAvailable];
    
}

+ (MPAutoParkManager *)managerWithDelegate:(id<MPAutoParkManagerDelegate>)delegate {
    
    MPAutoParkManager *manager = [[MPAutoParkManager alloc] init];
    manager.delegate = delegate;
    manager->_trackedActivity = nil;
    manager->_trackedLocation = nil;
    manager->_tracking = NO;
    
    return manager;
    
}



#pragma mark - Property Access Methods

- (CLLocationManager *)locationManager {
    
    if (!self->_locationManager) {
        
        self->_locationManager = [[CLLocationManager alloc] init];
        self->_locationManager.delegate = self;
        self->_locationManager.pausesLocationUpdatesAutomatically = NO;
        self->_locationManager.desiredAccuracy = 3000;
        
    }
    
    return self->_locationManager;
    
}

- (CMMotionActivityManager *)activityManager {
    
    if (!self->_activityManager) {
        
        self->_activityManager = [[CMMotionActivityManager alloc] init];
        
    }
    
    return self->_activityManager;
    
}

- (BOOL)canFlurry {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:MPUsageReportsSettingKey];
    
}



#pragma mark - CLLocationManagerDelegate Protocol Instance Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self->_trackedLocation = [locations lastObject];
    
    if ([self.delegate respondsToSelector:@selector(autoParkManager:didTrackNewLocation:)]) {
        
        [self.delegate autoParkManager:self didTrackNewLocation:self.trackedLocation];
        
    }
    
    NSLog(@"Background: %@", self.trackedLocation);
    
}



#pragma mark - Private Instance Methods

- (void)track {
    
    if ([MPAutoParkManager canTrack] && [self.delegate autoParkManagerShouldTrack:self]) {
        
        if ([self.delegate respondsToSelector:@selector(autoParkManagerDidStartTracking:)]) {
            
            [self.delegate autoParkManagerDidStartTracking:self];
            
        }
        
        [self.locationManager startUpdatingLocation];
        NSLog(@"Started Tracking");
        
        [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMMotionActivity *activity) {
           
            if ([self.delegate autoParkManagerShouldTrack:self]) {
                
                self->_trackedActivity = activity;
                NSLog(@"Motion: %@", self.trackedActivity);
                [[NSNotificationCenter defaultCenter] postNotificationName:MPAutoParkNewMotionNotification object:nil];
                if ([self.delegate respondsToSelector:@selector(autoParkManager:didTrackNewActivity:)]) {
                    
                    [self.delegate autoParkManager:self didTrackNewActivity:activity];
                    
                }
                
                if (!self->_pivot) {
                    
                    if (activity.automotive && (activity.confidence == CMMotionActivityConfidenceHigh)) {
                        
                        self->_pivot = activity;
                        
                    }
                    
                } else {
                    
                    if ((activity.walking || activity.running) && (activity.confidence == CMMotionActivityConfidenceMedium || activity.confidence == CMMotionActivityConfidenceHigh)) {
                        
                        [self finishTracking];
                        
                    }
                    
                }
                
            } else {
                
                [self stopTracking];
                
            }
            
        }];
        
    } else {
        
        NSLog(@"Device Not Tracking");
        
    }
    
}

- (void)finishTracking {
    
    if ([self.delegate respondsToSelector:@selector(autoParkManagerThinksUserParked:)]) {
        
        [self.delegate autoParkManagerThinksUserParked:self];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MPAutoParkNotification object:nil];
    
    if ([self canFlurry]) {
        
        [Flurry logEvent:MPAutoParkNotification];
        
    }
    
}



#pragma mark - Public Instance Methods

- (void)startTracking {
    
    self->_tracking = YES;
    self->_trackedActivity = nil;
    self->_trackedLocation = nil;
    self->_pivot = nil;
    [self track];
    
}

- (void)stopTracking {
    
    if ([self.delegate respondsToSelector:@selector(autoParkManagerDidStopTracking:)]) {
        
        [self.delegate autoParkManagerDidStopTracking:self];
        
    }
    self->_tracking = NO;
    self->_trackedActivity = nil;
    self->_trackedLocation = nil;
    self->_pivot = nil;
    self->_activityManager = nil;
    self->_locationManager = nil;
    NSLog(@"Stopped Tracking");
    [self.activityManager stopActivityUpdates];
    [self.locationManager stopUpdatingLocation];
    
}

- (void)resetTracking {
    
    self->_pivot = nil;
    
}

@end

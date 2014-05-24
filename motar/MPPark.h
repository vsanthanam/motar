//
//  MPPark.h
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "MPConstants.h"

typedef enum {
    
    MPParkStatusStandby,
    MPParkStatusParked,
    MPParkStatusComplete
    
} MPParkStatus;

@interface MPPark : NSObject <NSCoding>

@property (nonatomic, copy) NSString *parkTag;
@property (nonatomic, strong) CLLocation *parkLocation;
@property (nonatomic, readonly) NSDate *parkDate;
@property (nonatomic, strong) UIImage *parkImage;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, strong) UILocalNotification *parkReminder;
@property (nonatomic, assign, readonly) MPParkStatus parkStatus;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign, readonly, getter = isArchived) BOOL archived;
@property (nonatomic, readonly, getter = isParked) BOOL parked;
@property (nonatomic, readonly, getter = isMostRecent) BOOL mostRecent;

+ (MPPark *)park;
+ (MPPark *)parkWithLocation:(CLLocation *)location;
+ (MPPark *)parkFromSave;
+ (MPPark *)parkFromArchivesAtIndex:(NSInteger)index;

+ (BOOL)canUseiCloud;
+ (void)fillLocal;
+ (void)filliCloud;
+ (void)refresh;

+ (void)archivePark:(MPPark *)park;
+ (NSMutableArray *)parkArchives;
+ (void)clearArchives;
+ (void)clearSave;

+ (NSString *)defaultTag;
+ (void)setDefaultTag:(NSString *)newDefaultTag;
+ (void)resetDefaultTag;

- (id)initWithLocation:(CLLocation *)location;
- (void)park;
- (void)complete;
- (void)undo;
- (void)updateArchive;
- (void)savePark;

@end

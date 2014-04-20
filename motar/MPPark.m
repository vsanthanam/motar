//
//  MPPark.m
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPPark.h"

@implementation MPPark

@synthesize parkTag = _parkTag;
@synthesize parkLocation = _parkLocation;
@synthesize parkImage = _parkImage;
@synthesize returnDate = _returnDate;
@synthesize parkReminder = _parkReminder;
@synthesize parkStatus = _parkStatus;
@synthesize index = _index;
@synthesize archived = _archived;

static NSString *_defaultTag;

#pragma mark - Overridden Class Methods

+ (void)initialize {
    
    if (![MPPark canUseiCloud]) {
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultTagKey"]) {
            
            _defaultTag = @"My Car";
            
        } else {
            
            _defaultTag = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultTagKey"];
            
        }
        
    } else {
        
        if (![[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"DefaultTagKey"]) {
            
            _defaultTag = @"My Car";
            
        } else {
            
            _defaultTag = (NSString *)[[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"DefaultTagKey"];
            
        }
        
    }
    
}


#pragma mark - Public Class Methods

+ (MPPark *)park {
    
    return [[MPPark alloc] init];
    
}

+ (MPPark *)parkWithLocation:(CLLocation *)location {
    
    return [[MPPark alloc] initWithLocation:location];
    
}

+ (MPPark *)parkFromSave {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentKey"]) {
            
        NSData *parkData = (NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentKey"];
        MPPark *savedPark = [NSKeyedUnarchiver unarchiveObjectWithData:parkData];
        return savedPark;
        
    }
    
    return [MPPark park];
    
}

+ (MPPark *)parkFromArchivesAtIndex:(NSInteger)index {
    
    if ([MPPark parkArchives]) {
        
        NSData *parkData = [[MPPark parkArchives] objectAtIndex:index];
        MPPark *archivedPark = [NSKeyedUnarchiver unarchiveObjectWithData:parkData];
        return archivedPark;
        
    }
    
    return nil;
    
}

+ (BOOL)canUseiCloud {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudKey"];
    
}

+ (void)filliCloud {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultTagKey"]) {
        
        [[NSUbiquitousKeyValueStore defaultStore] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultTagKey"] forKey:@"DefaultTagKey"];
        
    }
    
}

+ (void)fillLocal {
    
    if ([[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"DefaultTagKey"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"DefaultTagKey"] forKey:@"DefaultTagKey"];
        
    }
    
}

+ (void)refresh {
    
    if (![MPPark canUseiCloud]) {
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultTagKey"]) {
            
            _defaultTag = @"My Car";
            
        } else {
            
            _defaultTag = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultTagKey"];
            
        }
        
    } else {
        
        if (![[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"DefaultTagKey"]) {
            
            _defaultTag = @"My Car";
            
        } else {
            
            _defaultTag = (NSString *)[[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"DefaultTagKey"];
            
        }
        
    }
    
}

+ (void)archivePark:(MPPark *)park {
    
    park->_archived = YES;
    NSData *parkData = [NSKeyedArchiver archivedDataWithRootObject:park];
    if ([MPPark parkArchives]) {
        
        NSMutableArray *newArray = [NSMutableArray arrayWithObject:parkData];
        [newArray addObjectsFromArray:[MPPark parkArchives]];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"PreviousKey"];
        
    } else {
        
        NSMutableArray *newArray = [NSMutableArray arrayWithObject:parkData];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"PreviousKey"];
        
    }
    
}

+ (NSMutableArray *)parkArchives {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PreviousKey"]) {
        
        return (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"PreviousKey"];
        
    }
    
    return nil;
    
}

+ (void)clearArchives {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PreviousKey"];
    
}

+ (void)clearSave {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSString *)defaultTag {
    
    return _defaultTag;
    
}

+ (void)setDefaultTag:(NSString *)newDefaultTag {
    
    if (![MPPark canUseiCloud]) {
        
        if (![newDefaultTag isEqual: @""]) {
            
            _defaultTag = newDefaultTag;
            [[NSUserDefaults standardUserDefaults] setObject:_defaultTag forKey:@"DefaultTagKey"];
            
        } else {
            
            [MPPark resetDefaultTag];
            
        }
        
    } else {
        
        if (![newDefaultTag isEqual: @""]) {
            
            _defaultTag = newDefaultTag;
            [[NSUbiquitousKeyValueStore defaultStore] setObject:_defaultTag forKey:@"DefaultTagKey"];
            
        } else {
            
            [MPPark resetDefaultTag];
            
        }
        
    }
    
}

+ (void)resetDefaultTag {
    
    if (![MPPark canUseiCloud]) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DefaultTagKey"];
        _defaultTag = @"My Car";
        
    } else {
        
        [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:@"DefaultTagKey"];
        
    }
    
}

#pragma mark - NSCoding Protocol Instance Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        self.parkTag = [aDecoder decodeObjectForKey:@"parkTag"];
        if ([aDecoder containsValueForKey:@"parkLocation"]) {
            
            self.parkLocation = [aDecoder decodeObjectForKey:@"parkLocation"];
            
        }
        if ([aDecoder containsValueForKey:@"parkImage"]) {
            
            self.parkImage = [aDecoder decodeObjectForKey:@"parkImage"];
            
        }
        if ([aDecoder containsValueForKey:@"returnDate"]) {
            
            self.returnDate = [aDecoder decodeObjectForKey:@"returnDate"];
            
        }
        if ([aDecoder containsValueForKey:@"parkReminder"]) {
            
            self->_parkReminder = [aDecoder decodeObjectForKey:@"parkReminder"];
            
        }
        if ([aDecoder containsValueForKey:@"parkStatus"]) {
            
            self->_parkStatus = (MPParkStatus)[aDecoder decodeIntegerForKey:@"parkStatus"];
            
        }
        if ([aDecoder containsValueForKey:@"index"]) {
            
            self.index = [aDecoder decodeIntegerForKey:@"index"];
            
        }
        self->_archived = YES;
        
    }
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.parkTag forKey:@"parkTag"];
    [aCoder encodeObject:self.parkLocation forKey:@"parkLocation"];
    [aCoder encodeObject:self.parkImage forKey:@"parkImage"];
    [aCoder encodeObject:self.returnDate forKey:@"returnDate"];
    [aCoder encodeObject:self.parkReminder forKey:@"parkReminder"];
    [aCoder encodeInteger:self.parkStatus forKey:@"parkStatus"];
    [aCoder encodeInteger:self.index forKey:@"index"];
    
}

#pragma mark - Property Access Instance Methods

- (NSDate *)parkDate {
    
    if (self.parkLocation) {
        
        return self.parkLocation.timestamp;
        
    }
    
    return nil;
    
}

- (void)setParkReminder:(UILocalNotification *)parkReminder {
    
    if (parkReminder) {
        
        self->_parkReminder = parkReminder;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[UIApplication sharedApplication] scheduleLocalNotification:self->_parkReminder];
        
    } else {
        
        self->_parkReminder = nil;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
    }
    
}

- (BOOL)isParked {
    
    return self.parkStatus == MPParkStatusParked;
    
}

- (BOOL)isMostRecent {
    
    if (self.index) {
        
        return self.index == 0;
        
    }
    
    return NO;
    
}

#pragma mark - Overridden Instance Methods

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.parkTag = [MPPark defaultTag];
        self->_parkStatus = MPParkStatusStandby;
        self->_archived = NO;
        
    }
    
    return self;
    
}

#pragma mark - Public Instance Methods

- (id)initWithLocation:(CLLocation *)location {
    
    self = [self init];
    if (self) {
        
        self.parkLocation = location;
        self->_parkStatus = MPParkStatusParked;
        
    }
    
    return self;
    
}

- (void)park {
    
    if (self.parkStatus == MPParkStatusStandby) {
        
        self->_parkStatus = MPParkStatusParked;
        
    }
    
}

- (void)complete {
    
    if ([self isParked]) {
        
        self->_parkStatus = MPParkStatusComplete;
        self.parkImage = nil;
        self.returnDate = [NSDate date];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
    }
    
}

- (void)undo {
    
    if (self.parkStatus == MPParkStatusComplete && [self isMostRecent]) {
        
        self->_parkStatus = MPParkStatusParked;
        self.returnDate = nil;
        self->_archived = NO;
        
    }
    
}

- (void)updateArchive {
    
    if ([MPPark parkArchives]) {
        
        NSData *parkData = [NSKeyedArchiver archivedDataWithRootObject:self];
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:[MPPark parkArchives]];
        [newArray replaceObjectAtIndex:self.index withObject:parkData];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"PreviousKey"];
        
    }
    
}

- (void)savePark {
   
    NSData *parkData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:parkData forKey:@"CurrentKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end

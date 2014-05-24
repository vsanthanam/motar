//
//  MPConstants.h
//  motar
//
//  Created by Varun Santhanam on 5/24/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPConstants : NSObject

// Park Data
extern NSString *const MPDefaultTagKey;
extern NSString *const MPCurrentParkKey;
extern NSString *const MPPreviousParksKey;

// Settings
extern NSString *const MPiCloudSettingKey;
extern NSString *const MPPinColorSettingKey;
extern NSString *const MPAutoParkSettingKey;
extern NSString *const MPiCloudDataKey;

// General
extern NSString *const MPAppFont;

// AutoPark Keys
extern NSString *const MPAutoParkNotification;

// Notification Keys
extern NSString *const MPNotificationTypeKey;
extern NSString *const MPNotificationTypeReminder;
extern NSString *const MPNotificationTypeExpired;
extern NSString *const MPNotificationTypeAutoPark;

@end

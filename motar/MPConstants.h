//
//  MPConstants.h
//  motar
//
//  Created by Varun Santhanam on 5/24/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPConstants : NSObject

// Park Data Keys
extern NSString *const MPDefaultTagKey;
extern NSString *const MPCurrentParkKey;
extern NSString *const MPPreviousParksKey;

// Settings Keys
extern NSString *const MPiCloudSettingKey;
extern NSString *const MPPinColorSettingKey;
extern NSString *const MPAutoParkSettingKey;
extern NSString *const MPiCloudDataKey;
extern NSString *const MPUsageReportsSettingKey;

// General
extern NSString *const MPAppFont;
extern NSString *const MPLaunchCountKey;
extern NSString *const MPFlurryKey;
extern NSString *const MPBuildNumberKey;
extern NSString *const MPVersionNumberKey;
extern NSString *const MPAutoParkVersionNumberKey;

// AutoPark Notifications
extern NSString *const MPAutoParkNotification;
extern NSString *const MPAutoParkNewMotionNotification;
extern NSString *const MPAutoParkWakeFromAutoParkNotification;

// Notification Info
extern NSString *const MPNotificationTypeKey;
extern NSString *const MPNotificationTypeReminder;
extern NSString *const MPNotificationTypeExpired;
extern NSString *const MPNotificationTypeAutoPark;
extern NSString *const MPNotificationTypeAutoParkExit;

// User Prompt Keys
extern NSString *const MPUseAutoParkPromptKey;
extern NSString *const MPAutoParkPromptKey;
extern NSString *const MPRateAppPromptKey;

@end

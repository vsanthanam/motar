//
//  MPAppDelegate.m
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPAppDelegate.h"

@implementation MPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Reset App Badge Number
    [application setApplicationIconBadgeNumber:0];
    
    // Setup Custom Navbar
    [[UINavigationBar appearance] setBarTintColor:[MPColorManager darkColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:MPAppFont size:21.0f]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Setup Custom Switches
    [[UISwitch appearance] setTintColor:[UIColor whiteColor]];
    
    // Custom Table View Cells
    // [[UITableViewCell appearance] setBackgroundColor:[MPColorManager darkColorLessAlpha]];
    
    // Custom Text Fields
    [[UITextField appearance] setBackgroundColor:[MPColorManager darkColorLessAlpha]];
    [[UITextField appearance] setTextColor:[UIColor whiteColor]];
    [[UITextField appearance] setFont:[UIFont fontWithName:MPAppFont size:14.0f]];
    
    // Update Settings Keys
    [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:@"BuildNumberKey"];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"VersionNumberKey"];
    NSLog(@"Build %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"BuildNumberKey"]);
    
    // Handle iCloud Authentication Process
    id currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    
    if (currentiCloudToken) {
        
        NSData *iCloudData = [NSKeyedArchiver archivedDataWithRootObject:currentiCloudToken];
        [[NSUserDefaults standardUserDefaults] setObject:iCloudData forKey:MPiCloudDataKey];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:MPiCloudDataKey];
        
    }
    
    // Add Observer Incase Of Account Change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudChanged) name:NSUbiquityIdentityDidChangeNotification object:nil];
    
    // Add Observer Incase Of Data Change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newData:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:[NSUbiquitousKeyValueStore defaultStore]];
    
    // Data While Inactive, Bring To Memory;
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    // IAP Setup
    self.paymentObserver = [[MPPaymentObserver alloc] init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self.paymentObserver];
    
    // Launch Count
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"LaunchCountKey"]) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"LaunchCountKey"];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"LaunchCountKey"] + 1 forKey:@"LaunchCountKey"];
        
    }
    
    // Handle Analytics
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"LaunchCountKey"] == 1) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MPUsageReportsSettingKey];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:MPUsageReportsSettingKey]) {
        
        [Flurry setCrashReportingEnabled:YES];
        [Flurry startSession:@"995T7XB64VFS4YGD56RM"];
        
    }
    
    
    return YES;
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    application.applicationIconBadgeNumber = 0;
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:MPAutoParkSettingKey]) {
        
        UILocalNotification *alert = [[UILocalNotification alloc] init];
        alert.alertBody = @"Hey, you quit motar! You'll need to open it again for AutoPark.";
        alert.hasAction = NO;
        alert.timeZone = [NSTimeZone defaultTimeZone];
        alert.fireDate = [[NSDate date] dateByAddingTimeInterval:2];
        alert.userInfo = @{@"key": @"exit"};
        [[UIApplication sharedApplication] scheduleLocalNotification:alert];
        
    }
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"Received Local Notification %@", notification);
    NSDictionary *infoDict = notification.userInfo;
    
    if (infoDict[MPNotificationTypeKey] == MPNotificationTypeAutoPark) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MPAutoParkWakeFromAutoParkNotification object:nil];
        
    }
    
}

- (void)iCloudChanged {
 
    NSLog(@"iCloud Availability Changed");
    
    id currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    
    // Check iCloud Availability
    if (currentiCloudToken) {
        
        NSData *oldTokenData = [[NSUserDefaults standardUserDefaults] objectForKey:MPiCloudDataKey];
        id oldToken = [NSKeyedUnarchiver unarchiveObjectWithData:oldTokenData];
        if (![oldToken isEqual: currentiCloudToken]) {
            
            NSData *iCloudData = [NSKeyedArchiver archivedDataWithRootObject:currentiCloudToken];
            [[NSUserDefaults standardUserDefaults] setObject:iCloudData forKey:MPiCloudDataKey];
            
        }
        
        // Refresh Data Caches
        [MPParkInfoViewController refresh];
        [MPPark refresh];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"iCloudDataKey"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MPiCloudSettingKey];
        
        // Migrate iCloud Data
        [MPParkInfoViewController fillLocal];
        [MPPark fillLocal];
        
        // Refresh Data Caches
        [MPParkInfoViewController refresh];
        [MPPark refresh];
        
    }
    
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
}

- (void)newData:(NSUbiquitousKeyValueStore *)store {
    
    NSLog(@"New Data From iCloud Push %@", store);

}

@end

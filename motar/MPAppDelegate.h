//
//  MPAppDelegate.h
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MPColorManager.h"
#import "MPConstants.h"
#import "MPParkInfoViewController.h"
#import "MPPark.h"
#import "MPAutoParkManager.h"
#import "MPPaymentObserver.h"

@interface MPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MPPaymentObserver *paymentObserver;

@end

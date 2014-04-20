//
//  MPMainViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPParkViewController.h"
#import "MPParkInfoViewController.h"
#import "MPColorManager.h"
#import "MPTutorialViewController.h"

@interface MPMainViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong, readonly) UIPageViewController *pageViewController;
@property (nonatomic, strong, readonly) MPParkViewController *parkViewController;
@property (nonatomic, strong, readonly) MPParkInfoViewController *parkInfoViewController;
@property (nonatomic, strong, readonly) UINavigationController *settingsViewController;
@property (nonatomic, strong, readonly) UINavigationController *previousTableViewController;

@property (nonatomic, readonly) MPPark *currentPark;

@end

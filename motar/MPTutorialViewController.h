//
//  MPTutorialViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/16/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPColorManager.h"
#import "MPTutorialParkViewController.h"
#import "MPTutorialParkInfoViewController.h"

@interface MPTutorialViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong, readonly) UIPageViewController *pageViewController;
@property (nonatomic, strong, readonly) MPTutorialParkViewController *parkViewController;
@property (nonatomic, strong, readonly) MPTutorialParkInfoViewController *parkInfoViewController;

@end

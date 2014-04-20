//
//  MPTutorialParkViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/17/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPParkButton.h"
#import "MPParkStatusMeter.h"
#import "MPShortInfoBubble.h"
#import "MPColorManager.h"

@interface MPTutorialParkViewController : UIViewController

@property (nonatomic, weak) UIPageViewController *pageViewController;
@property (nonatomic, assign, readonly) BOOL canContinue;

@property (weak, nonatomic) IBOutlet MPParkButton *tutorialParkButton;
@property (weak, nonatomic) IBOutlet MPParkStatusMeter *tutorialParkStatusMeter;
@property (weak, nonatomic) IBOutlet MPShortInfoBubble *tutorialShortInfoBubble;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

- (IBAction)userPark:(id)sender;
- (IBAction)userComplete:(id)sender;

@end

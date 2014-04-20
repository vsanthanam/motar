//
//  MPAutoParkViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/18/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

#import "MPColorManager.h"
#import "MPAutoParkManager.h"

@interface MPAutoParkViewController : UIViewController

@property (nonatomic, strong, readonly) CMMotionActivityManager *activityManager;
@property (weak, nonatomic) IBOutlet UIImageView *autoParkImageView;
@property (weak, nonatomic) IBOutlet UILabel *autoParkSensorStatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *autoParkSensorActivityIndicator;
@property (weak, nonatomic) IBOutlet UIProgressView *autoParkAccuracyMeter;

- (void)startSensing;
- (void)stopSensing;

- (IBAction)userDone:(id)sender;
- (IBAction)userHelp:(id)sender;


@end

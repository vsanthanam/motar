//
//  MPAutoParkViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/18/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPColorManager.h"
#import "MPAutoParkManager.h"
#import "MPConstants.h"

@interface MPAutoParkViewController : UIViewController

@property (nonatomic, weak) MPAutoParkManager *autoParkManager;
@property (weak, nonatomic) IBOutlet UIImageView *autoParkImageView;
@property (weak, nonatomic) IBOutlet UILabel *autoParkSensorStatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *autoParkSensorActivityIndicator;
@property (weak, nonatomic) IBOutlet UIProgressView *autoParkAccuracyMeter;
@property (weak, nonatomic) IBOutlet UILabel *autoParkAccuracyLabel;

- (IBAction)userDone:(id)sender;
- (IBAction)userHelp:(id)sender;
- (IBAction)userGPS:(id)sender;

@end

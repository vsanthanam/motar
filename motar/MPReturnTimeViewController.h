//
//  MPReturnTimeViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPPark.h"
#import "MPColorManager.h"

@interface MPReturnTimeViewController : UIViewController

@property (nonatomic, weak) MPPark *currentPark;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *parkTimeLabel;

- (IBAction)userHalf:(id)sender;
- (IBAction)userOne:(id)sender;
- (IBAction)userTwo:(id)sender;
- (IBAction)userChangeDate:(id)sender;
- (IBAction)userDone:(id)sender;
- (IBAction)userCancel:(id)sender;

@end

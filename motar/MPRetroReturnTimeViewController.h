//
//  MPRetroReturnTimeViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/16/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPColorManager.h"
#import "MPPark.h"

@interface MPRetroReturnTimeViewController : UIViewController

@property (nonatomic, weak) MPPark *currentPark;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;

- (IBAction)userSelectDate:(id)sender;
- (IBAction)userDone:(id)sender;
- (IBAction)userCancel:(id)sender;

@end

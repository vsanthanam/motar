//
//  MPRetroNameViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/23/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPPark.h"
#import "MPColorManager.h"

@interface MPRetroNameViewController : UIViewController

@property (nonatomic, weak) MPPark *currentPark;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

- (IBAction)userDone:(id)sender;
- (IBAction)userCancel:(id)sender;


@end

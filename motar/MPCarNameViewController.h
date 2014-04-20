//
//  MPCarNameViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/14/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPPark.h"
#import "MPColorManager.h"

@interface MPCarNameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *carNameField;

- (IBAction)userDone:(id)sender;

@end

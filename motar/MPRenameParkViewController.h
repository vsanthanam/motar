//
//  MPRenameParkViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/21/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPColorManager.h"
#import "MPPark.h"

@interface MPRenameParkViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) MPPark *currentPark;

- (IBAction)userDone:(id)sender;
- (IBAction)userCancel:(id)sender;


@end

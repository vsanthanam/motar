//
//  MPDataStorageViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/16/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPColorManager.h"
#import "MPPark.h"
#import "MPParkInfoViewController.h"

@interface MPDataStorageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *iCloudSwitch;

- (IBAction)userDone:(id)sender;

@end

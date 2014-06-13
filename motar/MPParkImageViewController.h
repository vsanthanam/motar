//
//  MPParkImageViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/16/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPColorManager.h"
#import "MPPark.h"

@interface MPParkImageViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, weak) MPPark *currentPark;

- (IBAction)userDone:(id)sender;
- (IBAction)userDelete:(id)sender;

@end

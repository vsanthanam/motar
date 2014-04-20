//
//  MPPinColorTableViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/14/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPParkInfoViewController.h"
#import "MPColorManager.h"

@interface MPPinColorTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *redCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *greenCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *purpleCell;

@end

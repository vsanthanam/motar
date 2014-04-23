//
//  MPSettingsTableViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/14/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MPAutoParkManager.h"
#import "MPColorManager.h"
#import "MPPark.h"
#import "MPParkInfoViewController.h"
#import "MPTutorialViewController.h"

@interface MPSettingsTableViewController : UITableViewController <UIActionSheetDelegate, SKProductsRequestDelegate>

@property (strong, nonatomic) NSArray *productCatalogue;
@property (strong, nonatomic) NSMutableDictionary *availableProducts;

@property (weak, nonatomic) IBOutlet UISwitch *iCloudSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoParkSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *carNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *pinColorCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *iCloudCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *clearHistoryCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *resetAppCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *autoParkCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *tutorialCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *websiteCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *shareAppCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *removeAdsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *restoreCell;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *removeAdsLabel;
@property (weak, nonatomic) IBOutlet UILabel *restoreLabel;

- (IBAction)useriCloud:(id)sender;
- (IBAction)userAutoPark:(id)sender;

@end
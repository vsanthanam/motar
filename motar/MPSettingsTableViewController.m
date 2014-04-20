//
//  MPSettingsTableViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/14/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPSettingsTableViewController.h"

@interface MPSettingsTableViewController () {
    
    UIActionSheet *_autoParkActionSheet;
    UIActionSheet *_historyActionSheet;
    UIActionSheet *_resetActionSheet;
    UIActionSheet *_confirmActionSheet;
    
}

@end

@implementation MPSettingsTableViewController

@synthesize iCloudSwitch = _iCloudSwitch;
@synthesize autoParkSwitch = _autoParkSwitch;
@synthesize carNameCell = _carNameCell;
@synthesize pinColorCell = _pinColorCell;
@synthesize iCloudCell = _iCloudCell;
@synthesize clearHistoryCell = _clearHistoryCell;
@synthesize resetAppCell = _resetAppCell;
@synthesize autoParkCell = _autoParkCell;
@synthesize tutorialCell = _tutorialCell;
@synthesize websiteCell = _websiteCell;
@synthesize shareAppCell = _shareAppCell;
@synthesize nameLabel = _nameLabel;
@synthesize colorLabel = _colorLabel;

#pragma mark - UIActionSheetDelegate Protocol Instance Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet == self->_autoParkActionSheet) {
        
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AutoParkKey"];
            
        } else {
            
            [self.autoParkSwitch setOn:NO animated:YES];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AutoParkKey"];
            
        }
        
    } else if (actionSheet == self->_historyActionSheet) {
        
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            
            [MPPark clearArchives];
            
        }
        
    } else if (actionSheet == self->_resetActionSheet) {
        
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            
            self->_confirmActionSheet = [[UIActionSheet alloc] initWithTitle:@"Are You Sure?"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Cancel"
                                                      destructiveButtonTitle:@"Yes, I'm Sure"
                                                           otherButtonTitles:nil];
            [self->_confirmActionSheet showInView:[UIApplication sharedApplication].keyWindow];
            
        }
        
    } else if (actionSheet == self->_confirmActionSheet) {
        
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"iCloudKey"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AutoParkKey"];
            [MPPark resetDefaultTag];
            [MPPark clearArchives];
            [MPParkInfoViewController setPinColor:MKPinAnnotationColorRed];
            [MPPark clearSave];
            [self.iCloudSwitch setOn:NO animated:YES];
            [self.autoParkSwitch setOn:NO animated:YES];
        
        }
        
    }
    
}

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [MPColorManager lightColor];
    self.carNameCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.pinColorCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.iCloudCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.clearHistoryCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.resetAppCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.autoParkCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.tutorialCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.websiteCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.shareAppCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudRefresh) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self refreshUI];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Protocol Instance Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        [self performSegueWithIdentifier:@"CarNameSegue" sender:indexPath];
        
    } else if (indexPath.row == 1 && indexPath.section == 0) {
        
        [self performSegueWithIdentifier:@"PinColorSegue" sender:indexPath];
        
    } else if (indexPath.row == 0 && indexPath.section == 1) {
        
        [self userClearHistory];
        
    } else if (indexPath.row == 1 && indexPath.section == 1) {
        
        [self userResetapp];
    
    } else if (indexPath.row == 0 && indexPath.section == 2) {
        
        [self userTutorial];
        
    } else if (indexPath.row == 1 && indexPath.section == 2) {
    
        [self userWebsite];
        
    } else if (indexPath.row == 0 && indexPath.section == 3) {
        
        [self userShareApp];
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (![MPAutoParkManager canTrack]) {
        
        return 5;
        
    }
    
    return 6;
    
}

#pragma mark - Private Instance Methods

- (void)userClearHistory {
    
    self->_historyActionSheet = [[UIActionSheet alloc] initWithTitle:@"You cannot undo this."
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:@"Clear History"
                                                   otherButtonTitles:nil];
    [self->_historyActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (void)userResetapp {
    
    self->_resetActionSheet = [[UIActionSheet alloc] initWithTitle:@"You cannot undo this."
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:@"Reset"
                                                 otherButtonTitles:nil];
    [self->_resetActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (void)userTutorial {
    
    MPTutorialViewController *viewController = (MPTutorialViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (void)userWebsite {
    
    NSURL *url = [NSURL URLWithString:@"http://www.santhanams.net/apps/parkbuddy"];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void)userShareApp {
    
    static NSString *shareString = @"Check out ParkMotion! It's a smart parking app that reminds you where you parked your car and helps you avoid parking tickets! ParkMotion";
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[shareString] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (void)refreshUI {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AutoParkKey"]) {
        
        [self.autoParkSwitch setOn:NO animated:YES];
        
    } else {
        
        [self.autoParkSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"AutoParkKey"] animated:YES];
        
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"iCloudDataKey"]) {
        
        self.iCloudSwitch.enabled = NO;
        
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudKey"]) {
        
        [self.iCloudSwitch setOn:NO animated:YES];
        
    } else {
        
        [self.iCloudSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudKey"]];
        
    }
    
    self.nameLabel.text = [MPPark defaultTag];
    NSString *colorText;
    MKPinAnnotationColor color = [MPParkInfoViewController pinColor];
    
    switch (color) {
        case MKPinAnnotationColorRed:
            colorText = @"Red";
            break;
            
        case MKPinAnnotationColorGreen:
            colorText = @"Green";
            break;
            
        case MKPinAnnotationColorPurple:
            colorText = @"Purple";
            break;
    }
    
    self.colorLabel.text = colorText;
    
}

- (void)iCloudRefresh {
    
    [MPPark refresh];
    [MPParkInfoViewController refresh];
    [self refreshUI];
    
}

#pragma mark - Actions

- (IBAction)useriCloud:(id)sender {
    
    if ([self.iCloudSwitch isOn]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"iCloudKey"];
        [MPParkInfoViewController filliCloud];
        [MPPark filliCloud];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iCloudKey"];
        [MPParkInfoViewController fillLocal];
        [MPPark fillLocal];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

- (IBAction)userAutoPark:(id)sender {
    
    if ([self.autoParkSwitch isOn]) {
        
        self->_autoParkActionSheet = [[UIActionSheet alloc] initWithTitle:@"AutoPark uses data from your phone's motion and gps sensors to remind you use the app. All tracking data is stored on the device only and destroyed after each use. This feature can be disabled at anytime"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Enable AutoPark"
                                                        otherButtonTitles:nil];
        [self->_autoParkActionSheet showInView:[UIApplication sharedApplication].keyWindow];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AutoParkKey"];
        
    }
    
}
@end

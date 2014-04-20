//
//  MPDataStorageViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/16/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPDataStorageViewController.h"

@interface MPDataStorageViewController ()

@end

@implementation MPDataStorageViewController

@synthesize iCloudSwitch = _iCloudSwitch;

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [MPColorManager lightColor];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)userDone:(id)sender {
    
    if ([self.iCloudSwitch isOn]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"iCloudKey"];
        [MPPark filliCloud];
        [MPParkInfoViewController filliCloud];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iCloudKey"];
        [MPPark fillLocal];
        [MPParkInfoViewController fillLocal];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"iCloudPromptKey"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}
@end

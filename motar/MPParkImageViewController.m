//
//  MPParkImageViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/16/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPParkImageViewController.h"

@interface MPParkImageViewController ()

@end

@implementation MPParkImageViewController

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

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

@end

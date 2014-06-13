//
//  MPRenameParkViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/21/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPRenameParkViewController.h"

@interface MPRenameParkViewController ()

@end

@implementation MPRenameParkViewController

@synthesize nameField = _nameField;

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [MPColorManager lightColor];
    self.nameField.placeholder = [MPPark defaultTag];
    
    if (![self.currentPark.parkTag isEqualToString:[MPPark defaultTag]]) {
        
        self.nameField.text = self.currentPark.parkTag;
        
    }
    
    [self.nameField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Actions

- (IBAction)userDone:(id)sender {
    
    if (![self.nameField.text isEqualToString:@""]) {
        
        self.currentPark.parkTag = self.nameField.text;
        
    } else {
        
        self.currentPark.parkTag = [MPPark defaultTag];
        
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)userCancel:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

@end

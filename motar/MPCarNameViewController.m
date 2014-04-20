//
//  MPCarNameViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/14/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPCarNameViewController.h"

@interface MPCarNameViewController ()

@end

@implementation MPCarNameViewController

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [MPColorManager lightColor];
    self.carNameField.placeholder = @"My Car";
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.carNameField becomeFirstResponder];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (![[MPPark defaultTag] isEqualToString:@"My Car"]) {
        
        self.carNameField.text = [MPPark defaultTag];
        
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    if (![self.carNameField.text isEqualToString:@""]) {
        
        [MPPark setDefaultTag:self.carNameField.text];
        
    } else {
        
        [MPPark resetDefaultTag];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)userDone:(id)sender {
    
    if (![self.carNameField.text isEqualToString:@""]) {
        
        [MPPark setDefaultTag:self.carNameField.text];
        
    } else {
        
        [MPPark resetDefaultTag];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end

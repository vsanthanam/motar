//
//  MPRetroNameViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/23/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPRetroNameViewController.h"

@interface MPRetroNameViewController ()

@end

@implementation MPRetroNameViewController

@synthesize currentPark = _currentPark;
@synthesize nameField = _nameField;

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [MPColorManager lightColor];
    self.nameField.placeholder = [MPPark defaultTag];
    self.nameField.text = self.currentPark.parkTag;
    [self.nameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Actions

- (IBAction)userDone:(id)sender {
    
    
    NSString *input = self.nameField.text;
    if (![input isEqualToString:@""]) {
        
        self.currentPark.parkTag = input;
        
    } else {
        
        self.currentPark.parkTag = [MPPark defaultTag];
        
    }
    [self.currentPark updateArchive];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)userCancel:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

@end

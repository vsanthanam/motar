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

@implementation MPParkImageViewController {
    
    UIActionSheet *_confirmActionSheet;
    
}

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [MPColorManager lightColor];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIActionSheetDelegate Protocol Instance Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet == self->_confirmActionSheet) {
        
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            
            [self deleteImage];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }
        
    }
    
}



#pragma mark - Private Instance Methods

- (void)deleteImage {
    
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = nil;
    self.currentPark.parkImage = nil;
    
}



#pragma mark - Actions

- (IBAction)userDone:(id)sender {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)userDelete:(id)sender {
    
    self->_confirmActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:@"Delete"
                                                   otherButtonTitles:nil];
    [self->_confirmActionSheet showInView:self.view];
    
}

@end

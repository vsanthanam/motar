//
//  MPRetroReturnTimeViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/16/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPRetroReturnTimeViewController.h"

@interface MPRetroReturnTimeViewController ()

@end

@implementation MPRetroReturnTimeViewController

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [MPColorManager lightColor];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.datePicker setDate:self.currentPark.returnDate animated:animated];
    [self updateTimeLabel];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private Instance Methods

- (void)updateTimeLabel {
    
    NSTimeInterval interval = [self.datePicker.date timeIntervalSinceDate:self.currentPark.parkDate];
    
    NSInteger seconds = (NSInteger)interval;
    NSInteger days = 0;
    NSInteger hours = 0;
    NSInteger minutes = 0;
    
    while (seconds >= 86400) {
        
        seconds -= 86400;
        days++;
        
    }
    
    while (seconds >= 3600) {
        
        seconds -= 3600;
        hours++;
        
    }
    
    while (seconds >= 60) {
        
        seconds -= 60;
        minutes++;
        
    }
    
    NSString *lengthString;
    if (days > 0) {
        
        lengthString = [NSString stringWithFormat:@"%liD%liH%liM", (long)days, (long)hours, (long)minutes];
        
    } else {
        
        lengthString = [NSString stringWithFormat:@"%liH%liM", (long)hours, (long)minutes];
        
    }
    [UIView transitionWithView:self.lengthLabel
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        self.lengthLabel.text = lengthString;
                        
                    }
                    completion:nil];
    
}



#pragma mark - Actions

- (IBAction)userSelectDate:(id)sender {
    
    if ([self.datePicker.date timeIntervalSinceNow] > 0) {
        
        [self.datePicker setDate:[NSDate date] animated:YES];
        
    } else if ([self.datePicker.date timeIntervalSinceDate:self.currentPark.parkDate] < 0) {
        
        [self.datePicker setDate:self.currentPark.parkDate animated:YES];
        
    }
    
    [self updateTimeLabel];
    
}

- (IBAction)userDone:(id)sender {
    
    self.currentPark.returnDate = self.datePicker.date;
    [self.currentPark updateArchive];
    
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)userCancel:(id)sender {
    
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

@end

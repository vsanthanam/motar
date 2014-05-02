//
//  MPReturnTimeViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPReturnTimeViewController.h"

@interface MPReturnTimeViewController ()

@end

@implementation MPReturnTimeViewController
@synthesize timeLeftLabel = _timeLeftLabel;
@synthesize reminderSwitch = _reminderSwitch;
@synthesize datePicker = _datePicker;
@synthesize parkTimeLabel = _parkTimeLabel;

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.view.backgroundColor = [MPColorManager lightColor];
    
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.currentPark.returnDate) {
        
        [self.datePicker setDate:self.currentPark.returnDate animated:YES];
        if (self.currentPark.parkReminder) {
            
            [self.reminderSwitch setOn:YES animated:YES];
            
        } else {
            
            [self.reminderSwitch setOn:NO animated:YES];
            
        }
        
    } else {
        
        NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComponents = [calender components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:self.currentPark.parkDate];
        dateComponents.minute += 30;
        NSDate *defaultDate = [calender dateFromComponents:dateComponents];
        [self.datePicker setDate:defaultDate animated:YES];
        
        
    }
    [self updateTimeLeft];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSString *dateString = [dateFormatter stringFromDate:self.currentPark.parkDate];
    self.parkTimeLabel.text = [NSString stringWithFormat:@"Time after %@", dateString];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Private Instance Methods

- (void)updateTimeLeft {
    
    NSInteger days = 0;
    NSInteger hours = 0;
    NSInteger minutes = 0;
    NSTimeInterval interval = [self.datePicker.date timeIntervalSinceDate:self.currentPark.parkDate];
    NSInteger seconds = (NSInteger)interval;
    
    if (interval < 0) {
        
        [self.datePicker setDate:self.currentPark.parkDate animated:YES];
        [self updateTimeLeft];
        
    }
    
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
    
    NSString *timeLeftString;
    if (days > 0) {
        
        timeLeftString = [NSString stringWithFormat:@"%liD%liH%liM", (long)days, (long)hours, (long)minutes];
        
    } else {
        
        timeLeftString = [NSString stringWithFormat:@"%liH%liM", (long)hours, (long)minutes];
        
    }
    
    [UIView transitionWithView:self.timeLeftLabel
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                       
                        self.timeLeftLabel.text = timeLeftString;
                        
                    }
                    completion:nil];
    
    if (interval <= 900) {
        
        [self.reminderSwitch setOn:NO animated:YES];
        self.reminderSwitch.enabled = NO;
        
    } else {
        
        if (!self.reminderSwitch.enabled) {
            
            self.reminderSwitch.enabled = YES;
            [self.reminderSwitch setOn:YES animated:YES];
            
        }
        
    }
    
    
}

#pragma mark - Actions

- (IBAction)userHalf:(id)sender {
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calender components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:self.currentPark.parkDate];
    dateComponents.minute += 30;
    [self.datePicker setDate:[calender dateFromComponents:dateComponents] animated:YES];
    [self updateTimeLeft];
    
}

- (IBAction)userOne:(id)sender {
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calender components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:self.currentPark.parkDate];
    dateComponents.hour++;
    [self.datePicker setDate:[calender dateFromComponents:dateComponents] animated:YES];
    [self updateTimeLeft];
}

- (IBAction)userTwo:(id)sender {
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calender components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:self.currentPark.parkDate];
    dateComponents.hour += 2;
    [self.datePicker setDate:[calender dateFromComponents:dateComponents] animated:YES];
    [self updateTimeLeft];
}

- (IBAction)userChangeDate:(id)sender {
    
    [self updateTimeLeft];
}

- (IBAction)userDone:(id)sender {
    
    self.currentPark.returnDate = self.datePicker.date;
    if ([self.reminderSwitch isOn]) {
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:self.currentPark.returnDate];
        dateComponents.minute -= 15;
        NSDate *reminderDate = [calendar dateFromComponents:dateComponents];
        
        NSLog(@"%@", reminderDate);
        
        UILocalNotification *parkReminder = [[UILocalNotification alloc] init];
        parkReminder.hasAction = NO;
        parkReminder.alertBody = @"Your parking expires in 15 minutes";
        parkReminder.fireDate = reminderDate;
        parkReminder.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        parkReminder.timeZone = [NSTimeZone defaultTimeZone];
        parkReminder.soundName = @"expired.mp3";
        parkReminder.userInfo = @{@"key": @"reminder", @"returnDate": self.currentPark.returnDate};
        self.currentPark.parkReminder = parkReminder;
        
    } else {
        
        self.currentPark.parkReminder = nil;
        
    }
    
    UILocalNotification *expirationReminder = [[UILocalNotification alloc] init];
    expirationReminder.hasAction = NO;
    expirationReminder.alertBody = @"Your parking has expired.";
    expirationReminder.fireDate = self.currentPark.returnDate;
    expirationReminder.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    expirationReminder.timeZone = [NSTimeZone defaultTimeZone];
    expirationReminder.soundName = @"expired.mp3";
    expirationReminder.userInfo = @{@"key": @"expired", @"returnDate": self.currentPark.returnDate};
    [[UIApplication sharedApplication] scheduleLocalNotification:expirationReminder];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)userCancel:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
@end

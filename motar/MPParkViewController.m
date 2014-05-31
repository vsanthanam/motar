//
//  MPParkViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPParkViewController.h"

@interface MPParkViewController ()

@end

@implementation MPParkViewController {
    
    UIAlertView *_locationAlert;
    UIAlertView *_autoParkAlert;
    UIAlertView *_rateAppAlert;
    NSTimer *_theTimer;
    
}

@synthesize pageViewController = _pageViewController;
@synthesize currentPark = _currentPark;
@synthesize locationManager = _locationManager;
@synthesize autoParkManager = _autoParkManager;

@synthesize parkButton = _parkButton;
@synthesize parkStatusMeter = _parkStatusMeter;
@synthesize activityIndicator = _activityIndicator;
@synthesize shortInfoBubble = _shortInfoBubble;
@synthesize helperLabel = _helperLabel;
@synthesize motionIndicatorButton = _motionIndicatorButton;

#pragma mark - Property Access Instance Methods

- (CLLocationManager *)locationManager {
    
    if (!self->_locationManager) {
        
        self->_locationManager = [[CLLocationManager alloc] init];
        self->_locationManager.delegate = self;
        self->_locationManager.pausesLocationUpdatesAutomatically = NO;
        
    }
    
    return self->_locationManager;
    
}

- (MPAutoParkManager *)autoParkManager {
    
    if (!self->_autoParkManager) {
        
        self->_autoParkManager = [MPAutoParkManager managerWithDelegate:self];
        
    }
    
    return self->_autoParkManager;
    
}

- (BOOL)canShowAds {
    
    return ![[NSUserDefaults standardUserDefaults] boolForKey:@"com.varunsanthanam.motar.noads"];
    
}

- (BOOL)canFlurry {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:MPUsageReportsSettingKey];
    
}

#pragma mark - MPAutoParkManagerDelegate Protocol Instance Methods

- (BOOL)autoParkManagerShouldTrack:(MPAutoParkManager *)manager {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:MPAutoParkSettingKey];
    
}

- (void)autoParkManagerDidStartTracking:(MPAutoParkManager *)manager {
    
    [self showSensorIndicator];
    
}

- (void)autoParkManagerDidStopTracking:(MPAutoParkManager *)manager {
    
    [self hideSensorIndicator];
    
}

- (void)autoParkManager:(MPAutoParkManager *)manager didTrackNewActivity:(CMMotionActivity *)activity {
    
}

- (void)autoParkManager:(MPAutoParkManager *)manager didTrackNewLocation:(CLLocation *)location {
    
}

- (void)autoParkManagerThinksUserParked:(MPAutoParkManager *)manager {
    
    UILocalNotification *reminder = [[UILocalNotification alloc] init];
    reminder.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
    reminder.alertBody = @"Did you park your car?";
    reminder.timeZone = [NSTimeZone defaultTimeZone];
    reminder.soundName = UILocalNotificationDefaultSoundName;
    reminder.userInfo = @{MPNotificationTypeKey: MPNotificationTypeAutoPark};
    [[UIApplication sharedApplication] scheduleLocalNotification:reminder];
    [self.autoParkManager stopTracking];
    [self.autoParkManager startTracking];
    
}

#pragma mark - CLLocationManagerDelegate Protocol Instance Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [locations lastObject];
    NSLog(@"USER: %@", location);
    NSTimeInterval interval = [location.timestamp timeIntervalSinceNow];
    if (abs(interval) < 2) {
        
        self.currentPark.parkLocation = location;
        [manager stopUpdatingLocation];
        [self completePark];
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (error != nil) {
        
        self->_locationAlert = [[UIAlertView alloc] initWithTitle:@"Location Error"
                                                          message:[NSString stringWithFormat:@"Failed to get location with error %@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [self->_locationAlert show];
        [self stopLoading];
        [manager stopUpdatingLocation];
        
    }
    
}

#pragma mark - ADBannerViewDelegate Protocol Instance Methods

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    if (error != NULL) {
        
        [self hideAds];
        
    }
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    [self showAds];
    
}

#pragma mark - UIAlertViewDelegate Protocol Instance Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == self->_rateAppAlert) {
        
        if (buttonIndex != alertView.cancelButtonIndex) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.appstore.com/varunsanthanam/motar"]];
            
        }
        
    }
    
}

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self prepareUI];
    
    [self.autoParkManager startTracking];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if ([self.currentPark isParked]) {
        
        [self parkedUI:NO];
        
    } else {
        
        [self standbyUI:NO];
        
    }
    
    if ([self.autoParkManager.delegate autoParkManagerShouldTrack:self.autoParkManager] && ![[NSUserDefaults standardUserDefaults] boolForKey:@"AutoParkPromptKey"]) {
        
        self->_autoParkAlert = [[UIAlertView alloc] initWithTitle:@"Motion Indicator"
                                                          message:@"The motion indicator appears whenver motar is gathering data from your device. Tap on the indicator for more info!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [self->_autoParkAlert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AutoParkPromptKey"];
        
    }
    
    if (![self canShowAds]) {
        
        [self hideAds];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"LaunchCountKey"] == 3 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"RateAppPromptKey"]) {
        
        self->_rateAppAlert = [[UIAlertView alloc] initWithTitle:@"Enjoying Motar?"
                                                         message:@"If you like motar, spread the word! We'd really appreciate a good review!"
                                                        delegate:self
                                               cancelButtonTitle:@"No, Thanks"
                                               otherButtonTitles:@"Review App", nil];
        [self->_rateAppAlert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RateAppPromptKey"];
        
    }
    
    if (!self.autoParkManager.tracking) {
        
        [self.autoParkManager startTracking];
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"AutoParkSegue"]) {
        
        MPAutoParkViewController *viewController = (MPAutoParkViewController *)[segue destinationViewController];
        viewController.autoParkManager = self.autoParkManager;
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Instance Methods

- (void)prepareUI {
    
    self.view.backgroundColor = [MPColorManager lightColor];
    
    if (!self.currentPark) {
        
        self.currentPark = [MPPark parkFromSave];
        
    }
    
    self.adBanner.alpha = 0.0;
    self.adBanner.hidden = YES;
    self.adBanner.delegate = self;
    
    self.parkButton.backgroundColor = [UIColor clearColor];
    self.parkStatusMeter.backgroundColor = [UIColor clearColor];
    self.shortInfoBubble.backgroundColor = [UIColor clearColor];
    
}

- (void)parkedUI:(BOOL)animated {
    
    if (animated) {
        
        [UIView transitionWithView:self.parkStatusMeter
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            
                            [self.parkStatusMeter setParked];
                            
                        }
                        completion:nil];
        
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             self.parkButton.alpha = 0.0;
                             
                         }
                         completion:^(BOOL finished){
                             
                             if (finished) {
                                 
                                 self.parkButton.hidden = YES;
                                 
                             }
                             self.shortInfoBubble.hidden = NO;
                             [UIView animateWithDuration:0.5
                                              animations:^{
                                                  
                                                  self.shortInfoBubble.alpha = 1.0;
                                                  
                                              }
                                              completion:^(BOOL finishd) {
                                                  
                                                  self.helperLabel.alpha = 0.0;
                                                  self.helperLabel.hidden = NO;
                                                  [UIView animateWithDuration:1.0
                                                                   animations:^{
                                                                       
                                                                       self.helperLabel.alpha = 1.0;
                                                                       
                                                                   }
                                                                   completion:^(BOOL finished) {
                                                                       
                                                                       [UIView animateWithDuration:1.0
                                                                                             delay:1.0
                                                                                           options:UIViewAnimationOptionCurveEaseInOut
                                                                                        animations:^{
                                                                                            
                                                                                            self.helperLabel.alpha = 0.0;
                                                                                            
                                                                                        }
                                                                                        completion:^(BOOL finished) {
                                                                                            
                                                                                            self.helperLabel.hidden = YES;
                                                                                            
                                                                                        }];
                                                                       
                                                                   }];
                                                  
                                              }];
                             
                         }];
        
        
    } else {
        
        [self.parkStatusMeter setParked];
        self.parkButton.hidden = YES;
        
    }
    
    [self fixPages];
    [self updateTimeLeft];
    
    if (self.currentPark.returnDate && [self.currentPark.returnDate timeIntervalSinceNow] > 0) {
        
        if (!self->_theTimer) {
            
            self->_theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLeft) userInfo:nil repeats:YES];
            
        }
        
    }
    
}

- (void)standbyUI:(BOOL)animated {
    
    if (animated) {
        
        [UIView transitionWithView:self.parkStatusMeter
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            
                            [self.parkStatusMeter setNotParked];
                            
                        }
                        completion:nil];
        self.parkButton.hidden = NO;
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             self.parkButton.alpha = 1.0;
                             
                         }
                         completion:nil];
        [UIView animateWithDuration:0.5
                         animations:^{
                          
                             self.shortInfoBubble.alpha = 0.0;
                             
                         }
                         completion:^(BOOL finished) {
                           
                             self.shortInfoBubble.hidden = YES;
                             
                         }];
        
    } else {
        
        [self.parkStatusMeter setNotParked];
        self.parkButton.hidden = NO;
        self.parkButton.alpha = 1.0;
        self.shortInfoBubble.hidden = YES;
        
    }
    
    [self fixPages];
    [self updateTimeLeft];
    
}

- (void)parkHere {
    
    [self.autoParkManager stopTracking];
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        
    } else {
        
        _locationAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Unavailable"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [self->_locationAlert show];
        
    }
    
}

- (void)completePark {
    
    [self.currentPark park];
    [self.currentPark savePark];
    [self parkedUI:YES];
    [self stopLoading];
    [self.autoParkManager startTracking];
    
}

- (void)findCar {
    
    [self.currentPark complete];
    [MPPark archivePark:self.currentPark];
    [MPPark clearSave];
    self.currentPark = [MPPark parkFromSave];
    
}

- (void)startLoading {
    
    [self.activityIndicator startAnimating];
    
}

- (void)stopLoading {
    
    [self.activityIndicator stopAnimating];
    
}

- (void)fixPages {
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.pageViewController setViewControllers:@[self]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        
    });
    
}

- (void)updateTimeLeft {
    
    if (!self.currentPark.returnDate) {
        
        [UIView transitionWithView:self.timeLeftLabel
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.timeLeftLabel.text = @"unlimited.";
                            
                        }
                        completion:nil];
        
    } else {
        
        NSTimeInterval interval = [self.currentPark.returnDate timeIntervalSinceNow];
        
        if (interval < 0) {
            
            [UIView transitionWithView:self.timeLeftLabel
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                
                                self.timeLeftLabel.text = @"expired!";
                                
                            }
                            completion:nil];
            
        } else {
            
            NSInteger seconds = (NSInteger)interval;
            NSInteger days = 0;
            NSInteger hours = 0;
            NSInteger minutes = 0;
            
            while (seconds >= 86400) {
                
                days++;
                seconds -= 86400;
                
            }
            
            while (seconds >= 3600) {
                
                hours++;
                seconds -= 3600;
                
            }
            
            while (seconds >= 60) {
                
                minutes++;
                seconds -= 60;
                
            }
            
            [UIView transitionWithView:self.timeLeftLabel
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                              
                                if (days > 0) {
                                    
                                    self.timeLeftLabel.text = [NSString stringWithFormat:@"%liD%liH%liM", (long)days, (long)hours, (long)minutes];
                                    
                                } else {
                                    
                                    self.timeLeftLabel.text = [NSString stringWithFormat:@"%liH%liM", (long)hours, (long)minutes];
                                    
                                }
                                
                            }completion:nil];
            
        }
        
    }
    
}

- (void)showSensorIndicator {
    
    [UIView animateWithDuration:1.0
                     animations:^{
                        
                         self.motionIndicatorButton.alpha = 1.0;
                         
                     }];
    
}

- (void)hideSensorIndicator {
    
    [UIView animateWithDuration:1.0
                     animations:^{
                        
                         self.motionIndicatorButton.alpha = 0.0;
                         
                     }];
    
}

#pragma mark - Public Instance Methods

- (void)showAds {
    
    if ([self canShowAds]) {
        
        self.adBanner.hidden = NO;
        [UIView animateWithDuration:1.0
                         animations:^{
                             
                             self.adBanner.alpha = 1.0;
                             
                         }
                         completion:nil];
        
    }
}

- (void)hideAds {
    
    [UIView animateWithDuration:0.5
                     animations:^{
                     
                         self.adBanner.alpha = 0.0;
                         
                     }
                     completion:^(BOOL finished) {
                        
                         self.adBanner.hidden = YES;
                         
                     }];
    
}


#pragma mark - Actions

- (IBAction)userParkCar:(id)sender {
    
    if (self.currentPark.parkStatus == MPParkStatusStandby) {
        
        [self startLoading];
        [self parkHere];
        if ([self canFlurry]) {
            
            [Flurry logEvent:@"User Park"];
            
        }
        
    }
    
}

- (IBAction)userFindCar:(id)sender {
    
    if ([self.currentPark isParked]) {
        
        [self findCar];
        [self standbyUI:YES];
        if ([self canFlurry]) {
            
            [Flurry logEvent:@"User Un-Park"];
            
        }
        
    }
    
    if (!self.autoParkManager.tracking) {
        
        [self.autoParkManager startTracking];
        
    } else {
        
        [self.autoParkManager stopTracking];
        [self.autoParkManager startTracking];
        
    }
    
}

- (IBAction)userAutoPark:(id)sender {
    
    [self performSegueWithIdentifier:@"AutoParkSegue" sender:sender];
    
}
@end

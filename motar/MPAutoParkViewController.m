//
//  MPAutoParkViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/18/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPAutoParkViewController.h"

@interface MPAutoParkViewController ()

@end

@implementation MPAutoParkViewController {
    
    UIAlertView *_helpAlert;
    
}

@synthesize activityManager = _activityManager;
@synthesize autoParkImageView = _autoParkImageView;
@synthesize autoParkSensorStatusLabel = _autoParkSensorStatusLabel;
@synthesize autoParkAccuracyMeter = _autoParkAccuracyMeter;

#pragma mark - Property Access Methods

- (CMMotionActivityManager *)activityManager {
    
    if (!self->_activityManager) {
        
        self->_activityManager = [[CMMotionActivityManager alloc] init];
        
    }
    
    return self->_activityManager;
    
}

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [MPColorManager lightColor];
    self.autoParkSensorActivityIndicator.hidesWhenStopped = YES;
    if ([MPAutoParkManager canTrack]) {
        
        [self startSensing];
        
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Private Instance Methods

- (void)didTrackNewActivity:(CMMotionActivity *)activity {
    
    switch (activity.confidence) {
        case CMMotionActivityConfidenceHigh:
            [self.autoParkAccuracyMeter setProgress:0.75 animated:YES];
            [self.autoParkAccuracyMeter setTintColor:[UIColor greenColor]];
            break;
        
        case CMMotionActivityConfidenceMedium:
            [self.autoParkAccuracyMeter setProgress:0.5 animated:YES];
            [self.autoParkAccuracyMeter setTintColor:[UIColor yellowColor]];
            break;
            
        default:
            [self.autoParkAccuracyMeter setProgress:0.25 animated:YES];
            [self.autoParkAccuracyMeter setTintColor:[UIColor redColor]];
            break;
    }
    
    if (activity.automotive) {
        
        [self.autoParkSensorActivityIndicator stopAnimating];
        [UIView transitionWithView:self.autoParkImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.autoParkImageView.image = [UIImage imageNamed:@"automotive.png"];
                            
                        }
                        completion:nil];
        [UIView transitionWithView:self.autoParkSensorStatusLabel
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.autoParkSensorStatusLabel.text = @"automotive";
                            
                        }
                        completion:nil];
        
    } else if (activity.stationary) {
        
        [self.autoParkSensorActivityIndicator stopAnimating];
        [UIView transitionWithView:self.autoParkImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.autoParkImageView.image = [UIImage imageNamed:@"stationary.png"];
                            
                        }
                        completion:nil];
        [UIView transitionWithView:self.autoParkSensorStatusLabel
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.autoParkSensorStatusLabel.text = @"stationary";
                            
                        }
                        completion:nil];
        
    } else if (activity.walking) {
        
        [self.autoParkSensorActivityIndicator stopAnimating];
        [UIView transitionWithView:self.autoParkImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.autoParkImageView.image = [UIImage imageNamed:@"walking.png"];
                            
                        }
                        completion:nil];
        [UIView transitionWithView:self.autoParkSensorStatusLabel
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.autoParkSensorStatusLabel.text = @"walking";
                            
                        }
                        completion:nil];
        
    } else  if (activity.running) {
        
        [self.autoParkSensorActivityIndicator stopAnimating];
        [UIView transitionWithView:self.autoParkImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.autoParkImageView.image = [UIImage imageNamed:@"running.png"];
                            
                        }
                        completion:nil];
        [UIView transitionWithView:self.autoParkSensorStatusLabel
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.autoParkSensorStatusLabel.text = @"running";
                            
                        }
                        completion:nil];
        
    } else if (activity.unknown) {
        
        [self.autoParkSensorActivityIndicator stopAnimating];
        [UIView transitionWithView:self.autoParkImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.autoParkImageView.image = [UIImage imageNamed:@"error.png"];
                            
                        }
                        completion:nil];
        [UIView transitionWithView:self.autoParkSensorStatusLabel
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.autoParkSensorStatusLabel.text = @"unknown";
                            
                        }
                        completion:nil];
        
    } else {
        
        [self.autoParkSensorActivityIndicator startAnimating];
        [UIView transitionWithView:self.autoParkSensorStatusLabel
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.autoParkSensorStatusLabel.text = @"calculating";
                            
                        }
                        completion:nil];
        
        [self.autoParkAccuracyMeter setProgress:0.0 animated:YES];
        
    }
    
}

#pragma mark - Public Instance Methods

- (void)stopSensing {
    
    [self.activityManager stopActivityUpdates];
    self->_activityManager = nil;
    
}

- (void)startSensing {
    
    [self.autoParkSensorActivityIndicator startAnimating];
    [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMMotionActivity *activity) {
        
        [self didTrackNewActivity:activity];
        
    }];
    
}


#pragma mark - Actions

- (IBAction)userDone:(id)sender {
    
    [self stopSensing];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)userHelp:(id)sender {
    
    static NSString *helpMessage = @"AutoPark uses information form your phone's GPS and motion sensors to decide if you are walking, running, or driving. Using this info, the app can tell when you park your car and automatically remind record the park. You can disable this feature at any time from the settings page";
    
    self->_helpAlert = [[UIAlertView alloc] initWithTitle:@"AutoPark"
                                                  message:helpMessage
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    [self->_helpAlert show];
}

@end

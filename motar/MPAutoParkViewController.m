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

@synthesize autoParkImageView = _autoParkImageView;
@synthesize autoParkSensorStatusLabel = _autoParkSensorStatusLabel;
@synthesize autoParkAccuracyMeter = _autoParkAccuracyMeter;
@synthesize autoParkAccuracyLabel = _autoParkAccuracyLabel;


#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [MPColorManager lightColor];
    self.autoParkSensorActivityIndicator.hidesWhenStopped = YES;
    if ([MPAutoParkManager canTrack]) {
        
        [self didTrackNewActivity];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTrackNewActivity) name:MPAutoParkNewMotionNotification object:nil];
        
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Private Instance Methods

- (void)didTrackNewActivity {
    
    CMMotionActivity *activity = self.autoParkManager.trackedActivity;
    
    switch (activity.confidence) {
        case CMMotionActivityConfidenceHigh:
            [self.autoParkAccuracyMeter setProgress:1.0 animated:YES];
            [self.autoParkAccuracyMeter setTintColor:[UIColor greenColor]];
            self.autoParkAccuracyLabel.text = @"high.";
            break;
        
        case CMMotionActivityConfidenceMedium:
            [self.autoParkAccuracyMeter setProgress:0.66 animated:YES];
            [self.autoParkAccuracyMeter setTintColor:[UIColor yellowColor]];
            self.autoParkAccuracyLabel.text = @"medium.";
            break;
            
        default:
            [self.autoParkAccuracyMeter setProgress:0.33 animated:YES];
            [self.autoParkAccuracyMeter setTintColor:[UIColor redColor]];
            self.autoParkAccuracyLabel.text = @"low.";
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
        self.autoParkAccuracyLabel.text = @"";
        
    }
    
}

#pragma mark - Public Instance Methods


#pragma mark - Actions

- (IBAction)userDone:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)userHelp:(id)sender {
    
    static NSString *helpMessage = @"AutoPark uses information form your phone's GPS and motion sensors to decide if you are walking, running, or driving. Using this info, the app can tell when you park your car and automatically remind record the park. You can disable this feature at any time from the settings page.";
    
    self->_helpAlert = [[UIAlertView alloc] initWithTitle:@"AutoPark"
                                                  message:helpMessage
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    [self->_helpAlert show];
}

- (IBAction)userGPS:(id)sender {
    
    NSString *GPSString = [NSString stringWithFormat:@"%@", self.autoParkManager.trackedLocation];
    UIAlertView *GPSAlert = [[UIAlertView alloc] initWithTitle:@"Tracked Location"
                                                       message:GPSString
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles: nil];
    [GPSAlert show];
    
}

@end

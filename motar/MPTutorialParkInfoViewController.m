//
//  MPTutorialParkInfoViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/16/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPTutorialParkInfoViewController.h"

@interface MPTutorialParkInfoViewController ()

@end

@implementation MPTutorialParkInfoViewController {
    
    BOOL didCenter;
    BOOL seen;
    UIAlertView *_mapAlert;
    
}

@synthesize parkDateView = _parkDateView;
@synthesize timeLeftView = _timeLeftView;
@synthesize parkDateL = _parkDateL;
@synthesize canContinue = _canContinue;
@synthesize mapView = _mapView;
@synthesize timeLeftLabel = _timeLeftLabel;

#pragma mark - MKMapViewDelegate Protocol Instance Methods

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {

    if (error != NULL) {
        
        self->_mapAlert = [[UIAlertView alloc] initWithTitle:@"Failed to load map"
                                                     message:nil
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [self->_mapAlert show];
        
    }
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    if (!self->didCenter) {
        
        MKCoordinateRegion region = self.mapView.region;
        region.center = self.mapView.userLocation.coordinate;
        region.span.longitudeDelta = 0.005f;
        region.span.latitudeDelta = 0.005f;
        [self.mapView setRegion:region animated:YES];
        
    }
    
}



#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [MPColorManager lightColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    self.parkDateL.text = dateString;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeLight" object:self];
    if (!seen) {
        seen = YES;
        [self performSelector:@selector(showHelp) withObject:nil afterDelay:1.0];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private Instance Methods

- (void)showHelp {
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.view.backgroundColor = [MPColorManager darkColor];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeDark" object:self];
                         
                     }
                     completion:^(BOOL finished) {
                       
                         UILabel *h1 = (UILabel *)[self.view viewWithTag:1];
                         UILabel *h2 = (UILabel *)[self.view viewWithTag:2];
                         UILabel *h3 = (UILabel *)[self.view viewWithTag:3];
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              
                                              h1.alpha = 1.0;
                                              h2.alpha = 1.0;
                                              h3.alpha = 1.0;
                                              self.mapView.alpha = 0.25;
                                              self.timeLeftView.alpha = 0.4;
                                              self.parkDateView.alpha = 0.4;
                                              
                                          }
                                          completion:^(BOOL finished) {
                                              
                                              [UIView transitionWithView:self.timeLeftView
                                                                duration:1.0
                                                                 options:UIViewAnimationOptionTransitionCrossDissolve
                                                              animations:^{
                                                                  
                                                                  self.timeLeftLabel.textColor = [UIColor whiteColor];
                                                                  self.timeLeftLabel.text = @"swipe left.";
                                                                  self->_canContinue = YES;
                                                                  [self.pageViewController setViewControllers:@[self]
                                                                                                    direction:UIPageViewControllerNavigationDirectionForward
                                                                                                     animated:NO
                                                                                                   completion:nil];
                                                                  
                                                                  
                                                              }
                                                              completion:nil];
                                              
                                          }];
                         
                     }];
    
}

@end

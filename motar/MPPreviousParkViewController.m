//
//  MPPreviousParkViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/14/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPPreviousParkViewController.h"

@interface MPPreviousParkViewController ()

@end

@implementation MPPreviousParkViewController {
    
    UIAlertView *_mapAlert;
    
}

@synthesize currentPark = _currentPark;
@synthesize mapView = _mapView;
@synthesize parkTimeLabel = _parkTimeLabel;
@synthesize areaLabel = _areaLabel;
@synthesize carLocationButton = _carLocationButton;
@synthesize renameParkButton = _renameParkButton;
@synthesize undoButton = _undoButton;

#pragma mark - MKMapViewDelegate Protocol Instance Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *annotationViewIdentifier = @"snorq";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
    
    if (!annotationView) {
        
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        annotationView.pinColor = [MPParkInfoViewController pinColor];
        NSLog(@"%li", (long)[MPParkInfoViewController pinColor]);
        
    } else {
        
        annotationView.pinColor = [MPParkInfoViewController pinColor];
        annotationView.annotation = annotation;
        
    }
    
    return annotationView;
    
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    
    if (error != NULL) {
        
        self->_mapAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't Load Map"
                                                     message:[NSString stringWithFormat:@"motar encountered an error: %@", error]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [_mapAlert show];
        
    }
    
}

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [MPColorManager lightColor];
    if (!self.currentPark) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudRefresh) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil];
    self.mapView.delegate = self;
    
    if (![self.currentPark isMostRecent]) {
        
        self.undoButton.hidden = YES;
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self refreshUI];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"RetroDateSegue"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        MPRetroReturnTimeViewController *viewController = (MPRetroReturnTimeViewController *)navController.visibleViewController;
        viewController.currentPark = self.currentPark;
        
    } else if ([[segue identifier] isEqualToString:@"RetroNameSegue"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        MPRetroNameViewController *viewController = (MPRetroNameViewController *)navController.visibleViewController;
        viewController.currentPark = self.currentPark;
        
    }
    
}

#pragma mark - Private Instance Methods

- (void)refreshUI {
    
    self.title = self.currentPark.parkTag;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    NSString *dateString = [dateFormatter stringFromDate:self.currentPark.parkDate];
    self.parkTimeLabel.text = dateString;
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = self.currentPark.parkLocation.coordinate;
    annotation.title = self.currentPark.parkTag;
    annotation.subtitle = dateString;
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion region = self.mapView.region;
    region.span.latitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    region.center = self.currentPark.parkLocation.coordinate;
    [self.mapView setRegion:region animated:YES];
    
    NSTimeInterval interval = [self.currentPark.returnDate timeIntervalSinceDate:self.currentPark.parkDate];
    
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
    
    self.previousLabel.text = lengthString;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __block CLPlacemark *placemark;
    [geocoder reverseGeocodeLocation:self.currentPark.parkLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (!error) {
                           
                           placemark = [placemarks lastObject];
                           NSString *city = [placemark locality];
                           NSString *state = [placemark administrativeArea];
                           NSString *locationString = [NSString stringWithFormat:@"%@, %@", city, state];
                           self.areaLabel.text = locationString;
                           
                       } else {
                           
                           NSLog(@"Failed to get localized location info: %@", error);
                           
                       }
                       
                   }];
    
    [self.currentPark updateArchive];
    
}

- (void)iCloudRefresh {
    
    [MPParkInfoViewController refresh];
    [self refreshUI];
    
}

#pragma mark - Actions

- (IBAction)userChangeDate:(id)sender {
    
    [self performSegueWithIdentifier:@"RetroDateSegue" sender:sender];
    
}

- (IBAction)userRename:(id)sender {
    
    [self performSegueWithIdentifier:@"RetroNameSegue" sender:sender];
    
}

- (IBAction)userCarLocation:(id)sender {
    
    MKCoordinateRegion region = self.mapView.region;
    region.center = self.currentPark.parkLocation.coordinate;
    [self.mapView setRegion:region animated:YES];
    
}

- (IBAction)userUndo:(id)sender {
    
    [self.currentPark undo];
    [self.currentPark savePark];
    [[NSNotificationCenter defaultCenter] postNotificationName:MPEmptyParkNotification object:nil];
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:[MPPark parkArchives]];
    [newArray removeObjectAtIndex:0];
    if (![MPPark canUseiCloud]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"PreviousKey"];
        
    } else {
        
        [[NSUbiquitousKeyValueStore defaultStore] setObject:newArray forKey:@"PreviousKey"];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end

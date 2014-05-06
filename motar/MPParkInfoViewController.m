//
//  MPParkInfoViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPParkInfoViewController.h"

@interface MPParkInfoViewController ()

@end

@implementation MPParkInfoViewController {
    
    UIAlertView *_mapAlert;
    UIAlertView *_cameraAlert;
    NSTimer *_theTimer;
    NSArray *_searchResults;
    
}
@synthesize currentPark = _currentPark;
@synthesize pageViewController = _pageViewController;

@synthesize mapView = _mapView;
@synthesize parkTimeLabel = _parkTimeLabel;
@synthesize showLocationButton = _showLocationButton;
@synthesize showCarButton = _showCarButton;
@synthesize timeLeftLabel = _timeLeftLabel;
@synthesize shareButton = _shareButton;

static MKPinAnnotationColor _pinColor;

+ (void)initialize {
    
    if (![MPParkInfoViewController canUseiCloud]) {
        
        if (![[NSUserDefaults standardUserDefaults] integerForKey:@"PinColorKey"]) {
            
            _pinColor = MKPinAnnotationColorRed;
            
        } else {
            
            _pinColor = (MKPinAnnotationColor)[[NSUserDefaults standardUserDefaults] integerForKey:@"PinColorKey"];
            
        }
        
    } else {
        
        if (![[NSUbiquitousKeyValueStore defaultStore] longLongForKey:@"PinColorKey"]) {
            
            _pinColor = MKPinAnnotationColorRed;
            
        } else {
            
            _pinColor = (MKPinAnnotationColor)[[NSUbiquitousKeyValueStore defaultStore] longLongForKey:@"PinColorKey"];
            
        }
        
    }
    
}

+ (MKPinAnnotationColor)pinColor {
    
    return _pinColor;
    
}

+ (void)setPinColor:(MKPinAnnotationColor)pinColor {
    
    _pinColor = pinColor;
    
    if (![MPParkInfoViewController canUseiCloud]) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:_pinColor forKey:@"PinColorKey"];
        
    } else {
        
        [[NSUbiquitousKeyValueStore defaultStore] setLongLong:_pinColor forKey:@"PinColorKey"];
        
    }
    
}

+ (BOOL)canUseiCloud {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudKey"];
    
}

+ (void)fillLocal {
    
    if ([[NSUbiquitousKeyValueStore defaultStore] longLongForKey:@"PinColorKey"]) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)[[NSUbiquitousKeyValueStore defaultStore] longLongForKey:@"PinColorKey"] forKey:@"PinColorKey"];
        
    }
    
}

+ (void)filliCloud {
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PinColorKey"]) {
        
        [[NSUbiquitousKeyValueStore defaultStore] setLongLong:[[NSUserDefaults standardUserDefaults] integerForKey:@"iCloudKey"] forKey:@"iCloudKey"];
        
    }
    
}

+ (void)refresh {
    
    if (![MPParkInfoViewController canUseiCloud]) {
        
        if (![[NSUserDefaults standardUserDefaults] integerForKey:@"PinColorKey"]) {
            
            _pinColor = MKPinAnnotationColorRed;
            
        } else {
            
            _pinColor = (MKPinAnnotationColor)[[NSUserDefaults standardUserDefaults] integerForKey:@"PinColorKey"];
            
        }
        
    } else {
        
        if (![[NSUbiquitousKeyValueStore defaultStore] longLongForKey:@"PinColorKey"]) {
            
            _pinColor = MKPinAnnotationColorRed;
            
        } else {
            
            _pinColor = (MKPinAnnotationColor)[[NSUbiquitousKeyValueStore defaultStore] longLongForKey:@"PinColorKey"];
            
        }
        
    }
    
}

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
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             self.mapView.alpha = 0.0;
                             
                         }
                         completion:^(BOOL finished) {
                            
                             self.mapView.hidden = YES;
                             
                         }];
        
    }
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    [self unhideLocationButton];
    
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
    if (error != NULL) {
        
        [self hideLocationButton];
        self->_mapAlert = [[UIAlertView alloc] initWithTitle:@"Location Error"
                                               message:[NSString stringWithFormat:@"motar encountered an error: %@", error]
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [self->_mapAlert show];
        
        
    }
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState == MKAnnotationViewDragStateStarting) {
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             self.mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                             self.showLocationButton.hidden = YES;
                             self.showCarButton.hidden = YES;
                             self.shareButton.hidden = YES;
                             self.renameButton.hidden = YES;
                             self.mapView.showsUserLocation = NO;
                             
                         }
                         completion:nil];
        
    } else if (newState == MKAnnotationViewDragStateEnding || newState == MKAnnotationViewDragStateCanceling) {
        
        NSLog(@"%@", self.currentPark.parkLocation);
        
        __block CLLocation *newLocation;
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             self.mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, 297);
                             newLocation = [[CLLocation alloc] initWithCoordinate:view.annotation.coordinate
                                                                         altitude:self.currentPark.parkLocation.altitude
                                                               horizontalAccuracy:self.currentPark.parkLocation.horizontalAccuracy
                                                                 verticalAccuracy:self.currentPark.parkLocation.verticalAccuracy
                                                                        timestamp:self.currentPark.parkLocation.timestamp];
                             self.showLocationButton.hidden = NO;
                             self.showCarButton.hidden = NO;
                             self.shareButton.hidden = NO;
                             self.renameButton.hidden = NO;
                             self.mapView.showsUserLocation = YES;
                             
                         }
                         completion:nil];
        if (newState != MKAnnotationViewDragStateCanceling) {
            
            self.currentPark.parkLocation = newLocation;
            
        }
        
        NSLog(@"%@", self.currentPark.parkLocation);
        
    }
    
}

#pragma mark - UIImagePickerControllerDelegate Protocol Instance Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *theImage = info[UIImagePickerControllerOriginalImage];
    self.currentPark.parkImage = theImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self prepareUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudRefresh) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    [self refreshUI];
    [self.currentPark savePark];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"returnTimeSegue"]) {
        
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        MPReturnTimeViewController *viewController = (MPReturnTimeViewController *)navController.viewControllers[0];
        viewController.currentPark = self.currentPark;
        
    } else if ([[segue identifier] isEqualToString:@"ParkImageSegue"]) {
        
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        MPParkImageViewController *viewController = (MPParkImageViewController *)navController.viewControllers[0];
        UIImageView *imageView = (UIImageView *)viewController.view;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = self.currentPark.parkImage;
        
    } else if ([[segue identifier] isEqualToString:@"RenameParkSegue"]) {
        
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        MPRenameParkViewController *viewController = (MPRenameParkViewController *)navController.viewControllers[0];
        viewController.currentPark = self.currentPark;
        
    }
    
}

#pragma mark - Private Instance Methods

- (void)prepareUI {
    
    self.view.backgroundColor = [MPColorManager lightColor];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
    self.showLocationButton.alpha = 0.0;
    self.showLocationButton.hidden = YES;
    
}

- (void)refreshUI {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSString *dateString = [dateFormatter stringFromDate:self.currentPark.parkDate];
    [UIView transitionWithView:self.parkTimeLabel
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        self.parkTimeLabel.text = dateString;
                        
                    }
                    completion:nil];
    
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
    
    if (!self.currentPark.returnDate) {
        
        self.timeLeftLabel.text = @"whenever.";
        
    } else {
        
        
        NSTimeInterval interval = [self.currentPark.returnDate timeIntervalSinceNow];
        if (interval > 0) {
            
            if (!self->_theTimer) {
                
                self->_theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
                
            }
            
        } else {
            
            self.timeLeftLabel.text = @"expired!";
            
        }
        
    }
    
}

- (void)unhideLocationButton {
    
    self.showLocationButton.hidden = NO;
    [UIView animateWithDuration:0.5
                     animations:^{
                        
                         self.showLocationButton.alpha = 1.0;
                         
                     }
                     completion:nil];
    
}

- (void)hideLocationButton {
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.showLocationButton.alpha = 0.0;
                         
                     }
                     completion:^(BOOL finished) {
                        
                         self.showLocationButton.hidden = YES;
                         
                     }];
    
}

- (void)tick {
    
    if (self.currentPark.returnDate) {
        
        NSInteger days = 0;
        NSInteger hours = 0;
        NSInteger minutes = 0;
        NSTimeInterval interval = [self.currentPark.returnDate timeIntervalSinceNow];
        if (interval > 0) {
            
            NSInteger seconds = (NSInteger)interval;
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
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                
                                self.timeLeftLabel.text = timeLeftString;
                                
                            }
                            completion:nil];
            
        } else {
            
            [UIView transitionWithView:self.timeLeftLabel
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                
                                self.timeLeftLabel.text = @"expired!";
                                
                            }
                            completion:nil];
            
        }
        
    }
    
}

- (void)iCloudRefresh {
    
    [MPParkInfoViewController refresh];
    [self refreshUI];
    
}

#pragma mark - Actions

- (IBAction)userShowLocation:(id)sender {
    
    MKCoordinateRegion region = self.mapView.region;
    region.center = self.mapView.userLocation.coordinate;
    [self.mapView setRegion:region animated:YES];
    
}

- (IBAction)userShowCar:(id)sender {
    
    MKCoordinateRegion region = self.mapView.region;
    region.center = self.currentPark.parkLocation.coordinate;
    [self.mapView setRegion:region animated:YES];
    
}

- (IBAction)userReturnTime:(id)sender {
    
    [self performSegueWithIdentifier:@"returnTimeSegue" sender:sender];
    
}

- (IBAction)userPicture:(id)sender {
    
    if (!self.currentPark.parkImage) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
            
            
        } else {
            
            self->_cameraAlert = [[UIAlertView alloc] initWithTitle:@"Camera Unavailable"
                                                            message:@"Motion Park Couldn't Access Your Camera"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [self->_cameraAlert show];
            self.pictureButton.enabled = NO;
            
        }
        
    } else {
        
        [self performSegueWithIdentifier:@"ParkImageSegue" sender:sender];
        
    }
    
}

- (IBAction)userDirections:(id)sender {
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.currentPark.parkLocation.coordinate addressDictionary:nil]];
    mapItem.name = self.currentPark.parkTag;
    BOOL mapLaunch = [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsMapTypeKey: @0}];
    
    if (!mapLaunch) {
        
        self->_mapAlert = [[UIAlertView alloc] initWithTitle:@"Directions Unavailable"
                                                     message:nil
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [self->_mapAlert show];
        
    }
    
}

- (IBAction)userShare:(id)sender {
    
    self.shareButton.enabled = NO;
    MKMapSnapshotOptions *snapShotOptions = [[MKMapSnapshotOptions alloc] init];
    snapShotOptions.region = self.mapView.region;
    snapShotOptions.showsBuildings = YES;
    snapShotOptions.showsPointsOfInterest = NO;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:snapShotOptions];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
       
        if (error != NULL) {
            NSLog(@"%@", error);
            UIAlertView *shareAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Error"
                                       message:@"Couldnt generate shareable map"
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [shareAlert show];
            
        } else {
            
            UIImage *shareableMap = snapshot.image;
            
            CGRect rect = CGRectMake(0, 0, shareableMap.size.width, shareableMap.size.height);
            MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
            UIImage *pinImage = pinView.image;
            UIGraphicsBeginImageContextWithOptions(shareableMap.size, YES, shareableMap.scale);
            
            [shareableMap drawAtPoint:CGPointMake(0, 0)];
            
            for (id<MKAnnotation>annotation in self.mapView.annotations) {
                
                if (![annotation isKindOfClass:[MKUserLocation class]]) {
                    
                    CGPoint point = [snapshot pointForCoordinate:annotation.coordinate];
                    if (CGRectContainsPoint(rect, point)) {
                        
                        CGPoint pinCenterOffset = pinView.centerOffset;
                        point.x -= pinView.bounds.size.width / 2.0;
                        point.y -= pinView.bounds.size.height / 2.0;
                        point.x += pinCenterOffset.x;
                        point.y += pinCenterOffset.y;
                        
                        [pinImage drawAtPoint:point];
                        
                    }
                    
                }
                
            }
            
            UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIActivityViewController *activityViewController;
            
            if (!self.currentPark.parkImage) {
                
                activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[finalImage] applicationActivities:nil];
                
            } else {
                
                activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[finalImage, self.currentPark.parkImage] applicationActivities:nil];
                
            }
            
            activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact];
            [self presentViewController:activityViewController animated:YES completion:nil];
            self.shareButton.enabled = YES;
            
        }
        
    }];
    
}

- (IBAction)userRename:(id)sender {
    
    [self performSegueWithIdentifier:@"RenameParkSegue" sender:sender];
    
}
@end

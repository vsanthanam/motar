//
//  MPParkInfoViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MPPark.h"
#import "MPReturnTimeViewController.h"
#import "MPParkImageViewController.h"
#import "MPRenameParkViewController.h"
#import "MPColorManager.h"
#import "MPAppDelegate.h"

@interface MPParkInfoViewController : UIViewController <MKMapViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) UIPageViewController *pageViewController;
@property (nonatomic, weak) MPPark *currentPark;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *parkTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *showLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *showCarButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *renameButton;

+ (MKPinAnnotationColor)pinColor;
+ (void)setPinColor:(MKPinAnnotationColor)pinColor;

+ (BOOL)canUseiCloud;
+ (void)filliCloud;
+ (void)fillLocal;
+ (void)refresh;

- (IBAction)userShowLocation:(id)sender;
- (IBAction)userShowCar:(id)sender;
- (IBAction)userReturnTime:(id)sender;
- (IBAction)userPicture:(id)sender;
- (IBAction)userDirections:(id)sender;
- (IBAction)userShare:(id)sender;
- (IBAction)userRename:(id)sender;


@end

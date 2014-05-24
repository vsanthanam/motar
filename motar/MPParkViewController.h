//
//  MPParkViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <iAd/iAd.h>

#import "MPPark.h"
#import "MPParkButton.h"
#import "MPParkStatusMeter.h"
#import "MPShortInfoBubble.h"
#import "MPAutoParkManager.h"
#import "MPColorManager.h"

@interface MPParkViewController : UIViewController <CLLocationManagerDelegate, ADBannerViewDelegate, UIAlertViewDelegate, MPAutoParkManagerDelegate>

@property (nonatomic, weak) UIPageViewController *pageViewController;
@property (nonatomic, strong) MPPark *currentPark;
@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, strong, readonly) MPAutoParkManager *autoParkManager;
@property (nonatomic, readonly, getter = canShowAds) BOOL adsAvailable;

@property (weak, nonatomic) IBOutlet MPParkButton *parkButton;
@property (weak, nonatomic) IBOutlet MPParkStatusMeter *parkStatusMeter;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;
@property (weak, nonatomic) IBOutlet MPShortInfoBubble *shortInfoBubble;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *helperLabel;
@property (weak, nonatomic) IBOutlet UIButton *motionIndicatorButton;

- (IBAction)userParkCar:(id)sender;
- (IBAction)userFindCar:(id)sender;
- (IBAction)userAutoPark:(id)sender;

- (void)showAds;
- (void)hideAds;

@end

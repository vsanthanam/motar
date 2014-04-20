//
//  MPTutorialParkInfoViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/16/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MPColorManager.h"
#import "MPParkTimeView.h"
#import "MPShortInfoBubble.h"

@interface MPTutorialParkInfoViewController : UIViewController <MKMapViewDelegate>

@property (assign, nonatomic, readonly) BOOL canContinue;
@property (nonatomic, weak) UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet MPParkTimeView *parkDateView;
@property (weak, nonatomic) IBOutlet MPShortInfoBubble *timeLeftView;
@property (weak, nonatomic) IBOutlet UILabel *parkDateL;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;

@end

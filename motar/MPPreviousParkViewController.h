//
//  MPPreviousParkViewController.h
//  motar
//
//  Created by Varun Santhanam on 4/14/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MPPark.h"
#import "MPColorManager.h"
#import "MPParkInfoViewController.h"
#import "MPRetroReturnTimeViewController.h"
#import "MPRetroNameViewController.h"

@interface MPPreviousParkViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) MPPark *currentPark;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *parkTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIButton *carLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *renameParkButton;

- (IBAction)userChangeDate:(id)sender;

- (IBAction)userRename:(id)sender;
- (IBAction)userCarLocation:(id)sender;

@end

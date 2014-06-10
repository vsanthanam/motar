//
//  MPSettingsTableViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/14/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPSettingsTableViewController.h"

@interface MPSettingsTableViewController () {
    
    UIActionSheet *_autoParkActionSheet;
    UIActionSheet *_historyActionSheet;
    UIActionSheet *_resetActionSheet;
    UIActionSheet *_confirmActionSheet;
    UIAlertView *_noadsAlert;
    
}

@end

@implementation MPSettingsTableViewController

@synthesize productCatalogue = _productCatalogue;
@synthesize availableProducts = _availableProducts;

@synthesize iCloudSwitch = _iCloudSwitch;
@synthesize autoParkSwitch = _autoParkSwitch;
@synthesize carNameCell = _carNameCell;
@synthesize pinColorCell = _pinColorCell;
@synthesize iCloudCell = _iCloudCell;
@synthesize clearHistoryCell = _clearHistoryCell;
@synthesize resetAppCell = _resetAppCell;
@synthesize autoParkCell = _autoParkCell;
@synthesize tutorialCell = _tutorialCell;
@synthesize websiteCell = _websiteCell;
@synthesize shareAppCell = _shareAppCell;
@synthesize removeAdsCell = _removeAdsCell;
@synthesize restoreCell = _restoreCell;
@synthesize nameLabel = _nameLabel;
@synthesize colorLabel = _colorLabel;
@synthesize removeAdsLabel = _removeAdsLabel;
@synthesize restoreLabel = _restoreLabel;
@synthesize websiteLabel = _websiteLabel;

static NSString *_websiteLink = @"http://www.varunsanthanam.com/motar";

#pragma mark - UIActionSheetDelegate Protocol Instance Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet == self->_autoParkActionSheet) {
        
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AutoParkKey"];
            
        } else {
            
            [self.autoParkSwitch setOn:NO animated:YES];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AutoParkKey"];
            
        }
        
    } else if (actionSheet == self->_historyActionSheet) {
        
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            
            [MPPark clearArchives];
            
        }
        
    } else if (actionSheet == self->_resetActionSheet) {
        
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            
            self->_confirmActionSheet = [[UIActionSheet alloc] initWithTitle:@"Are You Sure?"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Cancel"
                                                      destructiveButtonTitle:@"Yes, I'm Sure"
                                                           otherButtonTitles:nil];
            [self->_confirmActionSheet showInView:[UIApplication sharedApplication].keyWindow];
            
        }
        
    } else if (actionSheet == self->_confirmActionSheet) {
        
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"iCloudKey"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AutoParkKey"];
            [MPPark resetDefaultTag];
            [MPPark clearArchives];
            [MPParkInfoViewController setPinColor:MKPinAnnotationColorRed];
            [MPPark clearSave];
            [self.iCloudSwitch setOn:NO animated:YES];
            [self.autoParkSwitch setOn:NO animated:YES];
        
        }
        
    }
    
}

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [MPColorManager lightColor];
    self.carNameCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.pinColorCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.iCloudCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.clearHistoryCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.resetAppCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.autoParkCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.tutorialCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.websiteCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.shareAppCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.removeAdsCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.restoreCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudRefresh) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAds) name:@"PurchasedNoAds" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedNoAds) name:@"FailedNoAds" object:nil];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"com.varunsanthanam.motar.noads"]) {
        
        [self prepareStore];
        
    } else {
        
        self.removeAdsCell.backgroundColor = [MPColorManager lightColor];
        self.restoreCell.backgroundColor = [MPColorManager lightColor];
        self.removeAdsLabel.textColor = [MPColorManager darkColor];
        self.restoreLabel.textColor = [MPColorManager darkColor];
        self.removeAdsCell.userInteractionEnabled = NO;
        self.restoreCell.userInteractionEnabled = NO;
        self.removeAdsLabel.text = @"Thank You For Purchasing";
        
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_websiteLink]];
    NSURLConnection *connectionDoctor = [NSURLConnection connectionWithRequest:request delegate:self];
    [connectionDoctor start];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshUI];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (error != NULL) {
        
        self.websiteCell.backgroundColor = [MPColorManager lightColor];
        self.websiteCell.userInteractionEnabled = NO;
        self.websiteLabel.textColor = [MPColorManager darkColor];
        self.websiteLabel.text = [NSString stringWithFormat:@"%@ (Unavailable)", self.websiteLabel.text];
        
    }
    
}

#pragma mark - UITableViewDataSource Protocol Instance Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        [self performSegueWithIdentifier:@"CarNameSegue" sender:indexPath];
        
    } else if (indexPath.row == 1 && indexPath.section == 0) {
        
        [self performSegueWithIdentifier:@"PinColorSegue" sender:indexPath];
        
    } else if (indexPath.row == 0 && indexPath.section == 1) {
        
        [self userClearHistory];
        
    } else if (indexPath.row == 1 && indexPath.section == 1) {
        
        [self userResetapp];
    
    } else if (indexPath.row == 0 && indexPath.section == 2) {
        
        [self userTutorial];
        
    } else if (indexPath.row == 1 && indexPath.section == 2) {
    
        [self userWebsite];
        
    } else if (indexPath.row == 0 && indexPath.section == 3) {
        
        [self userShareApp];
        
    } else if (indexPath.row == 0 && indexPath.section == 4) {
        
        [self userRemoveAds];
        
    } else if (indexPath.row == 1 && indexPath.section == 4) {
        
        [self userRestorePurchase];
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (![MPAutoParkManager canTrack]) {
        
        return 6;
        
    }
    
    return 7;
    
}

#pragma mark - SKProductsRequestDelegate Protocol Instance Methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    for (SKProduct *product in response.products) {
        
        self.availableProducts[product.productIdentifier] = product;
        
    }
    
    for (NSString *identifier in response.invalidProductIdentifiers) {
        
        NSLog(@"Failed to validate invalid product identifier %@", identifier);
        [self disableProductWithIdentifier:identifier];
        
    }
    
    [self enableValidProducts];
    
}

#pragma mark - SKRequestDelegate Protocol Instance Methods

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    if (error != NULL) {
        
        NSLog(@"Failed to validate all product identifiers with error %@", error);
        [self disableAllProducts];
        
    }
    
}

- (void)requestDidFinish:(SKRequest *)request {
    
    NSLog(@"Successfully completed product identifier validation");
    
}

#pragma mark - Private Instance Methods

- (void)userClearHistory {
    
    self->_historyActionSheet = [[UIActionSheet alloc] initWithTitle:@"You cannot undo this."
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:@"Clear History"
                                                   otherButtonTitles:nil];
    [self->_historyActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (void)userResetapp {
    
    self->_resetActionSheet = [[UIActionSheet alloc] initWithTitle:@"You cannot undo this."
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:@"Reset"
                                                 otherButtonTitles:nil];
    [self->_resetActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (void)userTutorial {
    
    MPTutorialViewController *viewController = (MPTutorialViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (void)userWebsite {
    
    NSURL *url = [NSURL URLWithString:_websiteLink];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void)userShareApp {
    
    NSString *shareString = [NSString stringWithFormat:@"Check out motar! It's a smart parking app that reminds you where you parked your car and helps you avoid parking tickets! %@", _websiteLink];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[shareString] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (void)refreshUI {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AutoParkKey"]) {
        
        [self.autoParkSwitch setOn:NO animated:YES];
        
    } else {
        
        [self.autoParkSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"AutoParkKey"] animated:YES];
        
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"iCloudDataKey"]) {
        
        self.iCloudSwitch.enabled = NO;
        
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudKey"]) {
        
        [self.iCloudSwitch setOn:NO animated:YES];
        
    } else {
        
        [self.iCloudSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudKey"]];
        
    }
    
    self.nameLabel.text = [MPPark defaultTag];
    NSString *colorText;
    MKPinAnnotationColor color = [MPParkInfoViewController pinColor];
    
    switch (color) {
        case MKPinAnnotationColorRed:
            colorText = @"Red";
            break;
            
        case MKPinAnnotationColorGreen:
            colorText = @"Green";
            break;
            
        case MKPinAnnotationColorPurple:
            colorText = @"Purple";
            break;
    }
    
    self.colorLabel.text = colorText;
    
}

- (void)iCloudRefresh {
    
    [MPPark refresh];
    [MPParkInfoViewController refresh];
    [self refreshUI];
    
}

- (void)prepareStore {

    self.productCatalogue = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ProductCatalogue" withExtension:@"plist"]];
    self.availableProducts = [NSMutableDictionary dictionaryWithSharedKeySet:[NSMutableDictionary sharedKeySetForKeys:self.productCatalogue]];
    
    [self disableAllProducts];
    
    if ([SKPaymentQueue canMakePayments]) {
        
        [self validateProducts:self.productCatalogue];
        
    }
    
}

- (void)validateProducts:(NSArray *)productCatalogue {
    
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productCatalogue]];
    productsRequest.delegate = self;
    [productsRequest start];
    [self processAllProducts];
    
}

- (void)disableProductWithIdentifier:(NSString *)identifier {
    
    if ([identifier isEqualToString:@"com.varunsanthanam.motar.noads"]) {
        
        self.removeAdsCell.userInteractionEnabled = NO;
        self.restoreCell.userInteractionEnabled = NO;
        
        self.removeAdsCell.backgroundColor = [MPColorManager lightColor];
        self.restoreCell.backgroundColor = [MPColorManager lightColor];
        
        self.removeAdsLabel.text = @"Remove Ads (Unavailable)";
        self.restoreLabel.text = @"Restore Purchase (Unavailable)";
        
        self.removeAdsLabel.textColor = [MPColorManager darkColor];
        self.restoreLabel.textColor = [MPColorManager darkColor];
        
        NSLog(@"Disabled %@", identifier);
        
    } else {
        
        NSLog(@"Unknown product ID: %@", identifier);
        
    }
    
}

- (void)disableAllProducts {
    
    for (NSString *identifier in self.productCatalogue) {
        
        [self disableProductWithIdentifier:identifier];
        
    }
    
}

- (void)enableProductWithIdentifier:(NSString *)identifier {
    
    if ([identifier isEqualToString:@"com.varunsanthanam.motar.noads"]) {
        
        self.removeAdsCell.userInteractionEnabled = YES;
        self.restoreCell.userInteractionEnabled = YES;
        
        SKProduct *product = self.availableProducts[identifier];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        numberFormatter.locale = product.priceLocale;
        
        self.removeAdsLabel.text = [NSString stringWithFormat:@"Remove Ads (%@)", [numberFormatter stringFromNumber:product.price]];
        self.restoreLabel.text = @"Restore Purchase";
        self.removeAdsLabel.textColor = [UIColor whiteColor];
        self.restoreLabel.textColor = [UIColor whiteColor];
        
        self.removeAdsCell.backgroundColor = [MPColorManager darkColorLessAlpha];
        self.restoreCell.backgroundColor = [MPColorManager darkColorLessAlpha];
        
        NSLog(@"Enabled %@", identifier);
        
    } else {
        
        NSLog(@"Unknown Product ID: %@", identifier);
        
    }
    
}

- (void)enableValidProducts {
    
    for (NSString *identifier in [[self.availableProducts allKeys] mutableCopy]) {
        
        [self enableProductWithIdentifier:identifier];
        
    }
    
}

- (void)processProductsWithIdentifier:(NSString *)identifier {
    
    if ([identifier isEqualToString:@"com.varunsanthanam.motar.noads"]) {
        
        self.removeAdsCell.backgroundColor = [MPColorManager lightColor];
        self.restoreCell.backgroundColor = [MPColorManager lightColor];
        self.removeAdsCell.userInteractionEnabled = NO;
        self.restoreCell.userInteractionEnabled = NO;
        self.removeAdsLabel.text = @"Remove Ads (Loading)";
        self.restoreLabel.text = @"Restore Purchase";
        self.removeAdsLabel.textColor = [MPColorManager darkColor];
        self.restoreLabel.textColor = [MPColorManager darkColor];
        
        NSLog(@"Processing %@", identifier);
        
    }
    
}


- (void)processAllProducts {
    
    for (NSString *identifier in self.productCatalogue) {
        
        [self processProductsWithIdentifier:identifier];
        
    }
    
}

- (void)userRemoveAds {
    
    SKProduct *product = self.availableProducts[@"com.varunsanthanam.motar.noads"];
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [self processProductsWithIdentifier:@"com.varunsanthanam.motar.noads"];
    
}

- (void)userRestorePurchase {
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
}

- (void)userFollowTwitter {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error) {
                                          
                                           if (granted) {
                                               
                                               NSArray *availableAccounts = [accountStore accountsWithAccountType:accountType];
                                               if ([availableAccounts count] > 0) {
                                                   
                                                   ACAccount *account = availableAccounts[0];
                                                   
                                                   NSDictionary *info = @{@"screen_name": @"motarpark", @"follow": @"TRUE"};
                                                   SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friendships/create.json"] parameters:info];
                                                   request.account = account;
                                                   
                                                   [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                                      
                                                       if (urlResponse.statusCode == 200) {
                                                           
                                                           NSError *error;
                                                           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                                                           NSLog(@"Response %@", dict);
                                                           
                                                           UIAlertView *twitterAlert = [[UIAlertView alloc] initWithTitle:@"Thanks!"
                                                                                                                  message:@"Thank you for following us on twitter." delegate:nil
                                                                                                        cancelButtonTitle:@"OK"
                                                                                                        otherButtonTitles:nil];
                                                           [twitterAlert show];
                                                           
                                                       } else {
                                                           
                                                           UIAlertView *twitterAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                                  message:@"Could not follow on twitter"
                                                                                                                 delegate:nil
                                                                                                        cancelButtonTitle:@"OK"
                                                                                                        otherButtonTitles:nil];
                                                           [twitterAlert show];
                                                            
                                                       }
                                                       
                                                   }];
                                                   
                                               } else {
                                                   
                                                   UIAlertView *twitterAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                          message:@"No twitter accounts available"
                                                                                                         delegate:nil
                                                                                                cancelButtonTitle:@"OK"
                                                                                                otherButtonTitles:nil];
                                                   [twitterAlert show];
                                                   
                                               }
                                               
                                           } else {
                                               
                                               UIAlertView *twitterAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                      message:@"Could not access twitter account"
                                                                                                     delegate:nil
                                                                                            cancelButtonTitle:@"OK"
                                                                                            otherButtonTitles:nil];
                                               [twitterAlert show];
                                               
                                           }
                                           
                                       }];
    
}

- (void)removeAds {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.varunsanthanam.motar.noads"];
    self->_noadsAlert = [[UIAlertView alloc] initWithTitle:@"Thank You"
                                                   message:@"Thank you for your support!"
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [self->_noadsAlert show];
    
    self.removeAdsCell.backgroundColor = [MPColorManager lightColor];
    self.removeAdsLabel.textColor = [MPColorManager darkColor];
    self.restoreCell.backgroundColor = [MPColorManager lightColor];
    self.restoreLabel.textColor = [MPColorManager darkColor];
    self.removeAdsLabel.text = @"Thank You For Purchasing";
    self.removeAdsCell.userInteractionEnabled = NO;
    self.restoreCell.userInteractionEnabled = NO;
    
}

- (void)failedNoAds {
    
    [self enableProductWithIdentifier:@"com.varunsanthanam.motar.noads"];
    
}

#pragma mark - Actions

- (IBAction)useriCloud:(id)sender {
    
    if ([self.iCloudSwitch isOn]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"iCloudKey"];
        [MPParkInfoViewController filliCloud];
        [MPPark filliCloud];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iCloudKey"];
        [MPParkInfoViewController fillLocal];
        [MPPark fillLocal];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

- (IBAction)userAutoPark:(id)sender {
    
    if ([self.autoParkSwitch isOn]) {
        
        self->_autoParkActionSheet = [[UIActionSheet alloc] initWithTitle:@"AutoPark uses data from your phone's motion and gps sensors to remind you use the app. All tracking data is stored on the device only and destroyed after each use. This feature can be disabled at anytime. Tracking will begin after you restart the app."
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Enable AutoPark"
                                                        otherButtonTitles:nil];
        [self->_autoParkActionSheet showInView:[UIApplication sharedApplication].keyWindow];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AutoParkKey"];
        
    }
    
}
@end

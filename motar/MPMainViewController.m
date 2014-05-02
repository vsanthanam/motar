//
//  MPMainViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/11/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPMainViewController.h"

@interface MPMainViewController ()

@end

@implementation MPMainViewController {
    
    UIStatusBarStyle statusBar;
    
}

@synthesize pageViewController = _pageViewController;
@synthesize parkViewController = _parkViewController;
@synthesize parkInfoViewController = _parkInfoViewController;
@synthesize settingsViewController = _settingsViewController;
@synthesize previousTableViewController = _previousTableViewController;

- (MPPark *)currentPark {
    
    if (self.parkViewController.currentPark) {
        
        return self.parkViewController.currentPark;
        
    }
    
    return nil;
    
}

- (UIPageViewController *)pageViewController {
    
    if (!self->_pageViewController) {
        
        self->_pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        self->_pageViewController.dataSource = self;
        self->_pageViewController.delegate = self;
        
    }
    
    return self->_pageViewController;
    
}

- (MPParkViewController *)parkViewController {
    
    if (!self->_parkViewController) {
        
        self->_parkViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ParkViewController"];
        self->_parkViewController.pageViewController = self.pageViewController;
        
    }
    
    return self->_parkViewController;
    
}

- (MPParkInfoViewController *)parkInfoViewController {
    
    if (!self->_parkInfoViewController) {
        
        self->_parkInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ParkInfoViewController"];
        self->_parkInfoViewController.pageViewController = self.pageViewController;
        self->_parkInfoViewController.currentPark = self.currentPark;
        
    }
    
    return self->_parkInfoViewController;
    
}

- (UINavigationController *)settingsViewController {
    
    if (!self->_settingsViewController) {
        
        self->_settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        
    }
    
    return self->_settingsViewController;
    
}

- (UINavigationController *)previousTableViewController {
    
    if (!self->_previousTableViewController) {
        
        self->_previousTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviousTableViewController"];
        
    }
    
    return self->_previousTableViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (viewController == self.parkViewController) {
        
        if ([self.currentPark isParked]) {
            
            self->statusBar = UIStatusBarStyleDefault;
            [self setNeedsStatusBarAppearanceUpdate];
            return self.parkInfoViewController;
            
        }
        
        return nil;
        
    } else if (viewController == self.previousTableViewController) {
        
        return self.parkViewController;
        
    } else if (viewController == self.settingsViewController) {
        
        return self.previousTableViewController;
        
    }
    
    return nil;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (viewController == self.parkViewController) {
        
        return self.previousTableViewController;
        
    } else if (viewController == self.parkInfoViewController) {
        
        self->statusBar = UIStatusBarStyleLightContent;
        [self setNeedsStatusBarAppearanceUpdate];
        return self.parkViewController;
        
    } else if (viewController == self.previousTableViewController) {
        
        return self.settingsViewController;
        
    }
    
    return nil;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    
    if ([self.currentPark isParked]) {
        
        return 4;
        
    }
    
    return 3;
    
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    
    return 2;
    
}

#pragma mark - UIPageViewControllerDelegate Instance Methods

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
    self.parkInfoViewController.currentPark = self.currentPark;
    
}

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.pageViewController setViewControllers:@[self.parkViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.view.backgroundColor = [MPColorManager lightColor];
    self->statusBar = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialKey"]) {
        
        MPTutorialViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"iCloudDataKey"] && ![[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudPromptKey"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialKey"]) {
        
        [self performSegueWithIdentifier:@"iCloudSegue" sender:self.view];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return self->statusBar;
    
}

@end

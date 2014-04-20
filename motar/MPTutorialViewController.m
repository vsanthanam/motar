//
//  MPTutorialViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/16/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPTutorialViewController.h"

@interface MPTutorialViewController ()

@end

@implementation MPTutorialViewController {
    
    BOOL phase2;
    
}

@synthesize pageViewController = _pageViewController;
@synthesize parkViewController = _parkViewController;
@synthesize parkInfoViewController = _parkInfoViewController;

#pragma mark - Property Access Methods

- (UIPageViewController *)pageViewController {
    
    if (!self->_pageViewController) {
        
        self->_pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialPageViewController"];
        self->_pageViewController.dataSource = self;
        self->_pageViewController.delegate = self;
        
    }
    
    return self->_pageViewController;
    
}

- (MPTutorialParkViewController *)parkViewController {
    
    if (!self->_parkViewController) {
        
        self->_parkViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialParkViewController"];
        self->_parkViewController.pageViewController = self.pageViewController;
        
        
    }
    
    return self->_parkViewController;
    
}

- (MPTutorialParkInfoViewController *)parkInfoViewController {
    
    if (!self->_parkInfoViewController) {
        
        self->_parkInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialParkInfoViewController"];
        self->_parkInfoViewController.pageViewController = self.pageViewController;
        
    }
    
    return self->_parkInfoViewController;
    
}

#pragma mark - UIPageViewControlerDataSource Protocol Instance Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (viewController == self.parkViewController && [self.parkViewController canContinue]) {
        
        return self.parkInfoViewController;
        
    }
    
    return nil;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (viewController == self.parkInfoViewController && [self.parkInfoViewController canContinue]) {
        
        return self.parkViewController;
        
    }
    
    return nil;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
 
    return 2;
    
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    
    
    if (!self->phase2) {
        
        self->phase2 = YES;
        return 0;
        
    }
    
    return 1;
    
}

#pragma mark - Private Instance Methods

- (void)becomeDark {
    
    self.view.backgroundColor = [MPColorManager darkColor];
    
}

- (void)becomeLight {
    
    self.view.backgroundColor = [MPColorManager lightColor];
    
}

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [MPColorManager lightColor];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.pageViewController setViewControllers:@[self.parkViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self->phase2 = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeLight) name:@"BecomeLight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeDark) name:@"BecomeDark" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  MPTutorialParkViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/17/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPTutorialParkViewController.h"

@interface MPTutorialParkViewController ()

@end

@implementation MPTutorialParkViewController {
    
    BOOL stageTwo;
    
}

@synthesize pageViewController = _pageViewController;
@synthesize canContinue = _canContinue;

@synthesize tutorialParkButton = _tutorialParkButton;
@synthesize tutorialParkStatusMeter = _tutorialParkStatusMeter;
@synthesize tutorialShortInfoBubble = _tutorialShortInfoBubble;
@synthesize headerLabel = _headerLabel;

#pragma mark - Overridden Instance Methods;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self->_canContinue = NO;
    self.view.backgroundColor = [MPColorManager lightColor];
    self.tutorialParkButton.backgroundColor = [UIColor clearColor];
    self.tutorialParkStatusMeter.backgroundColor = [UIColor clearColor];
    self.tutorialShortInfoBubble.backgroundColor = [UIColor clearColor];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeLight" object:self];
    
    [super viewDidAppear:animated];
    if (!self->stageTwo) {
        
        [self performSelector:@selector(beginAnimations) withObject:nil afterDelay:0.5];
        
    } else {
        
        [self performSelector:@selector(phaseTwoAnimations) withObject:nil afterDelay:0.5];
        
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    self->_canContinue = NO;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beginAnimations {
    
    [UIView transitionWithView:self.headerLabel
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        self.headerLabel.textColor = [UIColor whiteColor];
                        
                    }
                    completion:nil];
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.tutorialParkStatusMeter.alpha = 0.5;
                         self.view.backgroundColor = [MPColorManager darkColor];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeDark" object:self];
                         
                     }
                     completion:nil];
    
}

- (void)phaseTwoAnimations {
 
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        
                         self.tutorialShortInfoBubble.alpha = 0.5;
                         self.tutorialParkStatusMeter.alpha = 1.0;
                         self.view.backgroundColor = [MPColorManager darkColor];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeDark" object:self];
                         [UIView transitionWithView:self.headerLabel
                                           duration:0.5
                                            options:UIViewAnimationOptionTransitionCrossDissolve
                                         animations:^{
                                             
                                             self.headerLabel.textColor = [UIColor whiteColor];
                                             self.headerLabel.text = @"tap to complete.";
                                             
                                         }completion:nil];
                         
                     }
                     completion:nil];
    
}

- (void)finishTutorial {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TutorialKey"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - Actions

- (IBAction)userPark:(id)sender {
    
    self.tutorialShortInfoBubble.hidden = NO;
    
    [UIView transitionWithView:self.headerLabel
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        self.headerLabel.textColor = [UIColor blackColor];
                        self.headerLabel.text = @"swipe right.";
                        
                    }
                    completion:nil];
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeLight" object:self];
                         self.view.backgroundColor = [MPColorManager lightColor];
                         
                     }
                     completion:nil];
    [UIView transitionWithView:self.tutorialParkStatusMeter
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        
                        [self.tutorialParkStatusMeter setParked];
                        
                    } completion:nil];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.tutorialParkButton.alpha = 0.0;
                         
                     }
                     completion:^(BOOL finished){
                         
                         self.tutorialParkButton.hidden = YES;
                         self.tutorialShortInfoBubble.alpha = 1.0;
                         
                     }];
    self->_canContinue = YES;
    self->stageTwo = YES;
    [self.pageViewController setViewControllers:@[self] direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
     
}

- (IBAction)userComplete:(id)sender {
    
    [UIView transitionWithView:self.tutorialParkStatusMeter
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                    
                        [self.tutorialParkStatusMeter setNotParked];
                        
                    }
                    completion:^(BOOL finished) {
                        
                        [UIView transitionWithView:self.headerLabel
                                          duration:0.5
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:^{
                                            
                                            self.headerLabel.text = @"that's all :)";
                                            
                                        }
                                        completion:^(BOOL finished) {
                                            
                                            [self performSelector:@selector(finishTutorial) withObject:nil afterDelay:0.5];
                                            
                                        }];
                        
                    }];
}

@end

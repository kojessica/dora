//
//  HomeViewController.m
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (nonatomic, assign) BOOL isRelevant;
- (void)toggleTabs;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isRelevant = YES;
        
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnRelevantButton:(id)sender {
    [self toggleTabs];
}

- (IBAction)OnPopularButton:(id)sender {
    [self toggleTabs];
}

- (void)toggleTabs {
    float xPos = self.view.frame.size.width / 2;
    if (!self.isRelevant) {
        xPos = 0.0f;
    }
    self.isRelevant = !self.isRelevant;
    
    [UIView animateWithDuration:0.9f
                          delay:0.0f
         usingSpringWithDamping:0.9f
          initialSpringVelocity:10.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.selectedBar.frame = CGRectMake(
                                    xPos,
                                    CGRectGetMinY(self.selectedBar.frame),
                                    CGRectGetWidth(self.selectedBar.frame),
                                    CGRectGetHeight(self.selectedBar.frame)
                                    );

                     }
                     completion:^(BOOL finished) {
                     }];
}

@end

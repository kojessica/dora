//
//  ComposeMessageViewController.m
//  dora
//
//  Created by Benjamin Chang on 4/11/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "ComposeMessageViewController.h"
#import "LocationController.h"
@interface ComposeMessageViewController ()

@end

@implementation ComposeMessageViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickSend:(id)sender {
    [Post postWithUser:[User currentUser] group:[self group] text:[self composedText].text location:[[LocationController sharedLocationController] locationManager].location];
}
@end

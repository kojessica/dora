//
//  GroupDetailViewController.m
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "ListViewController.h"
#import "ComposeMessageViewController.h"

@interface GroupDetailViewController ()

@end

@implementation GroupDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CALayer *layer = self.writeButton.layer;
    layer.shadowOffset = CGSizeMake(0, 1);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 2.0f;
    layer.shadowOpacity = 0.80f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];

    CALayer *tblayer = self.topBar.layer;
    tblayer.shadowOffset = CGSizeMake(0, 1);
    tblayer.shadowColor = [[UIColor blackColor] CGColor];
    tblayer.shadowRadius = 1.0f;
    tblayer.shadowOpacity = 0.50f;
    tblayer.shadowPath = [[UIBezierPath bezierPathWithRect:tblayer.bounds] CGPath];
    
    [self.groupLabel setText:[NSString stringWithFormat: @"@%@", self.group.data[@"name"]]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
    }];
}

- (IBAction)onCompose:(id)sender {
    ComposeMessageViewController *composeView = [[ComposeMessageViewController alloc] init];
    composeView.group = self.group;
    NSLog(@"TTests");
    
    [self presentViewController:composeView animated:YES completion:nil];
}
@end

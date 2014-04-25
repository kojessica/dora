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
    self.composedText.delegate = self;
    [self.backButton setTitle:[NSString stringWithFormat:@" @%@", self.group.name] forState:UIControlStateNormal];
    
    [self.composedText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.backgroundColor = [UIColor colorWithRed:250 green:250 blue:250 alpha:1.f];
}

- (IBAction)didClickSend:(id)sender {
    NSLog(@"%@", [self group]);
    NSLog(@"%@", [self composedText].text);
    NSLog(@"%@", [[LocationController sharedLocationController] locationManager].location);
    
    if ([[self composedText].text length] > 0) {
        NSString *newkey = [Post setRandomKey];
        
        [Post postWithUser:[User currentUser] group:[self group] text:[self composedText].text location:[[LocationController sharedLocationController] locationManager].location newKey:newkey];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        Post *post = [Post object];
        post.text = [self composedText].text;
        post.newKey = newkey;
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:post forKey:@"post"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newPostUploaded" object:nil userInfo:userInfo];
    }
}
- (IBAction)onCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

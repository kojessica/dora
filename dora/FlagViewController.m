//
//  FlagViewController.m
//  dora
//
//  Created by Jessica Ko on 5/2/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "FlagViewController.h"

@interface FlagViewController ()

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) id prevSender;
-(void)selectRadio:(id)sender;

@end

@implementation FlagViewController

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
    [self.backButton setTitle:[NSString stringWithFormat:@" @%@", self.group.name] forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaBold" size:15];
    self.doneButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaBold" size:13];
    self.label.font = [UIFont fontWithName:@"ProximaNovaRegular" size:14];
    self.label2.font = [UIFont fontWithName:@"ProximaNovaRegular" size:14];
    _isSelected = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDone:(id)sender {
    if (self.isSelected) {
        [Post flagPostWithId:self.post.objectId];
        
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.post.objectId forKey:@"postId"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"flagThisPost" object:self userInfo:userInfo];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)isSpam:(id)sender {
    [self selectRadio:sender];
}

- (IBAction)isBullying:(id)sender {
    [self selectRadio:sender];
}

- (IBAction)isBadContent:(id)sender {
    [self selectRadio:sender];
}

- (IBAction)isOther:(id)sender {
    [self selectRadio:sender];
}

-(void)selectRadio:(id)sender {
    if (self.isSelected) {
        [self.prevSender setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
        [self.prevSender setSelected:NO];
    }
    [sender setImage:[UIImage imageNamed:@"radio_selected.png"] forState:UIControlStateNormal];
    [sender setSelected:YES];
    self.isSelected = YES;
    self.prevSender = sender;
}
@end

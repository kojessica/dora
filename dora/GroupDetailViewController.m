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
#import "MBProgressHUD.h"
#import "Post.h"
#import "PostCell.h"
#import "SearchResultsViewController.h"

@interface GroupDetailViewController ()

@property (nonatomic,strong) NSArray *posts;

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
    self.postTable.delegate = self;
    self.postTable.dataSource = self;
    
    UINib *customNib = [UINib nibWithNibName:@"PostCell" bundle:nil];
    [self.postTable registerNib:customNib forCellWithReuseIdentifier:@"PostCell"];
    
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
    
    NSLog(@"%@", self.group);
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.postTable addSubview:refreshControl];
    
    [self.groupLabel setText:[NSString stringWithFormat: @"@%@", self.group.name]];
    if (self.group.objectId != nil) {
        [Post retrievePostsFromGroup:self.group completion:^(NSArray *objects, NSError *error) {
            [refreshControl endRefreshing];
            self.posts = objects;
            [self.postTable reloadData];
        }];
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"newPostUploaded"
                                               object:nil];
}

- (void)reload:(UIRefreshControl *)refreshControl
{
    if (self.group.objectId != nil) {
        [Post retrievePostsFromGroup:self.group completion:^(NSArray *objects, NSError *error) {
            [refreshControl endRefreshing];
            self.posts = objects;
            [self.postTable reloadData];
        }];
    }
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"newPostUploaded"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"Posted @%@", self.group.name];
        hud.margin = 15.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender {
    
    NSLog(@"%d", [self.presentingViewController isKindOfClass:[GroupDetailViewController class]]);
    
    if ([self.presentingViewController isKindOfClass:[SearchResultsViewController class]]) {
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:nil];
        }];
    }
}

- (IBAction)onCompose:(id)sender {
    ComposeMessageViewController *composeView = [[ComposeMessageViewController alloc] init];
    composeView.group = self.group;
    
    [self presentViewController:composeView animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)cellHeight:(NSIndexPath *)indexPath
{
    Post *post = [self.posts objectAtIndex:indexPath.row];
    NSString *name = post.text;
    CGSize maximumLabelSize = CGSizeMake(260,9999);
    UIFont *font=[UIFont systemFontOfSize:14];
    CGRect textRect = [name  boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return textRect.size.height;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, [self cellHeight:indexPath] + 44);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCell" forIndexPath:indexPath];
    
    [cell cellWithPost:[self.posts objectAtIndex:indexPath.row]];
    
    return cell;
}


@end

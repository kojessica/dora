//
//  ListViewController.m
//  dora
//
//  Created by Jessica Ko on 4/12/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "ListViewController.h"
#import "TabsController.h"
#import "GroupCell.h"
#import "GroupDetailViewController.h"
#import "Group.h"

@interface ListViewController ()

@property (strong, nonatomic) NSArray *listGroup;

@end

@implementation ListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    //[self.tableView registerNib:[UINib nibWithNibName:@"GroupCell" bundle:nil] forCellWithReuseIdentifier:@"GroupCell"];
    
    self.listGroup = [Group getAllGroups];
    NSLog(@"%@", self.listGroup);
    
    [self.tableView reloadData];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
	[super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
	[super didMoveToParentViewController:parent];
}

#pragma mark - UITableViewDataSource

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.listGroup count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"GroupCell";
    
    GroupCell *cell = (GroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GroupCell" owner:self options:nil];
		cell = (GroupCell*)[nib objectAtIndex:0];
    }
    Group *group = [[Group alloc] init];
    group.data = [[[self.listGroup objectAtIndex:indexPath.row] dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"name",@"objectId",@"location",@"popularIndex",@"totalPosts", nil]] mutableCopy];
    
    NSLog(@"%@", group.data);
    
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell setGroup:group];
    
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"%@, parent is %@", self.title, self.parentViewController);
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
	ListViewController *listViewController1 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	ListViewController *listViewController2 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	
	listViewController1.title = @"Another Tab 1";
	listViewController2.title = @"Another Tab 2";
    
	TabsController *tabBarController = [[TabsController alloc] init];
	tabBarController.viewControllers = @[listViewController1, listViewController2];
	tabBarController.title = @"Modal Screen";
	tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    */
    GroupDetailViewController *groupDetailView = [[GroupDetailViewController alloc] init];
    groupDetailView.title = @"Modal Screen";
	groupDetailView.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    groupDetailView.transitioningDelegate = self;
    groupDetailView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:groupDetailView];
	navController.navigationBar.tintColor = [UIColor blackColor];
    
    [UIView beginAnimations:nil context:nil];
    [self presentViewController:navController animated:YES completion:nil];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
	
}

- (IBAction)done:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end

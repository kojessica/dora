//
//  TDBWalkThroughViewController.m
//  TDBWalkthrough
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import "TDBWalkthrough.h"
#import "TDBWalkThroughViewController.h"
#import "TDBInterface.h"
#import "TDBSimpleWhite.h"

@interface TDBWalkthroughViewController ()

@property (strong, nonatomic) NSMutableArray *viewControllers;

@end

@implementation TDBWalkthroughViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewControllers = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Setup Methods

- (void)setupWithClassName:(NSString *)className nibName:(NSString *)nibName images:(NSArray *)images descriptions:(NSArray *)descriptions
{
    // TODO: must depend on the device
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    NSInteger nbSlides = MAX(images.count, descriptions.count);
    
    for (NSInteger i = 0; i < nbSlides; i++) {
        TDBInterface *slide = [[TDBSimpleWhite alloc] initWithNibName:@"TDBSimpleWhite" bundle:nil];
        
        //TDBInterface *slide = [[NSClassFromString(className) alloc] initWithNibName:nibName bundle:nil];
    
        NSString *text = (i >= descriptions.count) ? @"" : [descriptions objectAtIndex:i];
        UIImage *image = (i >= images.count) ? nil : [images objectAtIndex:i];
        [slide setupWithImage:image andText:text];
        
        slide.delegate = [[TDBWalkthrough sharedInstance] delegate];
        
        slide.view.frame = CGRectMake(width * i, 0, width, height);
        
        [self.scrollView addSubview:slide.view];
        
        [self.viewControllers addObject:slide];
    }
    
    self.scrollView.contentSize = CGSizeMake(width * nbSlides, height);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page == (self.pageControl.numberOfPages - 1)) {
        [(TDBInterface *)self.viewControllers[page] showButtons];
    }
}


@end
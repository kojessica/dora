//
//  HomeViewController.h
//  dora
//
//  Created by Jessica Ko on 4/1/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

- (IBAction)OnRelevantButton:(id)sender;
- (IBAction)OnPopularButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *selectedBar;
@property (weak, nonatomic) IBOutlet UICollectionView *groupCollectionView;

@end

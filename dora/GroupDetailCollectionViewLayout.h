//
//  GroupDetailCollectionViewLayout.h
//  dora
//
//  Created by Benjamin Chang on 5/3/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//
@import UIKit;

@interface GroupDetailCollectionViewLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat latestDelta;
@property (nonatomic, readonly) CGFloat maxParallaxOffset;

@end

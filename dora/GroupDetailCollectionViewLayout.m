//
//  GroupDetailCollectionViewLayout.m
//  dora
//
//  Created by Benjamin Chang on 5/3/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "GroupDetailCollectionViewLayout.h"
@interface GroupDetailCollectionViewLayout()

// arrays to keep track of insert, delete index paths
@property (nonatomic) NSMutableArray *deleteIndexPaths;
@property (nonatomic) NSMutableArray *insertIndexPaths;

@end


@implementation GroupDetailCollectionViewLayout


//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    // Must call super
//    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
//    
//    if ([self.insertIndexPaths containsObject:itemIndexPath])
//    {
//        // only change attributes on inserted cells
//       // if (!attributes)
//            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//        
//        // Configure attributes ...
//        attributes.alpha = 0.0;
//        attributes.center = CGPointMake(_center.x, _center.y);
//        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
//
//    }
//    
//    return attributes;
//}
//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    // So far, calling super hasn't been strictly necessary here, but leaving it in
//    // for good measure
//    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
//    
//    if ([self.deleteIndexPaths containsObject:itemIndexPath])
//    {
//        // only change attributes on deleted cells
//        if (!attributes)
//            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//        
//        // Configure attributes ...
//        attributes.alpha = 0.0;
//        attributes.center = CGPointMake(_center.x, _center.y);
//        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
//    }
//    
//    return attributes;
//}
@end

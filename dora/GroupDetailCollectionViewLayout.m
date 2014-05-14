//
//  GroupDetailCollectionViewLayout.m
//  dora
//
//  Created by Benjamin Chang on 5/3/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "GroupDetailCollectionViewLayout.h"
#import "ParallaxLayoutAttributes.h"
@interface GroupDetailCollectionViewLayout()

// arrays to keep track of insert, delete index paths
@property (nonatomic, strong) NSMutableArray *deleteIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertIndexPaths;

@end


@implementation GroupDetailCollectionViewLayout
static const CGFloat MaxParallaxOffset = 30.0;

+ (Class)layoutAttributesClass
{
    return [ParallaxLayoutAttributes class];
}
- (CGFloat)maxParallaxOffset
{
    return MaxParallaxOffset;
}
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    // Must call super
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertIndexPaths containsObject:itemIndexPath])
    {
        // only change attributes on inserted cells
       // if (!attributes)
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        
        // Configure attributes ...
        attributes.alpha = 0.0;
        attributes.center = CGPointMake(_center.x, _center.y);
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);

    }
    
    return attributes;
}
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    // So far, calling super hasn't been strictly necessary here, but leaving it in
    // for good measure
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deleteIndexPaths containsObject:itemIndexPath])
    {
        // only change attributes on deleted cells
        if (!attributes)
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        
        // Configure attributes ...
        attributes.alpha = 0.0;
        attributes.center = CGPointMake(_center.x, _center.y);
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    }
    
    return attributes;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *layoutAttributesArray =
    [super layoutAttributesForElementsInRect:rect];
    for (ParallaxLayoutAttributes *layoutAttributes in layoutAttributesArray) {
        if (layoutAttributes.representedElementCategory ==
            UICollectionElementCategoryCell)
        {
            layoutAttributes.parallaxOffset =
            [self parallaxOffsetForLayoutAttributes:layoutAttributes];
        }
    }
    return layoutAttributesArray;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ParallaxLayoutAttributes *layoutAttributes = (ParallaxLayoutAttributes *)
    [super layoutAttributesForItemAtIndexPath:indexPath];
    layoutAttributes.parallaxOffset =
    [self parallaxOffsetForLayoutAttributes:layoutAttributes];
    return layoutAttributes;
}
- (CGPoint)parallaxOffsetForLayoutAttributes:(ParallaxLayoutAttributes *)layoutAttributes
{
    NSParameterAssert(layoutAttributes != nil);
    NSParameterAssert([layoutAttributes isKindOfClass:[ParallaxLayoutAttributes class]]);
    
    CGRect bounds = self.collectionView.bounds;
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(bounds),
                                       CGRectGetMidY(bounds));
    CGPoint cellCenter = layoutAttributes.center;
    CGPoint offsetFromCenter = CGPointMake(boundsCenter.x - cellCenter.x,
                                           boundsCenter.y - cellCenter.y);
    
    CGSize cellSize = layoutAttributes.size;
    CGFloat maxVerticalOffsetWhereCellIsStillVisible =
    (bounds.size.height / 2) + (cellSize.height / 2);
    CGFloat scaleFactor = self.maxParallaxOffset /
    maxVerticalOffsetWhereCellIsStillVisible;
    
    CGPoint parallaxOffset = CGPointMake(0.0, offsetFromCenter.y * scaleFactor);
    
    return parallaxOffset;
}
@end

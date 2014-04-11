//
//  UIImage+Crop.m
//  WWDC14
//
//  Created by Nikolas Burk on 11/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "UIImage+Crop.h"

CGRect CGRectTransformToRect(CGRect fromRect, CGRect toRect) {
    CGPoint actualOrigin = (CGPoint){fromRect.origin.x * CGRectGetWidth(toRect), fromRect.origin.y * CGRectGetHeight(toRect)};
    CGSize actualSize = (CGSize){fromRect.size.width * CGRectGetWidth(toRect), fromRect.size.height * CGRectGetHeight(toRect)};
    return (CGRect){actualOrigin, actualSize};
}

@implementation UIImage (Crop)

+ (UIImage *)imageWithImage:(UIImage *)image cropInRect:(CGRect)rect
{
    NSParameterAssert(image != nil);
    if (CGPointEqualToPoint(CGPointZero, rect.origin) && CGSizeEqualToSize(rect.size, image.size))
    {
        return image;
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
    [image drawAtPoint:(CGPoint){-rect.origin.x, -rect.origin.y}];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image cropInRelativeRect:(CGRect)rect
{
    NSParameterAssert(image != nil);
    if (CGRectEqualToRect(rect, CGRectMake(0, 0, 1, 1)))
    {
        return image;
    }
    CGRect imageRect = (CGRect){CGPointZero, image.size};
    CGRect actualRect = CGRectTransformToRect(rect, imageRect);
    return [UIImage imageWithImage:image cropInRect:CGRectIntegral(actualRect)];
}


const CGFloat SHRINKING_FACTOR = 1.0;
const CGFloat MOVING_FACTOR = 10.0;

- (CGRect)centeredSquareArea
{
    
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    BOOL imageIsPortrait = imageWidth < imageHeight;
    
    CGFloat difference, x, y, width, height;
    if (imageIsPortrait)
    {
        difference = imageHeight - imageWidth;
        
        width = imageWidth;
        height = imageWidth;
        
        x = 0.0;
        y = difference / MOVING_FACTOR;
    }
    else
    {
        difference = imageWidth - imageHeight;
        
        
        width = imageHeight;
        height = imageHeight;
        
        x = difference / 2.0;
        y = 0.0;
        
    }
    
    CGRect centeredSquareArea = CGRectMake(x, y, width, height);
    return centeredSquareArea;
}

@end

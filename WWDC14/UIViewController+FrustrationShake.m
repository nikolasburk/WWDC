//
//  UIViewController+FrustrationShake.m
//  SAPNews
//
//  Created by Burk, Nikolas on 7/18/13.
//  Copyright (c) 2013 SAP AG. All rights reserved.
//

#import "UIViewController+FrustrationShake.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark - Frustration shake

@implementation UIViewController (FrustrationShake)

- (BOOL)canBecomeFirstResponder
{
    NSLog(@"DEBUG | %s | ", __func__);
    return NO;
}

- (UIImage *)grabTheView:(UIView *)view
{
    NSLog(@"DEBUG | %s | View: %@", __func__, view);
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenCapture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenCapture;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
//    UIImage *screencap = [self grabTheView:self.parentViewController.view];
    
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"DEBUG | %s | Got shaked", __func__);
    }
}

@end

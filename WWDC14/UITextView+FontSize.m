//
//  UITextView+FontSize.m
//  WWDC14
//
//  Created by Nikolas Burk on 13/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "UITextView+FontSize.h"

@implementation UITextView (FontSize)

-(CGSize) sizeForString:(NSString *)string withWidth:(CGFloat)width
{
    
    CGSize size = [string sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size;
}

@end

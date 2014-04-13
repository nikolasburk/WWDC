//
//  UITextView+FontSize.h
//  WWDC14
//
//  Created by Nikolas Burk on 13/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (FontSize)

-(CGSize) sizeForString:(NSString *)string withWidth:(CGFloat)width;

@end

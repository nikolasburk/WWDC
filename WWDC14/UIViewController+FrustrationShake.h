//
//  UIViewController+FrustrationShake.h
//  SAPNews
//
//  Created by Burk, Nikolas on 7/18/13.
//  Copyright (c) 2013 SAP AG. All rights reserved.
//
//  Implements logic for detecting a shake motion on the phone and opens the pushes the FrustrationShakeViewController on top of the view controller stack.
//  If you don't a view controller in your project to respond to the shake motion, you'll have to overwrite -(BOOL)canBecomeFirstResponder and return NO:
//
//  - (BOOL)canBecomeFirstResponder
//  {
//      return  NO;
//  }


#import <UIKit/UIKit.h>

@interface UIViewController (FrustrationShake)


@end

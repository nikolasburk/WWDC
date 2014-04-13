//
//  HelpShakeViewController.h
//  WWDC14
//
//  Created by Nikolas Burk on 12/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HelpShake <NSObject>

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event; // from UIResponder
- (NSString *)nibNameSuffix;

@end

@interface HelpShakeViewController : UIViewController

+ (void)openHelpShakeViewControllerWithViewController:(id<HelpShake>)viewController;
+ (void)showHelpShakeInfo;

@end

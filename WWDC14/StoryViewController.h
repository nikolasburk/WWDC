//
//  StoryViewController.h
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@interface StoryViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil story:(Story *)story bundle:(NSBundle *)nibBundleOrNil;

@end

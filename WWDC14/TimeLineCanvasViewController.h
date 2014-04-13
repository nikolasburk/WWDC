//
//  TimeLineCanvasViewController.h
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineCanvas.h"
#import "HelpShakeViewController.h"

@interface TimeLineCanvasViewController : UIViewController <TimeLineCanvasDelegate, HelpShake>


- (id)initWithNibName:(NSString *)nibNameOrNil stories:(NSArray *)stories bundle:(NSBundle *)nibBundleOrNil;


@end

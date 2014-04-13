//
//  GameViewController.h
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleGameGridView.h"
#import "Game.h"
#import "QuestionViewControllerTypes.h"
#import "HelpShakeViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface GameViewController : UIViewController <PuzzleGameGridViewDelegate, QuestionViewControllerDelegate, UIAlertViewDelegate, UITabBarControllerDelegate, HelpShake, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) Game *game;



@end


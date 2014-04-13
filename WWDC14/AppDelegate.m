//
//  AppDelegate.m
//  WWDC14
//
//  Created by Nikolas Burk on 04/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "AppDelegate.h"
#import "QuestionReader.h"
#import "GameViewController.h"
#import "StoryBuilder.h"

#define QUIZ_PUZZLE_TAB_INDEX 0
#define TIMELINE_CANVAS_TAB_INDEX 1

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"DEBUG | %s | ", __func__);
    
    UITabBarController *root = ((UITabBarController *)self.window.rootViewController);
    
    NSArray *tabBarItems = root.tabBar.items;
    UITabBarItem *quizPuzzleTabItem = tabBarItems[QUIZ_PUZZLE_TAB_INDEX];
    quizPuzzleTabItem.title = NSLocalizedString(@"Puzzle", nil);
    UITabBarItem *timeLineCanvasTabItem = tabBarItems[TIMELINE_CANVAS_TAB_INDEX];
    timeLineCanvasTabItem.title = NSLocalizedString(@"Time line canvas", nil);
    
    GameViewController *gameViewController = [root.viewControllers firstObject];
    root.delegate = gameViewController;
    
    [StoryBuilder storyBuilderSharedInstance];
    
    return YES;
}
							


@end

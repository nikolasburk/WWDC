//
//  TimeLineCanvasViewController.m
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "TimeLineCanvasViewController.h"
#import "StoryBuilder.h"
#import "StoryThumbnail.h"
#import "StoryViewController.h"

#define BIRTH_YEAR 1989
#define CURRENT_YEAR 2015
#define SKIP_RANGE NSMakeRange(1990, 14)]

#define HELP_SHAKE_NIBNAME_SUFFIX @"TimeLineCanvas"

@interface TimeLineCanvasViewController ()

@property (nonatomic, strong) NSArray *stories;

@end

@implementation TimeLineCanvasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil stories:(NSArray *)stories bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.stories = stories;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    TimeLineCanvas *timeLineCanvas = (TimeLineCanvas *)self.view;
    timeLineCanvas.delegate = self;
    
    // Hide status bar on canvas
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Make sure orientation is in landscape
    //    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    
    TimeLineCanvas *timeLineCanvas = (TimeLineCanvas *)self.view;
    if (!timeLineCanvas.timeLineView)
    {
        [timeLineCanvas buildTimeLineWithWidth:self.view.frame.size.width startYear:BIRTH_YEAR endYear:CURRENT_YEAR skip:SKIP_RANGE;
         NSArray *stories = [[StoryBuilder storyBuilderSharedInstance] stories];
         for(Story *story in stories)
         {
             [timeLineCanvas addStoryThumbnailToCanvasForStory:story];
         }
    }
}
         


#pragma mark - Help shake

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"DEBUG | %s | Got shaked", __func__);
        [HelpShakeViewController openHelpShakeViewControllerWithViewController:self];
    }
}

- (NSString *)nibNameSuffix
{
    return HELP_SHAKE_NIBNAME_SUFFIX;
}


         

         
         



#pragma mark - Time line canvas delegate
     
- (void)timeLineCanvas:(TimeLineCanvas *)timeLineCanvas didSelectStoryThumbnail:(StoryThumbnail *)storyThumbnail
{
    NSLog(@"DEBUG | %s | Did select story: %@", __func__, storyThumbnail.story);
    StoryViewController *storyViewController = [[StoryViewController alloc] initWithNibName:@"StoryViewController" story:storyThumbnail.story bundle:nil];
    storyViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:storyViewController animated:YES completion:nil];
}
     
@end

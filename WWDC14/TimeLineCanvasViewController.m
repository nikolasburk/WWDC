//
//  TimeLineCanvasViewController.m
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "TimeLineCanvasViewController.h"
#import "TimeLineCanvas.h"
#import "StoryBuilder.h"

#define BIRTH_YEAR 1989
#define CURRENT_YEAR 2014
#define SKIP_RANGE NSMakeRange(1990, 14)]


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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    TimeLineCanvas *timeLineCanvas = (TimeLineCanvas *)self.view;
    [timeLineCanvas buildTimeLineWithWidth:self.view.frame.size.width startYear:BIRTH_YEAR endYear:CURRENT_YEAR skip:SKIP_RANGE;
    NSArray *stories = [[StoryBuilder storyBuilderSharedInstance] stories];
    [timeLineCanvas setStories:stories];
    
    NSLog(@"DEBUG | %s | View: %@ (bounds: width = %f; height = %f)", __func__, self.view, self.view.bounds.size.width, self.view.bounds.size.height);
    
    NSLog(@"DEBUG | %s | Time line canvas: %@", __func__, timeLineCanvas);}


@end

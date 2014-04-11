//
//  StoryViewController.m
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController ()

@property (nonatomic, strong) Story *story;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet UITextView *firstTextView;
@property (weak, nonatomic) IBOutlet UITextView *secondTextView;
@property (weak, nonatomic) IBOutlet UITextView *thirdTextView;

@end

@implementation StoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil story:(Story *)story bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.story = story;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.story.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %d", [self.story monthName], self.story.year];

    self.firstImageView.image = self.story.images[0];
    self.firstTextView.text = self.story.paragraphs[0];
    self.firstTextView.font = [UIFont systemFontOfSize:22.0];
    self.firstTextView.textAlignment = NSTextAlignmentCenter;
    
    if ([self.story.images count] > 1 && [self.story.paragraphs count] > 1)
    {
        self.secondImageView.image = self.story.images[1];
        self.secondTextView.text = self.story.paragraphs[1];
        self.secondTextView.font = [UIFont systemFontOfSize:22.0];
        self.secondTextView.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.secondImageView.hidden = YES;
        self.secondTextView.hidden = YES;
    }
    
    if ([self.story.images count] > 2 && [self.story.paragraphs count] > 2)
    {
        self.thirdImageView.image = self.story.images[2];
        self.thirdTextView.text = self.story.paragraphs[2];
        self.thirdTextView.font = [UIFont systemFontOfSize:22.0];
        self.thirdTextView.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.thirdImageView.hidden = YES;
        self.thirdTextView.hidden = YES;
    }
}

- (IBAction)dismissButtonPressed
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end

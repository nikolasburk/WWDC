//
//  ViewController.m
//  WWDC14
//
//  Created by Nikolas Burk on 04/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "ViewController.h"
#import "GridView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GridView *gridView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.gridView setCurrentPattern:MVP_Four];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.gridView setCurrentPattern:MVP_Nine];
}

- (IBAction)setGridPattern:(UIButton *)sender
{
    [self.gridView setCurrentPattern:(MultiViewPattern)sender.tag];
}


@end

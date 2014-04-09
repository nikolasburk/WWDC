//
//  ReplyReader.m
//  WWDC14
//
//  Created by Nikolas Burk on 08/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "ReplyReader.h"

@interface ReplyReader ()
@property (nonatomic, strong) NSString *lastIncorrectAnswer;
@end

@implementation ReplyReader

static ReplyReader *replyReaderSharedInstance = nil;

+ (ReplyReader *)replyReaderSharedInstance
{
    @synchronized(self)
    {
        if (replyReaderSharedInstance == nil)
            replyReaderSharedInstance = [[self alloc] init];
    }
    return replyReaderSharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _negativeReplies = [self readRepliesFromPropertyList:NO];
        _positiveReplies = [self readRepliesFromPropertyList:YES];
    }
    return self;
}

- (NSArray *)readRepliesFromPropertyList:(BOOL)positiveReplies
{
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    // Path to the plist (in the application bundle)
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:positiveReplies ? POSITIVE_REPLIES_FILE_PATH : NEGATIVE_REPLIES_FILE_PATH ofType:SUFFIX_PLIST];
    
    // Build the array from the plist
    NSMutableArray *replies = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    NSLog(@"DEBUG | %s | Read %d %@ replies from property list\n%@", __func__, [replies count], positiveReplies ? @"positive" : @"negative", questions);
    
    return replies;
}

- (NSString *)randomReply:(BOOL)positive
{
    NSInteger max = positive ? [self.positiveReplies count] : [self.negativeReplies count];
    NSInteger randomIndex =  arc4random_uniform(max);
    NSString *reply = positive ? self.positiveReplies[randomIndex] : self.negativeReplies[randomIndex];
    
    // Make sure to never reply two times the same reply
    if ([reply isEqualToString:self.lastIncorrectAnswer])
    {
        return [self randomReply:positive];
    }
    else
    {
        self.lastIncorrectAnswer = positive ? nil : reply;
        return reply;
    }

}

@end

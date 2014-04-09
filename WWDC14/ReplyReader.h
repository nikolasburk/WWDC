//
//  ReplyReader.h
//  WWDC14
//
//  Created by Nikolas Burk on 08/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#define POSITIVE_REPLIES_FILE_PATH @"PositiveReplies"
#define NEGATIVE_REPLIES_FILE_PATH @"NegativeReplies"
#define SUFFIX_PLIST @"plist"

#import <UIKit/UIKit.h>

@interface ReplyReader : UIView

@property (nonatomic, strong, readonly) NSArray *positiveReplies;
@property (nonatomic, strong, readonly) NSArray *negativeReplies;

+ (ReplyReader *)replyReaderSharedInstance;

- (NSString *)randomReply:(BOOL)positive;

@end

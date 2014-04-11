//
//  Story.m
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "Story.h"
#import "UIImage+Crop.h"

@implementation Story

- (id)initWithTitle:(NSString *)title paragraphs:(NSArray *)paragraphs images:(NSArray *)images
{
    self = [super init];
    if (self)
    {
        _title = title;
        _paragraphs = paragraphs;
        _images = images;
    }
    return self;
}

- (id)initWithStoryInfo:(NSDictionary *)storyInfo
{
    self = [super init];
    if (self)
    {
        _storyID = storyInfo[kStoryID];
        _title = storyInfo[kTitle];
        _paragraphs = storyInfo[kParagraphs];
        _images = [self fetchImages:[storyInfo[kImages] integerValue]];
        NSDictionary *time = storyInfo[kTime];
        _year = [time[kYear] integerValue];
        _month = [time[kMonth] integerValue];
    }
    return self;
}



- (NSArray *)fetchImages:(NSInteger)numberOfImages
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for(int i = 0; i < numberOfImages; i++)
    {
        NSString *imageTitle = [NSString stringWithFormat:@"story%@_%d", self.storyID, i];
        UIImage *image = [UIImage imageNamed:imageTitle];
        
        // Cropping
        CGRect centeredSquareArea =  [image centeredSquareArea];
        UIImage *croppedImage = [UIImage imageWithImage:image cropInRect:centeredSquareArea];
        NSLog(@"DEBUG | %s | Add cropped image: %@ (%@)", __func__, imageTitle, croppedImage);
        if (croppedImage)
        {
            [images addObject:croppedImage];
        }
        
        // Shrinking
//        CGSize shrinkedSize = centeredSquareArea.size;        
//        UIGraphicsBeginImageContext(shrinkedSize);
//        [image drawInRect:CGRectMake(0,0,shrinkedSize.width,shrinkedSize.height)];
//        UIImage *shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        [images addObject:shrinkedImage];
        
    }
    return images;
}

- (NSString *)monthName
{
    NSString *monthName = nil;
    switch (_month)
    {
        case 1:
            monthName = NSLocalizedString(@"January", nil);
            break;
        case 2:
            monthName = NSLocalizedString(@"February", nil);
            break;
        case 3:
            monthName = NSLocalizedString(@"March", nil);
            break;
        case 4:
            monthName = NSLocalizedString(@"April", nil);
            break;
        case 5:
            monthName = NSLocalizedString(@"May", nil);
            break;
        case 6:
            monthName = NSLocalizedString(@"June", nil);
            break;
        case 7:
            monthName = NSLocalizedString(@"July", nil);
            break;
        case 8:
            monthName = NSLocalizedString(@"August", nil);
            break;
        case 9:
            monthName = NSLocalizedString(@"September", nil);
            break;
        case 10:
            monthName = NSLocalizedString(@"October", nil);
            break;
        case 11:
            monthName = NSLocalizedString(@"November", nil);
            break;
        case 12:
            monthName = NSLocalizedString(@"December", nil);
            break;
        default:
            break;
    }
    return monthName;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"Story %@ (%@) | %@ %d | %d images | %d paragraphs", self.storyID, self.title, [self monthName], self.year, [self.images count], [self.paragraphs count]];
    return description;
}

@end

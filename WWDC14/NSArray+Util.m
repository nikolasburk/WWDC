//
//  NSArray+Util.m
//  WWDC14
//
//  Created by Nikolas Burk on 07/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "NSArray+Util.h"

@implementation NSMutableArray (Util)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }

}

//- (void)shuffle
//{
//    if ([self count] < 2)
//    {
//        return;
//    }
//    [self shuffleIsShuffled:NO];
//}

- (void)shuffleIsShuffled:(BOOL)isShuffled
{
    if (isShuffled)
    {
        return;
    }
    else
    {
        NSMutableArray *copy = [[NSMutableArray alloc] initWithArray:self];
        
        BOOL seeded = NO;
        if(!seeded)
        {
            seeded = YES;
            srandom(time(NULL));
        }
        
        NSUInteger count = [self count];
        for (NSUInteger i = 0; i < count; ++i)
        {
            // Select a random element between i and end of array to swap with.
            int nElements = count - i;
            int n = (random() % nElements) + i;
            [self exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
        
        for (int i = 0; i < [self count]; i++)
        {
            if (![self[i] isEqual:copy[i]])
            {
                isShuffled = YES;
                break;
            }
        }
        [self shuffleIsShuffled:isShuffled];
    }
}

- (NSArray *)randomObjects:(NSInteger)numberOfRandomObjects
{
    NSMutableArray *shuffledCopy = [[NSMutableArray alloc] initWithArray:self];
    [shuffledCopy shuffle];
    
    NSUInteger randomStart = arc4random_uniform([self count] - numberOfRandomObjects);
    
    NSMutableArray *targetArray = [[NSMutableArray alloc] init];
    
    for (int i = randomStart;i < randomStart+numberOfRandomObjects; i++)
    {
        [targetArray addObject:shuffledCopy[i]];
    }
    return targetArray;
}

@end

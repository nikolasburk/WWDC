//
//  NSArray+Util.h
//  WWDC14
//
//  Created by Nikolas Burk on 07/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Util)

- (void)shuffle;
- (NSArray *)randomObjects:(NSInteger)numberOfRandomObjects;

@end

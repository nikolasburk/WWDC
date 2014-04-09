//
//  PuzzlePiece.m
//  WWDC14
//
//  Created by Nikolas Burk on 08/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "PuzzlePiece.h"

@implementation PuzzlePiece

- (id)initWithCGImage:(CGImageRef)cgImage originalIndex:(NSInteger)originalIndex
{
    self = [super initWithCGImage:cgImage];
    if (self)
    {
        _originalIndex = originalIndex;
    }
    return self;
}

@end

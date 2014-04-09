//
//  GridView.m
//  CameraManager
//
//  Created by Nikolas Burk on 10/22/13.
//  Copyright (c) 2013 Cameramanager. All rights reserved.
//

#import "GridView.h"


#define FRAME_VIEW_TAG 42
#define DROPPABLEVIEW_ANIMATION_DURATION 0.2

#define SELECTION_COLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]

@implementation GridView

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //NSLog(@"DEBUG[StreamGridView]: Init with coder...");
        _currentPattern = MVP_One;
        UIImageView *dummyImageBackground = [self dummyViewForCurrentMultiViewPattern];
        [dummyImageBackground setFrame:self.bounds];
        _contentViews = [[NSMutableArray alloc] initWithObjects:dummyImageBackground, nil];
        [self addSubview:dummyImageBackground];
        
        self.selectedViewIndex = -1;
        _isDragging = NO;
    }
    return self;
}
*/
 
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSLog(@"DEBUG[StreamGridView]: Init with coder...");
        _currentPattern = MVP_Nine;
        UIImageView *dummyImageBackground = [self dummyViewForCurrentMultiViewPattern];
        [dummyImageBackground setFrame:self.bounds];
        _contentViews = [[NSMutableArray alloc] initWithObjects:dummyImageBackground, nil];
        [self addSubview:dummyImageBackground];
        
        self.selectedViewIndex = -1;
        _isDragging = NO;
        _dragAndDropEnabled = NO;
    }
    return self;
}

- (void)setDelegate:(id<GridViewDelegate>)delegate
{
    _delegate = delegate;
}


#pragma mark - Grid control API

- (void)setCurrentPattern:(MultiViewPattern)pattern
{
    if (_delegate && [_delegate respondsToSelector:@selector(willChangeGridPatternFromPattern:toPattern:)])
    {
        [_delegate willChangeGridPatternFromPattern:_currentPattern toPattern:pattern];
    }
        
    int oldSelectedIndex = _selectedViewIndex;
    int newSelectedIndex = oldSelectedIndex >= pattern ? [self indexForFirstStreamViewInGrid] : oldSelectedIndex;
    _selectedViewIndex = newSelectedIndex < 0 ? 0 : newSelectedIndex;
    
    _currentPattern = pattern;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didDeselectStreamView:atIndex:)])
    {
        if (oldSelectedIndex < [_contentViews count])
        {
            [_delegate didDeselectStreamView:_contentViews[oldSelectedIndex] atIndex:oldSelectedIndex];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectStreamView:atIndex:)])
    {
        [_delegate didSelectStreamView:_contentViews[_selectedViewIndex] atIndex:_selectedViewIndex];
    }
    
    [self removeSelectionFrameFromView];
    [self removeContentViewsFromView];
    [self buildCurrentPattern];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didChangeGridPatternFromPattern:toPattern:)])
    {
        [_delegate didChangeGridPatternFromPattern:_currentPattern toPattern:pattern];
    }
}

- (MultiViewPattern)getCurrentPattern
{
    return _currentPattern;
}

- (void)setContentView:(UIView *)streamView atIndex:(int)index
{
    if (index > _currentPattern)
    {
        //NSLog(@"ERROR[StreamGridView]: Cannot set view at index %d (current pattern is %d)", index, _currentPattern);
        return;
    }

    CGFloat streamViewWidth = self.frame.size.width / sqrt(_currentPattern);
    CGFloat streamViewHeight = self.frame.size.height / sqrt(_currentPattern);

    CGFloat x = [self getXForIndex:index withStreamViewWidth:streamViewWidth];
    CGFloat y = [self getYForIndex:index withStreamViewHeight:streamViewHeight];
    
    [streamView setFrame:CGRectMake(x, y, streamViewWidth, streamViewHeight)];
    
    if ([_contentViews objectAtIndex:index])
    {
        [_contentViews replaceObjectAtIndex:index withObject:streamView];
    }
    else
    {
        [_contentViews addObject:streamView];
    }
    
    [self removeContentViewsFromView];
    [self buildCurrentPattern];
    
    [self setSelectedViewIndex:index];
}

//- (void)addActiveStreamViewToContentViews:(UIView *)streamView atIndex:(NSInteger)index
//{
//    // Fill the intermediate content views with dummy views
//    int neededDummyViews = index - [_contentViews count];
//    
//    NSMutableArray *dummyViews;
//    if (neededDummyViews > 0)
//    {
//        dummyViews = [[NSMutableArray alloc] init];
//        for (int i = 0; i < neededDummyViews; i++)
//        {
//            [dummyViews addObject:[self dummyViewForCurrentMultiViewPattern]];
//        }
//    }
//    
//    // Update the content views
//    if (dummyViews)  [_contentViews addObjectsFromArray:dummyViews];  
//    [_contentViews addObject:streamView];
//}

- (void)removeContentViewAtIndex:(NSInteger)index
{
    //NSLog(@"DEBUG[StreamGridView]: Remove stream view at index: %d", index);
    
    UIView *viewToRemove = _contentViews[index];
    if (_delegate && [_delegate respondsToSelector:@selector(willRemoveView:atIndex:)])
    {
        [_delegate willRemoveView:viewToRemove atIndex:index];
    }
    
    UIImageView *dummyView = [self dummyViewForCurrentMultiViewPattern];
    CGFloat x = [self getXForIndex:index withStreamViewWidth:dummyView.frame.size.width];
    CGFloat y = [self getYForIndex:index withStreamViewHeight:dummyView.frame.size.height];

    [dummyView setFrame:CGRectMake(x, y, dummyView.frame.size.width, dummyView.frame.size.height)];
    
    [_contentViews replaceObjectAtIndex:index withObject:dummyView];
    
    // Reset selected view index to first stream view in content views
    for (int i = 0; i < _currentPattern; i++)
    {
        #pragma warning StreamView
        if ([_contentViews[i] isKindOfClass:[UIView class]])
        {
            _selectedViewIndex = i;
            break;
        }
    }
    _selectedViewIndex = [self indexForFirstStreamView] >= _currentPattern ? 0 : [self indexForFirstStreamView];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectStreamView:atIndex:)])
    {
        [_delegate didSelectStreamView:_contentViews[_selectedViewIndex] atIndex:_selectedViewIndex];
    }
    
    [self removeContentViewsFromView];
    [self buildCurrentPattern];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didRemoveView:atIndex:)])
    {
        [_delegate didRemoveView:viewToRemove atIndex:index];
    }
}

// Does not handle the selection of any of the exchanged views! (to be done by the calling class)
- (void)exchangeContentViewAtIndex:(NSInteger)index1 withContentViewAtIndex:(NSInteger)index2
{
    if (index1 < 0 || index1 >= [_contentViews count] || index2 < 0 || index2 >= [_contentViews count])
    {
        NSLog(@"ERROR[StreamGridView]: Can not exchange content views, index out of range: ({%d, %d} > %d (current grid size) or < 0)", index1, index2, _currentPattern);
        return;
    }
    
    [_contentViews exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    
    [self removeContentViewsFromView];
    [self buildCurrentPattern];
}

- (void)removeAllStreamViews
{
    [self removeContentViewsFromView];
    [_contentViews removeAllObjects];
    _selectedViewIndex = 0;
    [self buildCurrentPattern];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectStreamView:atIndex:)])
    {
        [_delegate didSelectStreamView:_contentViews[_selectedViewIndex] atIndex:_selectedViewIndex];
    }
}

- (NSInteger)indexForNextFreeViewInGrid
{
    for (int i = 0; i < _currentPattern; i++)
    {
#pragma warning StreamView
        if (![_contentViews[i] isKindOfClass:[UIView class]])
        {
            return i;
        }
    }
    return -1;
}

- (NSInteger)indexForFirstStreamViewInGrid
{
    if (_currentPattern <= [_contentViews count])
    {
        for (int i = 0; i < _currentPattern; i++)
        {
#pragma warning StreamView
            if ([_contentViews[i] isKindOfClass:[UIView class]])
            {
                return i;
            }
        }
    }

    return 0;
}

- (NSInteger)numberOfCurrentlyActiveStreamViews
{
    NSInteger numberOfStreamViews = 0;
    for (int i = 0; i < _currentPattern; i++)
    {
        #pragma warning StreamView
        if ([_contentViews[i] isKindOfClass:[UIView class]])
        {
            numberOfStreamViews++;
        }
    }
    return numberOfStreamViews;
}

- (UIView *)viewForIndex:(int)index
{
    return (index < 0 || index >= [_contentViews count]) ? nil : _contentViews[index];
}

- (NSInteger)indexForView:(UIView *)view
{
    for (int i = 0; i < [_contentViews count]; i++)
    {
        if ([view isEqual:_contentViews[i]])
        {
            return i;
        }
    }
    return -1;
}

- (void)refresh
{
    [self removeContentViewsFromView];
    [self buildCurrentPattern];
}

#pragma mark - Stream view selection

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    int selectedIndex = [self getSelectedViewIndexFromTap:tapGestureRecognizer];
    [self setSelectedViewIndex:selectedIndex];
}

/*
- (void)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    int selectedIndex = [self getSelectedViewIndexFromTap:tapGestureRecognizer];
    [self removeViewAtIndex:selectedIndex];
}
*/


#pragma mark - Selected view control

- (void)setSelectedViewIndex:(NSInteger)selectedViewIndex
{
    NSInteger oldIndex = _selectedViewIndex;
    
    // Notify delegate that some view was deselected
    if (_delegate && [_delegate respondsToSelector:@selector(didDeselectStreamView:atIndex:)])
    {
        [_delegate didDeselectStreamView:nil atIndex:oldIndex];
    }
    
    // Update index
    _selectedViewIndex = selectedViewIndex;
    
    // Notify delegate about the new selection
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectStreamView:atIndex:)])
    {
        [_delegate didSelectStreamView:_contentViews[_selectedViewIndex] atIndex:_selectedViewIndex];
    }
    
    // Update grid organization
    [self removeContentViewsFromView];
    [self buildCurrentPattern];
}

// Create the frame for a view in the grid at a certain index
- (void)createFrameForViewAtIndex:(int)index withFrameColor:(UIColor *)frameColor
{
    if (index < 0)
    {
        return;
    }
    
    CGRect selectedViewRect = ((UIView *)_contentViews[index]).frame;
    
    CGFloat baseX = selectedViewRect.origin.x;
    CGFloat baseY = selectedViewRect.origin.y;
    CGFloat baseWidth = selectedViewRect.size.width;
    CGFloat baseHeight = selectedViewRect.size.height;
    
    CGFloat frameWidth = 5.0;
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(baseX, baseY, baseWidth, frameWidth)];
    topLine.tag = FRAME_VIEW_TAG + index;
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(baseX, baseY + baseHeight - frameWidth, baseWidth, frameWidth)];
    bottomLine.tag = FRAME_VIEW_TAG + index;
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(baseX, baseY, frameWidth, baseHeight)];
    leftLine.tag = FRAME_VIEW_TAG + index;
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(baseX + baseWidth - frameWidth, baseY, frameWidth, baseHeight)];
    rightLine.tag = FRAME_VIEW_TAG + index;

    [self createTransparencyForFrameLine:topLine isVertical:NO opaqueFirst:YES withColor:frameColor];
    [self createTransparencyForFrameLine:bottomLine isVertical:NO opaqueFirst:NO withColor:frameColor];
    [self createTransparencyForFrameLine:leftLine isVertical:YES opaqueFirst:YES withColor:frameColor];
    [self createTransparencyForFrameLine:rightLine isVertical:YES opaqueFirst:NO withColor:frameColor];

    [self addSubview:topLine];
    [self addSubview:bottomLine];
    [self addSubview:leftLine];
    [self addSubview:rightLine];
}

- (NSInteger)getSelectedViewIndexFromTap:(UIGestureRecognizer *)gestureRecognizer;
{
    CGPoint tappedPoint = [gestureRecognizer locationInView:self];
    
    CGFloat tappedX = tappedPoint.x;
    CGFloat tappedY = tappedPoint.y;
    
    CGFloat questionViewEdgeLength = self.bounds.size.width / sqrt(_currentPattern);
    
    NSInteger column = tappedX / questionViewEdgeLength;
    NSInteger row = tappedY / questionViewEdgeLength;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        int index = row *  sqrt(_currentPattern) + column;
        return index;
//        for (int i = 0; i < _currentPattern; i++)
//        {
//            if ([_contentViews[i] isEqual:gestureRecognizer.view])
//            {
//                return i;
//            }
//        }
    }
    return -1;
}


#pragma mark - Drag and drop

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (_dragAndDropEnabled)
    {
        [super touchesBegan:touches withEvent:event];
        _tapTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(startDragging:) userInfo:touches repeats:NO];
    }
}

- (void)startDragging:(NSTimer *)tapTimer
{
    if (_dragAndDropEnabled)
    {
        NSSet *touches = [tapTimer isValid] ? [tapTimer userInfo] : nil;
        [tapTimer invalidate];
        
        int touchedIndex = [self indexForLocation:[((UITouch *)[touches anyObject]) locationInView:self]];
        //NSLog(@"DEBUG[StreamGridView]: Start dragging (at index: %d)", touchedIndex);
        
        if (touchedIndex < 0)
        {
            //NSLog(@"DEBUG[StreamGridView]: DONT EVEN TRY TO ACCESS THE CONTENT VIEWS AT INDEX -1!!!!!!");
            return;
        }
        
        UIView *touchedStreamView = _contentViews[touchedIndex];
        
#pragma warning StreamView
        if (![touchedStreamView isKindOfClass:[UIView class]])
        {
            //NSLog(@"DEBUG[StreamGridView]: I DONT ALLOW TO DRAG DUMMY VIEWS!!!!");
            return;
        }
        
        [self removeSelectionFrameFromView];
        
        NSInteger oldIndex = _selectedViewIndex;
        _selectedViewIndex = touchedIndex;
        
        
        [self createFrameForViewAtIndex:_selectedViewIndex withFrameColor:SELECTION_COLOR];
        _lastSelectedIndexWhileDragging = -1;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectStreamView:atIndex:)])
        {
            [_delegate didSelectStreamView:(UIView *)touchedStreamView atIndex:_selectedViewIndex];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(didDeselectStreamView:atIndex:)])
        {
            [_delegate didDeselectStreamView:(UIView *)touchedStreamView atIndex:oldIndex];
        }
        
        _draggedView = touchedStreamView;
        _isDragging = YES;
        [self dragView:_draggedView atPosition:[touches anyObject]];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startDragging:) object:nil];
    if (_isDragging)
    {
        [super touchesMoved:touches withEvent:event];
        [self dragView:_draggedView atPosition:[touches anyObject]];
        if (_lastSelectedIndexWhileDragging != -1)
        {
            [self removeSelectionFrameFromStreamViewWithIndex:_lastSelectedIndexWhileDragging];
        }
        int newIndex = [self indexForLocation:[((UITouch *)[touches anyObject]) locationInView:self]];
        _lastSelectedIndexWhileDragging = newIndex;
        //NSLog(@"DEBUG[StreamGridView]: Touches moved, new index: %d", newIndex);
  
        if (newIndex != [self indexForDraggedView:_draggedView] && newIndex <= [_contentViews count] && newIndex >= 0)
        {
            [self createFrameForViewAtIndex:newIndex withFrameColor:SELECTION_COLOR];
        }
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startDragging:) object:nil];
    if ([_tapTimer isValid])
    {
        [_tapTimer invalidate];
        _tapTimer = nil;
        _draggedView = nil;
        _isDragging = NO;
        return;
    }
    
    if (![_tapTimer isValid] && _isDragging)
    {
        [super touchesEnded:touches withEvent:event];
        
        int targetIndex = [self indexForLocation:[((UITouch *)[touches anyObject]) locationInView:self]];
        int sourceIndex = [self indexForDraggedView:_draggedView];
        
        //NSLog(@"DEBUG[StreamGridView]: Swap indexes: %d --> %d", sourceIndex, targetIndex);
        
        if (targetIndex == sourceIndex)
        {
            [self removeContentViewsFromView];
            [self buildCurrentPattern];
        }
        else if(targetIndex == -1)
        {
            [self removeContentViewAtIndex:sourceIndex];
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(willExchangeView:atIndex:withView:atIndex:)])
            {
                [_delegate willExchangeView:_contentViews[sourceIndex] atIndex:sourceIndex withView:_contentViews[targetIndex] atIndex:targetIndex];
            }
            
            [_contentViews exchangeObjectAtIndex:sourceIndex withObjectAtIndex:targetIndex];
            [self removeContentViewsFromView];
            _selectedViewIndex = targetIndex;
            
            if (_delegate && [_delegate respondsToSelector:@selector(didSelectStreamView:atIndex:)])
            {
                [_delegate didSelectStreamView:_contentViews[_selectedViewIndex] atIndex:_selectedViewIndex];
            }
            
            [self buildCurrentPattern];
            
            if (_delegate && [_delegate respondsToSelector:@selector(didExchangeView:atIndex:withView:atIndex:)])
            {
                [_delegate didExchangeView:_contentViews[sourceIndex] atIndex:sourceIndex withView:_contentViews[targetIndex] atIndex:targetIndex];
            }
        }
        
        _isDragging = NO;
        _draggedView = nil;
        //[self endDrag];
    }
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesCancelled:touches withEvent:event];
    //NSLog(@"DEBUG[StreamGridView]: Touches cancelled");
    
    if ([_tapTimer isValid])
    {
        [_tapTimer invalidate];
        _tapTimer = nil;
        _draggedView = nil;
        _isDragging = NO;
        return;
    }
}

- (void)dragView:(UIView *)view atPosition:(UITouch *)touch;
{
    // animate into new position
	[UIView animateWithDuration:DROPPABLEVIEW_ANIMATION_DURATION animations:^{
        view.center = [touch locationInView:self];
    }];
    [self bringSubviewToFront:view];
}

- (NSInteger)indexForLocation:(CGPoint)location
{
    NSInteger index;
    
    CGFloat streamViewWidth = self.frame.size.width / sqrt(_currentPattern);
    CGFloat streamViewHeight = self.frame.size.height / sqrt(_currentPattern);
    
    CGFloat x = location.x;
    CGFloat y = location.y;
    
    // The target location has to be somewhere on the grid itself, otherwise return -1 to indicate the location is not on the grid
    if (x > 0.0 && y > 0.0 && x < self.frame.size.width && y < self.frame.size.height)
    {
        int indexX;
        int indexY;
        
        indexX = x / streamViewWidth;
        indexY = y / streamViewHeight;
        
        index = indexX +  indexY * sqrt(_currentPattern);
    }
    
    else
    {
        index = -1;
    }
    return index;
}

- (NSInteger)indexForDraggedView:(UIView *)view
{
    int sourceIndex = 0;
    for (UIView *view in _contentViews)
    {
        if ([view isEqual:_draggedView])
        {
            return sourceIndex;
        }
        sourceIndex++;
    }
    return sourceIndex;
}

- (NSMutableArray *)getContentViews
{
    return _contentViews;
}

- (void)disableDragAndDrop
{
    _dragAndDropEnabled = NO;
}

- (void)enableDragAndDrop
{
    _dragAndDropEnabled = YES;
}

- (void)clear
{
    for (UIView *view in _contentViews)
    {
        [view removeFromSuperview];
    }
    [_contentViews removeAllObjects];
}

#pragma mark - Helpers

- (NSInteger)indexForFirstStreamView
{
    int i = 0;
    for (UIView *view in _contentViews)
    {
#pragma warning StreamView
        if ([view isKindOfClass:[UIView class]])
        {
            break;
        }
        i++;
    }
    return i;
}

- (void)buildCurrentPattern
{
    CGFloat streamViewWidth = self.frame.size.width / sqrt(_currentPattern);
    CGFloat streamViewHeight = self.frame.size.height / sqrt(_currentPattern);
    
    // Check if dummy views are needed, and if so create them
    int neededDummyViews = _currentPattern - [_contentViews count];

    NSMutableArray *dummyViews;
    if (neededDummyViews > 0)
    {
        dummyViews = [[NSMutableArray alloc] init];
        for (int i = 0; i < neededDummyViews; i++)
        {
            [dummyViews addObject:[self dummyViewForCurrentMultiViewPattern]];
        }
    }
    
    // Update the content views
    if (dummyViews)  [_contentViews addObjectsFromArray:dummyViews];
    
    // Set the frame for the updated content views
    for (int i = 0; i < _currentPattern; i++)
    {
        CGFloat x = [self getXForIndex:i withStreamViewWidth:streamViewWidth];
        CGFloat y = [self getYForIndex:i withStreamViewHeight:streamViewHeight];
        UIView *view = _contentViews[i];
        [view setFrame:CGRectMake(x, y, streamViewWidth, streamViewHeight)];
        [self addSubview:view];
    }
    
    // Update selected view
    (_currentPattern == MVP_One) ? [self removeSelectionFrameFromView] : [self createFrameForViewAtIndex:_selectedViewIndex withFrameColor:SELECTION_COLOR];
    
}

- (void)removeContentViewsFromView
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }

}

- (void)removeSelectionFrameFromView
{
    for (UIView *view in self.subviews)
    {
        if (view.tag >= FRAME_VIEW_TAG)
        {
            [view removeFromSuperview];
        }
    }

}

- (void)removeSelectionFrameFromStreamViewWithIndex:(int)index
{
    for (UIView *view in self.subviews)
    {
        if (view.tag == FRAME_VIEW_TAG + index)
        {
            [view removeFromSuperview];
        }
    }
}

- (CGFloat)getXForIndex:(int)index withStreamViewWidth:(CGFloat)streamViewWidth
{
    CGFloat x = (_currentPattern == MVP_One) ? 0.0 : streamViewWidth * (index % (int)sqrt(_currentPattern));
    return x;
}

- (CGFloat)getYForIndex:(int)index withStreamViewHeight:(CGFloat)streamViewHeight
{
    CGFloat y = (_currentPattern == MVP_One) ? 0.0 : streamViewHeight * (index / (int)sqrt(_currentPattern));
    return y;
}

- (UIImageView *)dummyViewForCurrentMultiViewPattern
{
    CGFloat streamViewWidth = self.frame.size.width / sqrt(_currentPattern);
    CGFloat streamViewHeight = self.frame.size.height / sqrt(_currentPattern);
    
    UIImageView *dummyImageBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multiViewHolder"]];
    [dummyImageBackground setFrame:CGRectMake(0.0, 0.0, streamViewWidth, streamViewHeight)];
    
    return dummyImageBackground;
}

- (UIView *)createTransparencyForFrameLine:(UIView *)frameLine isVertical:(BOOL)isVertical opaqueFirst:(BOOL)opaqueFirst withColor:(UIColor *)color
{
    //UIColor *selectionColor = FIREBRICK; // [WhitelabelHelper navigationBarGradientBottom];
    int steps = isVertical ? frameLine.frame.size.width : frameLine.frame.size.height;
    
    for (int i = 0; i < steps; i++)
    {
        CGFloat x;
        CGFloat y; 
        CGFloat width;
        CGFloat height;

        if (isVertical)
        {
            x = i;
            y = 0.0;
            width = 1.0;
            height = frameLine.frame.size.height;
        }
        else
        {
            x = 0.0;
            y = i;
            width = frameLine.frame.size.width;
            height = 1.0;
        }
        
        UIView *pixelLine = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        pixelLine.backgroundColor = color;
        pixelLine.opaque = NO;
        
        CGFloat alpha = opaqueFirst ? 1 - ((float)i/(float)steps) : ((float)i/(float)steps);
        pixelLine.alpha = alpha;
        
        [frameLine addSubview:pixelLine];
    }
    return frameLine;
}



@end

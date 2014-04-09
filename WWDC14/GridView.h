//
//  StreamGridView.h
//  CameraManager
//
//  Created by Nikolas Burk on 10/22/13.
//  Copyright (c) 2013 Cameramanager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridViewSelection.h"

#define MAX_CONTENT_VIEWS 9


typedef enum
{
    MVP_One = 1,
    MVP_Four = 4,
    MVP_Nine = 9
    
} MultiViewPattern;

@protocol GridViewDelegate <NSObject>

- (void)willRemoveView:(UIView *)view atIndex:(NSInteger)index;
- (void)didRemoveView:(UIView *)view atIndex:(NSInteger)index;
- (void)didSelectStreamView:(UIView *)streamView atIndex:(NSInteger)index;
- (void)didDeselectStreamView:(UIView *)streamView atIndex:(NSInteger)index;
- (void)willChangeGridPatternFromPattern:(MultiViewPattern)oldPattern toPattern:(MultiViewPattern)newPattern;
- (void)didChangeGridPatternFromPattern:(MultiViewPattern)oldPattern toPattern:(MultiViewPattern)newPattern;

@optional
- (void)willExchangeView:(UIView *)sourceView atIndex:(NSInteger)sourceIndex withView:(UIView *)targetView atIndex:(NSInteger)targetIndex;
- (void)didExchangeView:(UIView *)sourceView atIndex:(NSInteger)sourceIndex withView:(UIView *)targetView atIndex:(NSInteger)targetIndex;

@end

@interface GridView : UIView <GridViewSelection>
{
    MultiViewPattern _currentPattern;
    NSMutableArray *_contentViews;
    
    BOOL _isDragging;
    UIView *_draggedView;
    int _lastSelectedIndexWhileDragging;
    
    NSTimer *_tapTimer;
    id<GridViewDelegate> _delegate;
    
}

@property (nonatomic) NSInteger selectedViewIndex;
@property (nonatomic, assign, readonly) BOOL dragAndDropEnabled;

- (void)setCurrentPattern:(MultiViewPattern)pattern;
- (MultiViewPattern)getCurrentPattern;
- (NSInteger)numberOfCurrentlyActiveStreamViews;

- (void)setContentView:(UIView *)contentView atIndex:(int)index;
- (void)removeContentViewAtIndex:(NSInteger)index;
- (void)exchangeContentViewAtIndex:(NSInteger)index1 withContentViewAtIndex:(NSInteger)index2;
- (NSInteger)getSelectedViewIndexFromTap:(UIGestureRecognizer *)tapGestureRecognizer;
- (NSInteger)indexForView:(UIView *)view;
- (void)removeAllStreamViews;
- (NSInteger)indexForNextFreeViewInGrid;
- (NSInteger)indexForFirstStreamViewInGrid;
- (UIView *)viewForIndex:(int)index;
- (void)setDelegate:(id<GridViewDelegate>)delegate;
- (NSMutableArray *)getContentViews;
//- (void)addActiveStreamViewToContentViews:(UIView *)streamView atIndex:(NSInteger)index;

- (void)refresh;
- (void)clear;

- (void)disableDragAndDrop;
- (void)enableDragAndDrop;


@end

//
//  DraggableView.m
//
//
//  Created by Raphaël Pinto on 02/08/13.
//
//
// The MIT License (MIT)
// Copyright (c) 2012 Raphael Pinto.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.



#import "DraggableView.h"




#define kDraggableViewLastPosition          @"DraggableViewLastPosition"
#define kMaxDragDistanceForTouchUpDetection 5.



@implementation DraggableView



#pragma mark -
#pragma mark View Life Cycle Methods



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"DraggableView" owner:self options:nil];
        self.mContentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.mContentView];
    }
    
    return self;
}


- (void)dealloc
{
    [_mContentView release];
    [super dealloc];
}



#pragma mark -
#pragma mark User Interaction Methods



- (IBAction)wasDragged:(id)_Button forEvent:(UIEvent *)_Event
{
    UITouch *lTouch = [[_Event touchesForView:_Button] anyObject];
    
	CGPoint lPreviousLocation = [lTouch previousLocationInView:_Button];
	CGPoint lCurrentLocation  = [lTouch locationInView:_Button];

    float newX = self.frame.origin.x;
    float newY = self.frame.origin.y;
    
    if (self.frame.origin.x + lCurrentLocation.x - lPreviousLocation.x + (self.frame.size.width / 2) > 0 &&
        self.frame.origin.x + lCurrentLocation.x - lPreviousLocation.x + (self.frame.size.width / 2) < [UIApplication sharedApplication].delegate.window.frame.size.width)
    {
        newX += lCurrentLocation.x - lPreviousLocation.x;
    }
    
    if (self.frame.origin.y + lCurrentLocation.y - lPreviousLocation.y + (self.frame.size.height / 2) > 0 &&
        self.frame.origin.y + lCurrentLocation.y - lPreviousLocation.y + (self.frame.size.height / 2) < [UIApplication sharedApplication].delegate.window.frame.size.height)
    {
        newY += lCurrentLocation.y - lPreviousLocation.y;
    }
    
    self.frame = CGRectMake(newX,
                            newY,
                            self.frame.size.width,
                            self.frame.size.height);
    
    [self saveLastPosition];
}


- (IBAction)onButtonTouchDown:(id)_Sender
{
    _mStartPosition = self.center;
}


- (IBAction)onButtonTouchUpInside:(id)_Sender
{
    if (hypotf(self.center.x - _mStartPosition.x, self.center.y - _mStartPosition.y) < kMaxDragDistanceForTouchUpDetection)
    {
        // You can detect the boutton touch up inside from here.
    }
}



#pragma mark -
#pragma mark Data Management Methods



- (void)saveLastPosition
{
    NSString *lLastPositionStr = NSStringFromCGPoint(CGPointMake(self.frame.origin.x, self.frame.origin.y));
    [[NSUserDefaults standardUserDefaults] setObject:lLastPositionStr forKey:kDraggableViewLastPosition];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end

/*
 * TimelineView.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 18, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

@implementation TimelineView : CPView
{
	CPArray _viewCountArray;
	CPArray _dateArray;
	int _maxViewCount;
}

- (id)initWithFrame:(CGRect)aFrame
{
	if (self = [super initWithFrame:aFrame])
	{
		_viewCountArray = [[CPArray alloc] initWithCapacity:30];
		_dateArray = [[CPArray alloc] initWithCapacity:30];
		_maxViewCount = 0;
	}
	return self;
}

- (void)addViewCount:(int)count forDate:(CPString)date
{
	[_dateArray addObject:date];
	[_viewCountArray addObject:count];
	if (count > _maxViewCount)
		_maxViewCount = count;
}

- (void)drawRect:(CGRect)rect
{
	var centerX = CPRectGetWidth(rect) / 2;
	var centerY = CPRectGetHeight(rect) / 2;
	var totalWidth = 800;
	var totalHeight = 200;
	
	var xIncrement = totalWidth / [_dateArray count];
	var yViewHeight = totalHeight / _maxViewCount;
	
	var gc = [[CPGraphicsContext currentContext] graphicsPort];
	CGContextSetStrokeColor(gc, [CPColor redColor]);
	CGContextSetLineWidth(gc, 3.0);
	
	// move to the origin
	CGContextBeginPath(gc);
	for (var i=0; i < [_viewCountArray count]; i++)
	{
		var x = (centerX-totalWidth/2) + i*xIncrement;
		var y = (centerY+totalHeight/2) - yViewHeight*[_viewCountArray objectAtIndex:i];
		CGContextAddLineToPoint(gc, x, y);
	}
	CGContextStrokePath(gc);
	
	
}

@end
/*
 * TimelineView.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 18, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

@import "DataPointLayer.j"

var totalWidth = 800;
var totalHeight = 200;

@implementation TimelineView : CPView
{
	CPArray _viewCountArray;
	CPArray _dateArray;
	CPArray _dataPointArray;
	CPArray _dataPointLayerArray;
	int _maxViewCount;
	
	CALayer _rootLayer;
	CALayer _axesLayer;
	CALayer _timelineLayer;
}

- (id)initWithFrame:(CGRect)aFrame
{
	if (self = [super initWithFrame:aFrame])
	{
		_viewCountArray = [[CPArray alloc] initWithCapacity:30];
		_dateArray = [[CPArray alloc] initWithCapacity:30];
		_dataPointLayerArray = [[CPArray alloc] initWithCapacity:30];
		_maxViewCount = 0;
		
		// configure the root layer
		_rootLayer = [CALayer layer];
		[self setWantsLayer:YES];
		[self setLayer:_rootLayer];
		[_rootLayer setBackgroundColor:[CPColor whiteColor]];

		// setup the axes layer
		_axesLayer = [CALayer layer];
		[_rootLayer addSublayer:_axesLayer];
		[_axesLayer setDelegate:self];
		[_axesLayer setAnchorPoint:CPPointMakeZero()];
		[_axesLayer setBounds:CGRectMake(0, 0, totalWidth, totalHeight)];
		[_axesLayer setBackgroundColor:[CPColor clearColor]];
		
		// configure the timeline layer
		_timelineLayer = [CALayer layer];
		[_rootLayer addSublayer:_timelineLayer];
		[_timelineLayer setDelegate:self];
		[_timelineLayer setAnchorPoint:CPPointMakeZero()];
		[_timelineLayer setBounds:CGRectMake(0, 0, totalWidth, totalHeight)];
		[_timelineLayer setBackgroundColor:[CPColor clearColor]];
		[_rootLayer setNeedsDisplay];
	}
	return self;
}

- (void)addViewCount:(int)count forDate:(CPString)date
{
	[_dateArray addObject:date];
	[_viewCountArray addObject:count];
	if (count > _maxViewCount)
		_maxViewCount = count;
	
	// remove all the current dataPoint layers
	for (var i=0; i < [_dataPointLayerArray count]; i++)
	{
		[[_dataPointLayerArray objectAtIndex:i] removeFromSuperlayer];
	}
	
	// create the data point array
	_dataPointArray = [[CPArray alloc] initWithCapacity:30];

	// calculate some values used for positioning the points
	var centerX = parseInt(CPRectGetWidth([_timelineLayer frame]) / 2);
	var centerY = parseInt(CPRectGetHeight([_timelineLayer frame]) / 2);
	var xIncrement = totalWidth / [_dateArray count];
	var yViewHeight = (totalHeight - 10) / _maxViewCount;
	
	for (var i=0; i < [_viewCountArray count]; i++)
	{
		// origin + the step forward for this value + 10 (to keep it off the axes)
		var x = (centerX-totalWidth/2) + i*xIncrement + 10;

		// origin - height for one view & view count
		var y = (centerY+totalHeight/2) - yViewHeight*[_viewCountArray objectAtIndex:i];

		[_dataPointArray addObject:CPPointMake(x, y)];
		
		// setup a new DataPointLayer for each point
		var newLayer = [[DataPointLayer alloc] init];
		[newLayer setPosition:CPPointMake(x-[newLayer boundSize]/2, y-[newLayer boundSize]/2)];
		[_timelineLayer addSublayer:newLayer];
		[_dataPointLayerArray addObject:newLayer]
	}
}

- (void)mouseMoved:(CPEvent)anEvent
{
	var originalPoint = [anEvent locationInWindow];
	var newPoint = [self  convertPoint:originalPoint fromView:[[self window] contentView]];
	var hitLayer = [_timelineLayer hitTest:newPoint];

	if (hitLayer != _timelineLayer)
		[hitLayer setBackgroundColor:[CPColor blueColor]];
	[hitLayer setNeedsDisplay];
}

- (void)drawLayer:(CALayer)layer inContext:(CGContext)gc
{
	if (layer == _axesLayer)
	{
		var rect = [layer frame];
		var centerX = parseInt(CPRectGetWidth(rect) / 2);
		var centerY = parseInt(CPRectGetHeight(rect) / 2);
		
		CGContextSetStrokeColor(gc, [CPColor grayColor]);
		CGContextSetLineWidth(gc, 2.0);
		CGContextBeginPath(gc);
		// add 1 to the x points to keep the lines entirely inside the layer
		CGContextAddLineToPoint(gc, centerX-totalWidth/2 + 1, centerY - totalHeight/2);
		CGContextAddLineToPoint(gc, centerX-totalWidth/2 + 1, centerY + totalHeight/2);
		CGContextAddLineToPoint(gc, centerX+totalWidth/2 + 1, centerY + totalHeight/2);
		CGContextStrokePath(gc);
	}
	else if (layer == _timelineLayer)
	{
		CGContextSetStrokeColor(gc, [CPColor redColor]);
		CGContextSetLineWidth(gc, 3.0);
		CGContextSetLineJoin(gc, kCGLineJoinRound);
		// draw the trendline first
		CGContextBeginPath(gc);
		for (var i=0; i < [_dataPointArray count]; i++)
		{
			var point = [_dataPointArray objectAtIndex:i];
			CGContextAddLineToPoint(gc, point.x, point.y);
		}
		CGContextStrokePath(gc);
	}
}

- (void)drawRect:(CGRect)rect
{
	// recenter the layers within the view, in case it was resized
	// ensure the layer is always placed on a pixel by forcing integers
	var centerX = parseInt(CPRectGetWidth(rect) / 2);
	var centerY = parseInt(CPRectGetHeight(rect) / 2);
	
	[_timelineLayer setPosition:CPPointMake(centerX-(totalWidth/2), centerY-(totalHeight/2))];
	[_axesLayer setPosition:CPPointMake(centerX-(totalWidth/2), centerY-(totalHeight/2))];
}

@end

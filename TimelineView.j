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
	CPArray _dataPointArray;
	int _maxViewCount;
	int _circleDiameter;
}

- (id)initWithFrame:(CGRect)aFrame
{
	if (self = [super initWithFrame:aFrame])
	{
		_viewCountArray = [[CPArray alloc] initWithCapacity:30];
		_dateArray = [[CPArray alloc] initWithCapacity:30];
		_maxViewCount = 0;
		_circleDiameter = 10;
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
	// recreate the array each time drawRect is called. Otherwise it keeps adding to itself
	_dataPointArray = [[CPArray alloc] initWithCapacity:30];
	
	var centerX = CPRectGetWidth(rect) / 2;
	var centerY = CPRectGetHeight(rect) / 2;
	var totalWidth = 800;
	var totalHeight = 200;
	
	var xIncrement = totalWidth / [_dateArray count];
	var yViewHeight = (totalHeight - 10) / _maxViewCount;
	
	var gc = [[CPGraphicsContext currentContext] graphicsPort];
	
	CGContextSetStrokeColor(gc, [CPColor redColor]);
	CGContextSetLineWidth(gc, 3.0);
	CGContextSetLineJoin(gc, kCGLineJoinRound);
	
	// draw the trendline first
	CGContextBeginPath(gc);
	for (var i=0; i < [_viewCountArray count]; i++)
	{
		// origin + the step forward for this value + 10 (to keep it off the axes)
		var x = (centerX-totalWidth/2) + i*xIncrement + 10;
		
		// origin - height for one view & view count
		var y = (centerY+totalHeight/2) - yViewHeight*[_viewCountArray objectAtIndex:i];
		
		[_dataPointArray addObject:CPPointMake(x, y)];
		CGContextAddLineToPoint(gc, x, y);
	}
	CGContextStrokePath(gc);
	
	// draw a circle at each data point
	CGContextSetStrokeColor(gc, [CPColor whiteColor]);
	CGContextSetFillColor(gc, [CPColor redColor]);
	CGContextSetLineWidth(gc, 1.5);
	for (var i=0; i < [_dataPointArray count]; i++)
	{
		var point = [_dataPointArray objectAtIndex:i];
		CGContextFillEllipseInRect(gc, CPRectMake(point.x-_circleDiameter/2,
												  point.y-_circleDiameter/2,
												  _circleDiameter,
												  _circleDiameter));
		CGContextStrokeEllipseInRect(gc, CPRectMake(point.x-_circleDiameter/2,
												  point.y-_circleDiameter/2,
												  _circleDiameter,
												  _circleDiameter));
	}
	
	// draw the axes
	CGContextSetStrokeColor(gc, [CPColor grayColor]);
	CGContextSetLineWidth(gc, 2.0);
	CGContextBeginPath(gc);
	CGContextAddLineToPoint(gc, (centerX-totalWidth/2), centerY - totalHeight/2);
	CGContextAddLineToPoint(gc, (centerX-totalWidth/2), centerY + totalHeight/2);
	CGContextAddLineToPoint(gc, (centerX+totalWidth/2), centerY + totalHeight/2);
	CGContextStrokePath(gc);
}

@end

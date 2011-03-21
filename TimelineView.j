/*
 * TimelineView.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 18, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

@import "DataPointLayer.j"
@import "DatePopupView.j"

var totalWidth = 800;
var totalHeight = 150;

@implementation TimelineView : CPView
{
	AppController _appController;
	CPArray _viewCountArray;
	CPArray _dateArray;
	CPArray _dataPointArray;
	CPArray _dataPointLayerArray;
	int _maxViewCount;
	int _currentlySelectedIndex;
	
	CALayer _rootLayer;
	CALayer _axesLayer;
	CALayer _timelineLayer;
	
	CPTextView _topLabel;
	CPTextView _middleLabel;
	CPTextView _leftDateLabel;
	CPTextView _middleDateLabel;
	CPTextView _rightDateLabel;
	
	CPTextView _mainTitle;
	
	DatePopupView _datePopupView;
}

- (id)initWithFrame:(CGRect)aFrame
{
	if (self = [super initWithFrame:aFrame])
	{
		_viewCountArray = [[CPArray alloc] initWithCapacity:30];
		_dateArray = [[CPArray alloc] initWithCapacity:30];
		_dataPointArray = [[CPArray alloc] initWithCapacity:30];
		_dataPointLayerArray = [[CPArray alloc] initWithCapacity:30];
		_maxViewCount = 0;
		_currentlySelectedIndex = -1;
		
		// configure the root layer
		_rootLayer = [CALayer layer];
		[self setWantsLayer:YES];
		[self setLayer:_rootLayer];
		[_rootLayer setBackgroundColor:[CPColor clearColor]];

		// setup the axes layer
		_axesLayer = [CALayer layer];
		[_rootLayer addSublayer:_axesLayer];
		[_axesLayer setDelegate:self];
		[_axesLayer setBounds:CGRectMake(0, 0, totalWidth, totalHeight)];
		[_axesLayer setBackgroundColor:[CPColor clearColor]];
		
		// configure the timeline layer
		_timelineLayer = [CALayer layer];
		[_rootLayer addSublayer:_timelineLayer];
		[_timelineLayer setDelegate:self];
		[_timelineLayer setBounds:CGRectMake(0, 0, totalWidth, totalHeight)];
		[_timelineLayer setBackgroundColor:[CPColor clearColor]];
		[_rootLayer setNeedsDisplay];
		
		// setup the axes labels
		_topLabel = [self labelWithTitle:"12345"];
		_middleLabel = [self labelWithTitle:"12345"];
		_leftDateLabel = [self labelWithTitle:"SomeMonth 1"];
		_middleDateLabel = [self labelWithTitle:"SomeMonth 15"];
		_rightDateLabel = [self labelWithTitle:"SomeMonth 30"];
		
		[_leftDateLabel setAlignment:CPLeftTextAlignment];
		[_middleDateLabel setAlignment:CPLeftTextAlignment];
		
		[self addSubview:_topLabel];
		[self addSubview:_middleLabel];
		[self addSubview:_leftDateLabel];
		[self addSubview:_middleDateLabel];
		[self addSubview:_rightDateLabel];
		
		_mainTitle = [self labelWithTitle:"bnewendorp's Daily Flickr Stats"]
		[_mainTitle setFont:[CPFont boldSystemFontOfSize:16.0]];
		[_mainTitle setAlignment:CPCenterTextAlignment];
		[_mainTitle sizeToFit];
		[self addSubview:_mainTitle];
		
		_datePopupView = [[DatePopupView alloc] initWithFrame:CPRectMake(0, 0, 90, 40)];
		[_datePopupView setFrameOrigin:CPPointMake(100, 100)];
		[_datePopupView setHidden:YES];
		[_datePopupView setAlphaValue:0.9];
		[self addSubview:_datePopupView];
	}
	return self;
}

/////////////////////////////////////////////
// Setup methods

- (void)setAppController:(AppController)controller
{
	_appController = controller;
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
	
	[_dataPointArray removeAllObjects];
	[_dataPointLayerArray removeAllObjects];

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
		[newLayer setPosition:CPPointMake(x, y)];
		[_timelineLayer addSublayer:newLayer];
		[_dataPointLayerArray addObject:newLayer]
	}
	
	[self setAxesLabelValues];
}

- (void)setAxesLabelValues
{
	[_topLabel setStringValue:[CPString stringWithFormat:"%i", _maxViewCount]];
	[_middleLabel setStringValue:[CPString stringWithFormat:"%i", _maxViewCount/2]];
	
	// don't setup the date labels unless we have a few values to use
	if ([_dateArray count] > 2)
	{
		[_leftDateLabel setStringValue:[CPString stringWithFormat:"%@",
												[_dateArray objectAtIndex:0]]];
		[_middleDateLabel setStringValue:[CPString stringWithFormat:"%@",
												[_dateArray objectAtIndex:parseInt([_dateArray count]/2)]]];
		[_rightDateLabel setStringValue:[CPString stringWithFormat:"%@",
												[_dateArray objectAtIndex:[_dateArray count]-1]]];
	}
}

/////////////////////////////////////////////
// Event handling

- (void)mouseMoved:(CPEvent)anEvent
{
	var originalPoint = [anEvent locationInWindow];
	var newPoint = [self convertPoint:originalPoint fromView:[[self window] contentView]];
	var hitLayer = [_timelineLayer hitTest:newPoint];
	var hitIndex = -1;

	// check all the dataPointLayers to see if we hit one
	for (var i=0; i < [_dataPointLayerArray count]; i++)
	{
		var layer = [_dataPointLayerArray objectAtIndex:i];
		
		// if we hit this layer, scale it up a bit
		if (hitLayer == layer)
		{
			hitIndex = i;
			[layer setAffineTransform:CGAffineTransformMakeScale(1.5, 1.5)];
			[layer setFillColor:[CPColor redColor]];
		}
		else if (i == _currentlySelectedIndex)
		{
			[layer setFillColor:[CPColor colorWithCalibratedRed:0.8 green:0.0 blue:0.0 alpha:1.0]];
		}
		else if (i != _currentlySelectedIndex)
		{
			[layer setAffineTransform:CGAffineTransformMakeIdentity()];
			[layer setFillColor:[CPColor darkGrayColor]];
		}
		[layer setNeedsDisplay];
	}
	
	// if we're hitting a point, hide the popup
	if (hitLayer == nil || hitLayer == _timelineLayer)
	{
		[_datePopupView setHidden:YES];
	}
	else
	{
		[_datePopupView setHidden:NO];
		[_datePopupView setDate:[_dateArray objectAtIndex:hitIndex]];
		[_datePopupView setViewCount:[_viewCountArray objectAtIndex:hitIndex]];
		var xPoint = newPoint.x - CGRectGetWidth([_datePopupView frame])/2;
		var yPoint = newPoint.y - CGRectGetHeight([_datePopupView frame]) - 12;
		[_datePopupView setFrameOrigin:CPPointMake(xPoint, yPoint)];
	}
}

- (void)mouseUp:(CPEvent)anEvent
{
	var originalPoint = [anEvent locationInWindow];
	var newPoint = [self convertPoint:originalPoint fromView:[[self window] contentView]];
	var hitLayer = [_timelineLayer hitTest:newPoint];
	
	// check all the dataPointLayers to see if we hit one
	for (var i=0; i < [_dataPointLayerArray count]; i++)
	{
		var layer = [_dataPointLayerArray objectAtIndex:i];
		
		// if we hit this layer, show the photos for that day
		if (hitLayer == layer)
		{
			[hitLayer setFillColor:[CPColor colorWithCalibratedRed:0.8 green:0.0 blue:0.0 alpha:1.0]];
			_currentlySelectedIndex = i;
			[_appController showDataForDayWithIndex:i];
		}
	}
}

/////////////////////////////////////////////
// Drawing methods

- (void)drawLayer:(CALayer)layer inContext:(CGContext)gc
{
	if (layer == _axesLayer)
	{
		var rect = [layer frame];
		var centerX = parseInt(CPRectGetWidth(rect) / 2);
		var centerY = parseInt(CPRectGetHeight(rect) / 2);
		
		CGContextSetStrokeColor(gc, [CPColor blackColor]);
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
		CGContextSetStrokeColor(gc, [CPColor darkGrayColor]);
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
	
	[_timelineLayer setPosition:CPPointMake(centerX, centerY)];
	[_axesLayer setPosition:CPPointMake(centerX, centerY)];
	
	// left of the axis by 40px, at the top of the Y axis
	[_topLabel setFrameOrigin:CGPointMake((centerX-totalWidth/2)-40, (centerY-totalHeight/2)-5)];
	
	// left of the axis by 40 px, at the middle of the Y axis
	[_middleLabel setFrameOrigin:CGPointMake((centerX-totalWidth/2)-40, centerY-5)];
	
	// at the left side of the X axis, below the X axis by 5px
	[_leftDateLabel setFrameOrigin:CGPointMake((centerX-totalWidth/2), (centerY+totalHeight/2)+5)];
	
	// middle of the timeline - the label's width/2, below the X axis by 5px
	[_middleDateLabel setFrameOrigin:CGPointMake(centerX-CPRectGetWidth([_middleDateLabel frame])/2,
												(centerY+totalHeight/2)+5)];
	
	// Right of the X axis - the label's width, below the X axis by 5px
	[_rightDateLabel setFrameOrigin:CGPointMake((centerX+totalWidth/2) - 
															CPRectGetWidth([_rightDateLabel frame]),
												(centerY+totalHeight/2)+5)];
	
	// Centered on the X axis, 10px from the top
	[_mainTitle setFrameOrigin:CGPointMake(centerX-CPRectGetWidth([_mainTitle frame])/2, 10)];
}

/////////////////////////////////////////////
// Helper methods


- (CPTextField)labelWithTitle:(CPString)title
{
	var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
	
	[label setStringValue:title];
	[label setTextColor:[CPColor blackColor]];
	[label setAlignment:CPRightTextAlignment];
	[label sizeToFit];
	
	return label;
}

@end

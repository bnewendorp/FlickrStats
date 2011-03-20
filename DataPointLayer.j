/*
 * DataPointLayer.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 18, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

var circleDiameter = 10;
var bounds = 16;

@implementation DataPointLayer : CALayer
{
	CPColor _fillColor;
}

- (id)init
{
	if (self = [super init])
	{
		[self setDelegate:self];
		[self setBounds:CGRectMake(0, 0, bounds, bounds)];
		[self setBackgroundColor:[CPColor clearColor]];
		_fillColor = [CPColor darkGrayColor];
	}
	return self;
}

- (void)setFillColor:(CPColor)color
{
	_fillColor = color;
}

- (void)drawLayer:(CALayer)layer inContext:(CGContext)gc
{
	CGContextSetStrokeColor(gc, [CPColor whiteColor]);
	CGContextSetFillColor(gc, _fillColor);
	CGContextSetLineWidth(gc, 1.5);
	CGContextFillEllipseInRect(gc, CPRectMake((bounds-circleDiameter)/2,
											  (bounds-circleDiameter)/2,
											  circleDiameter,
											  circleDiameter));
	CGContextStrokeEllipseInRect(gc, CPRectMake((bounds-circleDiameter)/2,
											  (bounds-circleDiameter)/2,
											  circleDiameter,
											  circleDiameter));
}

@end

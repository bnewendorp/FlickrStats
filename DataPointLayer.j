/*
 * DataPointLayer.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 18, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

var _circleDiameter = 10;


@implementation DataPointLayer : CALayer
{
	
}

- (id)init
{
	if (self = [super init])
	{
		[self setDelegate:self];
		[self setAnchorPoint:CPPointMakeZero()];
		[self setBounds:CGRectMake(0, 0, 15, 15)];
		[self setBackgroundColor:[CPColor clearColor]];
	}
	return self;
}

- (void)drawLayer:(CALayer)layer inContext:(CGContext)gc
{
	CGContextSetStrokeColor(gc, [CPColor whiteColor]);
	CGContextSetFillColor(gc, [CPColor redColor]);
	CGContextSetLineWidth(gc, 1.5);
	CGContextFillEllipseInRect(gc, CPRectMake(_circleDiameter/2,
											  _circleDiameter/2,
											  _circleDiameter,
											  _circleDiameter));
	CGContextStrokeEllipseInRect(gc, CPRectMake(_circleDiameter/2,
											  _circleDiameter/2,
											  _circleDiameter,
											  _circleDiameter));
}

@end

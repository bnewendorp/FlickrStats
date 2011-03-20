/*
 * DatePopupView.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 20, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */


@implementation DatePopupView : CPView
{
	CPString _date;
	int _viewCount;
	
	CPImageView _backgroundImageView;
	CPTextField _dateLabel;
	CPTextField _viewCountLabel;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self setBackgroundColor:[CPColor clearColor]];
		
		_backgroundImageView = [[CPImageView alloc] initWithFrame:[self frame]];
		[_backgroundImageView setImage:[
						[CPImage alloc] initWithContentsOfFile:"Resources/Date_Popup_Background.png"
																size:CGSizeMake(88, 37)]];
		[self addSubview:_backgroundImageView];
		_dateLabel = [self labelWithTitle:"SomeMonth 31"];
		_viewCountLabel = [self labelWithTitle:"12345 views"];
		
		[_dateLabel setFrameOrigin:CPPointMake(
					CGRectGetWidth([self frame])/2 - CGRectGetWidth([_dateLabel frame])/2, 0)];
		[_viewCountLabel setFrameOrigin:CPPointMake(
					CGRectGetWidth([self frame])/2 - CGRectGetWidth([_viewCountLabel frame])/2, 14)];
		
		[self addSubview:_dateLabel];
		[self addSubview:_viewCountLabel];
	}
	return self;
}

- (void)setDate:(CPString)date
{
	_date = date;
	[_dateLabel setStringValue:_date];
}

- (void)setViewCount:(int)count
{
	_viewCount = count;
	if (_viewCount != 1)
		[_viewCountLabel setStringValue:[CPString stringWithFormat:"%i views", _viewCount]];
	else
		[_viewCountLabel setStringValue:"1 view"];
}

/////////////////////////////////////////////
// Helper methods

- (CPTextField)labelWithTitle:(CPString)title
{
	var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
	
	[label setStringValue:title];
	[label setTextColor:[CPColor whiteColor]];
	[label setAlignment:CPCenterTextAlignment];
	[label sizeToFit];
	
	return label;
}

@end

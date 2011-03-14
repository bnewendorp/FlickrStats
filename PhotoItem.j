/*
 * PhotoItem.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 13, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

@import <AppKit/CPView.j>
@import "PhotoData.j"

@implementation PhotoItem : CPView
{
	CPImage _image;
	CPImageView _imageView;
	PhotoData _photoData;
	CPView _captionView;
}

- (void)setRepresentedObject:(JSObject)object
{
	_photoData = object;
	
	// setup the imageView if we haven't done it yet
	if (!_imageView)
	{
		_imageView = [[CPImageView alloc] initWithFrame:CGRectMakeCopy([self bounds])];
		[_imageView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[_imageView setImageScaling:CPScaleProportionally];
		[_imageView setHasShadow:YES];
		[self addSubview:_imageView];
	}
	
	// Set up the image in the view after it's loaded
	[_image setDelegate:nil];
	
	if (object != [CPNull null])
		_image = [[CPImage alloc] initWithContentsOfFile:[_photoData photoURL]];

    [_image setDelegate:self];
    
    if([_image loadStatus] == CPImageLoadStatusCompleted)
        [_imageView setImage:_image];
    else
        [_imageView setImage:nil];
}

- (void)mouseEntered:(CPEvent)event
{
	[_captionView setHidden:NO];
}

- (void)mouseExited:(CPEvent)event
{
	[_captionView setHidden:YES];
}

- (void)imageDidLoad:(CPImage)image
{
	[_imageView setImage:image];
	
	// setup the caption view for use when it's needed
	// need to do this in imageDidLoad because that's where the view has a size
	// place it across the bottom of self
	var height = 25;
	
	_captionView = [[CPView alloc] initWithFrame:CGRectMake(0,
															CPRectGetHeight([_imageView bounds]) - height,
															CPRectGetWidth([_imageView bounds]),
															height)];
	[_captionView setBackgroundColor:[CPColor darkGrayColor]];
	[_captionView setAlphaValue:0.85];
	[_captionView setHidden:YES];
	
	// make a label to put insnide the caption
	var label = [self labelWithTitle:"View count: " + [_photoData viewCount]];
	[label setFrameOrigin:CGPointMake(0, 0)];
	[label setFrame:CPRectCreateCopy([_captionView bounds])];
	[_captionView addSubview:label];
	
	[self addSubview:_captionView];
}

- (CPTextField)labelWithTitle:(CPString)title
{
	var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
	
	[label setStringValue:title];
	[label setTextColor:[CPColor whiteColor]];
	[label sizeToFit];
	[label setAlignment:CPCenterTextAlignment];
	[label setVerticalAlignment:CPCenterVerticalTextAlignment];
	
	return label;
}

@end

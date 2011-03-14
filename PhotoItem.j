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
	
}

- (void)mouseExited:(CPEvent)event
{
	
}

- (void)imageDidLoad:(CPImage)image
{
	[_imageView setImage:image];
}

@end

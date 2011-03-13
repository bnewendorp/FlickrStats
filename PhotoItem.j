/*
 * PhotoItem.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 13, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

@import <AppKit/CPView.j>

@implementation PhotoItem : CPView
{
	CPImage _image;
	CPImaveView _imageView;
}

- (void)setRepresentedObject:(JSObject)object
{
	// setup the imageView if we haven't done it yet
	if (!_imageView)
	{
		_imageView = [[CPImageView alloc] initWithFrame:CGRectMakeCopy([self bounds])];
		[_imageView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[_imageView setImageScaling:CPScaleProportionally];
		[_imageView setHasShadow:YES];
		[self addSubview:imageView];
	}
	
	[_image setDelegate:nil];
	
	_image = [[CPImage alloc] initWithContentsOfFile:thumbForFlickrPhoto(anObject)];

    [_image setDelegate:self];
    
    if([_image loadStatus] == CPImageLoadStatusCompleted)
        [_imageView setImage:_image];
    else
        [_imageView setImage:nil];
}

- (void)imageDidLoad:(CPImage)image
{
	[_imageView setImage:image];
}

@end

// Javascript helper method from Cappuccino FlickrPhoto sample app
function thumbForFlickrPhoto(photo)
{
    return "http://farm"+photo.farm+".static.flickr.com/"+photo.server+"/"+photo.id+"_"+photo.secret+"_m.jpg";
}

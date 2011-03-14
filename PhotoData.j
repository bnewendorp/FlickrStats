/*
 * PhotoData.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 13, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

@import <Foundation/CPObject.j>

// Class to store all the data we keep about each photo
@implementation PhotoData : CPObject
{
	CPString photoID @accessors;
	CPString photoURL @accessors;
	CPString viewCount @accessors;
}

@end
/*
 * StatFile.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 12, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

@import <Foundation/CPObject.j>


@implementation StatFile : CPObject
{
	CPString _dataFilePath;
	CPString _displayName;
	
	CPArray _photoIDArray;
	CPArray _viewCountArray;
}

- (id)initWithFilePath:(CPString)filePath
{
	if(self = [super init])
	{
		_dataFilePath = filePath;
		
	}
	return self;
}

- (void)setDataFilePath:(CPString)filePath
{
	_dataFilePath = filePath;
}

- (CPString)displayName
{
	return _displayName;
}

@end

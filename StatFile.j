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
		_photoIDArray = [[CPArray alloc] initWithCapacity:20];
		_viewCountArray = [[CPArray alloc] initWithCapacity:20];
		
		// get the CSV file via CPURLConnection
		var request = [CPURLRequest requestWithURL:_dataFilePath];
		var response;
		var rawData = [CPURLConnection sendSynchronousRequest:request returningResponse:response];
		[self parseCSVString:[rawData rawString]];
		
		// set the display name based on the file name
		var fileNameElements = [[_dataFilePath lastPathComponent] componentsSeparatedByString:"-"];
		_displayName = [[CPString alloc] initWithFormat:"%@ %i, %i",
									[self monthNameForInt:[[fileNameElements objectAtIndex:2] intValue]],
									[[fileNameElements objectAtIndex:3] intValue],
									[[fileNameElements objectAtIndex:1] intValue]];
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

- (void)parseCSVString:(CPString)csvString
{
	// not the safest assumption that they all use \n, but it'll do
	var lines = [csvString componentsSeparatedByString:"\n"];
	for (i=1; i < [lines count]; i++)
	{
		var line = [lines objectAtIndex:i];
			
		// get an array of the elements on each line
		var elements = [line componentsSeparatedByString:","];

		// error checking in case there's a short or empty line
		if ([elements count] < 5)
			break;
			
		// grab the number out of the photo's URL
		[_photoIDArray addObject:[[elements objectAtIndex:1] lastPathComponent]];
		
		// get the view count
		[_viewCountArray addObject:[[elements objectAtIndex:5] intValue]];
	}
}

- (CPString)monthNameForInt:(int)value
{
	if (value == 1)
		return "January";
	else if (value == 2)
		return "February";
	else if (value == 3)
		return "March";
	else if (value == 4)
		return "April";
	else if (value == 5)
		return "May";
	else if (value == 6)
		return "June";
	else if (value == 7)
		return "July";
	else if (value == 8)
		return "August";
	else if (value == 9)
		return "September";
	else if (value == 10)
		return "October";
	else if (value == 11)
		return "November";
	else if (value == 12)
		return "December";
}

@end

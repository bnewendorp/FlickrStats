/*
 * StatFile.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 12, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

@import <Foundation/CPObject.j>

// Class to track all the data from each CSV file
@implementation StatFile : CPObject
{
	CPString _dataFilePath;
	CPString _displayName;
	
//	CPArray _photoIDArray;
	CPDictionary _viewCountDictionary;
	CPDictionary _photoURLDictionary;
}

- (id)initWithFilePath:(CPString)filePath
{
	if(self = [super init])
	{
		_dataFilePath = filePath;
		_viewCountDictionary = [[CPDictionary alloc] init];
		_photoURLDictionary = [[CPDictionary alloc] init];
		
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

- (int)count
{
	return [_viewCountDictionary count];
}

- (int)totalViewCount
{
	var keys = [_viewCountDictionary allKeys];
	var totalCount = 0;
	
	for (var i=0; i < [keys count]; i++)
	{
		totalCount += [_viewCountDictionary valueForKey:[keys objectAtIndex:i]];
	}
	return totalCount;
}

- (CPString)photoIDForIndex:(int)index
{
	return [[_viewCountDictionary allKeys] objectAtIndex:index];
}

- (CPDictionary)photoURLDictionary
{
	return _photoURLDictionary;
}

- (CPDictionary)viewCountDictionary
{
	return _viewCountDictionary;
}

- (void)addPhotoURL:(CPString)newURL forPhotoID:photoID
{
	[_photoURLDictionary setValue:newURL forKey:photoID];
}

- (void)parseCSVString:(CPString)csvString
{
	// not the safest assumption that they all use \n, but it'll do
	var lines = [csvString componentsSeparatedByString:"\n"];
	for (var i=1; i < [lines count]; i++)
	{
		var line = [lines objectAtIndex:i];
			
		// get an array of the elements on each line
		var elements = [line componentsSeparatedByString:","];

		// error checking in case there's a short or empty line
		if ([elements count] < 5)
			break;
		
		var viewCountIndex = [elements count] - 1;
		
		// get the view count for the corresponding photo
		[_viewCountDictionary setValue:[[elements objectAtIndex:viewCountIndex] intValue]
								forKey:[[elements objectAtIndex:1] lastPathComponent]];
		
		// also add a null object to the photoURL dictionary, to be replaced as needed
		[_photoURLDictionary setValue:[CPNull null]
								forKey:[[elements objectAtIndex:1] lastPathComponent]];
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

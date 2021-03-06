/*
 * AppController.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 12, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "StatFile.j"
@import "PhotoItem.j"
@import "PhotoData.j"
@import "TimelineView.j"
@import "EKActivityIndicatorView.j"

var splitViewHeight = 250;

@implementation AppController : CPObject
{
	CPWindow theWindow;

	@outlet CPCollectionView _collectionView;
	@outlet TimelineView _timelineView;
	@outlet CPSplitView _splitView;
	
	CPArray _csvFileArray;
	
	EKActivityIndicatorView _loadingView;
	CPTimer _loadingTimer;
	
	int _receiveCount;
	int _selectedIndex;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	// Hide the menu bar, we aren't using it
	[CPMenu setMenuBarVisible:NO];
	
}

- (void)awakeFromCib
{
	[theWindow setFullBridge:YES];
	_csvFileArray = [[CPArray alloc] initWithCapacity:40];
	
	[self loadDataFiles];

	// give the timeline all the data it needs
	for (var i=0; i < [_csvFileArray count]; i++)
	{
		var file = [_csvFileArray objectAtIndex:i];
		[_timelineView addViewCount:[file totalViewCount] forDate:[file displayName]];
	}
	[_timelineView setAppController:self];
	
	// configure the default height of the splitview
	[_splitView setPosition:CGRectGetHeight([_splitView frame])-splitViewHeight ofDividerAtIndex:0];
	[_splitView setDelegate:self];
	
	// setup the collection view
	// make a prototype PhotoItem first
	var prototypeItem = [[CPCollectionViewItem alloc] init];
	[prototypeItem setView:[[PhotoItem alloc] init]];
	[_collectionView setDelegate:self];
	[_collectionView setItemPrototype:prototypeItem];
	[_collectionView setMinItemSize:CGSizeMake(150, 150)];
	[_collectionView setMaxItemSize:CGSizeMake(150, 150)];
	[_collectionView setBackgroundColor:[CPColor lightGrayColor]];
	
	// Make the loading view for when it's needed
	_loadingView = [[EKActivityIndicatorView alloc] initWithFrame:CGRectMake(
		 									(CPRectGetWidth([_collectionView visibleRect])-25) / 2,
											(CPRectGetHeight([_collectionView visibleRect])-25) / 2,
											50, 50)];
	[_collectionView addSubview:_loadingView];
}

- (void)showDataForDayWithIndex:(int)index
{
	_selectedIndex = index;
	
	// create a timer to display the loading view and clear the collection view
	// use a timer in case it loads really fast and the timer isn't necessary
	_loadingTimer = [CPTimer scheduledTimerWithTimeInterval:0.15
									 				 target:_loadingView
												   selector:@selector(startAnimating)
												   userInfo:null
													repeats:NO];
	[_collectionView setContent:[[CPArray alloc] init]];
	
	// set day to the StatFile for the selected row
	var day = [_csvFileArray objectAtIndex:_selectedIndex];
	
	// request the photo URL for each photo in that day's statistics
	for (var i=0; i < [day count]; i++)
	{
		var request = [CPURLRequest requestWithURL:"http://flickr.com/services/rest/?method="+
				"flickr.photos.getSizes&photo_id=" + encodeURIComponent([day photoIDForIndex:i]) +
				"&format=json&api_key=964106a1c097256de54d7d2aafd4d9b6"];
		[CPJSONPConnection sendRequest:request callback:"jsoncallback" delegate:self];
	}
	_receiveCount = 0;
}

/////////////////////////////////////////////
// CPSplitView delegate methods

- (float)splitView:(CPSplitView)aSpiltView
constrainSplitPosition:(float)proposedPosition
		   ofSubviewAt:(int)subviewIndex
{
	return CGRectGetHeight([_splitView frame])-splitViewHeight;
}

- (void)splitViewDidResizeSubviews:(CPNotification)notification
{
	[_splitView setPosition:CGRectGetHeight([_splitView frame])-splitViewHeight ofDividerAtIndex:0];
}

/////////////////////////////////////////////
// CPJSONPConnection delegate methods

- (void)connection:(CPJSONPConnection)aConnection didReceiveData:(CPString)data
{
	// set day to the StatFile for the selected row
	var day = [_csvFileArray objectAtIndex:_selectedIndex];
	
	// CPSONPConnection gives a Javascript object back, not really a CPString
	// Need to access the values in a JS way.
	// data returns sizes, which has an array of size objects
	var sizeObjects = data.sizes;
	
	// Need the photo ID, going to parse it out of the URL because we don't know what order the
	// JSONP callbacks will be received in
	// Separate the URL by "/", object 5 is the photo ID
	var urlComponents = [data.sizes.size[0].url componentsSeparatedByString:"/"];
	
	for (var i = 0; i < data.sizes.size.length; i++)
	{
		if (data.sizes.size[i].label == "Small")
		{
			[day addPhotoURL:data.sizes.size[i].source forPhotoID:[urlComponents objectAtIndex:5]];
		}
	}
	
	_receiveCount++;
	
	// if we've loaded all the URLs
	if (_receiveCount == [day count])
	{
		[_loadingTimer invalidate];
		[_loadingView stopAnimating];
		
		// make PhotoData objects in an array for every photo in the day. Use that array for the
		// collection view's data.
		var dataArray = [[CPArray alloc] init];
		var keyArray = [[day photoURLDictionary] allKeys];
		for (var i=0; i < [keyArray count]; i++)
		{
			var newData = [[PhotoData alloc] init];
			[newData setPhotoID:[keyArray objectAtIndex:i]];
			[newData setPhotoURL:[[day photoURLDictionary] valueForKey:[keyArray objectAtIndex:i]]];
			[newData setViewCount:[[day viewCountDictionary] valueForKey:[keyArray objectAtIndex:i]]];
			[dataArray addObject:newData];
		}
		[_collectionView reloadContent];
		[_collectionView setContent:dataArray];
	}
}

- (void)connection:(CPJSONPConnection)aConnection didFailWithError:(CPString)error
{
	alert(error);
}

/////////////////////////////////////////////
// Setup methods
- (void)loadDataFiles
{
	var dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-01.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-02.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-03.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-04.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-05.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-06.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-07.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-08.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-09.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-10.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-11.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-12.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-13.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-14.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-15.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-16.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-17.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-18.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-19.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-20.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-21.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-22.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-23.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-24.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-25.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-26.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-27.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-02-28.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-01.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-02.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-03.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-04.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-05.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-06.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-07.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-08.csv"]];
	[_csvFileArray addObject:dataFile];
	
	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-09.csv"]];
	[_csvFileArray addObject:dataFile];

	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-10.csv"]];
	[_csvFileArray addObject:dataFile];

	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-11.csv"]];
	[_csvFileArray addObject:dataFile];

	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-12.csv"]];
	[_csvFileArray addObject:dataFile];

	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-13.csv"]];
	[_csvFileArray addObject:dataFile];

	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-14.csv"]];
	[_csvFileArray addObject:dataFile];

	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-15.csv"]];
	[_csvFileArray addObject:dataFile];

	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-16.csv"]];
	[_csvFileArray addObject:dataFile];

	dataFile = [[StatFile alloc] initWithFilePath:
						[[CPBundle mainBundle] pathForResource:"referrers-2011-03-17.csv"]];
	[_csvFileArray addObject:dataFile];
}

@end

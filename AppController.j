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


@implementation AppController : CPObject
{
	CPWindow theWindow;

	@outlet CPCollectionView _collectionView;
	@outlet CPTableView _statisticsTableView;
	
	CPArray _csvFileArray;
	
	int _receiveCount;
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
	
	// setup the contents of the table view
	[_statisticsTableView setDelegate:self];
	[_statisticsTableView setDataSource:self];
	
	// setup the collection view
	// make a prototype PhotoItem first
	var prototypeItem = [[CPCollectionViewItem alloc] init];
	[prototypeItem setView:[[PhotoItem alloc] init]];
	[_collectionView setDelegate:self];
	[_collectionView setItemPrototype:prototypeItem];
	[_collectionView setMinItemSize:CGSizeMake(150, 150)];
	[_collectionView setMaxItemSize:CGSizeMake(150, 150)];
	[_collectionView setBackgroundColor:[CPColor lightGrayColor]];
}

/////////////////////////////////////////////
// Collection view delegate methods

-(CPData)collectionView:(CPCollectionView)collectionView
  dataForItemsAtIndexes:(CPIndexSet)indices
				forType:(CPString)aType
{
	CPLog("CollectionView dataForItemsAtIndexes forType")
}


/////////////////////////////////////////////
// Table view data source methods

// return the number of values in the data source array
- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
	return [_csvFileArray count];
}

// return a CPString for each row in the table view
- (id)tableView:(CPTableView)tableView
objectValueForTableColumn:(CPTableColumn)tableColumn
					  row:(int)row
{
	return [[_csvFileArray objectAtIndex:row] displayName];
}

/////////////////////////////////////////////
// Table view delegate methods

// respond to the selection changing by loading a new data set
- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
	// set day to the StatFile for the selected row
	var day = [_csvFileArray objectAtIndex:[_statisticsTableView selectedRow]];
	
	// request the photo URL for each photo in that day's statistics
	for (i=0; i < [day count]; i++)
	{
		var request = [CPURLRequest requestWithURL:"http://flickr.com/services/rest/?method="+
				"flickr.photos.getSizes&photo_id=" + encodeURIComponent([day photoIDForIndex:i]) +
				"&format=json&api_key=964106a1c097256de54d7d2aafd4d9b6"];
		[CPJSONPConnection sendRequest:request callback:"jsoncallback" delegate:self];
	}
	_receiveCount = 0;
}

/////////////////////////////////////////////
// CPJSONPConnection delegate methods

- (void)connection:(CPJSONPConnection)aConnection didReceiveData:(CPString)data
{
	// set day to the StatFile for the selected row
	var day = [_csvFileArray objectAtIndex:[_statisticsTableView selectedRow]];
	
	// CPSONPConnection gives a Javascript object back, not really a CPString
	// Need to access the values in a JS way.
	// data returns sizes, which has an array of size objects
	var sizeObjects = data.sizes;
	
	// Need the photo ID, going to parse it out of the URL because we don't know what order the
	// JSONP callbacks will be received in
	// Separate the URL by "/", object 5 is the photo ID
	var urlComponents = [data.sizes.size[0].url componentsSeparatedByString:"/"];
	
	for (i = 0; i < data.sizes.size.length; i++)
	{
		if (data.sizes.size[i].label == "Small")
		{
			[day addPhotoURL:data.sizes.size[i].source forPhotoID:[urlComponents objectAtIndex:5]];
		}
	}
	
	_receiveCount++;
	
	if (_receiveCount == [day count])
	{
		[_collectionView reloadContent];
		[_collectionView setContent:[[day photoURLDictionary] allValues]];
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
}

@end

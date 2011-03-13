/*
 * AppController.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 12, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "StatFile.j"


@implementation AppController : CPObject
{
	CPWindow theWindow;

	@outlet CPCollectionView collectionView;
	@outlet CPTableView statisticsTableView;
	
	CPArray _csvFileArray;
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
	[statisticsTableView setDelegate:self];
	[statisticsTableView setDataSource:self];
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
	var day = [_csvFileArray objectAtIndex:[statisticsTableView selectedRow]];
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

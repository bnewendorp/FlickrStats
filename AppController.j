/*
 * AppController.j
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 12, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

@import <Foundation/CPObject.j>


@implementation AppController : CPObject
{
	CPWindow theWindow;

	@outlet CPCollectionView collectionView;
	@outlet CPTableView statisticsTableView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	// Hide the menu bar, we aren't using it
	[CPMenu setMenuBarVisible:NO];
}

- (void)awakeFromCib
{
	[theWindow setFullBridge:YES];
	
	// setup the contents of the table view
	[statisticsTableView setDelegate:self];
	[statisticsTableView setDataSource:self];
}

// Table view data source methods

// return the number of values in the data source array
- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
	return [csvFileArray count];
}

// return a CPString for each row in the table view
- (id)tableView:(CPTableView)aTableView
objectValueForTableColumn:(CPTableColumn)aColumn
					  row:(int)aRowIndex
{
	
}

// Table view delegate methods

// respond to the selection changing by loading a new data set
(void)tableViewSelectionDidChange:(CPNotification)aNotification
{
	
}

@end

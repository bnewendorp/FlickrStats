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
}

@end

//
//  WallsheetViewController.m
//  homer
//
//  Created by Stan Potemkin on 6/10/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import "WallsheetViewController.h"
#import "WallsheetView.h"


@interface WallsheetViewController ()
@end


@implementation WallsheetViewController

#pragma mark - Memory -
- (id)init
{
	if ((self = [super init])) {
		self.view = [[[WallsheetView alloc] init] autorelease];
	}
	
    return self;
}

- (void)dealloc
{
	// ...
	[super dealloc];
}
@end

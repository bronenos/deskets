//
//  AppDelegate.h
//  homer
//
//  Created by Stan Potemkin on 6/10/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WallsheetWindowController.h"
#import "WallsheetViewController.h"
#import "WallsheetView.h"


@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow					*_window;
	WallsheetWindowController	*_windowController;
	WallsheetViewController		*_wallSheet;
}
@end

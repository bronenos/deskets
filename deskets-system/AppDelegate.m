//
//  AppDelegate.m
//  homer
//
//  Created by Stan Potemkin on 6/10/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import "AppDelegate.h"
#import "NSColor+CGColor.h"
#import "NSView+Wallsheet.h"


@implementation AppDelegate
- (void)dealloc
{
	[_wallSheet release];
	[_windowController release];
	[_window release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Lay it out on the background but below the icons
	NSRect screct = [NSScreen mainScreen].frame;
	_window = [[NSWindow alloc] initWithContentRect:screct styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	_window.alphaValue = 0;
	_window.opaque = NO;
	_window.backgroundColor = [NSColor colorWithDeviceWhite:0 alpha:0.3];
	_window.level = kCGDesktopWindowLevel;
	
	// Place it on each space
	_window.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces;
	
	// Make it transparently animatable
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.8];
	[_window.animator setAlphaValue:1.0];
	[NSAnimationContext endGrouping];
	
	// Init wallsheet and display it
	_wallSheet = [[WallsheetViewController alloc] init];
	[_window.contentView addSubview:_wallSheet.view];
	
	[_window makeKeyAndOrderFront:nil];
}

@end

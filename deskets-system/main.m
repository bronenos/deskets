//
//  main.m
//  homer
//
//  Created by Stan Potemkin on 6/10/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"


int main(int argc, char *argv[])
{
	[NSApplication sharedApplication];
	[NSApp setDelegate:[AppDelegate new]];
	
	return NSApplicationMain(argc, (const char **)argv);
}

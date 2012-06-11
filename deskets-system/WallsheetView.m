//
//  WallsheetView.m
//  homer
//
//  Created by Stan Potemkin on 6/10/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import "WallsheetView.h"
#import "WallWidget.h"
#import "NSColor+CGColor.h"
#import "NSView+Wallsheet.h"
#import <dlfcn.h>


@interface WallsheetView (Private)
- (float)getCalendarSize;
- (void)genDay:(int)day ofType:(unsigned int)type inRect:(CGRect)rect;
@end


@implementation WallsheetView

#pragma mark - Init -
- (id)init
{
	if ((self = [super init])) {
		_widgets = [NSMutableArray array];
		
		NSFileManager *fm = [NSFileManager defaultManager];
		NSString *rootPath = [NSBundle mainBundle].resourcePath;
		
		for (NSString *fname in [fm contentsOfDirectoryAtPath:rootPath error:nil]) {
			if ([fname hasSuffix:@".dylib"] == false) {
				continue;
			}
			
			NSString *fpath = [rootPath stringByAppendingPathComponent:fname];
			void *lib = dlopen(fpath.UTF8String, RTLD_LAZY);
			if (lib) {
				WallWidget* (*w_init)(void) = dlsym(lib, "init");
				if (w_init) {
					WallWidget *widget = w_init();
					[_widgets addObject:widget];
				}
			}
		}
		
		self.subviews = _widgets;
	}
	
	return self;
}

- (void)dealloc
{
	[_widgets release];
	[super dealloc];
}


#pragma mark - Managing View -
- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
	[super viewWillMoveToWindow:newWindow];
	self.frame = newWindow.frame;
}

- (void)setFrame:(NSRect)frameRect
{
	[super setFrame:frameRect];
	[self.subviews makeObjectsPerformSelector:@selector(resizeSelf)];
	[self.subviews makeObjectsPerformSelector:@selector(layoutContents)];
}
@end

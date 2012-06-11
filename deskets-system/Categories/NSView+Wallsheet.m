//
//  NSView+Wallsheet.m
//  homer
//
//  Created by Stan Potemkin on 6/11/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import "NSView+Wallsheet.h"
#import "NSColor+CGColor.h"


@implementation NSView (Wallsheet)
- (void)setBackgroundColor:(NSColor *)color
{
	CALayer *bglayer = [CALayer layer];
	[bglayer setBackgroundColor:color.CGColor];
	
	[self setWantsLayer:YES];
	[self setLayer:bglayer];
}
@end

//
//  NSColor+CGColor.m
//  homer
//
//  Created by Stan Potemkin on 6/11/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import "NSColor+CGColor.h"


@implementation NSColor (CGColor)
- (CGColorRef)CGColor {
	CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
	NSInteger componentCount = [self numberOfComponents];
	CGFloat *components = (CGFloat *)calloc(componentCount, sizeof(CGFloat));
	
	[self getComponents:components];
	CGColorRef color = CGColorCreate(colorSpace, components);
	
	free((void*)components);
	return color;
}
@end

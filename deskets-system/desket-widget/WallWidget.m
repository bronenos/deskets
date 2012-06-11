//
//  WallWidget.m
//  homer
//
//  Created by Stan Potemkin on 6/11/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import "WallWidget.h"
#import <Foundation/Foundation.h>


@implementation WallWidget
- (id)init
{
	if ((self = [super init])) {
		self.wantsLayer = YES;
		self.layer.borderWidth = 2.0;
		self.layer.borderColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.2].CGColor;
		self.layer.cornerRadius = 10.0;
		self.layer.backgroundColor = [NSColor colorWithDeviceWhite:0 alpha:0.4].CGColor;
	}
	
	return self;
}


+ (WallWidget *)widget
{
	return [[[self alloc] init] autorelease];
}

+ (CGPoint)edgeOffset
{
	return CGPointMake(70, 70);
}
@end

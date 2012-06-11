//
//  CalendarWidget.h
//  homer
//
//  Created by Stan Potemkin on 6/11/12.
//  Copyright (c) 2012 Mail.Ru. All rights reserved.
//

#import "WallWidget.h"


extern WallWidget* init();


@interface CalendarWidget : WallWidget <WallWidgetProtocol>
{
	NSTimer		*_calTimer;
}
@end

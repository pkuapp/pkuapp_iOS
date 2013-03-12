//
//  CalendarGroudView.m
//  iOSOne
//
//  Created by wuhaotian on 11-7-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//



#import "CalendarGroudView.h"
#import "QuartzCore/CALayer.h"
#import "SystemHelper.h"
#import <EventKit/EventKit.h>
#import "SystemHelper.h"
#import "Course.h"
#import "ModelsAddon.h"

@implementation CalendarGroundView

- (void)setupForDisplay
{
    for (int i = 0; i < 12 ; i++) {
    float start = [Course starthourForClass:i+1];
    CGRect tagFrame = CGRectMake(wHourTag, heightOffset + start*hHour, wClassTag, hClassTag);
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:tagFrame];
    tagLabel.textAlignment = UITextAlignmentCenter;
    tagLabel.text = [NSString stringWithFormat:@"%d",i+1];
    tagLabel.font = fontHourTag;
    tagLabel.backgroundColor = [UIColor clearColor];
    [tagLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:tagLabel];
    }
}

-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context
{
    
    CGContextSetRGBStrokeColor(context, 145/255, 145/255, 145/255, 1.0);
    
    //for (NSString *familyName in [UIFont familyNames]) { NSLog(@"%@, %@", familyName, [UIFont fontNamesForFamilyName:familyName]); }    
	CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextSetLineWidth(context, 0.3);
    float x = widthOffsetDayView;
    float y = heightOffset;
    const CGFloat  patterns[1] = {1};
    for (int i = 0;i < 25 ; i++, y += hHour) {
        
        CGContextSetRGBFillColor(context, 145/255.0, 145/255.0, 145/255.0, 0.25);
        CGContextSetLineDash(context, 0, NULL, 0);
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context, widthTotal, y);
        CGContextStrokePath(context);
        
        CGContextMoveToPoint(context, x, y + hHour/2.0);
        CGContextAddLineToPoint(context, widthTotal, y+hHour/2.0);
        
        CGContextSetLineDash(context, 0, patterns, 1);
        CGContextStrokePath(context);
        
        CGContextSetRGBFillColor(context, 0/255, 0/255, 0/255, 0.25);
        [[NSString stringWithFormat:@"%d:00",i] drawInRect:CGRectMake(0.0, y-fontHourTag.pointSize/2.0, wAxis, 24) withFont:day_font_hourTag lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
        //int length = [[NSString stringWithFormat:@"%d:00",i] length];
        //CGContextShowTextAtPoint(context, 5.0, y + sizeFont / 2,kstring ,length);
        
    }
    
//    const CGFloat *colorTagComp = CGColorGetComponents([colorClassTag CGColor]);
    
//    const CGFloat *colorTagBgComp = CGColorGetComponents([colorClassTaBg CGColor]);
    
//    CGContextSetRGBFillColor(context, colorTagBgComp[0], colorTagBgComp[1], colorTagBgComp[2], 1.0);
    
//    CGContextFillRect(context, CGRectMake(wHourTag+1, 0, wClassTag, heightTotal));
    CGContextMoveToPoint(context, wAxis, 0);
    CGContextAddLineToPoint(context, wAxis, heightTotal);
    
    CGContextSetLineDash(context, 0, patterns, 1);
    CGContextStrokePath(context);
    
//    CGContextSetRGBFillColor(context, colorTagComp[0], colorTagComp[1], colorTagComp[2], 1.0);
    
//    for (int i = 0; i < 12; i ++) {
//        
//        float start = [Course starthourForClass:i+1];
//        
//        CGRect tagFrame = CGRectMake(wHourTag+1, heightOffset + start*hHour, wClassTag, hClassTag);
//        
//        CGContextFillRect(context,tagFrame);
//        
//        }
    /*CGContextSetRGBFillColor(context, 0.5, 1.0, 1.0, 1.0);
     
     for (int i ; i < 12; i++) {
     float start =  [Course starthourForClass:i+1];
     NSString *tag = [NSString stringWithFormat:@"%d",i+1];
     [tag drawInRect:CGRectMake(widthHourTag, heightOffset + start*heightHour, wClassTag, hClassTag) withFont:fontHourTag lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
     
     }*/
}

@end

@implementation CalendarWeekGroundView


-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
	}
	return self;
}

-(void)drawInContext:(CGContextRef)context
{
    [super drawInContext:context];

}

-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}
@end


#pragma mark - DayGroundView

@implementation CalendarDayGroundView

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
    }
	return self;
}

-(void)drawInContext:(CGContextRef)context
{
    [super drawInContext:context];

}
-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

@end

#pragma mark - EventView

@implementation EventView

@synthesize EventName;
@synthesize groundType;
@synthesize weight;
@synthesize numDay;
@synthesize startHour,endHour,xIndent,viewType,stringLocation,identifier,objIndex,delegate;

- (void)didSelectSelfView
{
    if (self.viewType == EventViewNone) {
        NSLog(@"%d",self.objIndex);
        [self.delegate didSelectEKEventForIndex:self.objIndex];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x+1, frame.origin.y, frame.size.width-2, frame.size.height)];
    if (nil != self) {
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0;
//        self.layer.borderColor = colorBorder;
        self.clearsContextBeforeDrawing = YES;
        self.backgroundColor = colorCourseBg;
    }
    return self;
}

- (void)drawInWeekContext:(CGContextRef)context
{
    CGContextSetRGBFillColor(context,1.0 , 1.0, 1.0, 1.0);
    CGRect frame = CGRectMake( 5,5 , self.bounds.size.width-10, self.bounds.size.height-10);
    [self.EventName drawInRect:frame withFont:fontTitleWeek lineBreakMode:UILineBreakModeWordWrap];
}

- (void)drawInDayContext:(CGContextRef)context
{
    CGPoint titlePoint,subtitlePoint;
    
    float titleWidth;
    
    CGContextSetRGBFillColor(context,1.0 , 1.0, 1.0, 1.0);
    
    float lineWidthOffset = 0;

    if (self.viewType == EventViewCourse) {
        
        lineWidthOffset = wClassTag;
        
    }
    
    titlePoint = CGPointMake(5,5);
    
    titleWidth = self.bounds.size.width -10;
    
    subtitlePoint = CGPointMake(5, 10+18);
    
    float fulltitleWidth = [self.EventName sizeWithFont:day_font_title].width;
    
    if (fulltitleWidth > titleWidth) {
  
        NSInteger index = self.EventName.length * titleWidth/fulltitleWidth -2;
        
        if (index > 0) {
            self.EventName = [[self.EventName substringToIndex:index] stringByAppendingFormat:@"..."];   
        }
    }
    
    [self.EventName drawAtPoint:titlePoint forWidth:titleWidth withFont:fontTitle lineBreakMode:UILineBreakModeWordWrap];
    
    [self.stringLocation drawAtPoint:subtitlePoint forWidth:titleWidth withFont:day_font_sub lineBreakMode:UILineBreakModeWordWrap];
    
}

- (void)drawRect:(CGRect)rect

{
    [super drawRect:rect];
    if (self.groundType == CalendarGroundTypeDay) {
        
        [self drawInDayContext:UIGraphicsGetCurrentContext()];
    }
    else if (self.groundType == CalendarGroundTypeWeek)
    [self drawInWeekContext:UIGraphicsGetCurrentContext()];
}


- (id)initWithDict:(NSDictionary *)dict ForGroundType:(CalendarGroundType)thegroundType ViewType:(EventViewType)theViewType
{
    float start  = [dict[@"start"] floatValue];
    float end  = [dict[@"end"] floatValue];
    int day = [dict[@"day"] intValue];
    
    NSString *name = dict[@"name"];
    NSString *location = dict[@"place"];
    
    if (thegroundType == CalendarGroundTypeWeek) {
        CGRect  frame = CGRectMake(wHourTag + (day-1)*widthColumn ,heightOffset + start * hHour, widthColumn,hHour * (end - start));
        if (!(self = [self initWithFrame:frame])) return nil;

    }
    self = [super init];
    if (self) {
        self.weight = 1.0;
        self.EventName = name;
        self.xIndent = 0;
        self.startHour = start;
        self.endHour = end;
        self.groundType = thegroundType;
        self.viewType = theViewType;
        self.stringLocation = location;
        self.identifier = [dict[@"identifier"] intValue];
        self.numDay = day;
    }
    return self;
    
}

- (id)initWithEKEvent:(EKEvent *)event ForGroudType:(CalendarGroundType)thegroundType inDate:(NSDate *)date
{
    NSString *name = event.title;
    
    NSString *location = event.location;
    
    if (!name) {
        name = @"";
    }
    if (!location) {
        location = @"";
    }
    
    if (thegroundType == CalendarGroundTypeDay) {
    
    float start = [self floatHourForDate:event.startDate inDate:date];
        
    float end = [self floatHourForDate:event.endDate inDate:date];
    
    NSNumber *daynum = @([SystemHelper getDayForDate:event.startDate]);
    
        
    NSDictionary *dict = @{@"name": name,@"start": @(start),@"end": @(end),@"day": daynum ,@"place": location};
        
    return [self initWithDict:dict ForGroundType:CalendarGroundTypeDay ViewType:EventViewNone];
        
    }
    else if (thegroundType == CalendarGroundTypeWeek){
        if ([event.endDate timeIntervalSinceDate:event.startDate] < 86400) {
            
            float start = [self floatHourForDate:event.startDate inDate:date];
            
            float end = [self floatHourForDate:event.endDate inDate:date];

            NSNumber *daynum = @([SystemHelper getDayForDate:event.startDate]);
            
            NSDictionary *dict = @{@"name": name,@"start": @(start),@"end": @(end),@"day": daynum ,@"place": location} ;
            
            return [self initWithDict:dict ForGroundType:CalendarGroundTypeDay ViewType:EventViewNone];
        }
    }
    return nil;
    
}
//call this method after you determined property xIndent and weight
- (void)setupForDayDisplay
{
    float width = widthNormalDayView * weight;
    
    [self setFrame:CGRectMake(wAxis + xIndent*width ,heightOffset+self.startHour*hHour, width-2, hHour*(self.endHour-startHour))];
    
//    self.layer.cornerRadius = 6.0;
    
    self.layer.masksToBounds = YES;
    
    self.layer.borderWidth = 1.0;
    
    self.clearsContextBeforeDrawing = YES;
    
       if (self.viewType == EventViewCourse) {

           self.layer.borderColor = colorCourseBorder;

           //self.backgroundColor = colorCourseBg;
           self.backgroundColor = [UIColor clearColor];
           UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
           bgView.image = [[UIImage imageNamed:@"event-bg-course.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:19];
           // bgView.image =  ];
           [self addSubview:bgView];
           
          /*
           UIButton *buttonDiz = [UIButton buttonWithType:UIButtonTypeCustom];
           UIButton *buttonAssign = [UIButton buttonWithType:UIButtonTypeCustom];
           [buttonDiz setImage:[UIImage imageNamed:@"discuss.png"] forState:UIControlStateNormal];
           [buttonAssign setImage:[UIImage imageNamed:@"assignment.png"] forState:UIControlStateNormal];
           //a fix for image offset
           
           float wbound = self.bounds.size.width;
           
           float ybound = self.bounds.size.height;
           
           float xBtnDiz = wbound - btn_size - btn_padding_right;
           
           float xBtnAssign = xBtnDiz - btn_size - btn_padding_right;
           
           [buttonDiz setFrame:CGRectMake(xBtnDiz, ybound - btn_padding_bottom - btn_size, btn_size, btn_size)];
           buttonDiz.layer.opacity = btn_opacity_inactive;
           [buttonAssign setFrame:CGRectMake(xBtnAssign, ybound - btn_padding_bottom - btn_size, btn_size, btn_size)];
           buttonAssign.layer.opacity = btn_opacity_active;
           buttonAssign.imageEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
           
           
        buttonDiz.layer.cornerRadius = day_radius;
        buttonAssign.layer.cornerRadius = day_radius;
        buttonDiz.layer.borderColor = colorCourseBorder;
        buttonDiz.backgroundColor = colorCourseBg;
        buttonAssign.layer.borderColor = colorCourseBorder;
        buttonAssign.backgroundColor = colorCourseBg;
        buttonAssign.titleLabel.font = fontTitle;
        buttonDiz.titleLabel.font = fontTitle;
        
        buttonDiz.layer.borderWidth = 1.0;
        buttonAssign.layer.borderWidth = 1.0;
//
           [buttonAssign addTarget:self action:@selector(didHitDizButtonInEventView:) forControlEvents:UIControlEventTouchUpInside];
        
        //buttonAssign.highlighted = YES;
        
           [buttonDiz setTitle:@"讨论" forState:UIControlStateNormal];
           
           [buttonAssign setTitle:@"作业" forState:UIControlStateNormal];
           
           [self addSubview:buttonAssign];
            
           [self addSubview:buttonDiz];
           */
           // handle title display
           
           UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.bounds.size.width - 10, 21)];
           
           titleLabel.textAlignment = UITextAlignmentLeft;
           titleLabel.userInteractionEnabled = YES;
           titleLabel.text = self.EventName;
           titleLabel.adjustsFontSizeToFitWidth = NO;
           titleLabel.font = day_font_title;
           titleLabel.textColor = [UIColor whiteColor];
           titleLabel.backgroundColor = [UIColor clearColor];
           titleLabel.shadowColor = colorEventTitleShadow;
           titleLabel.shadowOffset = CGSizeMake(0, -1);
           [self addSubview:titleLabel];
           
           
           UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 26, self.bounds.size.width - 10, 16)];
           locationLabel.userInteractionEnabled = YES;
           locationLabel.textAlignment = UITextAlignmentLeft;
           locationLabel.adjustsFontSizeToFitWidth = NO;
           locationLabel.font = day_font_sub;
           locationLabel.textColor = [UIColor whiteColor];
           locationLabel.text = self.stringLocation;
           locationLabel.backgroundColor = [UIColor clearColor];
           //locationLabel.shadowColor = colorEventTitleShadow;
           //locationLabel.shadowOffset = CGSizeMake(0, -1);
           [self addSubview:locationLabel];
           
    }
    else {
        self.layer.borderColor = colorLocalBorder;
        
        self.backgroundColor = colorLocalBg;
        
        [self addTarget:self action:@selector(didSelectSelfView) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupForWeekDisplay{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0;
    float width = widthNormalWeekView * weight;
    [self setFrame:CGRectMake((self.numDay-1)*widthNormalWeekView + wAxis + xIndent*width ,heightOffset+self.startHour*hHour, width, hHour*(self.endHour-startHour))];
    if (self.viewType == EventViewCourse) {
        self.layer.borderColor = colorCourseBorder;
        self.backgroundColor = colorCourseBg;

    }
    else {
        self.layer.borderColor = colorLocalBorder;
        self.backgroundColor = colorLocalBg;
        [self addTarget:self action:@selector(didSelectSelfView) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (float)floatHourForDate:(NSDate *)date inDate:(NSDate *)dayDate
{
    if ([date compare:dayDate] == NSOrderedAscending) {
        return 0.0;
    }
    else if ([date compare:[dayDate dateByAddingTimeInterval:86400]] == NSOrderedDescending)
    {
        return 24.0;
    }
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *component;
    unsigned unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    component = [calender components:unitFlags fromDate:date];
    float hour = [component hour] + [component minute] / 60.0;
    return hour;
}

- (void)didHitDizButtonInEventView:(UIButton *)dizButton
{
  
}
@end


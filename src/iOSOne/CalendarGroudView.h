//
//  CalendarGroudView.h
//  iOSOne
//
//  Created by wuhaotian on 11-7-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

//  This file define CalendarWeekGroundView,CalendarDayGroundView ANNND EventView
//  1. CalendarWeekGroundView is the ground in the scroll view for week display and *DayGroundView for day display. They both inherits CalendarGroundView to share its drawing code.

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
@class EKEvent;
#pragma mark - appearance params

#define radius 5.0
//define width
#define padding_right 10
#define widthTotal 320
#define widthButton 60
#define wAxis 46


//define height
#define hHour 48.0
#define heightOffset 24.0
#define heightWeekNumber 20.0
#define yOffsetAboveBottom 5
#define heightTotal (24 * hHour + heightOffset *2)
#define heightButton 30

//color
#define colorCourseBorder [[UIColor colorWithRed:0 green:28/255.0 blue:62/255.0 alpha:0.85] CGColor]
#define colorCourseBg [UIColor colorWithRed:0 green:73/255.0 blue:164/255.0 alpha:0.85]

#define colorLocalBorder [UIColorFromRGB(0x7A52BA) CGColor]
#define colorLocalBg UIColorFromRGB(0x9581E3)

//font
#define fsizeM 14
#define fsizeS 12
#define fontNameHourTag @"HelveticaNeue-Bold"
#define fontNameClassTag @"HelveticaNeue-Bold"
#define fontTitle [UIFont fontWithName:@"Helvetica-Bold" size:12]
#define fontHourTag [UIFont fontWithName:fontNameHourTag size:10]
/////////////////////////////////////////////////
//setup DayView specially
#define btn_size 24
#define btn_opacity_active 0.8
#define btn_opacity_inactive 0.05
//height
#define hClassTag (hHour * 5/6.0)
#define btn_padding_bottom 4
//width
#define wClassTag 14
#define wHourTag wAxis - wClassTag
#define btn_padding_right 4

//color
#define colorClassTag UIColorFromRGB(0xC8E8FA)
#define colorClassTaBg UIColorFromRGB(0xE0F4FF)
#define colorEventBg [UIColor colorWithRed:0 green:73/255.0 blue:164/255.0 alpha:0.85]
#define colorEventTitleShadow colorEventBg

#define widthOffsetDayView  wHourTag + wClassTag
#define widthNormalDayView  (320.0 - widthOffsetDayView-14)
//font
#define day_font_title [UIFont boldSystemFontOfSize:fsizeM]
#define day_font_sub [UIFont fontWithName:@"Helvetica Neue" size:fsizeS]
#define day_font_hourTag [UIFont fontWithName:@"Helvetica Neue" size:fsizeS]
/////////////////////////////////////////////////

//setup WeekView specially
#define widthColumn   (320.0 - wAxis - padding_right) / 7

//width

#define widthNormalWeekView (320.0 - wAxis - padding_right) / 7

//font 
#define fontTitleWeek [UIFont fontWithName:@"Helvetica-Bold" size:fsizeS]



typedef enum{
    CalendarGroundTypeDay,
    CalendarGroundTypeWeek,
}CalendarGroundType;

typedef enum {
    EventViewCourse,
    EventViewNone
    
}EventViewType;

#pragma mark - CalendarGroundView defination

@interface CalendarGroundView : UIView {
@private
    
}
-(void)drawInContext:(CGContextRef)context;
-(void)setupForDisplay;
@end

@interface CalendarWeekGroundView : CalendarGroundView {
    
}

-(void)drawInContext:(CGContextRef)context;
@end



@interface CalendarDayGroundView : CalendarGroundView {
@private
    
}
-(void)drawInContext:(CGContextRef)context;
@end

@protocol EventViewDelegate <NSObject>

- (void) didSelectCourseForIndex:(NSInteger)index;
- (void) didSelectEKEventForIndex:(NSInteger)index;
- (void) didSelectDizBtnForCourseIndex:(NSInteger)index;
- (void) didSelectAssignBtnForCourseIndex:(NSInteger)index;

@end

#pragma mark - EventView defination

@interface EventView : UIControl {
    
}

@property (nonatomic, assign) NSObject<EventViewDelegate> *delegate;
@property (nonatomic, retain)NSString *EventName;
@property (nonatomic, retain)NSString *stringLocation;
@property (nonatomic)NSInteger objIndex;
@property (nonatomic) float startHour;
@property (nonatomic) float endHour;
@property (nonatomic) float weight;
@property (nonatomic) NSInteger xIndent;
@property (nonatomic) CalendarGroundType groundType;
@property (nonatomic) EventViewType viewType;
@property (nonatomic) NSInteger numDay;
@property (nonatomic) NSInteger identifier;

-(id) initWithDict:(NSDictionary *)dict ForGroundType:(CalendarGroundType)thegroundType ViewType:(EventViewType) theViewType;

-(void) drawInWeekContext:(CGContextRef)context;

-(void) drawInDayContext:(CGContextRef)context;

- (id)initWithEKEvent:(EKEvent *)event ForGroudType:(CalendarGroundType)thegroundType inDate:(NSDate *)date;

- (void)setupForDayDisplay;

- (void)setupForWeekDisplay;

- (float)floatHourForDate:(NSDate *)date inDate:(NSDate*)dayDate;

- (void)didHitDizButtonInEventView:(UIButton *)dizButton;
//
- (void)didSelectSelfView;

@end
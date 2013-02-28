//
//  NotificationCell.m
//  iOSOne
//
//  Created by  on 12-2-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell
@synthesize typeLabel;
@synthesize typeImg;
@synthesize contentLabel;
@synthesize detailView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [typeLabel release];
    [typeImg release];
    [contentLabel release];
    [detailView release];
    [super dealloc];
}
@end

//
//  ChannelData.h
//  vtvvideos
//
//  Created by Duy Quang on 2/22/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelData : NSObject

@property(assign) NSInteger total;
@property(assign) NSInteger perPage;
@property(assign) BOOL hiddenSubscriberCount;
@property(strong, nonatomic) NSString* title;
@property(strong, nonatomic) NSString* descriptions;
@property(strong, nonatomic) NSString* channelId;
@property(strong, nonatomic) NSString* imgAvaUrl;
@property(strong, nonatomic) NSString* imgBannerUrl;
@property(strong, nonatomic) NSString* viewCount;
@property(strong, nonatomic) NSString* videoCount;
@property(strong, nonatomic) NSString* subscriberCount;
@property(strong, nonatomic) NSString* liveBroadcastContent;

@property(strong, nonatomic) NSMutableArray *listOfChannel;

-(void)setSingleDataByItem:(NSDictionary*)item;

-(void)setSingleDataBySearchItem:(NSDictionary*)item;

@end

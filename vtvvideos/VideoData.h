//
//  VideoData.h
//  vtvvideos
//
//  Created by Duy Quang on 2/21/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoData : NSObject<NSCoding>

@property(strong, nonatomic) NSString* videoId;
@property(strong, nonatomic) NSString* title;
@property(strong, nonatomic) NSString* descriptionVideo;
@property(strong, nonatomic) NSString* thumbailUrl;
@property(strong, nonatomic) NSString* privacyStatus;
@property(strong, nonatomic) NSString* liveBroadcastContent;
@property(strong, nonatomic) NSString* duration;
@property(strong, nonatomic) NSString* viewCount;
@property(strong, nonatomic) NSString* likeCount;
@property(strong, nonatomic) NSString* dislikeCount;
@property(strong, nonatomic) NSString* commentCount;
@property(strong, nonatomic) NSString* publishedAt;
@property(strong, nonatomic) NSString* nextPageToken;

@property(assign) NSInteger total;
@property(assign) NSInteger perPage;
@property(strong, nonatomic) NSMutableArray *listItems;

-(void)setSingleDataByChannelItem:(NSDictionary*)item;
-(void)setSingleDataByPlaylistItem:(NSDictionary*)item;
-(void)setSingleDataByVideoItem:(NSDictionary*)item;

@end

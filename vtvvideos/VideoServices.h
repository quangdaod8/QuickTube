//
//  VideoServices.h
//  vtvvideos
//
//  Created by Duy Quang on 2/21/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoData.h"
#import "ChannelData.h"
#import "PlayListData.h"
#import "AFNetworking.h"

typedef void (^blockDone)(NSError* error, VideoData* videoData);
typedef void (^blockChannel)(NSError* error, ChannelData* channelData);
typedef void (^blockPlayList)(NSError* error, PlayListData* playListData);

@interface VideoServices : NSObject

-(void)getVideoInfoById:(NSString*)videoId Completed:(blockDone)completed;

-(void)getVideoListByPlaylistId:(NSString*)playListId NexPageToken:(NSString*)nextPageToken Completed:(blockDone)completed;

-(void)getVideoListByChannelId:(NSString*)channelId NexPageToken:(NSString*)nextPageToken Completed:(blockDone)completed;

-(void)getLiveStreamingByChannelId:(NSString*)channelId Completed:(blockDone)completed;

-(void)getPlayListByChannelId:(NSString*)channelId Perpage:(NSInteger)perPage Completed:(blockPlayList)completed;

-(void)getChannelInfoByUserName:(NSString*)user Completed:(blockChannel)completed;

-(void)getChannelInfoByChannelId:(NSString*)channelId Completed:(blockChannel)completed;

-(void)searchChannelByTitle:(NSString*)title maxResults:(NSInteger)maxResults Completed:(blockChannel)completed;


@end

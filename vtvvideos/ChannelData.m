//
//  ChannelData.m
//  vtvvideos
//
//  Created by Duy Quang on 2/22/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "ChannelData.h"

@implementation ChannelData
-(void)setSingleDataByItem:(NSDictionary *)item {
    NSDictionary *snippet = item[@"snippet"];
    NSDictionary *brandingSettings = item[@"brandingSettings"];
    NSDictionary *statistics = item[@"statistics"];
    NSDictionary *image = brandingSettings[@"image"];
    NSDictionary *thumbnails = snippet[@"thumbnails"];
    NSDictionary *medium = thumbnails[@"medium"];
    
    _channelId = item[@"id"];
    _title = snippet[@"title"];
    _liveBroadcastContent = snippet[@"liveBroadcastContent"];
    _descriptions = snippet[@"description"];
    _videoCount = statistics[@"videoCount"];
    _viewCount = statistics[@"viewCount"];
    _subscriberCount = statistics[@"subscriberCount"];
    _hiddenSubscriberCount = [statistics[@"hiddenSubscriberCount"]boolValue];
    _imgBannerUrl = image[@"bannerMobileMediumHdImageUrl"];
    _imgAvaUrl = medium[@"url"];
    
}
-(void)setSingleDataBySearchItem:(NSDictionary *)item {
    NSDictionary *snippet = item[@"snippet"];
    NSDictionary *channelId = item[@"id"];
    
    _channelId = channelId[@"channelId"];
    _title = snippet[@"title"];
    _liveBroadcastContent = snippet[@"liveBroadcastContent"];
    
}
@end

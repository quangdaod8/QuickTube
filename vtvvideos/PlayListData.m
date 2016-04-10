//
//  PlayListData.m
//  vtvvideos
//
//  Created by Duy Quang on 2/24/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "PlayListData.h"

@implementation PlayListData

-(void)getSingleDataByItem:(NSDictionary *)item {

    _playListId = item[@"id"];
    
    NSDictionary *contentDetails = item[@"contentDetails"];
    _total = [contentDetails[@"itemCount"]integerValue];
    
    NSDictionary* snippet = item[@"snippet"];
    _title = snippet[@"title"];
    _channelId = snippet[@"channelId"];
    _channelTitle = snippet[@"channelTitle"];
    _descriptionPlayList = snippet[@"description"];
    
    NSDictionary* thumbnails = snippet[@"thumbnails"];
    NSDictionary* high = thumbnails[@"high"];
    _thumbnailsUrl = high[@"url"];
}

@end

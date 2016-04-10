//
//  VideoData.m
//  vtvvideos
//
//  Created by Duy Quang on 2/21/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "VideoData.h"

@implementation VideoData

-(void)setSingleDataByChannelItem:(NSDictionary *)item {
    NSDictionary *videoid = item[@"id"];
    NSDictionary *snippet = item[@"snippet"];
    NSDictionary *thumbnails = snippet[@"thumbnails"];
    NSDictionary *high = thumbnails[@"high"];
    
    _videoId = videoid[@"videoId"];
    _publishedAt = snippet[@"publishedAt"];
    _title = snippet[@"title"];
    _descriptionVideo = snippet[@"description"];
    _liveBroadcastContent = snippet[@"liveBroadcastContent"];
    _thumbailUrl = high[@"url"];
    
}

-(void)setSingleDataByPlaylistItem:(NSDictionary *)item {
    NSDictionary *snippet = item[@"snippet"];
    NSDictionary *thumbnails = snippet[@"thumbnails"];
    NSDictionary *high = thumbnails[@"high"];
    NSDictionary *contentDetails = item[@"contentDetails"];
    NSDictionary *status = item[@"status"];
    
    _publishedAt = snippet[@"publishedAt"];
    _title = snippet[@"title"];
    _descriptionVideo = snippet[@"description"];
    _thumbailUrl = high[@"url"];
    _videoId = contentDetails[@"videoId"];
    _privacyStatus = status[@"privacyStatus"];
    
}

-(void)setSingleDataByVideoItem:(NSDictionary *)item {
    NSDictionary *snippet = item[@"snippet"];
    NSDictionary *contentDetails = item[@"contentDetails"];
    NSDictionary *statistics = item[@"statistics"];
    
    _nextPageToken = item[@"nextPageToken"];
    _title = snippet[@"title"];
    _descriptionVideo = snippet[@"description"];
    _publishedAt = snippet[@"publishedAt"];
    
    _duration = contentDetails[@"duration"];
    
    _viewCount = statistics[@"viewCount"];
    _likeCount = statistics[@"likeCount"];
    _dislikeCount = statistics[@"dislikeCount"];
    _commentCount = statistics[@"commentCount"];
    
    _liveBroadcastContent = snippet[@"liveBroadcastContent"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        _title = [aDecoder decodeObjectForKey:@"title"];
        _videoId = [aDecoder decodeObjectForKey:@"videoId"];
        _descriptionVideo = [aDecoder decodeObjectForKey:@"descriptionVideo"];
        _thumbailUrl = [aDecoder decodeObjectForKey:@"thumbailUrl"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_videoId forKey:@"videoId"];
    [aCoder encodeObject:_descriptionVideo forKey:@"descriptionVideo"];
    [aCoder encodeObject:_thumbailUrl forKey:@"thumbailUrl"];
}
@end

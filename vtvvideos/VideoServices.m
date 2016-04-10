//
//  VideoServices.m
//  vtvvideos
//
//  Created by Duy Quang on 2/21/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "VideoServices.h"

@implementation VideoServices

-(void)getPlayListByChannelId:(NSString *)channelId Perpage:(NSInteger)perPage Completed:(blockPlayList)completed {
    
    NSString *address = @"https://www.googleapis.com/youtube/v3/playlists";
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    [data setObject:@"snippet,contentDetails,status" forKey:@"part"];
    [data setObject:channelId forKey:@"channelId"];
    [data setObject:@"AIzaSyDVq1OTm4mvdbaD-ROVAolhrNwv1WvRNuU" forKey:@"key"];
    [data setObject:[NSNumber numberWithInteger:perPage] forKey:@"maxResults"];
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:address parameters:data success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        PlayListData *data = [[PlayListData alloc]init];
        data.listOfPlayList = [[NSMutableArray alloc]init];
        NSDictionary *dict = responseObject;
        NSDictionary *pageInfo = dict[@"pageInfo"];
        data.total = [pageInfo[@"totalResults"]integerValue];
        data.perPage = [pageInfo[@"resultsPerPage"]integerValue];
        
        NSDictionary *items = dict[@"items"];
        for(NSDictionary *perItem in items) {
            PlayListData *temp = [[PlayListData alloc]init];
            [temp getSingleDataByItem:perItem];
            if(temp.total > 0) [data.listOfPlayList addObject:temp];
        }
        completed(nil,data);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completed(error,nil);
    }];
}

-(void)getVideoListByChannelId:(NSString *)channelId NexPageToken:(NSString *)nextPageToken Completed:(blockDone)completed {
    NSString *address = @"https://www.googleapis.com/youtube/v3/search";
    
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    [data setObject:@"snippet" forKey:@"part"];
    [data setObject:channelId forKey:@"channelId"];
    [data setObject:@"AIzaSyDVq1OTm4mvdbaD-ROVAolhrNwv1WvRNuU" forKey:@"key"];
    [data setObject:[NSNumber numberWithInteger:50] forKey:@"maxResults"];
    [data setObject:@"date" forKey:@"order"];
    [data setObject:@"video" forKey:@"type"];
    [data setObject:nextPageToken forKey:@"pageToken"];
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:address parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dict = responseObject;
        NSDictionary *pageInfo = dict[@"pageInfo"];
        VideoData *data = [[VideoData alloc]init];
        data.total = [pageInfo[@"totalResults"] integerValue];
        data.perPage = [pageInfo[@"resultsPerPage"] integerValue];
        data.nextPageToken = dict[@"nextPageToken"];
        data.listItems = [[NSMutableArray alloc] init];
        
        NSDictionary *items = [dict objectForKey:@"items"];
        for(NSDictionary* perItem in items) {
            VideoData *temp = [[VideoData alloc]init];
            [temp setSingleDataByChannelItem:perItem];
            [data.listItems addObject:temp];
        }
        completed(nil,data);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completed(error,nil);
    }];
}


-(void)getVideoListByPlaylistId:(NSString *)playListId NexPageToken:(NSString *)nextPageToken Completed:(blockDone)completed {
    
    NSString *address = @"https://www.googleapis.com/youtube/v3/playlistItems";

    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    [data setObject:@"snippet,contentDetails,status" forKey:@"part"];
    [data setObject:playListId forKey:@"playlistId"];
    [data setObject:@"AIzaSyDVq1OTm4mvdbaD-ROVAolhrNwv1WvRNuU" forKey:@"key"];
    [data setObject:[NSNumber numberWithInteger:50] forKey:@"maxResults"];
    [data setObject:nextPageToken forKey:@"pageToken"];
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:address parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary * dict = responseObject;
        NSDictionary *pageInfo = dict[@"pageInfo"];
        VideoData *data = [[VideoData alloc]init];
        data.total = [pageInfo[@"totalResults"] integerValue];
        data.perPage = [pageInfo[@"resultsPerPage"] integerValue];
        data.nextPageToken = dict[@"nextPageToken"];
        data.listItems = [[NSMutableArray alloc] init];
        
        NSDictionary *items = [dict objectForKey:@"items"];
        for(NSDictionary* perItem in items) {
            VideoData *temp = [[VideoData alloc]init];
            [temp setSingleDataByPlaylistItem:perItem];
            [data.listItems addObject:temp];
        }
        completed(nil,data);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completed(error,nil);
    }];
}

-(void)getChannelInfoByUserName:(NSString *)user Completed:(blockChannel)completed {
    
    NSString *address = @"https://www.googleapis.com/youtube/v3/channels";
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    [data setObject:@"snippet,brandingSettings,statistics" forKey:@"part"];
    [data setObject:user forKey:@"forUsername"];
    [data setObject:@"AIzaSyDVq1OTm4mvdbaD-ROVAolhrNwv1WvRNuU" forKey:@"key"];
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:address parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        NSDictionary *pageInfo = dict[@"pageInfo"];
        if([pageInfo[@"totalResults"] integerValue] == 1) {
            ChannelData *channelData = [[ChannelData alloc]init];
            NSDictionary *items = [dict objectForKey:@"items"];
            for(NSDictionary *perItem in items) {
                [channelData setSingleDataByItem:perItem];
                completed(nil,channelData);
            }
        }
        else completed(nil,nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completed(error,nil);
    }];
}

-(void)getLiveStreamingByChannelId:(NSString *)channelId Completed:(blockDone)completed {
    NSString *address = @"https://www.googleapis.com/youtube/v3/search";
    
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    [data setObject:@"snippet" forKey:@"part"];
    [data setObject:channelId forKey:@"channelId"];
    [data setObject:@"AIzaSyDVq1OTm4mvdbaD-ROVAolhrNwv1WvRNuU" forKey:@"key"];
    [data setObject:[NSNumber numberWithInteger:50] forKey:@"maxResults"];
    [data setObject:@"live" forKey:@"eventType"];
    [data setObject:@"video" forKey:@"type"];
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:address parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dict = responseObject;
        NSDictionary *pageInfo = dict[@"pageInfo"];
        VideoData *data = [[VideoData alloc]init];
        data.total = [pageInfo[@"totalResults"] integerValue];
        data.perPage = [pageInfo[@"resultsPerPage"] integerValue];
        data.listItems = [[NSMutableArray alloc] init];
        
        NSDictionary *items = [dict objectForKey:@"items"];
        for(NSDictionary* perItem in items) {
            VideoData *temp = [[VideoData alloc]init];
            [temp setSingleDataByChannelItem:perItem];
            [data.listItems addObject:temp];
        }
        completed(nil,data);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completed(error,nil);
    }];
}

-(void)getVideoInfoById:(NSString *)videoId Completed:(blockDone)completed {
    NSString *address = @"https://www.googleapis.com/youtube/v3/videos";
    
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    [data setObject:@"statistics,contentDetails,snippet" forKey:@"part"];
    [data setObject:videoId forKey:@"id"];
    [data setObject:@"AIzaSyDVq1OTm4mvdbaD-ROVAolhrNwv1WvRNuU" forKey:@"key"];

    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:address parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSDictionary *items = dict[@"items"];
        
        for(NSDictionary *perItem in items) {
        VideoData *temp = [[VideoData alloc]init];
        [temp setSingleDataByVideoItem:perItem];
        completed(nil,temp);
        }
        
    }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completed(error,nil);
    }];
}


-(void)getChannelInfoByChannelId:(NSString *)channelId Completed:(blockChannel)completed {
    NSString *address = @"https://www.googleapis.com/youtube/v3/channels";
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    [data setObject:@"snippet,brandingSettings,statistics" forKey:@"part"];
    [data setObject:channelId  forKey:@"id"];
    [data setObject:@"AIzaSyDVq1OTm4mvdbaD-ROVAolhrNwv1WvRNuU" forKey:@"key"];
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:address parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        NSDictionary *pageInfo = dict[@"pageInfo"];
        if([pageInfo[@"totalResults"] integerValue] == 1) {
            ChannelData *channelData = [[ChannelData alloc]init];
            NSDictionary *items = [dict objectForKey:@"items"];
            for(NSDictionary *perItem in items) {
                [channelData setSingleDataByItem:perItem];
                completed(nil,channelData);
            }
        }
        else completed(nil,nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completed(error,nil);
    }];
}

-(void)searchChannelByTitle:(NSString *)title maxResults:(NSInteger)maxResults Completed:(blockChannel)completed {
    NSString *address = @"https://www.googleapis.com/youtube/v3/search";
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    [data setObject:@"snippet" forKey:@"part"];
    [data setObject:title  forKey:@"q"];
    [data setObject:@"channel" forKey:@"type"];
    [data setObject:[NSNumber numberWithInteger:maxResults] forKey:@"maxResults"];
    [data setObject:@"AIzaSyDVq1OTm4mvdbaD-ROVAolhrNwv1WvRNuU" forKey:@"key"];
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:address parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dict = responseObject;
        NSDictionary *pageInfo = dict[@"pageInfo"];
        ChannelData *data = [[ChannelData alloc]init];
        data.listOfChannel = [[NSMutableArray alloc]init];
        
        data.total = [pageInfo[@"totalResults"] integerValue];
        data.perPage = [pageInfo[@"resultsPerPage"] integerValue];
        
            NSDictionary *items = [dict objectForKey:@"items"];
            for(NSDictionary *perItem in items) {
                ChannelData *temp = [[ChannelData alloc]init];
                [temp setSingleDataBySearchItem:perItem];
                [data.listOfChannel addObject:temp];
            }
        completed(nil,data);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completed(error,nil);
    }];

}

@end

//
//  PlayListData.h
//  vtvvideos
//
//  Created by Duy Quang on 2/24/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayListData : NSObject

@property(assign) NSInteger total;
@property(assign) NSInteger perPage;
@property(strong, nonatomic) NSString* playListId;
@property(strong, nonatomic) NSString* title;
@property(strong, nonatomic) NSString* descriptionPlayList;
@property(strong, nonatomic) NSString* thumbnailsUrl;
@property(strong, nonatomic) NSString* channelTitle;
@property(strong, nonatomic) NSString* channelId;
@property(strong, nonatomic) NSMutableArray* listOfPlayList;

-(void)getSingleDataByItem:(NSDictionary*)item;

@end

//
//  PlayList.h
//  vtvvideos
//
//  Created by Duy Quang on 2/24/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoServices.h"
#import "PlayListCell.h"
#import "PlayListData.h"
#import "MBProgressHUD.h"
#import "VideoServices.h"
#import "ViewController.h"
#import "VideoData.h"

@interface PlayList : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString* channelId;
@property (strong, nonatomic) NSString* channelTitle;
@property (strong, nonatomic) NSArray *listPlayList;
@property (strong, nonatomic) VideoData *allVideo;
@property (strong, nonatomic) VideoData *liveStreaming;
@property (strong, nonatomic) VideoServices *service;

@end

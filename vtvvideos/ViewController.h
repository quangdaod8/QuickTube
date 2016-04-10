//
//  ViewController.h
//  vtvvideos
//
//  Created by Duy Quang on 2/21/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoServices.h"
#import "MBProgressHUD.h"
#import "CustomCell.h"
#import "YTPlayerView.h"
#import "TLYShyNavBarManager.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,YTPlayerViewDelegate,CustomCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign) NSInteger perPage;
@property (assign) NSInteger total;
@property (assign) BOOL isLoadMore;
@property (assign) BOOL byChannel;
@property (assign) BOOL isFavo;
@property (assign) bool isPlayerLoaded;
@property (strong, nonatomic) YTPlayerView *player;
@property (strong, nonatomic) NSArray* listOfVideos;
@property (strong, nonatomic) NSString* playlistId;
@property (strong, nonatomic) NSString* channelId;
@property (strong, nonatomic) NSString* nextPageToken;

@property (strong, nonatomic) VideoServices *service;

-(void)loadVideosByPlayListId:(NSString*)playlistId WithTitle:(NSString*)title;
-(void)loadVideosByChannelId:(NSString*)channelId WithTitle:(NSString*)title;
-(void)loadLiveStreamByChannelId:(NSString*)channelId WithTitle:(NSString*)title;
-(void)loadFavoriteVideos;

@end


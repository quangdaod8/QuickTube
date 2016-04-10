//
//  ViewController.m
//  vtvvideos
//
//  Created by Duy Quang on 2/21/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title =@" ";
    _player = [[YTPlayerView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width*180/320)];
    _player.delegate = self;
    _player.playbackQuality = kYTPlaybackQualityAuto;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _player.bounds.size.height, self.view.bounds.size.width, 1)];
    line.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _player.bounds.size.height + 1, self.view.bounds.size.width, 10)];
    view.alpha = 0.8;
    view.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
    [_player addSubview:line];
    [_player addSubview:view];
    [_tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _service = [[VideoServices alloc]init];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.shyNavBarManager.scrollView = self.tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listOfVideos.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isFavo) return YES;
    else return NO;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isFavo) return  YES;
    else return NO;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    VideoData *temp = [[VideoData alloc]init];
    temp = _listOfVideos[indexPath.row];
    [cell setDataForCellByVideoData:temp];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size.width*150/320;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadVideosByPlayListId:(NSString *)playlistId WithTitle:(NSString *)title {
    self.navigationItem.title = title;
    _byChannel = NO;
    _playlistId = playlistId;
    [self loadDataWithPlaylistId:playlistId OnTheFisrtTime:YES];
}

-(void)loadVideosByChannelId:(NSString *)channelId WithTitle:(NSString *)title {
    self.navigationItem.title = title;
    _byChannel = YES;
    _channelId = channelId;
    [self loadDataWithChannelId:channelId OnTheFisrtTime:YES];
}

-(void)loadLiveStreamByChannelId:(NSString *)channelId WithTitle:(NSString *)title {
    self.navigationItem.title = title;
    _channelId = channelId;
    [self loadDataByLiveStreaming];
}

-(void)loadDataByLiveStreaming {
    _service = [[VideoServices alloc]init];
    [_service getLiveStreamingByChannelId:_channelId Completed:^(NSError *error, VideoData *videoData) {
        if(!error) {
            _listOfVideos = videoData.listItems;
            NSLog(@"%d",videoData.total);
            [_tableView reloadData];
        }
    }];
}
-(void)loadFavoriteVideos {
    _isFavo = YES;
    self.navigationItem.title = @"Favorite Videos";
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = edit;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault objectForKey:@"videos"];
    _listOfVideos = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    [_tableView reloadData];
}

-(void)loadDataWithPlaylistId:(NSString*)playlistId OnTheFisrtTime:(BOOL)isFirstLoad {
    if(isFirstLoad) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundColor = [UIColor whiteColor];
        hud.label.text = @"Loading Videos ...";

        [_service getVideoListByPlaylistId:_playlistId NexPageToken:@"" Completed:^(NSError *error, VideoData *videoData) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(!error) {
                _listOfVideos = videoData.listItems;
            
                if(videoData.nextPageToken) {
                    _isLoadMore = YES;
                    _nextPageToken = videoData.nextPageToken;
                }
                else _isLoadMore = NO;
                [_tableView reloadData];
                
            } else {
                //Error can't load more

            }
        }];
    } else {
        if(_isLoadMore) {
            [_service getVideoListByPlaylistId:_playlistId NexPageToken:_nextPageToken Completed:^(NSError *error, VideoData *videoData) {
                
                if(!error) {
                _listOfVideos = [_listOfVideos arrayByAddingObjectsFromArray:videoData.listItems];
                    if(videoData.nextPageToken) {
                        _isLoadMore = YES;
                        _nextPageToken = videoData.nextPageToken;
                    }
                else _isLoadMore = NO;
                [_tableView reloadData];
                } else {
                    //Error can't loadmore
                }
            }];
        } else NSLog(@"notthing to load more");
    }
}

-(void)loadDataWithChannelId:(NSString*)channelId OnTheFisrtTime:(BOOL)isFirstLoad {
    if(isFirstLoad) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundColor = [UIColor whiteColor];
        hud.label.text = @"Loading Videos ...";
        
        [_service getVideoListByChannelId:_channelId NexPageToken:@"" Completed:^(NSError *error, VideoData *videoData) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(!error) {
                NSLog(@"\nTotal: %d\nPerpage: %d\nNext Page Token: %@",videoData.total,videoData.perPage,videoData.nextPageToken);
                _listOfVideos = videoData.listItems;
                if(videoData.nextPageToken) {
                    _isLoadMore = YES;
                    _nextPageToken = videoData.nextPageToken;
                }
                else _isLoadMore = NO;
                [_tableView reloadData];
                
            } else {
                //Error
            }
        }];
        
    } else {
        if(_isLoadMore) {
            [_service getVideoListByChannelId:_channelId NexPageToken:_nextPageToken Completed:^(NSError *error, VideoData *videoData) {
                if(!error) {
                _listOfVideos = [_listOfVideos arrayByAddingObjectsFromArray:videoData.listItems];
                    if(videoData.nextPageToken) {
                        _isLoadMore = YES;
                        _nextPageToken = videoData.nextPageToken;
                    }
                else _isLoadMore = NO;
                [_tableView reloadData];
                NSLog(@"\nTotal: %d\nPerpage: %d\nNext Page Token: %@",videoData.total,videoData.perPage,videoData.nextPageToken);
                } else {
                    //Error can't load next page
                }
            }];
        }
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == _listOfVideos.count - 1) {
        if(_byChannel) [self loadDataWithChannelId:_channelId OnTheFisrtTime:NO];
        else [self loadDataWithPlaylistId:_playlistId OnTheFisrtTime:NO];
    }
}

-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
    [_player playVideo];
    _isPlayerLoaded = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([_player isDescendantOfView:self.view]) NSLog(@"player already added");
    else {
        [self.view addSubview:_player];
        [self.shyNavBarManager setExtensionView:_player];
        self.shyNavBarManager.stickyExtensionView = YES;
    }
}
- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error {
    [self AlertWithTitle:@"Error" Messenger:@"We can't play this video now" Butontitle:@"Ok"];
}

-(void)pressPlayWithVideoId:(NSString *)videoId {
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.label.text = @"Preparing Video ...";
    NSDictionary *playerVars = @{@"playsinline" : @1,};
    if(_isPlayerLoaded) {
        [_player clearVideo];
        [_player cueVideoById:videoId startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
        [_player playVideo];
    }
    else [_player loadWithVideoId:videoId playerVars:playerVars];
    
}

-(void)pressInfoWithVideoId:(NSString *)videoId {
    [_service getVideoInfoById:videoId Completed:^(NSError *error, VideoData *videoData) {
        if(!error) {
            NSString *s = [[NSString alloc]init];
            if([videoData.liveBroadcastContent isEqualToString:@"live"]) {
                s = [NSString stringWithFormat:@"Live Streaming...\n%@ Views\n%@ Likes  |  %@ Dislikes\n\nDescription:\n%@",videoData.viewCount,videoData.likeCount,videoData.dislikeCount,videoData.descriptionVideo];
            } else {
                s = [NSString stringWithFormat:@"Duration: %@\n%@ Views\n%@ Likes  |  %@ Dislikes\n\nDescription:\n%@",[self parseDuration:videoData.duration],videoData.viewCount,videoData.likeCount,videoData.dislikeCount,videoData.descriptionVideo];
            }
            [self AlertWithTitle:videoData.title Messenger:s Butontitle:@"OK"];
        } else {
            [self AlertWithTitle:@"Error" Messenger:error.localizedDescription Butontitle:@"OK"];
        }
    }];
}
-(void)pressActionWithVideoId:(NSString *)videoId Title:(NSString *)title {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://youtube.com/watch?v=%@",videoId]];
    UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[title,url] applicationActivities:nil];
    
    UIPopoverPresentationController *popPresenter = [activity popoverPresentationController];
    popPresenter.sourceView = self.view;
    popPresenter.sourceRect = self.navigationController.navigationBar.frame;

    [self presentViewController:activity animated:YES completion:nil];
}

-(void)pressFavoWithVideoData:(VideoData *)videoData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault objectForKey:@"videos"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    BOOL isAdded = NO;
    for(VideoData *video in array) {
        if([video.videoId isEqualToString:videoData.videoId]) {
            isAdded = YES;
            break;
        }
    }
    if(isAdded) [self AlertWithTitle:@"Error" Messenger:@"You can't add this video because it has been added to Favorite already" Butontitle:@"OK"];
    else {
        [array addObject:videoData];
        NSData *save = [NSKeyedArchiver archivedDataWithRootObject:array];
        [userDefault setObject:save forKey:@"videos"];
        [userDefault synchronize];
        [self AlertWithTitle:@"Favorite" Messenger:@"This video has been added to Favorite" Butontitle:@"OK"];
    }
}

-(void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    if(state == kYTPlayerStatePlaying) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    if (state == kYTPlayerStateEnded) {
        [_player nextVideo];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)edit {
    if(self.editing)
    {
        [super setEditing:NO animated:YES];
        [_tableView setEditing:NO animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [_tableView setEditing:YES animated:YES];
        //[_tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { //implement the delegate method
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSData *data = [userDefault objectForKey:@"videos"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        [array removeObjectAtIndex:indexPath.row];
        _listOfVideos = array;
        NSData *save = [NSKeyedArchiver archivedDataWithRootObject:array];
        [userDefault setObject:save forKey:@"videos"];
        [userDefault synchronize];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault objectForKey:@"videos"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    VideoData *temp = [array objectAtIndex:fromIndexPath.row];
    [array removeObjectAtIndex:fromIndexPath.row];
    [array insertObject:temp atIndex:toIndexPath.row];
    NSData *save = [NSKeyedArchiver archivedDataWithRootObject:array];
    [userDefault setObject:save forKey:@"videos"];
    [userDefault synchronize];
}

-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:messenger delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
        [alert show];
    }
}
- (NSString *)parseDuration:(NSString *)duration {
    NSInteger hours = 0;
    NSInteger minutes = 0;
    NSInteger seconds = 0;
    NSRange timeRange = [duration rangeOfString:@"T"];
    duration = [duration substringFromIndex:timeRange.location];
    while (duration.length > 1) {
        duration = [duration substringFromIndex:1];
        NSScanner *scanner = [NSScanner.alloc initWithString:duration];
        NSString *part = [NSString.alloc init];
        [scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&part];
        NSRange partRange = [duration rangeOfString:part];
        duration = [duration substringFromIndex:partRange.location + partRange.length];
        NSString *timeUnit = [duration substringToIndex:1];
        if ([timeUnit isEqualToString:@"H"])
            hours = [part integerValue];
        else if ([timeUnit isEqualToString:@"M"])
            minutes = [part integerValue];
        else if ([timeUnit isEqualToString:@"S"])
            seconds = [part integerValue];
    }
    if(hours != 0) return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    else return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
@end

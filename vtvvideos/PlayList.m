//
//  PlayList.m
//  vtvvideos
//
//  Created by Duy Quang on 2/24/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "PlayList.h"

@interface PlayList ()

@end

@implementation PlayList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = @" ";
    self.navigationItem.title = _channelTitle;
    [_tableView registerNib:[UINib nibWithNibName:@"PlayListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.label.text = @"Loading Data ...";
    
    _service = [[VideoServices alloc]init];
    [_service getPlayListByChannelId:_channelId Perpage:50 Completed:^(NSError *error, PlayListData *playListData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(!error) {
            _listPlayList = playListData.listOfPlayList;
            [_tableView reloadData];
        } else {
            NSLog(error.localizedDescription);
        }
    }];
    
    [_service getVideoListByChannelId:_channelId NexPageToken:@"" Completed:^(NSError *error, VideoData *videoData) {
        if(!error) {
            _allVideo = videoData;
            [_tableView reloadData];
        }
    }];
    
    [_service getLiveStreamingByChannelId:_channelId Completed:^(NSError *error, VideoData *videoData) {
        if(!error && videoData.total > 0) {
            _liveStreaming = videoData;
            [_tableView reloadData];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_liveStreaming.total > 0) return 3;
    else return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size.width*150/320;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_liveStreaming.total > 0) {
        if(section == 0 || section == 1) return 1;
        else return _listPlayList.count;
    } else {
        if(section == 0)return 1;
        else return _listPlayList.count;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(_liveStreaming.total > 0) {
    if(section == 0) {
        UILabel *lbl = [[UILabel alloc]init];
        lbl.backgroundColor = [UIColor whiteColor];
        lbl.text = @"Live Now";
        lbl.alpha = 0.9;
        lbl.textColor = [UIColor colorWithRed:1 green:0.2 blue:0.4 alpha:1];
        lbl.textAlignment = NSTextAlignmentCenter;
        [lbl setFont:[UIFont systemFontOfSize:15]];
        return lbl;
    } else {
        if(section == 1) {
            UILabel *lbl = [[UILabel alloc]init];
            [lbl setFont:[UIFont systemFontOfSize:15]];
            lbl.backgroundColor = [UIColor whiteColor];
            lbl.text = @"Videos";
            lbl.alpha = 0.9;
            lbl.textColor = [UIColor colorWithRed:1 green:0.2 blue:0.4 alpha:1];
            lbl.textAlignment = NSTextAlignmentCenter;
            return lbl;
            
        } else {
        UILabel *lbl = [[UILabel alloc]init];
            [lbl setFont:[UIFont systemFontOfSize:15]];
        lbl.alpha = 0.9;
        lbl.backgroundColor = [UIColor whiteColor];
        lbl.text = @"PlayLists";
        lbl.textColor = [UIColor colorWithRed:1 green:0.2 blue:0.4 alpha:1];
        lbl.textAlignment = NSTextAlignmentCenter;
        return lbl;
        }
    }
    } else {
        if(section == 0) {
            UILabel *lbl = [[UILabel alloc]init];
            [lbl setFont:[UIFont systemFontOfSize:15]];
            lbl.backgroundColor = [UIColor whiteColor];
            lbl.text = @"Videos";
            lbl.alpha = 0.9;
            lbl.textColor = [UIColor colorWithRed:1 green:0.2 blue:0.4 alpha:1];
            lbl.textAlignment = NSTextAlignmentCenter;
            return lbl;
        } else {
                UILabel *lbl = [[UILabel alloc]init];
            [lbl setFont:[UIFont systemFontOfSize:15]];
                lbl.backgroundColor = [UIColor whiteColor];
                lbl.text = @"PlayLists";
                lbl.alpha = 0.9;
                lbl.textColor = [UIColor colorWithRed:1 green:0.2 blue:0.4 alpha:1];
                lbl.textAlignment = NSTextAlignmentCenter;
                return lbl;
    }
}
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(_liveStreaming.total > 0) {
        if(indexPath.section == 2) {
            PlayListData *temp = [[PlayListData alloc]init];
            temp = _listPlayList[indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setDataByPlayListData:temp];
        } else {
            if(indexPath.section == 1) [cell setDataByVideoData:_allVideo];
            else {
                [cell setDataByVideoData:_liveStreaming];
                cell.title.text = @"All Live Streaming";
            }
        }
    } else {
        if(indexPath.section == 1) {
            PlayListData *temp = [[PlayListData alloc]init];
            temp = _listPlayList[indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setDataByPlayListData:temp];
        } else {
            if(indexPath.section == 0) [cell setDataByVideoData:_allVideo];
        }

    }
        return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_liveStreaming.total > 0) {
        if(indexPath.section == 0) {
            [self performSegueWithIdentifier:@"live" sender:nil];
        } else {
            if(indexPath.section == 2) {
                PlayListData *temp = [[PlayListData alloc]init];
                temp = _listPlayList[indexPath.row];
                [self performSegueWithIdentifier:@"show" sender:temp];
            } else {
                [self performSegueWithIdentifier:@"videos" sender:nil];
            }

        }
    } else {
        if(indexPath.section == 1) {
            PlayListData *temp = [[PlayListData alloc]init];
            temp = _listPlayList[indexPath.row];
            [self performSegueWithIdentifier:@"show" sender:temp];
        } else {
            [self performSegueWithIdentifier:@"videos" sender:nil];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"show"]) {
        PlayListData *playlist = sender;
        ViewController *videos = [segue destinationViewController];
        [videos loadVideosByPlayListId:playlist.playListId WithTitle:playlist.title];
    }
    if([segue.identifier isEqualToString:@"videos"]) {
        ViewController *videos = [segue destinationViewController];
       [videos loadVideosByChannelId:_channelId WithTitle:_channelTitle];
    }
    if([segue.identifier isEqualToString:@"live"]) {
        ViewController *videos = [segue destinationViewController];
        [videos loadLiveStreamByChannelId:_channelId WithTitle:@"Live Now"];
    }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

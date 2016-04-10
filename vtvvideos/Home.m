//
//  Home.m
//  vtvvideos
//
//  Created by Duy Quang on 2/23/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "Home.h"

@interface Home ()

@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _floatButton = [[VCFloatingActionButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 70, self.view.bounds.size.height -70, 50, 50) normalImage:[UIImage imageNamed:@"menudot.png"] andPressedImage:[UIImage imageNamed:@"cross.png"] withScrollview:_tableView];
    [_floatButton setHideWhileScrolling:YES];
    _floatButton.delegate = self;
    _floatButton.labelArray = @[@"About",@"Favorite Videos",@"Manage My Channels",@"Add Channel's name",@"Search Channel"];
    _floatButton.imageArray = @[@"about",@"videos.png",@"edit.png",@"enter.png",@"search.png"];
    [self.view addSubview:_floatButton];
    
    self.navigationItem.title = @"QuickTube";
    self.navigationItem.backBarButtonItem.title =@" ";
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = add;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChannelCell" bundle:nil] forCellReuseIdentifier:@"channel"];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _service = [[VideoServices alloc]init];
    _arrayChannel = [[NSMutableArray alloc]init];
    
}

-(void)didSelectMenuOptionAtIndex:(NSInteger)row {
    if (row == 0) {
        UIAlertController *us = [UIAlertController alertControllerWithTitle:@"About" message:@"QuickTube helps you manage favorite Youtube channels to watch videos within a few taps." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [us dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *share = [UIAlertAction actionWithTitle:@"Share QuickTube" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *s = @"QuickTube helps you manage favorite Youtube channels to watch videos within a few taps.";
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/quicktube/id1095051365?ls=1&mt=8"];
            UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[s,url] applicationActivities:nil];
            
            UIPopoverPresentationController *popPresenter = [activity popoverPresentationController];
            popPresenter.sourceView = self.view;
            popPresenter.sourceRect = self.navigationController.navigationBar.frame;
            
            [self presentViewController:activity animated:YES completion:nil];
        }];
        UIAlertAction *rate = [UIAlertAction actionWithTitle:@"Review & Rate" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1095051365&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
        }];
        [us addAction:share];
        [us addAction:rate];
        [us addAction:cancel];
        
        [self presentViewController:us animated:YES completion:nil];
    }
    if(row == 1) {
        [self performSegueWithIdentifier:@"favo" sender:nil];
    }
    if(row == 2) {
        [self edit];
    }
    if(row == 3) {
        [self addChannel];
    }
    if(row == 4) {
        [self performSegueWithIdentifier:@"search" sender:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateChannel];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayChannel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size.width*150/320;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"channel" forIndexPath:indexPath];
    [cell setUserInteractionEnabled:YES];
    [_service getChannelInfoByChannelId:_arrayChannel[indexPath.row] Completed:^(NSError *error, ChannelData *channelData) {
        if(!error && channelData) {
            [cell setDataByChannelData:channelData];
            [_service getLiveStreamingByChannelId:channelData.channelId Completed:^(NSError *error, VideoData *videoData) {
                if(!error && videoData.total > 0) {
                    channelData.liveBroadcastContent = @"live";
                    [cell setDataByChannelData:channelData];
                }
            }];
        } else {
            [cell setUserInteractionEnabled:NO];
            cell.title.text = @"";
            cell.videoCount.text = @"Error";
            cell.subCount.text = error.localizedDescription;
        }
    }];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ChannelData *data = cell.channelData;
    [self performSegueWithIdentifier:@"list" sender:data];
    //[self performSegueWithIdentifier:@"videos" sender:data];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSObject *temp = [_arrayChannel objectAtIndex:fromIndexPath.row];
    [_arrayChannel removeObjectAtIndex:fromIndexPath.row];
    [_arrayChannel insertObject:temp atIndex:toIndexPath.row];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:_arrayChannel forKey:@"array"];
    [userDefault synchronize];
}

-(void)edit {
    if(self.editing)
    {
        [super setEditing:NO animated:YES];
        [_tableView setEditing:NO animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@""];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [_tableView setEditing:YES animated:YES];
        //[_tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { //implement the delegate method
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_arrayChannel removeObjectAtIndex:indexPath.row];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:_arrayChannel forKey:@"array"];
        [userDefault synchronize];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

-(void)addSheet {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a Youtube Channel" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *username = [UIAlertAction actionWithTitle:@"Enter Channel's Name" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addChannel];
    }];
    UIAlertAction *seacrh = [UIAlertAction actionWithTitle:@"Search Channel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"search" sender:nil];
    }];
    [alert addAction:cancel];
    [alert addAction:seacrh];
    [alert addAction:username];
    
    UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = _tableView.tableFooterView;
    popPresenter.sourceRect = _tableView.tableFooterView.bounds;
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)addChannel {
    UIAlertController *byTitle = [UIAlertController alertControllerWithTitle:@"Add Channel" message:@"Youtube Channel's name look like: \"http://youtube.com/name\"" preferredStyle:UIAlertControllerStyleAlert];
    [byTitle addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter channel's name";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [byTitle dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_service getChannelInfoByUserName:byTitle.textFields[0].text Completed:^(NSError *error, ChannelData *channelData) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(!error) { if(channelData) {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSMutableArray *array = [NSMutableArray arrayWithArray:[userDefault objectForKey:@"array"]];
                if([array containsObject:channelData.channelId]) [self AlertWithTitle:channelData.title Messenger:@"You can't add this channel because it has been added already" Butontitle:@"OK"];
                else {
                    [array addObject:channelData.channelId];
                    [userDefault setObject:array forKey:@"array"];
                    [userDefault synchronize];
                    [self AlertWithTitle:channelData.title Messenger:@"This channel has been added successfully" Butontitle:@"OK"];
                    [self updateChannel];
                }
            } else [self AlertWithTitle:@"Error" Messenger:@"This channel is not found" Butontitle:@"OK"];
            } else {
                [self AlertWithTitle:@"Error" Messenger:error.localizedDescription Butontitle:@"OK"];
            }
        }];
    }];
    [byTitle addAction:ok];
    [byTitle addAction:cancel];
    [self presentViewController:byTitle animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"list"]) {
         ChannelData *data = sender;
        PlayList *list = [segue destinationViewController];
        list.channelId = data.channelId;
        list.channelTitle = data.title;
    }
    if([segue.identifier isEqualToString:@"favo"]) {
        ViewController *videos = [segue destinationViewController];
        [videos loadFavoriteVideos];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)updateChannel {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _arrayChannel = [[userDefault arrayForKey:@"array"] mutableCopy];
    [_tableView reloadData];
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (IBAction)btnAdd:(id)sender {
    [self addSheet];
}
@end

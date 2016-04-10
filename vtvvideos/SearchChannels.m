//
//  SearchChannels.m
//  vtvvideos
//
//  Created by Duy Quang on 3/18/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "SearchChannels.h"

@interface SearchChannels ()

@end

@implementation SearchChannels

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [[NSArray alloc]init];
    _service = [[VideoServices alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"ChannelCell" bundle:nil] forCellReuseIdentifier:@"channel"];
    
    _search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 100, 30)];
    _search.placeholder =@"Youtube Channel";
    _search.delegate = self;
    _search.tintColor = [UIColor colorWithRed:1 green:0.2 blue:0.4 alpha:1];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:_search];
    UIBarButtonItem *btnSerach = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchChannel)];
    self.navigationItem.rightBarButtonItems = @[btnSerach, right];
    self.navigationItem.backBarButtonItem.title = @" ";
    //self.navigationItem.leftBarButtonItem = left;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"channel" forIndexPath:indexPath];
    cell.title.text = @"Loading...";
    ChannelData *temp = _array[indexPath.row];
    [_service getChannelInfoByChannelId:temp.channelId Completed:^(NSError *error, ChannelData *channelData) {
        if(!error && channelData) {
            channelData.liveBroadcastContent = temp.liveBroadcastContent;
            [cell setDataByChannelData:channelData];
            [cell.btnAdd setHidden:NO];
        } else {
            NSLog(error.localizedDescription);
        }
    }];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ChannelData *data = cell.channelData;
    [self performSegueWithIdentifier:@"searchList" sender:data];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"searchList"]) {
        ChannelData *data = sender;
        PlayList *list = [segue destinationViewController];
        list.channelId = data.channelId;
        list.channelTitle = data.title;
    }
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchChannel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchChannel {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_service searchChannelByTitle:_search.text maxResults:50 Completed:^(NSError *error, ChannelData *channelData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(!error) {
            _array = channelData.listOfChannel;
            [_tableView reloadData];
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
            [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        } else [self AlertWithTitle:@"Error" Messenger:error.localizedDescription Butontitle:@"Ok"];
    }];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

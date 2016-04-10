//
//  SearchChannels.h
//  vtvvideos
//
//  Created by Duy Quang on 3/18/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelCell.h"
#import "VideoServices.h"
#import "MBProgressHUD.h"
#import "PlayList.h"

@interface SearchChannels : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(strong, nonatomic) UISearchBar* search;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) VideoServices *service;

@end

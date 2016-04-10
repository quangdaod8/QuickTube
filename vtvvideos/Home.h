//
//  Home.h
//  vtvvideos
//
//  Created by Duy Quang on 2/23/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelCell.h"
#import "VideoServices.h"
#import "MBProgressHUD.h"
#import "ViewController.h"
#import "ChannelData.h"
#import "PlayList.h"
#import "VCFloatingActionButton.h"

@interface Home : UIViewController<UITableViewDataSource,UITableViewDelegate,floatMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnAdd:(id)sender;
@property (strong, nonatomic) VideoServices* service;
@property (strong, nonatomic) NSMutableArray* arrayChannel;
@property (strong, nonatomic) VCFloatingActionButton *floatButton;
@end

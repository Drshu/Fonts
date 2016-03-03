//
//  FontListViewController.h
//  Fonts
//
//  Created by shucheng on 16/3/2.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontListViewController : UITableViewController

@property(copy,nonatomic)NSArray *fontNames;
@property(assign,nonatomic)BOOL showFavorite;

@end

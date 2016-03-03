//
//  FontListViewController.m
//  Fonts
//
//  Created by shucheng on 16/3/2.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import "FontListViewController.h"
#import "FavoritesList.h"
#import "FontSizeViewController.h"
#import "FontInfoViewController.h"

@interface FontListViewController ()

@property(assign,nonatomic)CGFloat cellPointSize;//储存每一个字体优先显示尺寸
@end

@implementation FontListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIFont *preferredTableViewFont=[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.cellPointSize=preferredTableViewFont.pointSize;//找到优先尺寸
    
    if (self.showFavorite) {
        self.navigationItem.rightBarButtonItem=self.editButtonItem;
    }
}



#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fontNames count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"FontName";
    UITableViewCell *cell =[tableView
                            dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //配置表单元
    cell.textLabel.font =[self fontForDisplayAtIndexPath:indexPath];
    cell.textLabel.text=self.fontNames[indexPath.row];
    cell.detailTextLabel.text=self.fontNames[indexPath.row];
    
    return cell;
}
-(UIFont*)fontForDisplayAtIndexPath:(NSIndexPath*)indexPath{
    NSString *fontName = self.fontNames[indexPath.row];
    return [UIFont fontWithName:fontName size:self.cellPointSize];//获取字体名称
}

-(void)viewDidAppear:(BOOL)animated{//刷新视图，在平常操作时，视图显示器会显出之前传入的字体名称列表
    if (self.showFavorite) {
        self.fontNames = [FavoritesList shardFavoritesList].favorites;
        [self.tableView reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIFont *font = [self fontForDisplayAtIndexPath:indexPath];
    return 25 +font.ascender-font.descender;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.showFavorite;//添加编辑操作，可以删除和排序
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.showFavorite) {
        return;
    }//判断是不是收藏列表，不是就直接跳出
    if (editingStyle  == UITableViewCellEditingStyleDelete) {
        NSString *favorite = self.fontNames[indexPath.row];
        [[FavoritesList shardFavoritesList]removeFavorite:favorite];
        self.fontNames=[FavoritesList shardFavoritesList].favorites;
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//使用渐隐动画消失
    }
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    [[FavoritesList shardFavoritesList] moveItemAtIndex:fromIndexPath.row
                                                    toIndex:toIndexPath.row];
    self.fontNames = [FavoritesList shardFavoritesList].favorites;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath =[self.tableView indexPathForCell:sender];
    UIFont *font=[self fontForDisplayAtIndexPath:indexPath];
    [segue.destinationViewController navigationItem].title = font.fontName;
    
    if([segue.identifier isEqualToString:@"ShowFontSize"]){
    FontSizeViewController *sizesVC = segue.destinationViewController;
        sizesVC.font=font;}
    else if([segue.identifier isEqualToString:@"ShowFontInfo"]){
        FontInfoViewController *infoVC = segue.destinationViewController;
        infoVC.font=font;
        infoVC.favorite=[[FavoritesList shardFavoritesList].favorites
                         containsObject:font.fontName];
        
    }
    
}

- (void)xprepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    UIFont *font = [self fontForDisplayAtIndexPath:indexPath];
    [segue.destinationViewController navigationItem].title = font.fontName;
    
    FontSizeViewController *sizesVC = segue.destinationViewController;
    sizesVC.font = font;
}

@end

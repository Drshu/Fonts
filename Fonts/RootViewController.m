//
//  RootViewController.m
//  Fonts
//
//  Created by shucheng on 16/3/2.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import "RootViewController.h"
#import "FavoritesList.h"
#import "FontListViewController.h"
@interface RootViewController ()
@property(copy,nonatomic)NSArray *familyNames;//这是一个复制数组，是所要显示的所有字体系列的列表
//这里使用copy而不使用strong的原因在于如果使用strong，从外部传入一个NSMuTableArray的实例来设置familyNames的值，调用这之后就要更改数组内容，就将会和屏幕上显示的不一致，RootViewController实例会变得不一致。
//以后使用基类不可变，有可变子类的时候，包括NSArray，NSDictonary，NSString和NSData，都需要用copy来声明属性
@property(assign,nonatomic)CGFloat cellPointSize;//表视图单元中字体的大小
@property(strong,nonatomic)FavoritesList *favoritesList;//指向favorite单例的指针


@end

@implementation RootViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取新视图控制器，并且将选定对象传入新的控制器
    NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];//通过sender来判断哪一行被点击，并向segue请求destinationViewController
    FontListViewController *listVC=segue.destinationViewController;
    //判断点击的是1（收藏单元）还是0（字体系列）
    if (indexPath.section == 0) {
        NSString *familyName = self.familyNames[indexPath.row];
        listVC.fontNames = [[UIFont fontNamesForFamilyName:familyName]
                            sortedArrayUsingSelector:@selector(compare:)];
        listVC.navigationItem.title=familyName;
        listVC.showFavorite=NO;
    }else{
        listVC.fontNames=self.favoritesList.favorites;
        listVC.navigationItem.title=@"Favorites";
        listVC.showFavorite=YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.familyNames=[[UIFont familyNames]
                      sortedArrayUsingSelector:@selector(compare:)];//放置已知字体的名字，并进行排序
    UIFont *preferredTableViewFont=[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.cellPointSize = preferredTableViewFont.pointSize;
    self.favoritesList = [FavoritesList shardFavoritesList];//获取收藏列表单例
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//返回分区数
    if ([self.favoritesList.favorites count] > 0) {
        return 2;
    }else{
        return 1;}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//返回分区的行数
    if (section == 0) {
        return [self.familyNames count];
    }else{
        return 1;}
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"所有字体系列";
    }else{
        return @"我收藏的字体";
    }
}//设置分区标题

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FamilyNameCell = @"FamilyName";
    static NSString *FavoritesCell= @"Favorites";//定义两个表单元标识符
    UITableViewCell *cell=nil;
    //根据分区索引来判断是哪一个分区
    if (indexPath.section == 0) {
        cell=[tableView dequeueReusableCellWithIdentifier:FamilyNameCell
                                             forIndexPath:indexPath];
        cell.textLabel.font=[self fontForDisplayAtIndexPath:indexPath];
        cell.textLabel.text=self.familyNames[indexPath.row];
        cell.detailTextLabel.text=self.familyNames[indexPath.row];
    }else{
        cell=[tableView dequeueReusableCellWithIdentifier:FavoritesCell forIndexPath:indexPath];
    }
    return cell;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];//可以重新加载表视图，因为在视图切换的时候，可能有需要更新的东西，例如收藏的内容
    
}

-(UIFont*)fontForDisplayAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.section == 0) {
        NSString *familyName = self.familyNames[indexPath.row];
        NSString *fontName=[[UIFont fontNamesForFamilyName:familyName]
                            firstObject];//使用已有的字体系列名称找到所有的字体名称，并且获取系列中首个字体的名称
        return [UIFont fontWithName:fontName size:self.cellPointSize];
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UIFont *font =[self fontForDisplayAtIndexPath:indexPath];
        return 25 + font.ascender - font.descender;//可以计算出升部和降部之间的差异
    }else{
        return tableView.rowHeight;
    }
}
@end

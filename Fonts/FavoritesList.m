//
//  FavoritesList.m
//  Fonts
//
//  Created by shucheng on 16/3/1.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import "FavoritesList.h"
@interface FavoritesList()
@property (strong,nonatomic)NSMutableArray *favorites;//这个属性变量虽然是NSMutableArray的返回值，而头文件是返回NSArray，但是事实上前者是后者的子类，但是需要注意我们希望API公开的是一个NSArray而不是NSMutableArray。

@end


@implementation FavoritesList

+(instancetype)shardFavoritesList{//创建了一个类的实例，并且将其返回，dispatch部分的代码只会执行一次
    static FavoritesList *shared=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shared = [[self alloc]init];
        
    });
    return shared;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];//判断偏好设置内是否已经有收藏的内容，如果有就复制给favorite属性，否则给一个空的可变数组。
        NSArray *storedFavorites=[defaults objectForKey:@"favorites"];
        if (storedFavorites) {
            self.favorites=[storedFavorites mutableCopy];
            
        }else{
            self.favorites=[NSMutableArray array];
        }
    }
    return self;
}


-(void)saveFavorites{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:self.favorites forKey:@"favorites"];
    [defaults synchronize];
}

//下面的是添加和删除收藏，可以快速储存更改
- (void)addFavorite:(id)item {
    [_favorites insertObject:item atIndex:0];
    [self saveFavorites];
}
    //使用_favorite的原因是若使用self.favorite，编译器会在头文件中发现这是一个NSArray（不可变的）


-(void)removeFavorite:(id)item{
    [_favorites removeObject:item];
    [self saveFavorites];
}


-(void)moveItemAtIndex:(NSInteger)from toIndex:(NSInteger)to{
    id item=_favorites[from];
    [_favorites removeObjectAtIndex:from];
    [_favorites insertObject:item atIndex:to];
    [self saveFavorites];
}

@end

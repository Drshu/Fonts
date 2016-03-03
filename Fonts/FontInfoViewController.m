//
//  FontInfoViewController.m
//  Fonts
//
//  Created by shucheng on 16/3/2.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import "FontInfoViewController.h"
#import "FavoritesList.h"
@interface FontInfoViewController ()

@property(weak,nonatomic)IBOutlet UILabel *fontSampleLabel;
@property(weak,nonatomic)IBOutlet UISlider *fontSizesSlider;
@property(weak,nonatomic)IBOutlet UILabel *fontSizesLabel;
@property(weak,nonatomic)IBOutlet UISwitch *favoritesSwitch;

@end

@implementation FontInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fontSampleLabel.font=self.font;
    self.fontSampleLabel.text=@"AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz  0123456789";
    self.fontSizesSlider.value = self.font.pointSize;
    self.fontSizesLabel.text= [NSString stringWithFormat:@"%.0f",self.font.pointSize];
    self.favoritesSwitch.on=self.favorite;
}

-(IBAction)slideFontSize:(UISlider*)slider{
    float newSize = roundf(slider.value);
    self.fontSampleLabel.font=[self.font fontWithSize:newSize];
    self.fontSizesLabel.text= [NSString stringWithFormat:@"%.0f",newSize];
}

-(IBAction)toggleFavorite:(UISwitch*)sender{
    FavoritesList *favoritesList =[FavoritesList shardFavoritesList];
    if (sender.on) {
        [favoritesList addFavorite:self.font.fontName];
        
    }else{
        [favoritesList removeFavorite:self.font.fontName];
     }
}


@end

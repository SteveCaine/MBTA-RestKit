//
//  DetailViewController.h
//  MBTA-APIs
//
//  Created by Steve Caine on 01/05/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

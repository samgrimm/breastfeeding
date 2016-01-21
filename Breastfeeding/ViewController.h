//
//  ViewController.h
//  Breastfeeding
//
//  Created by Samantha Cabral on 1/14/16.
//  Copyright © 2016 Samantha Cabral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSArray *results;


@end


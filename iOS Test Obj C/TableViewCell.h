//
//  TableViewCell.h
//  iOS Test Obj C
//
//  Created by Mr Ruby on 27/08/16.
//  Copyright © 2016 Castle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *resultImageView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIView *viewContainingText;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@end

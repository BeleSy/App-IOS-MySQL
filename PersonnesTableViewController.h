//
//  ViewController.h
//  SqlLite
//
//  Created by Sonnarinh Syhaphom (Étudiant) on 17-02-13.
//  Copyright © 2017 Sonnarinh Syhaphom (Étudiant). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditPersonneViewController.h"

@interface PersonnesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

#pragma mark - Actions
- (IBAction)ajouterEnregistrement:(id)sender;

@end


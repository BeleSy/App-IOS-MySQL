//
//  EditPersonneViewController.h
//  SqlLite
//
//  Created by Sonnarinh Syhaphom (Étudiant) on 17-02-16.
//  Copyright © 2017 Sonnarinh Syhaphom (Étudiant). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPersonneViewController : UIViewController <UITextFieldDelegate>

#pragma mark - Propriétés
@property (strong, nonatomic) IBOutlet UITextField* prenom;
@property (strong, nonatomic) IBOutlet UITextField* nom;
@property (strong, nonatomic) IBOutlet UITextField* age;
@property (strong,nonatomic) NSString* idPersonne; //sert à aller chercher l'information

@end

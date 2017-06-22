//
//  EditPersonneViewController.m
//  SqlLite
//
//  Created by Sonnarinh Syhaphom (Étudiant) on 17-02-16.
//  Copyright © 2017 Sonnarinh Syhaphom (Étudiant). All rights reserved.
//

#import "EditPersonneViewController.h"
#import "PersonneDTO.h"
#import "PersonneFacade.h"
#import "NetworkActivityIndicatorManager.h"

#pragma mark - Membres prives
@interface EditPersonneViewController ()

#pragma mark - Methodes prives
-(void)chargerInfo;
-(void)startNetworkActivityIndication;
-(void)endNetworkActivityIndication;

@end

#pragma mark - Membres publics
@implementation EditPersonneViewController

#pragma mark - Proprietes
@synthesize prenom;
@synthesize nom;
@synthesize age;
@synthesize idPersonne;

#pragma mark - Methodes prives
-(void)chargerInfo {
    [self startNetworkActivityIndication];
    
    // Charge les donnees de l'enregistrement de la base de donnees
    PersonneDTO* personneDTO = [[PersonneFacade personneFacade] readPersonne:[self idPersonne]];
    
    // Met a jour les valeurs des text fields de l'interface avec les donnees de l'enregistrement lu
    if(personneDTO != nil) {
        [[self prenom] setText:[personneDTO prenom]];
        [[self nom] setText:[personneDTO nom]];
        [[self age] setText:[personneDTO age]];
        NSLog(@"Requete de lecture reussie pour l'enregistrement %@\n\n", [personneDTO idPersonne]);
    } else {
        NSLog(@"Impossible d'executer la requete de lecture\n\n");
    }
    [self performSelector:@selector(endNetworkActivityIndication) withObject:nil afterDelay:2.0f];
}

- (void)startNetworkActivityIndication {
    [[NetworkActivityIndicatorManager sharedManager] startActivity];
}

- (void)endNetworkActivityIndication {
    [[NetworkActivityIndicatorManager sharedManager] endActivity];
}

#pragma mark - Methodes du ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[[self navigationController] navigationBar] setTintColor:[[[self navigationItem] rightBarButtonItem] tintColor]];
    [[self prenom] setDelegate:self];
    [[self nom] setDelegate:self];
    [[self age] setDelegate:self];
    
    // Verifie si le parametre de modification d'un enregistrement a ete assigne
    if ([self idPersonne] != nil) {
        // Charge l'enregistrement correspondant
        [self chargerInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gestion du clavier
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
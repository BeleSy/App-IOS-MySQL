//
//  ViewController.m
//  SqlLite
//
//  Created by Sonnarinh Syhaphom (Étudiant) on 17-02-13.
//  Copyright © 2017 Sonnarinh Syhaphom (Étudiant). All rights reserved.
//

#import "PersonnesTableViewController.h"
#import "NetworkActivityIndicatorManager.h"
#import "PersonneFacade.h"

#pragma mark - Membres prives
@interface PersonnesTableViewController ()

#pragma mark - Proprietes prives
@property (strong, nonatomic) NSMutableArray* personnes;
@property (nonatomic) NSString* idPersonne;

#pragma mark - Methodes prives
-(void)chargerDonnees;
-(void)startNetworkActivityIndication;
-(void)endNetworkActivityIndication;

@end

#pragma mark - Membres publics
@implementation PersonnesTableViewController

#pragma mark - Proprietes
@synthesize personnes;
@synthesize idPersonne;

#pragma mark - Methodes privees
-(void)chargerDonnees {
    [self startNetworkActivityIndication];
    // Charge les donnees
    if([self personnes] != nil){
        [self setPersonnes:nil];
    }
    [self setPersonnes:[[PersonneFacade personneFacade] getAllPersonnes]];
    
    // Recharge la table view
    [[self tableView] reloadData];
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
    
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    [self chargerDonnees];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ajouterEnregistrement:(id)sender {
    // Indique a EditPersonneViewController que c'est un ajout et non une mise a jour
    [self setIdPersonne:nil];
    [self performSegueWithIdentifier:@"idSegueEditPersonne" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self personnes] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonneDTO* personneDTO = [[self personnes] objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellPersonne" forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"idCellPersonne"];
    }
    
    // Mets a jour les labels des cellules
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@", [personneDTO prenom], [personneDTO nom]]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"Age : %@", [personneDTO age]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    PersonneDTO* personneDTO = [[self personnes] objectAtIndex:[indexPath row]];
    
    // Passe la clef primaire au prochain view controller pour qu'il charge les donnees de l'enregistrement
    // Au lieu de -1
    [self setIdPersonne:[personneDTO idPersonne]];
    [self performSegueWithIdentifier:@"idSegueEditPersonne" sender:tableView];
}

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        PersonneDTO* personneDTO = [[self personnes] objectAtIndex:[indexPath row]];
        int nombreEnregistrements = [[PersonneFacade personneFacade] deletePersonne:personneDTO];
        
        if(nombreEnregistrements > -1) {
            [[self personnes] removeObjectAtIndex:[indexPath row]];
            NSLog(@"Requete de suppression reussie. %d enregistrement(s) supprime(s)\n\n", nombreEnregistrements);
        } else {
            NSLog(@"Impossible d'executer la requete de suppression\n\n");
        }
        
        // Recharge la table view en effectuant une animation de suppression
        [UIView animateWithDuration:0.3 animations:^(void) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];}
                         completion:^(BOOL finished) {
                             [self chargerDonnees];
                         }];
    }
}

#pragma mark - Methodes des segues
-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    EditPersonneViewController* editPersonneViewController = [segue destinationViewController];
    [editPersonneViewController setIdPersonne:[self idPersonne]];
}

-(IBAction)returnActionForSegue:(UIStoryboardSegue*)returnSegue {
    EditPersonneViewController* editPersonneViewController = [returnSegue sourceViewController];
    
    PersonneDTO* personneDTO = [[PersonneDTO alloc] initAvecIdPersonne:
                                [editPersonneViewController idPersonne] prenom:
                                [[editPersonneViewController prenom] text] nom:
                                [[editPersonneViewController nom] text] etAge:
                                [[editPersonneViewController age] text]];
    
    if([[personneDTO prenom] length] != 0
       && [[personneDTO nom] length] != 0
       && [[personneDTO age] length] > 0) {
        
        int nombreEnregistrements = 0;
        NSString* typeRequete = [personneDTO idPersonne] != nil ? @"mise a jour" : @"creation";
        NSString* typeRequeteAction = [personneDTO idPersonne] != nil ? @"mise a jour" : @"cree(s)";
        
        // Si l'ID de la personne dans EditPersonneViewController a une valeur differente de -1, on fait une mise a jour. Sinon, on fait un ajout
        
        if([personneDTO idPersonne] != nil) {
            nombreEnregistrements = [[PersonneFacade personneFacade] updatePersonne:personneDTO];
        } else {
            nombreEnregistrements = [[PersonneFacade personneFacade] createPersonne:personneDTO];
        }
        
        if(nombreEnregistrements > -1) {
            if([personneDTO idPersonne] != nil
               || nombreEnregistrements > 0) {
                NSLog(@"Requete de mise a %@ reussie. %d enregistrement(s) %@\n\n", typeRequete, nombreEnregistrements, typeRequeteAction);
            } else {
                NSLog(@"Impossible d'executer la requete de %@\n\n", typeRequete);
            }
        } else {
            NSLog(@"Impossible d'executer la requete de %@\n\n", typeRequete);
        }
        
        // Recharge la table view
        [self chargerDonnees];
    }
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

//
//  PersonneFacade.m
//  33-MySQL
//
//  Created by Sonnarinh Syhaphom (Étudiant) on 17-02-23.
//  Copyright © 2017 Sonnarinh Syhaphom. All rights reserved.
//

#import "PersonneFacade.h"
#import "PersonneDTO.h"

static PersonneFacade* personneFacade = nil;

#pragma mark - Membres publics
@implementation PersonneFacade

#pragma mark - Methdes D'initialisation
+(void)initialize {
    personneFacade = [[PersonneFacade alloc]init];
}

-(instancetype)init {
    if(personneFacade == nil){
        personneFacade = [super init];
    }
    return personneFacade;
}

#pragma mark - Methodes metier
+(PersonneFacade*)personneFacade {
    return personneFacade;
}
-(int)createPersonne:(PersonneDTO*)personneDTO {
    __block int nombreEnregistrements = 0;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@URL_SERVICE_WEB]];
    NSString* parametresRequete = [NSString stringWithFormat:@"methode=createPersonne&serveur=%@&utilisateur=%@&motDePasse=%@&baseDeDonnees=%@&port=%@&prenom=%@&nom=%@&age=%@", @SERVEUR,@UTILISATEUR, @MOT_DE_PASSE, @BASE_DE_DONNEES, @PORT, [personneDTO prenom],[personneDTO nom], [personneDTO age]];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[parametresRequete dataUsingEncoding:NSUTF8StringEncoding]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData* donnees,NSURLResponse* response, NSError* error){
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        
        if ([httpResponse statusCode]==200 && donnees !=nil) {
            NSDictionary* resultatJSON = [NSJSONSerialization JSONObjectWithData:donnees options:NSJSONReadingAllowFragments error:&error];
            
            nombreEnregistrements = (int) [resultatJSON[@"nombreEnregistrements"]integerValue];
        }else if ([httpResponse statusCode] != 200 && donnees != nil){
            NSDictionary* erreurJSON = [NSJSONSerialization JSONObjectWithData:donnees options:NSJSONReadingAllowFragments error:&error];
            NSString* codeErreur = erreurJSON[@"codeErreur"];
            NSString* messageErreur = erreurJSON[@"messageErreur"];
            
            NSLog(@"[Code d'erreur HTTP %ld] Echec de la requete %@?%@ -> [Code d'erreur MySQL %@] %@",(long) [httpResponse statusCode],@URL_SERVICE_WEB,parametresRequete,codeErreur,messageErreur);
        }else if(error != nil){
            NSLog(@"[Code d'erreur %ld] Echec de la requete %@?%@",(long)[httpResponse statusCode],@URL_SERVICE_WEB, parametresRequete,[error localizedDescription]);
        }else{
            NSLog(@"[Code d'erreur %ld] Echec de la requete %@?%@",(long)[httpResponse statusCode],@URL_SERVICE_WEB, parametresRequete);
        }
        dispatch_semaphore_signal(semaphore);
        
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return nombreEnregistrements;
}

-(PersonneDTO*)readPersonne:(NSString*)idPersonne{
    __block PersonneDTO* personneDTO;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@URL_SERVICE_WEB]];
    
    
    NSString* parametresRequete = [NSString stringWithFormat:@"methode=readPersonne&serveur=%@&utilisateur=%@&motDePasse=%@&baseDeDonnees=%@&port=%@&idPersonne=%@", @SERVEUR, @UTILISATEUR, @MOT_DE_PASSE, @BASE_DE_DONNEES, @PORT, idPersonne];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[parametresRequete dataUsingEncoding:NSUTF8StringEncoding]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData* donnees,NSURLResponse* response, NSError* error){
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        
        if ([httpResponse statusCode]==200 && donnees !=nil) {
            NSDictionary* resultatJSON = [NSJSONSerialization JSONObjectWithData:donnees options:NSJSONReadingAllowFragments error:&error];
            
            NSString* prenom = resultatJSON[@"prenom"];
            NSString* nom = resultatJSON[@"nom"];
            NSString* age = resultatJSON[@"age"];
            
            personneDTO = [[PersonneDTO alloc] initAvecIdPersonne:idPersonne prenom:prenom nom:nom etAge:age];
            
        }else if ([httpResponse statusCode] != 200 && donnees != nil){
            NSDictionary* erreurJSON = [NSJSONSerialization JSONObjectWithData:donnees options:NSJSONReadingAllowFragments error:&error];
            NSString* codeErreur = erreurJSON[@"codeErreur"];
            NSString* messageErreur = erreurJSON[@"messageErreur"];
            
            NSLog(@"[Code d'erreur HTTP %ld] Echec de la requete %@?%@ -> [Code d'erreur MySQL %@] %@",(long) [httpResponse statusCode],@URL_SERVICE_WEB,parametresRequete,codeErreur,messageErreur);
        }else if(error != nil){
            NSLog(@"[Code d'erreur %ld] Echec de la requete %@?%@",(long)[httpResponse statusCode],@URL_SERVICE_WEB, parametresRequete,[error localizedDescription]);
        }else{
            NSLog(@"[Code d'erreur %ld] Echec de la requete %@?%@",(long)[httpResponse statusCode],@URL_SERVICE_WEB, parametresRequete);
        }
        dispatch_semaphore_signal(semaphore);
        
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return personneDTO;
}


-(int)updatePersonne:(PersonneDTO*)personneDTO{
    __block int nombreEnregistrements = 0;
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@URL_SERVICE_WEB]];
    
    NSString* parametresRequete = [NSString stringWithFormat:@"methode=updatePersonne&serveur=%@&utilisateur=%@&motDePasse=%@&baseDeDonnees=%@&port=%@&idPersonne=%@&prenom=%@&nom=%@&age=%@", @SERVEUR,@UTILISATEUR, @MOT_DE_PASSE, @BASE_DE_DONNEES, @PORT,[personneDTO idPersonne], [personneDTO prenom],[personneDTO nom], [personneDTO age]];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[parametresRequete dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData* donnees,NSURLResponse* response, NSError* error){
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        
        
        
        if ([httpResponse statusCode]==200 && donnees !=nil) {
            
            NSDictionary* resultatJSON = [NSJSONSerialization JSONObjectWithData:donnees options:NSJSONReadingAllowFragments error:&error];
            
            
            
            nombreEnregistrements = (int) [resultatJSON[@"nombreEnregistrements"]integerValue];
            
        }else if ([httpResponse statusCode] != 200 && donnees != nil){
            
            NSDictionary* erreurJSON = [NSJSONSerialization JSONObjectWithData:donnees options:NSJSONReadingAllowFragments error:&error];
            
            NSString* codeErreur = erreurJSON[@"codeErreur"];
            
            NSString* messageErreur = erreurJSON[@"messageErreur"];
            
            
            
            NSLog(@"[Code d'erreur HTTP %ld] Echec de la requete %@?%@ -> [Code d'erreur MySQL %@] %@",(long) [httpResponse statusCode],@URL_SERVICE_WEB,parametresRequete,codeErreur,messageErreur);
            
        }else if(error != nil){
            
            NSLog(@"[Code d'erreur %ld] Echec de la requete %@?%@",(long)[httpResponse statusCode],@URL_SERVICE_WEB, parametresRequete,[error localizedDescription]);
            
        }else{
            
            NSLog(@"[Code d'erreur %ld] Echec de la requete %@?%@",(long)[httpResponse statusCode],@URL_SERVICE_WEB, parametresRequete);
            
        }
        
        dispatch_semaphore_signal(semaphore);
        
        
        
    }] resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return nombreEnregistrements;
}

-(int)deletePersonne:(PersonneDTO*)personneDTO{
    __block int nombreEnregistrements = 0;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@URL_SERVICE_WEB]];
    NSString* parametresRequete = [NSString stringWithFormat:@"methode=deletePersonne&serveur=%@&utilisateur=%@&motDePasse=%@&baseDeDonnees=%@&port=%@&idPersonne=%@&prenom=%@&nom=%@&age=%@", @SERVEUR,@UTILISATEUR, @MOT_DE_PASSE, @BASE_DE_DONNEES, @PORT,[personneDTO idPersonne], [personneDTO prenom],[personneDTO nom], [personneDTO age]];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[parametresRequete dataUsingEncoding:NSUTF8StringEncoding]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData* donnees,NSURLResponse* response, NSError* error){
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        
        if ([httpResponse statusCode]==200 && donnees !=nil) {
            NSDictionary* resultatJSON = [NSJSONSerialization JSONObjectWithData:donnees options:NSJSONReadingAllowFragments error:&error];
            
            nombreEnregistrements = (int) [resultatJSON[@"nombreEnregistrements"]integerValue];
        }else if ([httpResponse statusCode] != 200 && donnees != nil){
            NSDictionary* erreurJSON = [NSJSONSerialization JSONObjectWithData:donnees options:NSJSONReadingAllowFragments error:&error];
            NSString* codeErreur = erreurJSON[@"codeErreur"];
            NSString* messageErreur = erreurJSON[@"messageErreur"];
            
            NSLog(@"[Code d'erreur HTTP %ld] Echec de la requete %@?%@ -> [Code d'erreur MySQL %@] %@",(long) [httpResponse statusCode],@URL_SERVICE_WEB,parametresRequete,codeErreur,messageErreur);
        }else if(error != nil){
            NSLog(@"[Code d'erreur %ld] Echec de la requete %@?%@",(long)[httpResponse statusCode],@URL_SERVICE_WEB, parametresRequete,[error localizedDescription]);
        }else{
            NSLog(@"[Code d'erreur %ld] Echec de la requete %@?%@",(long)[httpResponse statusCode],@URL_SERVICE_WEB, parametresRequete);
        }
        dispatch_semaphore_signal(semaphore);
        
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return nombreEnregistrements;
}

-(NSMutableArray*)getAllPersonnes{
    __block NSMutableArray* personnes = [[NSMutableArray alloc]init];
    
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@URL_SERVICE_WEB]];
    
    NSString* parametresRequete = [NSString stringWithFormat:@"methode=getAllPersonnes&serveur=%@&utilisateur=%@&motDePasse=%@&baseDeDonnees=%@&port=%@&", @SERVEUR,@UTILISATEUR, @MOT_DE_PASSE, @BASE_DE_DONNEES, @PORT];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    
    
    
    
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[parametresRequete dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData* donnees,NSURLResponse* response, NSError* error){
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        
        
        
        if ([httpResponse statusCode]==200 && donnees !=nil) {
            
            NSArray* resultats = [NSJSONSerialization JSONObjectWithData:donnees options:NSJSONReadingAllowFragments error:&error];
            
            for (NSDictionary* personneJSON in resultats) {
                
                PersonneDTO* personneDTO = [[PersonneDTO alloc]init];
                
                
                
                [personneDTO setIdPersonne:personneJSON[@"idPersonne"]];
                
                [personneDTO setPrenom:personneJSON[@"prenom"]];
                
                [personneDTO setNom:personneJSON[@"nom"]];
                
                [personneDTO setAge:personneJSON[@"age"]];
                
                [personnes addObject:personneDTO];
                
            }
            
            
            
            
            
            
            
        }else if ([httpResponse statusCode] != 200 && donnees != nil){
            
            NSDictionary* erreurJSON = [NSJSONSerialization JSONObjectWithData:donnees options:NSJSONReadingAllowFragments error:&error];
            
            NSString* codeErreur = erreurJSON[@"codeErreur"];
            
            NSString* messageErreur = erreurJSON[@"messageErreur"];
            
            
            
            NSLog(@"[Code d'erreur HTTP %ld] Echec de la requete %@?%@ -> [Code d'erreur MySQL %@] %@",(long) [httpResponse statusCode],@URL_SERVICE_WEB,parametresRequete,codeErreur,messageErreur);
            
        }else if(error != nil){
            
            NSLog(@"[Code d'erreur %ld] Echec de la requete %@?%@",(long)[httpResponse statusCode],@URL_SERVICE_WEB, parametresRequete,[error localizedDescription]);
            
        }else{
            
            NSLog(@"[Code d'erreur %ld] Echec de la requete %@?%@",(long)[httpResponse statusCode],@URL_SERVICE_WEB, parametresRequete);
            
        }
        
        dispatch_semaphore_signal(semaphore);
        
        
        
    }] resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return personnes;
}


@end
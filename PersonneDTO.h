//
//  PersonneDTO.h
//  33-MySQL
//
//  Created by Sonnarinh Syhaphom (Étudiant) on 17-02-23.
//  Copyright © 2017 Sonnarinh Syhaphom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonneDTO : NSObject

@property (strong, nonatomic) NSString* idPersonne;
@property (strong, nonatomic) NSString* prenom;
@property (strong, nonatomic) NSString* nom;
@property (strong, nonatomic) NSString* age;

#pragma mark - Méthode d'initialisation
- (instancetype)initAvecIdPersonne:(NSString *)unIdPersonne prenom:(NSString*) unPrenom nom:(NSString*) unNom etAge:(NSString *)unAge;


@end


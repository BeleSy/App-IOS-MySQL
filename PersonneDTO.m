//
//  PersonneDTO.m
//  33-MySQL
//
//  Created by Sonnarinh Syhaphom (Étudiant) on 17-02-23.
//  Copyright © 2017 Sonnarinh Syhaphom. All rights reserved.
//

#import "PersonneDTO.h"
#import <Foundation/Foundation.h>

@implementation PersonneDTO

@synthesize idPersonne;
@synthesize prenom;
@synthesize nom;
@synthesize age;

- (instancetype) initAvecIdPersonne:(id)unIdPersonne prenom:(id)unPrenom nom:(id)unNom etAge:(id)unAge{
    
    if (self = [super init]) {
        self -> idPersonne = unIdPersonne;
        self -> prenom = unPrenom;
        self -> nom = unNom;
        self -> age = unAge;
    }
    return self;
}

@end
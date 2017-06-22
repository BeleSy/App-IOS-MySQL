//
//  PersonneFacade.h
//  33-MySQL
//
//  Created by Sonnarinh Syhaphom (Étudiant) on 17-02-23.
//  Copyright © 2017 Sonnarinh Syhaphom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonneDTO.h"

@interface PersonneFacade : NSObject

#pragma mark - Méthodes métier
+ (PersonneFacade*)personneFacade;

- (int)createPersonne:(PersonneDTO*)personneDTO;

-(PersonneDTO*)readPersonne:(NSString*)idPersonne;

- (int)updatePersonne:(PersonneDTO*)personneDTO;

- (int)deletePersonne:(PersonneDTO*)personneDTO;

-(NSMutableArray*)getAllPersonnes;


@end

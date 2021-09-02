//
//  GenericManagedObject.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 14/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject { // EntityFactoryManagedObject: NSManagedObject {
    func createEntity<T>() -> T {
        return (NSEntityDescription.insertNewObject(forEntityName: self.entity.managedObjectClassName, into: self.managedObjectContext!) as? T)!
    }
}

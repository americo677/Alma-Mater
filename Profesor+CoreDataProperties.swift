//
//  Profesor+CoreDataProperties.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 1/03/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Profesor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profesor> {
        return NSFetchRequest<Profesor>(entityName: "Profesor");
    }

    @NSManaged public var email: String?
    @NSManaged public var indice: Double
    @NSManaged public var nombre: String?
    @NSManaged public var telefono: String?
    @NSManaged public var asignatura: Asignatura?

}

//
//  Institucion+CoreDataProperties.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 1/03/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Institucion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Institucion> {
        return NSFetchRequest<Institucion>(entityName: "Institucion");
    }

    @NSManaged public var descripcion: String?
    @NSManaged public var indice: Double
    @NSManaged public var indicePais: Double
    @NSManaged public var programas: NSSet?

}

// MARK: Generated accessors for programas
extension Institucion {

    @objc(addProgramasObject:)
    @NSManaged public func addToProgramas(_ value: Programa)

    @objc(removeProgramasObject:)
    @NSManaged public func removeFromProgramas(_ value: Programa)

    @objc(addProgramas:)
    @NSManaged public func addToProgramas(_ values: NSSet)

    @objc(removeProgramas:)
    @NSManaged public func removeFromProgramas(_ values: NSSet)

}

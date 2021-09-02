//
//  Asignatura+CoreDataProperties.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 1/03/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Asignatura {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Asignatura> {
        return NSFetchRequest<Asignatura>(entityName: "Asignatura");
    }

    @NSManaged public var creditos: Double
    @NSManaged public var indice: Double
    @NSManaged public var nombre: String?
    @NSManaged public var promedio: Double
    @NSManaged public var cortes: NSSet?
    @NSManaged public var periodo: Periodo?
    @NSManaged public var profesor: Profesor?

}

// MARK: Generated accessors for cortes
extension Asignatura {

    @objc(addCortesObject:)
    @NSManaged public func addToCortes(_ value: Corte)

    @objc(removeCortesObject:)
    @NSManaged public func removeFromCortes(_ value: Corte)

    @objc(addCortes:)
    @NSManaged public func addToCortes(_ values: NSSet)

    @objc(removeCortes:)
    @NSManaged public func removeFromCortes(_ values: NSSet)

}

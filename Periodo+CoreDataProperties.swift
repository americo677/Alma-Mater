//
//  Periodo+CoreDataProperties.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 1/03/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Periodo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Periodo> {
        return NSFetchRequest<Periodo>(entityName: "Periodo");
    }

    @NSManaged public var creditos: Double
    @NSManaged public var fechaFinal: NSDate?
    @NSManaged public var fechaInicial: NSDate?
    @NSManaged public var indice: Double
    @NSManaged public var indiceDuracion: Double
    @NSManaged public var nombre: String?
    @NSManaged public var promedio: Double
    @NSManaged public var asignaturas: NSSet?
    @NSManaged public var programa: Programa?

}

// MARK: Generated accessors for asignaturas
extension Periodo {

    @objc(addAsignaturasObject:)
    @NSManaged public func addToAsignaturas(_ value: Asignatura)

    @objc(removeAsignaturasObject:)
    @NSManaged public func removeFromAsignaturas(_ value: Asignatura)

    @objc(addAsignaturas:)
    @NSManaged public func addToAsignaturas(_ values: NSSet)

    @objc(removeAsignaturas:)
    @NSManaged public func removeFromAsignaturas(_ values: NSSet)

}

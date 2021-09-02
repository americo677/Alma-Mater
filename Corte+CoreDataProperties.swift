//
//  Corte+CoreDataProperties.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 1/03/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Corte {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Corte> {
        return NSFetchRequest<Corte>(entityName: "Corte");
    }

    @NSManaged public var fechaFinal: NSDate?
    @NSManaged public var fechaInicial: NSDate?
    @NSManaged public var indice: Double
    @NSManaged public var nombre: String?
    @NSManaged public var porcentaje: Double
    @NSManaged public var promedio: Double
    @NSManaged public var asignaturas: NSSet?
    @NSManaged public var formasEvaluacion: NSSet?

}

// MARK: Generated accessors for asignaturas
extension Corte {

    @objc(addAsignaturasObject:)
    @NSManaged public func addToAsignaturas(_ value: Asignatura)

    @objc(removeAsignaturasObject:)
    @NSManaged public func removeFromAsignaturas(_ value: Asignatura)

    @objc(addAsignaturas:)
    @NSManaged public func addToAsignaturas(_ values: NSSet)

    @objc(removeAsignaturas:)
    @NSManaged public func removeFromAsignaturas(_ values: NSSet)

}

// MARK: Generated accessors for formasEvaluacion
extension Corte {

    @objc(addFormasEvaluacionObject:)
    @NSManaged public func addToFormasEvaluacion(_ value: FormaEvaluacion)

    @objc(removeFormasEvaluacionObject:)
    @NSManaged public func removeFromFormasEvaluacion(_ value: FormaEvaluacion)

    @objc(addFormasEvaluacion:)
    @NSManaged public func addToFormasEvaluacion(_ values: NSSet)

    @objc(removeFormasEvaluacion:)
    @NSManaged public func removeFromFormasEvaluacion(_ values: NSSet)

}

//
//  FormaEvaluacion+CoreDataProperties.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 1/03/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension FormaEvaluacion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FormaEvaluacion> {
        return NSFetchRequest<FormaEvaluacion>(entityName: "FormaEvaluacion");
    }

    @NSManaged public var indice: Double
    @NSManaged public var indiceTipoEvaluacion: Double
    @NSManaged public var nombre: String?
    @NSManaged public var porcentaje: Double
    @NSManaged public var promedio: Double
    @NSManaged public var corte: Corte?
    @NSManaged public var evaluaciones: NSSet?

}

// MARK: Generated accessors for evaluaciones
extension FormaEvaluacion {

    @objc(addEvaluacionesObject:)
    @NSManaged public func addToEvaluaciones(_ value: Evaluacion)

    @objc(removeEvaluacionesObject:)
    @NSManaged public func removeFromEvaluaciones(_ value: Evaluacion)

    @objc(addEvaluaciones:)
    @NSManaged public func addToEvaluaciones(_ values: NSSet)

    @objc(removeEvaluaciones:)
    @NSManaged public func removeFromEvaluaciones(_ values: NSSet)

}

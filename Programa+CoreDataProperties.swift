//
//  Programa+CoreDataProperties.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 25/05/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Programa {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Programa> {
        return NSFetchRequest<Programa>(entityName: "Programa")
    }

    @NSManaged public var duracion: Double
    @NSManaged public var email: String?
    @NSManaged public var esPromedioPonderado: Bool
    @NSManaged public var indice: Double
    @NSManaged public var indiceNivelAcademico: Double
    @NSManaged public var indicePais: Double
    @NSManaged public var nombre: String?
    @NSManaged public var promedio: Double
    @NSManaged public var esEsquemaActual: Bool
    @NSManaged public var escala: Escala?
    @NSManaged public var institucion: Institucion?
    @NSManaged public var periodos: NSSet?

}

// MARK: Generated accessors for periodos
extension Programa {

//    @objc(addPeriodosObject:)
//    @NSManaged public func addToPeriodos(_ value: Periodo)
//
//    @objc(removePeriodosObject:)
//    @NSManaged public func removeFromPeriodos(_ value: Periodo)
//
//    @objc(addPeriodos:)
//    @NSManaged public func addToPeriodos(_ values: NSSet)
//
//    @objc(removePeriodos:)
//    @NSManaged public func removeFromPeriodos(_ values: NSSet)

}

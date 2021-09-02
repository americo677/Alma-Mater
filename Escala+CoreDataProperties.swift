//
//  Escala+CoreDataProperties.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 11/05/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Escala {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Escala> {
        return NSFetchRequest<Escala>(entityName: "Escala")
    }

    @NSManaged public var descripcion: String?
    @NSManaged public var indice: Double
    @NSManaged public var indicePais: Double
    @NSManaged public var tipo: Double
    @NSManaged public var valorMinParaAprobacion: Double
    @NSManaged public var valorMinimo: Double
    @NSManaged public var valorMaximo: Double
    @NSManaged public var programas: NSSet?
    @NSManaged public var rangos: NSSet?

}

// MARK: Generated accessors for programas
extension Escala {

    //@objc(addProgramasObject:)
    //@NSManaged public func addToProgramas(_ value: Programa)

    //@objc(removeProgramasObject:)
    //@NSManaged public func removeFromProgramas(_ value: Programa)

    //@objc(addProgramas:)
    //@NSManaged public func addToProgramas(_ values: NSSet)

    //@objc(removeProgramas:)
    //@NSManaged public func removeFromProgramas(_ values: NSSet)

}

// MARK: Generated accessors for rangos
extension Escala {

    //@objc(addRangosObject:)
    //@NSManaged public func addToRangos(_ value: RangoEscala)

    //@objc(removeRangosObject:)
    //@NSManaged public func removeFromRangos(_ value: RangoEscala)

    //@objc(addRangos:)
    //@NSManaged public func addToRangos(_ values: NSSet)

    //@objc(removeRangos:)
    //@NSManaged public func removeFromRangos(_ values: NSSet)

}

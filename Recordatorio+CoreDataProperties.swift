//
//  Recordatorio+CoreDataProperties.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 1/03/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Recordatorio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recordatorio> {
        return NSFetchRequest<Recordatorio>(entityName: "Recordatorio");
    }

    @NSManaged public var detenido: Bool
    @NSManaged public var enPausa: Bool
    @NSManaged public var fecha: NSDate?
    @NSManaged public var frecuenciaAviso: Double
    @NSManaged public var hora: NSDate?
    @NSManaged public var indice: Double
    @NSManaged public var indiceFrecuenciaAviso: Double
    @NSManaged public var indicePrevioAviso: Double
    @NSManaged public var mensaje: String?
    @NSManaged public var previoAviso: Double
    @NSManaged public var programado: Bool
    @NSManaged public var evaluacion: Evaluacion?

}

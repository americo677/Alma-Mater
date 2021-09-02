//
//  Evaluacion+CoreDataProperties.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 1/03/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Evaluacion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Evaluacion> {
        return NSFetchRequest<Evaluacion>(entityName: "Evaluacion");
    }

    @NSManaged public var compartido: Bool
    @NSManaged public var definitiva: Double
    @NSManaged public var descripcion: String?
    @NSManaged public var fecha: NSDate?
    @NSManaged public var hora: NSDate?
    @NSManaged public var imagen: String?
    @NSManaged public var indice: Double
    @NSManaged public var nota: Double
    @NSManaged public var notaAlfa: String?
    @NSManaged public var puntosAdicionales: Double
    @NSManaged public var formaEvaluacion: FormaEvaluacion?
    @NSManaged public var recordatorio: Recordatorio?

}

//
//  RangoEscala+CoreDataProperties.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 1/03/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension RangoEscala {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RangoEscala> {
        return NSFetchRequest<RangoEscala>(entityName: "RangoEscala");
    }

    @NSManaged public var descripcion: String?
    @NSManaged public var indice: Double
    @NSManaged public var indiceEscala: Double
    @NSManaged public var limiteInferior: Double
    @NSManaged public var limiteSuperior: Double
    @NSManaged public var valor: Double
    @NSManaged public var valorAlfa: String?
    @NSManaged public var escala: Escala?

}

//
//  CoreDataExtensions.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 16/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData


extension Institucion {
    
    func orderByDescription(orden: Orden) -> [AnyObject] {
        let moc = SingleManagedObjectContext.sharedInstance.getMOC()
        
        let data = NSFetchRequest<NSFetchRequestResult>(entityName: Institucion.entity().managedObjectClassName!)
        
        data.entity = NSEntityDescription.entity(forEntityName: Institucion.entity().managedObjectClassName!, in: moc)
        
        do {
            let instituciones = try moc.fetch(data) as [AnyObject]
            
            //self.instituciones = instituciones.sorted { ($0 as! Institucion).descripcion! < ($1 as! Institucion).descripcion! }
            if orden == .ascendente {
                return instituciones.sorted { ($0 as! Institucion).descripcion! < ($1 as! Institucion).descripcion! }
            } else {
                return instituciones.sorted { ($0 as! Institucion).descripcion! > ($1 as! Institucion).descripcion! }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
}

extension Escala {
    func addToRangos(rango: RangoEscala) {
        let rangos = self.mutableSetValue(forKey: "rangos")
        rangos.add(rango)
    }

    func obtenerRangos() -> [AnyObject] {
        let rangos = self.mutableSetValue(forKey: "rangos").allObjects as [AnyObject]
        
        let rangosOrdenados = rangos.sorted { ($0 as! RangoEscala).limiteInferior < ($1 as! RangoEscala).limiteInferior }
        
        return rangosOrdenados
    }

    func obtenerUltimoIndice() -> Double {
        var result: Double = 0
        let escalas = fetchData(entity: .escala, byIndex: nil, orderByIndex: true)
        
        if escalas.count > 0 {
            result = (escalas.last as! Escala).indice
        }
        
        return result
    }
    
    func obtenerNuevoIndice() -> Double {
        let result: Double = obtenerUltimoIndice() + 1
        return result
    }
    
    func obtenerPrimerIndice() -> Double {
        var result: Double = 0
        let escalas = fetchData(entity: .escala, byIndex: nil, orderByIndex: true)
        
        if escalas.count > 0 {
            result = (escalas.first as! Escala).indice
        }
        
        return result
    }
    
}

extension RangoEscala {
    func obtenerUltimoIndice() -> Double {
        var result: Double = 0
        let rangos = fetchData(entity: .rango, byIndex: nil, orderByIndex: true)
        
        if rangos.count > 0 {
            result = (rangos.last as! Programa).indice
        }
        
        return result
    }
    
    func obtenerNuevoIndice() -> Double {
        let result: Double = obtenerUltimoIndice() + 1
        return result
    }
    
    func obtenerPrimerIndice() -> Double {
        var result: Double = 0
        let rangos = fetchData(entity: .rango, byIndex: nil, orderByIndex: true)
        
        if rangos.count > 0 {
            result = (rangos.first as! Programa).indice
        }
        
        return result
    }

}

extension Programa {
    func periodoVigente() -> Periodo? {
        let periodos = self.mutableSetValue(forKey: "periodos")
       
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        let hoy = Date()
        
        if periodos.count > 0 {
            //print("Periodos: \(periodos)")
            let periodosFiltrados = periodos.filter {
                (($0 as! Periodo).fechaInicial! as Date) <= hoy && hoy <= (($0 as! Periodo).fechaFinal! as Date)
            }
            if periodosFiltrados.count >= 1 {
                return periodosFiltrados.first as? Periodo
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func addPeriodo(periodo: Periodo) {
        let periodos = self.mutableSetValue(forKey: "periodos")
        periodos.add(periodo)
    }

    func removePeriodo(periodo: Periodo) {
        let periodos = self.mutableSetValue(forKey: "periodos")
        periodos.remove(periodo)
    }
    
    func obtenerPeriodos() -> [AnyObject] {
        let periodos = self.mutableSetValue(forKey: "periodos").allObjects
        
        return periodos as [AnyObject]
    }
    
    func obtenerPeriodosOrdernadoPorIndice() -> [AnyObject] {
        let periodos = self.mutableSetValue(forKey: "periodos").allObjects
        var result = [AnyObject]()
        
        if periodos.count > 0 {
            result = periodos.sorted { ($0 as! Periodo).indice < ($1 as! Periodo).indice } as [AnyObject]
        }
        
        return result as [AnyObject]
    }

    func obtenerUltimoIndice() -> Double {
        var result: Double = 0
        let programas = fetchData(entity: .programa, byIndex: nil, orderByIndex: true)
        
        if programas.count > 0 {
            result = (programas.last as! Programa).indice
        }
        
        return result
    }
    
    func obtenerNuevoIndice() -> Double {
        let result: Double = obtenerUltimoIndice() + 1
        return result
    }
    
    func obtenerPrimerIndice() -> Double {
        var result: Double = 0
        let programas = fetchData(entity: .programa, byIndex: nil, orderByIndex: true)
        
        if programas.count > 0 {
            result = (programas.first as! Programa).indice
        }
        
        return result
    }
}

extension Periodo {
    func obtenerUltimoIndice() -> Double {
        var result: Double = 0
        let periodos = fetchData(entity: .periodo, byIndex: nil, orderByIndex: true)
        
        if periodos.count > 0 {
            result = (periodos.last as! Periodo).indice
        }
        
        return result
    }
    
    func obtenerNuevoIndice() -> Double {
        let result: Double = obtenerUltimoIndice() + 1
        return result
    }
    
    func obtenerPrimerIndice() -> Double {
        var result: Double = 0
        let periodos = fetchData(entity: .periodo, byIndex: nil, orderByIndex: true)
        
        if periodos.count > 0 {
            result = (periodos.first as! Periodo).indice
        }
        
        return result
    }
    
    func obtenerAsignaturas() -> [AnyObject] {
        let asignaturas = self.mutableSetValue(forKey: "asignaturas").allObjects as [AnyObject]
        
        return asignaturas
    }
    
}

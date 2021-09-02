//
//  FileSystemLib.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 13/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

func getPath(_ fileName: String) -> String {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent(fileName)
    return fileURL.path
}

func getDocumentsURL() -> NSURL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsURL as NSURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL!.path
    
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func genFileNameFromDateTime(sufix formato: String) -> String {
    let date = NSDate()
    let calendar = NSCalendar.current
    let hour = calendar.component(.hour, from: date as Date)
    let minutes = calendar.component(.minute, from: date as Date)
    let seconds = calendar.component(.second, from: date as Date)
    let day = calendar.component(.day, from: date as Date)
    let month = calendar.component(.month, from: date as Date)
    let year = calendar.component(.year, from: date as Date)
    
    let fileName = String(format: "%04d%02d%02d%02d%02d%02d.%@", year, month, day, hour, minutes, seconds, formato)
    
    return fileName
}

/*
// MARK: - Carga inicial de datos JSON
func loadInitJSON() {
    if let dataPath = Bundle.main.path(forResource: "initialbudget", ofType: "json") {
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: dataPath), options: NSData.ReadingOptions.mappedIfSafe)
            do {
                let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if let budgetsJSON : [NSDictionary] = jsonResult["Presupuesto"] as? [NSDictionary] {
                    for budgetJSON: NSDictionary in budgetsJSON {
                        
                        //for (name, value) in budget {
                        //    print("\(name) , \(value)")
                        //}
                        
                        self.presupuesto = self.loadInitJSONPresupuesto(budgetJSON)
                        
                        do {
                            try self.moc.save()
                        } catch let error as NSError {
                            print("No se pudo guardar los datos precargados de presupuesto.  Error: \(error)")
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    self.presupuesto = nil
}

func loadInitJSONSeccion(_ section: NSDictionary) -> PresupuestoSeccion {
    //print("sección: \(section)")
    
    let seccion = NSEntityDescription.insertNewObject(forEntityName: self.smModelo.smPresupuestoSeccion.entityName, into: self.moc) as? PresupuestoSeccion
    
    for (name, value) in section {
        
        if name as! String == self.smModelo.smPresupuestoSeccion.colDescripcion {
            seccion!.setValue(value as! String, forKey: self.smModelo.smPresupuestoSeccion.colDescripcion)
        }
        
        if name as! String == smModelo.smPresupuestoSeccion.colTotalIngresos {
            seccion!.setValue(value as! Double, forKey: smModelo.smPresupuestoSeccion.colTotalIngresos)
        }
        
        if name as! String == smModelo.smPresupuestoSeccion.colTotalEgresos {
            seccion!.setValue(value as! Double, forKey: smModelo.smPresupuestoSeccion.colTotalEgresos)
        }
        
        if name as! String == smModelo.smPresupuestoSeccion.colPresupuesto {
            seccion!.setValue(self.presupuesto, forKey: smModelo.smPresupuestoSeccion.colPresupuesto)
        }
        
        let lpsRecibo = seccion?.mutableSetValue(forKey: self.smModelo.smPresupuestoSeccion.colRecibos)
        
        if name as! String == "recibos" {
            if let recibos : [NSDictionary] = section["recibos"] as? [NSDictionary] {
                for recibo: NSDictionary in recibos {
                    let iRecibo = self.loadInitJSONRecibo(recibo, seccion: seccion!)
                    lpsRecibo?.add(iRecibo)
                }
                seccion?.setValue(lpsRecibo, forKey: self.smModelo.smPresupuestoSeccion.colRecibos)
            }
        }
    }
    return seccion!
}
*/

// MARK: - Cargue json de instituciones
func loadInitJSONInstitucion(json: NSDictionary) -> Bool {
    var finishOk: Bool = false
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    let institucion = NSEntityDescription.insertNewObject(forEntityName: Institucion.entity().managedObjectClassName!, into: moc) as? Institucion
    for (name, value) in json {
        var countKey = 0
        for key in Institucion.entity().attributesByName.keys {
            countKey += 1
            if countKey == 3 && key != "programas" {
                institucion?.setValue(nil, forKey: "programas")
            }
            if name as! String == key {
                institucion?.setValue(value, forKey: key)
                //print("key: \(key) -> value: \(value)")
            }
        }
        
        finishOk = true
    }
    return finishOk
}

func loadInitJSONRango(json: NSDictionary, escala: Escala) -> Bool {
    var finishOk: Bool = false
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    let rango = (NSEntityDescription.insertNewObject(forEntityName: RangoEscala.entity().managedObjectClassName!, into: moc) as? RangoEscala)!
    
    for (name, value) in json {
        for key in RangoEscala.entity().attributesByName.keys {
            if name as! String == key {
                //print("name<\(name)> value<\(value)>")
                rango.setValue(value, forKey: key)
            }
        }
        finishOk = true
    }
    escala.addToRangos(rango: rango)
    //print("Rango: \(rango)")
    rango.setValue(escala, forKey: "escala")
    return finishOk
}

// MARK: - Cargue json de escalas
func loadInitJSONEscala(json: NSDictionary) -> Bool {
    var finishOk: Bool = false
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    let escala = (NSEntityDescription.insertNewObject(forEntityName: Escala.entity().managedObjectClassName!, into: moc) as? Escala)!
    
    // para obtener los atributos individuales
    for (name, value) in json {
        for key in Escala.entity().attributesByName.keys {
            if name as! String == key {
                escala.setValue(value, forKey: key)
                //print("key: \(key) -> value: \(value)")
            }
        }
    }
    
    // para obtener los datos del arreglo rangos
    if let jsonRangos = json["rangos"] as? [NSDictionary] {
        // access nested dictionary values by key
        
        for jsonRango: NSDictionary in jsonRangos {
            finishOk = loadInitJSONRango(json: jsonRango, escala: escala)
            if !finishOk {
                break
            }
        }
    }
    
    
                    //rango = NSEntityDescription.insertNewObject(forEntityName: RangoEscala.entity().managedObjectClassName!, into: moc) as? RangoEscala
                    
                    //var valString: String?
                    //var valNumeric: NSNumber?
                    /*
                    for (atributoRango, valorAtributoRango) in jsonRango {
                        for dict in RangoEscala.entity().attributesByName {
                            //if let valString = (jsonRango[dict.key]! as! String)! {
                            //    print("atributo<\(dict.key)> class<\(dict.value.attributeValueClassName!)> valor<\(valString)>")
                            //} else if let valNumeric = (jsonRango[dict.key]! as! NSNumber)! {
                            //    print("atributo<\(dict.key)> class<\(dict.value.attributeValueClassName!)> valor<\(valNumeric)>")
                            //}
                            
                            if let valString = jsonRango[dict.key] as? String {
                                print("atributo<\(dict.key)> class<\(dict.value.attributeValueClassName!)> valor<\(valString)>")
                                switch (dict.value.attributeType) {
                                case NSAttributeType.doubleAttributeType:
                                    let douVal = (valString.characters.count) > 0 ? numFormatter.number(from: valString)?.doubleValue: 0.0
                                    // Double(valString!)
                                    rango?.setValue(douVal, forKey: dict.key)
                                    print("Double type")
                                    break
                                case NSAttributeType.dateAttributeType:
                                    let dateVal = dtFormatter.date(from:valString)
                                    rango?.setValue(dateVal, forKey: dict.key)
                                    print("Date type")
                                    break
                                case NSAttributeType.stringAttributeType:
                                    rango?.setValue(valString, forKey: dict.key)
                                    print("String type")
                                    break
                                case NSAttributeType.integer16AttributeType:
                                    let int16Val = (valString.characters.count) > 0 ? numFormatter.number(from: valString)?.int16Value: 0
                                    rango?.setValue(int16Val, forKey: dict.key)
                                    print("Integer16 type")
                                    break
                                case NSAttributeType.booleanAttributeType:
                                    let boolVal = Bool.init(valString)
                                    
                                    rango?.setValue(boolVal, forKey: dict.key)
                                    print("Boolean type")
                                    break
                                default: break
                                }
                            }
                        }
                        
                    }
                    
                    */
                    
                    
/*
                    for (name, value) in jsonRango {
                        for dict in RangoEscala.entity().attributesByName {
                            if name as! String == dict.key {
                                print("atributo: <\(dict.key)>")
                                switch (dict.value.attributeType) {
                                    case NSAttributeType.doubleAttributeType:
                                        rango?.setValue(Double(value as! String)!, forKey: dict.key)
                                        print("Double type")
                                    break
                                    case NSAttributeType.dateAttributeType:
                                        rango?.setValue(value as! Date, forKey: dict.key)
                                        print("Date type")
                                    break
                                    case NSAttributeType.stringAttributeType:
                                        rango?.setValue(value as! String, forKey: dict.key)
                                        print("String type")
                                    break
                                    case NSAttributeType.integer16AttributeType:
                                        rango?.setValue(Int16.init((value as! String)), forKey: dict.key)
                                        print("Integer16 type")
                                    break
                                    case NSAttributeType.booleanAttributeType:
                                        rango?.setValue(value as! Bool, forKey: dict.key)
                                        print("Boolean type")
                                    break
                                default: break
                                }
                            }
                        }
                        
                    }
                    */
                //}
              
            //}
        //}
        //finishOk = true
    //}
    escala.setValue(nil, forKey: "programas")
    
    return finishOk
}

// MARK: - Carga inicial de datos JSON
func loadInitJSON(jsonFile: String, type: ClassForPreLoading) -> Bool {
    var finishOk: Bool = true
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    if let dataPath = Bundle.main.path(forResource: jsonFile, ofType: "json") {
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: dataPath), options: NSData.ReadingOptions.mappedIfSafe)
            do {
                let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                switch type {
                case .institucion:
                    if let jsonInstituciones : [NSDictionary] = jsonResult["Institucion"] as? [NSDictionary] {
                        for jsonInstitucion: NSDictionary in jsonInstituciones {
                            
                            if loadInitJSONInstitucion(json: jsonInstitucion) {
                                do {
                                    try moc.save()
                                } catch let error as NSError {
                                    print("No se pudo guardar los datos precargados de Instituciones.  Error: \(error)")
                                    finishOk = false
                                }
                            } else {
                                print("No se pudo recuperar los datos precargados de Instituciones.")
                            }
                            
                        }
                    }
                    break
                case .escala:
                    if let jsonEscalas : [NSDictionary] = jsonResult["Escala"] as? [NSDictionary] {
                        for jsonEscala: NSDictionary in jsonEscalas {
                            
                            if loadInitJSONEscala(json: jsonEscala) {
                                do {
                                    try moc.save()
                                } catch let error as NSError {
                                    print("No se pudo guardar los datos precargados de escalas.  Error: \(error)")
                                    finishOk = false
                                }
                            } else {
                                print("No se pudo recuperar los datos precargados de escalas.")
                            }
                            
                        }
                    }
                    break
                default:
                    print("No aplicó a ninguno de los pre-cargues establecidos!")
                    break
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    return finishOk
}

/*
func loadJSONMemeber(_ institucionDict: NSDictionary) -> Institucion {
    //print("Presupuesto: \(budget)")
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    
    let presupuesto = NSEntityDescription.insertNewObject(forEntityName: self.smModelo.smPresupuesto.entityName, into: self.moc) as? Presupuesto
    
    for (name, value) in budget {
        
        
        if name as! String == smModelo.smPresupuesto.colActivo {
            if value as! Bool == true {
                presupuesto!.setValue(true, forKey: smModelo.smPresupuesto.colActivo)
            } else {
                presupuesto!.setValue(false, forKey: smModelo.smPresupuesto.colActivo)
            }
        }
        
        let lpsSeccion = presupuesto?.mutableSetValue(forKey: self.smModelo.smPresupuesto.colSecciones)
        
        if name as! String == "secciones" {
            if let secciones : [NSDictionary] = budget["secciones"] as? [NSDictionary] {
                for seccion: NSDictionary in secciones {
                    let iSeccion = self.loadInitJSONSeccion(seccion)
                    lpsSeccion?.add(iSeccion)
                }
                presupuesto?.setValue(lpsSeccion, forKey: self.smModelo.smPresupuesto.colSecciones)
            }
        }
    }
    
    do {
        try moc.save()
    } catch let error as NSError {
        print("No se pudo guardar los datos precargados de instituciones.  Error: \(error)")
    }

    return presupuesto!
}
*/

/*
 func cargarImagenDesde(fileName: String!) -> UIImage? {
 
 if fileName != nil {
 if !fileName.isEmpty {
 //let fullFileName = URL(fileURLWithPath: fileName)
 
 //"\((getDocumentsURL().appendingPathComponent(fileName)?.absoluteString)!).jpg"
 
 let iImagen = UIImage(contentsOfFile: fileName!)
 
 if iImagen == nil {
 print("No se encontró la imagen: \(fileName!)")
 } else {
 print("Cargando imagen de la ruta: \(fileName!)")
 }
 
 // this is just for you to see the path in case you want to go to the directory, using Finder.
 return iImagen
 }
 }
 return UIImage()
 }
 
 func guardarImagen(imagen: UIImage!) -> Bool {
 
 //let jpgImage = UIImagePNGRepresentation(image)
 
 let jpgImage = UIImageJPEGRepresentation(imagen, 0.6)
 
 var isOk: Bool?
 
 let fileName = getDocumentsURL().appendingPathComponent(genFileNameFromDateTime())
 
 //self.nombreArchivoImagen =  "\(fileName!)"
 
 do {
 _ = try jpgImage?.write(to: fileName!)
 print("La imagen fue almacenada en el dispositivo \(fileName!)")
 isOk = true
 } catch let err {
 isOk = false
 print("No se pudo almacenar la imagen: \(err.localizedDescription)")
 }
 return isOk!
 }
 
 func saveImage(image: UIImage!, imageFullFileName fullName: inout String) -> Bool {
 
 //let jpgImage = UIImagePNGRepresentation(image)
 
 let jpgImage = UIImageJPEGRepresentation(imagen, 0.6)
 
 var isOk: Bool?
 
 let fileName = getDocumentsURL().appendingPathComponent(genFileNameFromDateTime())
 
 //self.nombreArchivoImagen =  "\(fileName!)"
 
 do {
 _ = try jpgImage?.write(to: fileName!)
 print("La imagen fue almacenada en el dispositivo \(fileName!)")
 isOk = true
 } catch let err {
 isOk = false
 print("No se pudo almacenar la imagen: \(err.localizedDescription)")
 }
 return isOk!
 }
 */

// conseguido en internet
// https://iosdevcenters.blogspot.com/2016/04/save-and-get-image-from-document.html

// Save image at document directory

func isAValidDirectory(directory directoryName: String) -> Bool {
    //let fileManager = FileManager.default
    
    let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let path = "\(paths.appendingPathComponent(directoryName))"
    //let fileManager = FileManager.default
    
    var isDir: ObjCBool = false
    var isValidDir: Bool = false
    
    if manager.fileExists(atPath: path, isDirectory: &isDir) {
        if isDir.boolValue {
            // file exists and is a directory
            print("El directorio \(directoryName) es válido")
            isValidDir = true
        } else {
            // file exists and is not a directory
            print("Error, el componente Images no es un directorio")
            isValidDir = createDirectory(directory: directoryName)
        }
    } else {
        // file does not exist
        print("Error, no existe el directorio para Mis Regalos App")
        isValidDir = createDirectory(directory: directoryName)
    }
    
    return isValidDir
}

func saveImageIn(directory directoryName: String, image: UIImage!, fullFileName fileName: inout String) -> Bool {
    
    //let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var isSaveOk: Bool = true
    
    if isAValidDirectory(directory: directoryName) {
        let path = paths.appendingPathComponent(directoryName)
        
        fileName = genFileNameFromDateTime(sufix: "jpg")
        
        let fullPath = path.appendingPathComponent(fileName)
        
        //print("File name: \(fileName)")
        //print("Full path: \(fullPath)")
        
        //let image = UIImage(named: fileName)
        
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        
        //isSaveOk = manager.createFile(atPath: fullPath.absoluteString, contents: imageData, attributes: nil)
        
        do {
            
            try imageData?.write(to: fullPath)
            
        } catch (let error as Error) {
            print("Error al escribir imagen: \(error.localizedDescription)")
            isSaveOk = false
        }
        
        if !isSaveOk {
            print("No se pudo almacenar el archivo \(fullPath.absoluteString)")
        }
    } else {
        isSaveOk = false
    }
    
    return isSaveOk
}


// get document directory path
/*
 func getDirectoryPath() -> String {
 let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
 let documentsDirectory = paths[0]
 return documentsDirectory
 }
 */

// get image from document directory
func getImageFrom(directory directoryName: String, fileName: String) -> UIImage {
    
    let iImage: UIImage?
    
    let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let path = paths.appendingPathComponent(directoryName)
    
    let imagePath = path.appendingPathComponent(fileName)
    
    //print("Full image path: \(imagePath)")
    
    if manager.fileExists(atPath: imagePath.path) {
        iImage = UIImage(contentsOfFile: imagePath.path)
    } else {
        print("Not found image \(imagePath.absoluteString)")
        iImage = UIImage()
    }
    
    return iImage!
}

// create directory
func createDirectory(directory directoryName: String) -> Bool {
    let manager = FileManager.default
    
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let path = paths.appendingPathComponent(directoryName)
    
    var isCreationOk: Bool = true
    
    if !manager.fileExists(atPath: path.path) {
        do {
            try manager.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
        } catch (let error as Error) {
            print("Error al intentar crear el directorio \(directoryName): \(error.localizedDescription)")
            isCreationOk = false
        }
    } else {
        print("El directorio \(directoryName) ya existe!")
    }
    
    return isCreationOk
}

// delete directory
func deleteFileFrom(directory directoryName: String, fileNameToDelete fileName: String) -> Bool {
    let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let path = paths.appendingPathComponent(directoryName)
    
    let imagePath = path.appendingPathComponent(fileName)
    
    var isDeletedOk: Bool = true
    
    if manager.fileExists(atPath: imagePath.path) {
        try! manager.removeItem(atPath: imagePath.path)
    } else {
        print("No se pudo elminar el archivo \(imagePath.path)")
        isDeletedOk = false
    }
    
    return isDeletedOk
}

// MARK: - Consulta a la BD de instituciones y escalas registradas
func fetchData(entity: ClassForPreLoading, byIndex index: Double? = nil, orderByIndex order: Bool? = false) -> [AnyObject] {
    
    var results = [AnyObject]()
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    //let sortDescriptor = NSSortDescriptor(key: "secciones.recibos.fecha", ascending: false)
    
    
    // fetchRequest.sortDescriptors = [sortDescriptor]
    
    // Initialize Fetch Request
    //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: smModelo.smPresupuesto.entityName)
    
    //let fetchRequest: NSFetchRequest<Programa> = Programa.fetchRequest() //
    //var fecthRequest: NSFetchRequestResult?
    
    switch entity {
    case .institucion:
        let fetchInstitucion: NSFetchRequest<Institucion> = Institucion.fetchRequest()
        fetchInstitucion.entity = NSEntityDescription.entity(forEntityName: "Institucion", in: moc)
        if index != nil {
            let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
            //let predicate = NSPredicate(format: " descripcion contains[c] %@ ", "norte" as String)
            fetchInstitucion.predicate = predicate
        }
        do {
            results = try moc.fetch(fetchInstitucion)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        break
    case .escala:
        let fetchEscala: NSFetchRequest<Escala> = Escala.fetchRequest()
        fetchEscala.entity = NSEntityDescription.entity(forEntityName: "Escala", in: moc)
        if index != nil {
            let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
            fetchEscala.predicate = predicate
        }
        do {
            results = try moc.fetch(fetchEscala)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        break
    case .programa:
        let fetchPrograma: NSFetchRequest<Programa> = Programa.fetchRequest()
        fetchPrograma.entity = NSEntityDescription.entity(forEntityName: "Programa", in: moc)
        if index != nil {
            let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
            fetchPrograma.predicate = predicate
        }
        do {
            let programas = try moc.fetch(fetchPrograma)
            if programas.count > 0 {
                if order! {
                    results = programas.sorted { ($0 as Programa).indice < ($1 as Programa).indice }
                } else {
                    results = programas
                }
            } else {
                results = []
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        break
    case .periodo:
        let fetchPeriodo: NSFetchRequest<Periodo> = Periodo.fetchRequest()
        fetchPeriodo.entity = NSEntityDescription.entity(forEntityName: "Periodo", in: moc)
        if index != nil {
            let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)
            fetchPeriodo.predicate = predicate
        }
        do {
            let periodos = try moc.fetch(fetchPeriodo)
            if order! {
                results = periodos.sorted { ($0 as Periodo).indice < ($1 as Periodo).indice }
            } else {
                results = periodos
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        break
    default:
        break
    }
    
    return results
}



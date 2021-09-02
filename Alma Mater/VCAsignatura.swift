//
//  VCAsignatura.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 10/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData


class VCAsignatura: UIViewController {

    
    @IBOutlet weak var tfPrograma: UITextField!
    @IBOutlet weak var tfPeriodo: UITextField!
    @IBOutlet weak var tfAsignatura: UITextField!
    @IBOutlet weak var tfCreditos: UITextField!
    @IBOutlet weak var tfProfesor: UITextField!
    @IBOutlet weak var tfEMailProfesor: UITextField!
    @IBOutlet weak var tfTelefonoProfesor: UITextField!
    
    var toolTip: CMPopTipView? = nil
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()

    var programas = [AnyObject]()
    var programa: Programa? = nil
    
    var periodo: Periodo? = nil
    
    var periodos = [AnyObject]()

    
    func btnGuardarOnTouchUpInside(_ sender: AnyObject) {
        // code for saving here
    }
    
    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        //initToolBar(toolbarColor: UIColor.customOceanBlue())
        
        initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Nueva Asignatura")
        
        //initSearchBar(tableView: tvEvaluaciones)
        
        self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        self.initTextFields(self.programa)
        
    }
    
    func initTextFields(_ programa: Programa? = nil) {
        if programa == nil {
            
            self.tfPrograma.text = ""
            self.tfPeriodo.text = ""
            self.tfAsignatura.text = ""
            self.tfCreditos.text = ""
            self.tfProfesor.text = ""
            self.tfEMailProfesor.text = ""
            self.tfTelefonoProfesor.text = ""
            
            self.tfCreditos.keyboardType = .numberPad
            self.tfEMailProfesor.keyboardType = .emailAddress
            self.tfTelefonoProfesor.keyboardType = .phonePad
            
            //self.loadPickerView(&self.pckrDuracionPeriodo, indiceSeleccionado:  Global.defaultIndex.duracionPeriodo, indicePorDefecto: Global.defaultIndex.duracionPeriodo, tag: 1, textField: self.tfDuracionPeriodo, opciones: Global.arreglo.nombreDuracion, accionDone: #selector(donePicker(for:)), accionCancel: #selector(cancelPicker(for:)))
            
        } else {
            // se cargan los datos si la vista es para consultar un programa
            self.tfPrograma.text = programa?.nombre
            
            self.periodo = programa?.periodoVigente()
            
            self.tfPeriodo.text = self.periodo?.nombre
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadPreferences()
        hideKeyboardWhenTappedAround()
        hidePopUpOnTap()
        
        NSLog("viewDidLoad executed...")
        
    }
    
    func handleTapToHidePopup(recognizer: UITapGestureRecognizer) {
        if self.toolTip != nil {
            self.toolTip?.dismiss(animated: true)
            self.toolTip = nil
        }
    }
    
    func hidePopUpOnTap() {
        let hideTapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapToHidePopup(recognizer:)))
        
        hideTapGestureRecognizer.numberOfTapsRequired = 1
        hideTapGestureRecognizer.numberOfTouchesRequired = 1
        hideTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(hideTapGestureRecognizer)
        
    }
    
    // MARK: - Recupera los datos del único programa registrado (versión inicial)
    func getData() {
        self.programas = fetchData(entity: .programa, byIndex: 1)
        self.programa = self.programas.first as? Programa
        
        
    }

    // MARK: - Muestra los datos enviados desde la vista VCProgramas para edición
    func showData() {
        if self.programa != nil {
            self.tfPrograma.text = self.programa?.nombre
            //let institucion = self.programa?.institucion
        } else {
            self.getData()
            self.initTextFields(self.programa)
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            // para consultar el único programa esperado
            //self.getData()
            
            self.showData()
        NSLog("viewDidAppear executed...")
        
    }
        
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("viewWillDisappear executed")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Procedimiento de preparación y validación de datos ingresados para guardado
    func prepararDatos(isDataReady isComplete: inout Bool) {
        isComplete = true
        
        if !self.tfPrograma.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el programa", toFocus: self.tfPrograma)
        }
        
        if !self.tfPeriodo.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el periodo", toFocus: self.tfPeriodo)
        }
        
        if !self.tfAsignatura.hasText {
            isComplete = false
            showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre de la asignatura", toFocus: self.tfAsignatura)
            
        }
        
        if !self.tfCreditos.hasText {
            
        }
        
        if !self.tfProfesor.hasText {
            
        }
        
        if !self.tfEMailProfesor.hasText {
            
        }
        
        if !self.tfTelefonoProfesor.hasText {
            
        }

        /*
         
         if !self.tfDescripcion.hasText {
         isComplete = false
         showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la descripción de la compra", toFocus: self.tfDescripcion)
         }
         
         //self.tfBanco.text = ""
         if !self.tfComercio.hasText {
         isComplete = false
         showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre del establecimiento o negocio donde resalizó la compra.", toFocus: self.tfComercio)
         }
         
         //self.tfFranquicia.text = ""
         if !self.tfFecha.hasText {
         isComplete = false
         showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la fecha de compra.", toFocus: self.tfFecha)
         }
         
         //self.tfCupoAsignado.text = ""
         if !self.tfValor.hasText {
         isComplete = false
         showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el valor de la compra.", toFocus: self.tfValor)
         }
         
         //self.tfTEAVigente.text = ""
         if !self.tfPlazo.hasText {
         isComplete = false
         showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el plazo que seleccionó para el pago de la compra.", toFocus: self.tfPlazo)
         }
         
         if !self.tfTEA.hasText {
         isComplete = false
         showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la tasa que se aplicará para el cálculo de los intereses.", toFocus: self.tfPlazo)
         }
         
         if isComplete {
         if self.boolEsNuevo {
         
         let compra = NSEntityDescription.insertNewObject(forEntityName: "Compra", into: self.moc)
         
         let nuevoIndice: Double = (compra as! Compra).obtenerNuevoIndice()
         
         compra.setValue(nuevoIndice, forKey: "indice")
         
         compra.setValue(self.tfDescripcion.text, forKey: "descripcion")
         
         compra.setValue(self.tfComercio.text, forKey: "comercio")
         
         compra.setValue(fmtDate.date(from: (self.tfFecha.text)!), forKey: "fecha")
         
         compra.setValue(fmtMon.number(from: self.tfValor.text!)?.doubleValue, forKey: "valor")
         
         compra.setValue(fmtFloat.number(from:  self.tfPlazo.text!), forKey: "plazo")
         
         compra.setValue(fmtFloat.number(from:  self.tfTEA.text!), forKey: "tea")
         
         if self.nombreArchivoImagen != nil {
         compra.setValue(self.nombreArchivoImagen, forKey:"imagen")
         } else {
         compra.setValue("icono-bolsocompra.png", forKey: "imagen")
         }
         
         self.tarjeta?.addToCompras(compra: compra as! Compra)
         
         } else if self.boolEsModificacion {
         
         //self.compra.setValue(nuevoIndice, forKey: "indice")
         
         self.compra?.setValue(self.tfDescripcion.text, forKey: "descripcion")
         
         self.compra?.setValue(self.tfComercio.text, forKey: "comercio")
         
         self.compra?.setValue(fmtDate.date(from: (self.tfFecha.text)!), forKey: "fecha")
         
         //self.compra?.setValue(fmtFloat.number(from: self.tfValor.text!)?.doubleValue, forKey: "valor")
         
         let valorCompra: Double = (fmtMon.number(from: self.tfValor.text!)?.doubleValue)!
         //print("valor de la compra a modificar: \(valorCompra)")
         self.compra?.actualizar(valor: valorCompra)
         
         self.compra?.setValue(fmtFloat.number(from:  self.tfPlazo.text!), forKey: "plazo")
         
         self.compra?.setValue(fmtFloat.number(from:  self.tfTEA.text!), forKey: "tea")
         
         if self.nombreArchivoImagen != "icono-bolsocompra.png" {
         self.compra?.setValue(self.nombreArchivoImagen, forKey:"imagen")
         //} else {
         //    self.compra?.setValue("icono-bolsocompra.png", forKey: "imagen")
         }
         }
         }

         
         
         
         
         
        if self.programa == nil {
            // nombre del programa
            if !self.tfPrograma.hasText {
                //programa.setValue(self.tfPrograma.text, forKey: "nombre")
         
                //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre del programa o curso.", toFocus: self.tfPrograma)
                return
            }
            
            // país del programa
            if !(self.pckrPais.selectedRow(inComponent: 0) != -1) {
                //programa.setValue(self.pckrPais.selectedRow(inComponent: 0), forKey: "indicePais")
                //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar el país donde se realiza el programa.", toFocus: self.tfPais)
                return
            }
            
            // institucion
            if !(self.instituto != nil) {
                //programa.setValue(self.instituto, forKey: "institucion")
                //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar la institución donde se realiza el programa.", toFocus: self.tfInstitucion)
                return
            }
            
            // nivel academico
            if !(self.pckrNivelAcademico.selectedRow(inComponent: 0) != -1) {
                //programa.setValue(self.pckrNivelAcademico.selectedRow(inComponent: 0), forKey: "indiceNivelAcademico")
                //} else {
                //programa.setValue(0, forKey: "indiceNivelAcademico")
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar el nivel academico del programa o curso.", toFocus: self.tfNivelAcademico)
                return
            }
            
            // escala de calificacion
            if !(self.escalaMedicion != nil) {
                //programa.setValue(self.escalaMedicion, forKey: "escala")
                //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar la escala de calificación que se aplica para el cálculo de los promedios y llevar el registro de notas.", toFocus: self.tfEscala)
                return
            }
            
            let programa = NSEntityDescription.insertNewObject(forEntityName: "Asignatura", into: self.moc)
            
            let nuevoIndice: Double = (programa as! Programa).obtenerNuevoIndice()
            
            programa.setValue(nuevoIndice, forKey: "indice")
            
            programa.setValue(self.tfPrograma.text, forKey: "nombre")
            
            programa.setValue(self.pckrPais.selectedRow(inComponent: 0), forKey: "indicePais")
            
            programa.setValue(self.instituto, forKey: "institucion")
            
            programa.setValue(self.pckrNivelAcademico.selectedRow(inComponent: 0), forKey: "indiceNivelAcademico")
            
            programa.setValue(self.escalaMedicion, forKey: "escala")
            
            if self.tfEMail.hasText {
                programa.setValue(self.tfEMail.text, forKey: "email")
            }
            
            // promedio ponderado
            programa.setValue(self.swPonderado.isOn, forKey: "esPromedioPonderado")
            
            // setear como programa esquema - Es el programa que se empleará para desplegar toda la configuración y registros asociados al mismo.
            programa.setValue(false, forKey: "esEsquemaActual")
        } else {
            // nombre del programa
            if self.tfPrograma.hasText {
                self.programa!.setValue(self.tfPrograma.text, forKey: "nombre")
                
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre del programa o curso.", toFocus: self.tfPrograma)
                return
            }
            
            // país del programa
            if self.pckrPais.selectedRow(inComponent: 0) != -1 {
                self.programa!.setValue(self.pckrPais.selectedRow(inComponent: 0), forKey: "indicePais")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar el país donde se realiza el programa.", toFocus: self.tfPrograma)
                return
            }
            
            // institucion
            if self.instituto != nil {
                self.programa!.setValue(self.instituto!, forKey: "institucion")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar la institución donde se realiza el programa.", toFocus: self.tfInstitucion)
                return
            }
            
            // nivel academico
            if self.pckrNivelAcademico.selectedRow(inComponent: 0) != -1 {
                self.programa!.setValue(self.pckrNivelAcademico.selectedRow(inComponent: 0), forKey: "indiceNivelAcademico")
            } else {
                self.programa!.setValue(0, forKey: "indiceNivelAcademico")
            }
            
            // escala de calificacion
            if self.escalaMedicion != nil {
                //print("Escala: \(self.escalaMedicion!)")
                self.programa!.setValue(self.escalaMedicion!, forKey: "escala")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar la escala de calificación que se aplica para el cálculo de los promedios y llevar el registro de notas.", toFocus: self.tfEscala)
                return
            }
            
            if self.tfEMail.hasText {
                self.programa!.setValue(self.tfEMail.text, forKey: "email")
            }
            
            // promedio ponderado
            self.programa!.setValue(self.swPonderado.isOn, forKey: "esPromedioPonderado")
        }
 */
    }
        
    // MARK: - Precedimiento de guardado
    func guardar() -> Bool {
        var canISave: Bool = true
        do {
            prepararDatos(isDataReady: &canISave)
            
            if canISave {
                
                try self.moc.save()
                
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos del programa fueron grabados con éxito.", toFocus: nil)
            }
        } catch  {
            let err = error as NSError
            print("No se pudo guardar los datos del programa.  Error: \(err.localizedDescription)")
        }
        return canISave
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

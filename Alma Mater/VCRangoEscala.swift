//
//  VCRangoEscala.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 13/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCRangoEscala: UIViewController {

    @IBOutlet weak var tfPrograma: UITextField!
    
    @IBOutlet weak var tfEscala: UITextField!
    
    @IBOutlet weak var tfRango: UITextField!
    
    @IBOutlet weak var tfLimiteInferior: UITextField!
    
    @IBOutlet weak var tfLimiteSuperior: UITextField!

    @IBOutlet weak var tfValorUnico: UITextField!

    @IBOutlet weak var tfLetraRepresentativa: UITextField!    
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    var programa: Programa? = nil
    var escalaMedicion: Escala? = nil
    var rango: RangoEscala? = nil
    var escala: Global.CDEscala?

    var boolEsNuevo: Bool = false
    var boolEsModificacion: Bool = false
    var boolEsConsulta: Bool = false
    //var boolDataIsSaved: Bool = false
    
    var toolTip: CMPopTipView? = nil

    let fmtFloat : NumberFormatter = NumberFormatter()
    
    var indiceEscala: Double = 0

    func getData() {
        if self.rango == nil {
            
        }
    }
    
    func showData() {
        if self.rango == nil {
            self.tfPrograma.text = ""
            self.tfEscala.text = ""
            self.tfRango.text = ""
            self.tfLimiteInferior.text = ""
            self.tfLimiteSuperior.text = ""
            self.tfValorUnico.text = ""
            self.tfLetraRepresentativa.text = ""
        } else {
            if self.escalaMedicion == nil {
                self.escalaMedicion = self.rango?.escala
                //print("Escala del Rango: \((self.rango?.escala)!)")
                self.tfEscala.text = self.escalaMedicion?.descripcion?.capitalized
            } else {
                self.tfEscala.text = self.escalaMedicion?.descripcion?.capitalized
            }

            if self.programa == nil {
                self.tfPrograma.text = ""
            } else {
                self.tfPrograma.text = self.programa?.nombre?.capitalized
            }
            
            self.tfRango.text = self.rango?.descripcion?.capitalized
            
            self.tfLimiteInferior.text = fmtFloat.string(from: NSNumber.init(value: (self.rango?.limiteInferior)!))
            
            self.tfLimiteSuperior.text =  fmtFloat.string(from: NSNumber.init(value: (self.rango?.limiteSuperior)!))
            
            self.tfValorUnico.text =  fmtFloat.string(from: NSNumber.init(value: (self.rango?.valor)!))
            
            self.tfLetraRepresentativa.text = (self.rango?.valorAlfa)!
        }
    }
    
    // MARK: - Inicializa formateadores numéricos
    func initFormatters() {
        // Preparación del formateador de fecha
        //dtFormatter.dateFormat = "dd/MM/yyyy"
        
        // Preparación de los formateadores númericos
        fmtFloat.numberStyle = .none
        fmtFloat.maximumFractionDigits = 2
        
    }
    
    func initTextFields() {
        self.tfLimiteInferior.keyboardType = .decimalPad
        self.tfLimiteSuperior.keyboardType = .decimalPad
        self.tfValorUnico.keyboardType = .decimalPad
        
        if self.boolEsConsulta {
            self.tfPrograma.backgroundColor = UIColor.lightGray
            self.tfEscala.backgroundColor = UIColor.lightGray
            self.tfRango.backgroundColor = UIColor.lightGray
            self.tfLimiteInferior.backgroundColor = UIColor.lightGray
            self.tfLimiteSuperior.backgroundColor = UIColor.lightGray
            self.tfValorUnico.backgroundColor = UIColor.lightGray
            self.tfLetraRepresentativa.backgroundColor = UIColor.lightGray
            
            self.tfPrograma.isEnabled = false
            self.tfEscala.isEnabled = false
            self.tfRango.isEnabled = false
            self.tfLimiteInferior.isEnabled = false
            self.tfLimiteSuperior.isEnabled = false
            self.tfValorUnico.isEnabled = false
            self.tfLetraRepresentativa.isEnabled = false
        } else {
            self.tfPrograma.backgroundColor = UIColor.white
            self.tfEscala.backgroundColor = UIColor.white
            self.tfRango.backgroundColor = UIColor.white
            self.tfLimiteInferior.backgroundColor = UIColor.white
            self.tfLimiteSuperior.backgroundColor = UIColor.white
            self.tfValorUnico.backgroundColor = UIColor.white
            self.tfLetraRepresentativa.backgroundColor = UIColor.white

            self.tfPrograma.isEnabled = true
            self.tfEscala.isEnabled = true
            self.tfRango.isEnabled = true
            self.tfLimiteInferior.isEnabled = true
            self.tfLimiteSuperior.isEnabled = true
            self.tfValorUnico.isEnabled = true
            self.tfLetraRepresentativa.isEnabled = true
            
            self.tfPrograma.text = ""
            self.tfEscala.text = ""
            self.tfRango.text = ""
            self.tfLimiteInferior.text = ""
            self.tfLimiteSuperior.text = ""
            self.tfValorUnico.text = ""
            self.tfLetraRepresentativa.text = ""
            self.tfRango.becomeFirstResponder()
        }
    }
    
    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        //initToolBar(toolbarColor: UIColor.customOceanBlue())
        
        if self.boolEsNuevo {
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Nuevo Rango")
        } else if self.boolEsModificacion {
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Modificación de Rango")
        } else {
            initToolBar(toolbarDesign: .toLeftBackToRighStyle, actions: [nil], title: "Consulta de Rango")
        }
        
        //initSearchBar(tableView: tvEvaluaciones)
        
        self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        // inicializa formateadores
        initFormatters()
        
        // Inicializa los textfields y los pickerviews
        showData() //initTextFields()
        
        initTextFields()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadPreferences()
        hideKeyboardWhenTappedAround()
        hidePopUpOnTap()
        
        //self.boolDataIsSaved = false
    }
    
    func btnGuardarOnTouchUpInside(_ sender: AnyObject) {
        let button = sender as! UIBarButtonItem
        // code for saving here
        if Global().modoAsistido {
            if self.toolTip == nil {
                //self.toolTip = CMPopTipView(message: "Este es un demo de tooltip")
                self.toolTip = CMPopTipView(title: "Guardado de Datos", message: "Con esta opción podrá almacenar o actualizar los datos registrados para el programa en su dispositivo.  Toque aquí para guardar los datos.")
                //self.toolTip?.title = "Titulo del ToolTip"
                //self.toolTip?.titleFont =  UIFont(name: "Futura", size: 12)
                self.toolTip?.delegate = self
                self.toolTip?.textFont = UIFont(name: "Futura", size: 11)
                self.toolTip?.backgroundColor = UIColor.white
                
                self.toolTip?.textColor = UIColor.darkGray
                self.toolTip?.tag       = 1
                //print("tag<\(self.toolTip?.tag)!>")
                self.toolTip?.presentPointing(at: button, animated: true)
                //self.toolTip?.presentPointing(at: button, in: self.view, animated: true) // (at: sender, animated: true)
            }
        } else {
            //self.performSegue(withIdentifier: "segueAgregarPeriodo", sender: self)
            // Dismiss
            self.toolTip?.dismiss(animated: true)
            self.toolTip = nil
            let isSaved = self.guardar()
            if isSaved && self.boolEsNuevo {
                self.loadPreferences()
            }
        }
    }

    @IBAction func btnEscogerEscalaOnTouchUpInside(_ sender: UIButton) {
        if Global().modoAsistido {
            if self.toolTip == nil {
                //self.toolTip = CMPopTipView(message: "Este es un demo de tooltip")
                self.toolTip = CMPopTipView(title: "Selección de Escala", message: "Listará las escalas predifinidas en la app, ud. puede crear nuevas escalas.  Toque aquí para ir a la pantalla.")
                //self.toolTip?.title = "Titulo del ToolTip"
                //self.toolTip?.titleFont =  UIFont(name: "Futura", size: 12)
                self.toolTip?.delegate = self
                self.toolTip?.textFont = UIFont(name: "Futura", size: 11)
                self.toolTip?.backgroundColor = UIColor.white
                
                self.toolTip?.textColor = UIColor.darkGray
                self.toolTip?.tag       = 2
                //print("tag<\(self.toolTip?.tag)!>")
                self.toolTip?.presentPointing(at: sender, in: self.view, animated: true) // (at: sender, animated: true)
            }
        } else {
            // Dismiss
            self.toolTip?.dismiss(animated: true)
            self.toolTip = nil
            self.performSegue(withIdentifier: "segueEscogerEscala", sender: self)
        }
    }

    // MARK: - Procedimiento de preparación y validación de datos ingresados para guardado
    func prepararDatos(isDataReady isComplete: inout Bool) {
        isComplete = true
        
        if self.rango == nil {
            
            // nombre del programa
            //if self.tfPrograma.hasText {
            //    rango.setValue(self.tfPrograma.text, forKey: "nombre")
                
            //} else {
            //    isComplete = false
            //    showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre del programa o curso.", toFocus: self.tfPrograma)
            //}
            
            // escala de calificacion
            if !(self.escalaMedicion != nil) {
                //rango.setValue(self.escalaMedicion, forKey: "escala")
                //let indiceEscala = self.escalaMedicion?.indice
                //rango.setValue(indiceEscala, forKey: "indiceEscala")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar la escala de calificación que se aplica para el rango de calificaciones.", toFocus: self.tfEscala)
                return
            }

            if !self.tfRango.hasText {
                //rango.setValue(self.tfRango.text, forKey: "descripcion")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar una descripción para el rango de calificaciones.", toFocus: self.tfRango)
                return
            }
            
            if !self.tfLimiteInferior.hasText {
                //rango.setValue(fmtFloat.number(from: (self.tfLimiteInferior.text)!)?.doubleValue , forKey: "limiteInferior")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar el valor mínimo del rango de calificaciones.", toFocus: self.tfLimiteInferior)
                return
            }
            
            if !self.tfLimiteSuperior.hasText {
                //rango.setValue(fmtFloat.number(from: (self.tfLimiteSuperior.text)!)?.doubleValue , forKey: "limiteSuperior")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar el valor máximo del rango de calificaciones.", toFocus: self.tfLimiteSuperior)
                return
            }
            
            if !self.tfValorUnico.hasText {
                //rango.setValue(fmtFloat.number(from: (self.tfValorUnico.text)!)?.doubleValue , forKey: "valor")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar el mínimo valor único del rango de calificaciones.", toFocus: self.tfValorUnico)
                return
            }
            
            if !self.tfLetraRepresentativa.hasText {
                //rango.setValue(self.tfLetraRepresentativa.text, forKey: "valorAlfa")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar la letra que representa el rango de calificaciones.", toFocus: self.tfLetraRepresentativa)
                return
            }
            
            // Luego de validar los datos obligatorios se procede con el almacenamiento de los datos.
            let rango = NSEntityDescription.insertNewObject(forEntityName: "RangoEscala", into: self.moc)
            
            let nuevoIndice: Double = (rango as! RangoEscala).obtenerNuevoIndice()
            
            rango.setValue(nuevoIndice, forKey: "indice")
            
            rango.setValue(self.escalaMedicion, forKey: "escala")
            let indiceEscala = self.escalaMedicion?.indice
            rango.setValue(indiceEscala, forKey: "indiceEscala")

            rango.setValue(self.tfRango.text, forKey: "descripcion")

            rango.setValue(fmtFloat.number(from: (self.tfLimiteInferior.text)!)?.doubleValue , forKey: "limiteInferior")

            rango.setValue(fmtFloat.number(from: (self.tfLimiteSuperior.text)!)?.doubleValue , forKey: "limiteSuperior")

            rango.setValue(fmtFloat.number(from: (self.tfValorUnico.text)!)?.doubleValue , forKey: "valor")

            rango.setValue(self.tfLetraRepresentativa.text, forKey: "valorAlfa")
        } else {
            // nombre del programa
            //if self.tfPrograma.hasText {
            //    self.programa!.setValue(self.tfPrograma.text, forKey: "nombre")
            //} else {
            //    isComplete = false
            //    showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre del programa o curso.", toFocus: self.tfPrograma)
            //}
            
            // escala de calificacion
            if self.escalaMedicion != nil {
                //print("Escala: \(self.escalaMedicion!)")
                self.rango!.setValue(self.escalaMedicion!, forKey: "escala")
                self.rango?.setValue(self.escalaMedicion?.indice, forKey: "indiceEscala")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar la escala de calificación que se aplica para el cálculo de los promedios y llevar el registro de notas.", toFocus: self.tfEscala)
                return
            }
            
            if self.tfRango.hasText {
                self.rango!.setValue(self.tfRango.text, forKey: "descripcion")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar una descripción para el rango de calificaciones.", toFocus: self.tfRango)
                return
            }
            
            if self.tfLimiteInferior.hasText {
                self.rango!.setValue(fmtFloat.number(from: (self.tfLimiteInferior.text)!)?.doubleValue , forKey: "limiteInferior")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar el valor mínimo del rango de calificaciones.", toFocus: self.tfLimiteInferior)
                return
            }
            
            if self.tfLimiteSuperior.hasText {
                self.rango!.setValue(fmtFloat.number(from: (self.tfLimiteSuperior.text)!)?.doubleValue , forKey: "limiteSuperior")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar el valor máximo del rango de calificaciones.", toFocus: self.tfLimiteSuperior)
                return
            }
            
            if self.tfValorUnico.hasText {
                self.rango!.setValue(fmtFloat.number(from: (self.tfValorUnico.text)!)?.doubleValue , forKey: "valor")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar el mínimo valor único del rango de calificaciones.", toFocus: self.tfValorUnico)
                return
            }
            
            if self.tfLetraRepresentativa.hasText {
                self.rango!.setValue(self.tfLetraRepresentativa.text, forKey: "valorAlfa")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debes ingresar la letra que representa el rango de calificaciones.", toFocus: self.tfLetraRepresentativa)
                return
            }
        }
    }
    
    // MARK: - Precedimiento de guardado
    func guardar() -> Bool {
        var canISave: Bool = true
        do {
            prepararDatos(isDataReady: &canISave)
            
            if canISave {
                
                try self.moc.save()
                
                //self.boolDataIsSaved = true

                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos del rango de calificaciones fueron grabados con éxito.", toFocus: nil)
            }
        } catch let error as NSError {
            print("No se pudo guardar los datos del rango de calificaciones.  Error: \(error)")
        }
        return canISave
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueEscogerEscala" {
            let vcEscala = segue.destination as! VCEscalas
            vcEscala.delegate = self
            vcEscala.boolCalledFromRango = true
        }
    }
 

}

extension VCRangoEscala: CMPopTipViewDelegate {
    func popTipViewWasDismissed(byUser popTipView: CMPopTipView!) {
        let tag = self.toolTip?.tag
        
        self.toolTip = nil
        
        self.toolTip?.removeFromSuperview()
        
        self.toolTip?.dismiss(animated: true)
        
        if tag == 1 {
            let isSaved = self.guardar()
            if isSaved && self.boolEsNuevo {
                self.loadPreferences()
            }
            //if !self.boolDataIsSaved {
            //    _ = self.guardar()
            //}
        } else if tag == 2 {
            self.performSegue(withIdentifier: "segueEscogerEscala", sender: self)
        } else if tag == 3 {
        } else if tag == 4 {
        } else if tag == 5 {
        } else {
            // do nothing
        }
        
    }
}

extension VCRangoEscala: DataTransferDelegate {
    func send(data: Global.CDEscala) -> Bool {
        self.escala = data
        
        //tfEscala.text = self.escala?.descripcion.capitalized
        indiceEscala = (self.escala?.indice)!
        
        let escalas = fetchData(entity: .escala, byIndex: (self.indiceEscala))
        
        //print("\(escalas)")
        if escalas.count > 0 {
            self.escalaMedicion = (escalas.first! as! Escala)
            self.tfEscala.text = self.escalaMedicion?.descripcion?.capitalized
            if self.rango != nil {
                self.rango!.setValue(self.escalaMedicion, forKey: "escala")
                self.rango?.setValue(self.escalaMedicion?.indice, forKey: "indiceEscala")
            }
        }
        
        return true
    }
    
}


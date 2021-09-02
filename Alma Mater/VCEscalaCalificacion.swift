//
//  VCEscalaCalificacion.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 10/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCEscalaCalificacion: UIViewController {

    @IBOutlet weak var tfPrograma: UITextField!
    
    @IBOutlet weak var tfEscalaNombre: UITextField!
    
    @IBOutlet weak var tfValorMinimoParaAprobacion: UITextField!
    
    @IBOutlet weak var tfValorMaximo: UITextField!
    
    @IBOutlet weak var tfValorMinimo: UITextField!
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    var escala: Escala? = nil
    var programa: Programa? = nil
    //var programas = [AnyObject]()
    
    var toolTip: CMPopTipView? = nil

    var boolEsNuevo: Bool = false
    var boolEsModificacion: Bool = false
 
    let fmtFloat : NumberFormatter = NumberFormatter()

    // MARK: - Inicializa formateadores numéricos
    func initFormatters() {
        // Preparación del formateador de fecha
        //dtFormatter.dateFormat = "dd/MM/yyyy"
        
        // Preparación de los formateadores númericos
        fmtFloat.numberStyle = .none
        fmtFloat.maximumFractionDigits = 2
        
    }
    
    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        //initToolBar(toolbarColor: UIColor.customOceanBlue())
        
        if self.boolEsNuevo {
            self.escala = nil
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Nueva Escala")
        } else if self.boolEsModificacion {
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Modificación de Escala")
        } else {
            initToolBar(toolbarDesign: .toLeftBackToRighStyle, actions: [nil], title: "Consulta de Escala")
        }
        
        //initSearchBar(tableView: tvEvaluaciones)
        
        self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        // inicializa formateadores
        initFormatters()
        
        // Inicializa los textfields y los pickerviews
        initTextFields()
        
    }
    
    func initTextFields(_ programa: Programa? = nil) {
        //if programa == nil {
            
            self.tfPrograma.text = ""
            self.tfEscalaNombre.text = ""
            self.tfValorMinimoParaAprobacion.text = ""
            self.tfValorMinimo.text = ""
            self.tfValorMaximo.text = ""
            self.tfEscalaNombre.becomeFirstResponder()
        //} else {
            // se cargan los datos si la vista es para consultar un programa
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadPreferences()
        hideKeyboardWhenTappedAround()
        hidePopUpOnTap()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getData()
        self.showData()
        
        //print("viewWillAppear exec...")
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
        
        //self.programas = fetchData(entity: .programa, byIndex: 1)
        //self.programa = self.programas.first as? Programa

        //if !self.boolEsNuevo {
        //    if self.escala == nil {
        //        self.escala = self.programa?.escala
        //    }
        //}
    }
    
    // MARK: - Muestra los datos enviados desde la vista VCProgramas para edición
    func showData() {
        
        if self.boolEsNuevo {
            self.tfPrograma.text = ""
            self.tfEscalaNombre.text = ""
            self.tfValorMinimoParaAprobacion.text = ""
            self.tfValorMinimo.text = ""
            self.tfValorMaximo.text = ""
        } else {
            //if self.programa != nil {
            if self.escala != nil {
                
                
                //self.tfPrograma.text = self.programa?.nombre
                
                self.tfEscalaNombre.text = self.escala?.descripcion
                
                self.tfValorMinimoParaAprobacion.text = fmtFloat.string(from: NSNumber.init(value: (self.escala?.valorMinParaAprobacion)!))!
                
                self.tfValorMinimo.text =  fmtFloat.string(from: NSNumber.init(value: (self.escala?.valorMinimo)!))!
                
                self.tfValorMaximo.text =  fmtFloat.string(from: NSNumber.init(value: (self.escala?.valorMaximo)!))!
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // para consultar el único programa esperado
        self.getData()
        
        self.showData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func btnGuardarOnTouchUpInside(_ sender: AnyObject) {
        // code for saving here
        let button = sender as! UIBarButtonItem
        // code for saving here
        if Global().modoAsistido {
            if self.toolTip == nil {
                //self.toolTip = CMPopTipView(message: "Este es un demo de tooltip")
                self.toolTip = CMPopTipView(title: "Guardado de Datos", message: "Con esta opción podrá almacenar o actualizar los datos registrados para la escala de calificaciones en su dispositivo.  Toque aquí para guardar los datos.")
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

    @IBAction func btnListarRangosEscalaOnTouchUpInside(_ sender: UIButton) {
    
        //self.performSegue(withIdentifier: "segueListarRangosEscala", sender: self)
    }
    
    
    // MARK: - Procedimiento de preparación y validación de datos ingresados para guardado
    func prepararDatos(isDataReady isComplete: inout Bool) {
        isComplete = true
        
        if self.escala == nil {
            // nombre del programa
            if !self.tfEscalaNombre.hasText {
                //escala.setValue(self.tfEscalaNombre.text, forKey: "descripcion")
                
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre de la escala de calificaciones.", toFocus: self.tfEscalaNombre)
                return
            }

            if !self.tfValorMinimoParaAprobacion.hasText {
                //escala.setValue(fmtFloat.number(from: self.tfValorMinimoParaAprobacion.text!)?.doubleValue, forKey: "valorMinParaAprobacion")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el valor mínimo para aprobación.", toFocus: self.tfValorMinimoParaAprobacion)
                return
            }

            if !self.tfValorMinimo.hasText {
                //escala.setValue(fmtFloat.number(from: self.tfValorMinimo.text!)?.doubleValue, forKey: "valorMinimo")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el valor mínimo de la escala.", toFocus: self.tfValorMinimo)
                return
            }

            if !self.tfValorMaximo.hasText {
                //escala.setValue(fmtFloat.number(from: self.tfValorMaximo.text!)?.doubleValue, forKey: "valorMaximo")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el valor máximo de la escala.", toFocus: self.tfValorMaximo)
                return
            }
            
            // Luego de validar los datos obligatorios se crea la instancia de la escala para su almacenamiento

            let escala = NSEntityDescription.insertNewObject(forEntityName: "Escala", into: self.moc)
            
            let nuevoIndice: Double = (escala as! Escala).obtenerNuevoIndice()
            
            escala.setValue(nuevoIndice, forKey: "indice")
            

            escala.setValue(self.tfEscalaNombre.text, forKey: "descripcion")

            escala.setValue(fmtFloat.number(from: self.tfValorMinimoParaAprobacion.text!)?.doubleValue, forKey: "valorMinParaAprobacion")

            escala.setValue(fmtFloat.number(from: self.tfValorMinimo.text!)?.doubleValue, forKey: "valorMinimo")

            escala.setValue(fmtFloat.number(from: self.tfValorMaximo.text!)?.doubleValue, forKey: "valorMaximo")

        } else {
            // nombre del programa
            if self.tfEscalaNombre.hasText {
                self.escala?.setValue(self.tfEscalaNombre.text, forKey: "descripcion")
                
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre de la escala de calificaciones.", toFocus: self.tfEscalaNombre)
                return
            }
            
            if self.tfValorMinimoParaAprobacion.hasText {
                self.escala?.setValue(fmtFloat.number(from: self.tfValorMinimoParaAprobacion.text!)?.doubleValue, forKey: "valorMinParaAprobacion")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el valor mínimo para aprobación.", toFocus: self.tfValorMinimoParaAprobacion)
                return
            }

            if self.tfValorMinimo.hasText {
                self.escala?.setValue(fmtFloat.number(from: self.tfValorMinimo.text!)?.doubleValue, forKey: "valorMinimo")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el valor mínimo de la escala.", toFocus: self.tfValorMinimo)
                return
            }
            
            if self.tfValorMaximo.hasText {
                self.escala?.setValue(fmtFloat.number(from: self.tfValorMaximo.text!)?.doubleValue, forKey: "valorMaximo")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el valor máximo de la escala.", toFocus: self.tfValorMaximo)
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
                
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos de la escala de calificaciones fueron grabados con éxito.", toFocus: nil)
            }
        } catch let error as NSError {
            print("No se pudo guardar los datos de la escala.  Error: \(error)")
        }
        return canISave
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension VCEscalaCalificacion: CMPopTipViewDelegate {
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
        //    self.performSegue(withIdentifier: "segueAgregarPeriodo", sender: self)
        //} else if tag == 2 {
        //    swPonderado.setOn(!swPonderado.isOn, animated: true)
        //} else if tag == 3 {
        //    self.performSegue(withIdentifier: "segueEscogerEscala", sender: self)
        //} else if tag == 4 {
        //    self.performSegue(withIdentifier: "segueEscogerInstitucion", sender: self)
        //} else if tag == 5 {
        //    _ = self.guardar()
        } else {
            // do nothing
        }
        
    }
}


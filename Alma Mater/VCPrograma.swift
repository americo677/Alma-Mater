//
//  VCPrograma.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 10/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCPrograma: UIViewController {
    
    @IBOutlet weak var tfPrograma: UITextField!
    @IBOutlet weak var tfPais: UITextField!
    @IBOutlet weak var tfInstitucion: UITextField!
    @IBOutlet weak var tfNivelAcademico: UITextField!
    @IBOutlet weak var tfEscala: UITextField!
    @IBOutlet weak var tfEMail: UITextField!
    @IBOutlet weak var swPonderado: UISwitch!
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    var institucion: Global.CDInstitucion? = nil
    var instituto: Institucion? = nil
    var escala: Global.CDEscala?
    var escalaMedicion: Escala? = nil
    
    var programas = [AnyObject]()
    var programa: Programa? = nil
    
    var pckrPais = UIPickerView()
    var pckrNivelAcademico = UIPickerView()
    
    var activeTextField = UITextField()
    
    var toolTip: CMPopTipView? = nil
    
    var periodos = [AnyObject]()
    
    var indicePrograma: Double = 0
    var indicePais: Double = 0
    var indiceInstitucion: Double = 0
    var indiceNivelAcademico: Double = 0
    var indiceEscala: Double = 0

    // MARK: - Rutinas para selección y cancelación del pickerview
    func donePicker(for sender: UIBarButtonItem) {
        self.activeTextField.resignFirstResponder()
        self.view.endEditing(true)
    }

    // MARK: - Rutinas para selección y cancelación del pickerview
    func cancelPicker(for sender: UIBarButtonItem) {
        self.activeTextField.resignFirstResponder()
        self.view.endEditing(true)
    }

    // MARK: - Carga inicial del pickerView país
    /*
    func loadPickerView(_ pickerView: inout UIPickerView, indiceSeleccionado: Int, indicePorDefecto: Int = 0, tag: Int, textField tf: UITextField, opciones: Array<String>) {
        // Preparación del Picker de ipo de RegistroT
        pickerView     = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 250))
        pickerView.backgroundColor = .gray
        pickerView.tag = tag
        
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let tb         = UIToolbar()
        tb.barStyle    = UIBarStyle.default
        tb.isTranslucent = true
        
        //toolBar.tintColor = UIColor.whiteColor()
        //UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        tb.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker(for:)))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let btnCancel = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelPicker(for:)))
        
        tb.setItems([btnCancel, btnSpace, btnDone], animated: false)
        tb.isUserInteractionEnabled = true
        
        tf.inputView = pickerView
        tf.inputAccessoryView = tb
        
        // colocar el valor por default en el picker de un solo componente
        //numberOfRows = self.pckrRelacion.numberOfRows(inComponent: 0)
        if pickerView.selectedRow(inComponent: 0) == -1 {
            if pickerView.numberOfRows(inComponent: 0) > 0 {
                pickerView.selectRow(indicePorDefecto, inComponent: 0, animated: true)
                tf.text = opciones[pickerView.selectedRow(inComponent: 0)]
            }
        } else {
            tf.text = opciones[pickerView.selectedRow(inComponent: 0)]
        }
    }
    */
    
    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        //initToolBar(toolbarColor: UIColor.customOceanBlue())
        
        initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Nuevo Programa")
        
        //initSearchBar(tableView: tvEvaluaciones)
        
        self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        // Inicializa los textfields y los pickerviews
        self.initTextFields()
        
        //hidePopUpOnTap()
        
    }
    
    func initTextFields(_ programa: Programa? = nil) {
        if programa == nil {
            
            self.tfPais.delegate = self
            self.tfNivelAcademico.delegate = self
            
            
            self.tfPrograma.text = ""
            self.tfPais.text = ""
            self.tfInstitucion.text = ""
            self.tfNivelAcademico.text = ""
            self.tfEscala.text = ""
            self.tfEMail.text = ""
            self.swPonderado.isOn = true
            
            self.loadPickerView(&self.pckrPais, indiceSeleccionado:  Global.defaultIndex.pais, indicePorDefecto: Global.defaultIndex.pais, tag: 1, textField: self.tfPais, opciones: Global.arreglo.pais, accionDone: #selector(donePicker(for:)), accionCancel: #selector(cancelPicker(for:)))
            
            self.loadPickerView(&self.pckrNivelAcademico, indiceSeleccionado:  Global.defaultIndex.nivelAcademico, indicePorDefecto: Global.defaultIndex.nivelAcademico, tag: 2, textField: self.tfNivelAcademico, opciones: Global.arreglo.nivelAcademico, accionDone: #selector(donePicker(for:)), accionCancel: #selector( cancelPicker(for:)))
            
        } else {
            // se cargan los datos si la vista es para consultar un programa
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadPreferences()
        hideKeyboardWhenTappedAround()
        hidePopUpOnTap()
        
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
            
            self.indicePais = (self.programa?.indicePais)!
            self.tfPais.text = Global.arreglo.pais[Int(self.indicePais)]
            
            if self.institucion != nil {
                self.indiceInstitucion = (institucion?.indice)!
                if self.indiceInstitucion != 0 {
                    self.tfInstitucion.text = (institucion?.descripcion.capitalized)
                } else {
                    self.tfInstitucion.text = self.instituto?.descripcion?.capitalized
                }
            } else {
                self.instituto = self.programa?.institucion
                self.tfInstitucion.text = self.instituto?.descripcion?.capitalized
            }
            
            self.indiceNivelAcademico = (self.programa?.indiceNivelAcademico)!
            self.tfNivelAcademico.text = Global.arreglo.nivelAcademico[Int(self.indiceNivelAcademico)]
            
            if self.escala != nil {
                self.indiceEscala = (escala?.indice)!
                if self.indiceEscala != 0 {
                    self.tfEscala.text = (escala?.descripcion.capitalized)
                    
                } else {
                    self.tfEscala.text = self.escalaMedicion?.descripcion?.capitalized
                }
            } else {
                self.escalaMedicion = self.programa?.escala
                self.tfEscala.text = self.escalaMedicion?.descripcion?.capitalized
            }
            
            self.tfEMail.text = self.programa?.email
            
            let esPonderado: Bool = (self.programa?.esPromedioPonderado)!
            self.swPonderado.setOn(esPonderado, animated: true)
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
    
    // MARK: - Funciones de los UIPickerViews
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return Global.arreglo.pais.count
        } else {
            return Global.arreglo.nivelAcademico.count
        }
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return Global.arreglo.pais[row]
        } else {
            return Global.arreglo.nivelAcademico[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.tfPais.text = Global.arreglo.pais[row]
        } else {
            self.tfNivelAcademico.text = Global.arreglo.nivelAcademico[row]
            self.indiceNivelAcademico = (row as NSNumber).doubleValue
            self.programa?.setValue(self.indiceNivelAcademico, forKey: "indiceNivelAcademico")
        }
    }
    
    
    // MARK: - Acciones de botones
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
                self.toolTip?.tag       = 5
                //print("tag<\(self.toolTip?.tag)!>")
                self.toolTip?.presentPointing(at: button, animated: true)
                //self.toolTip?.presentPointing(at: button, in: self.view, animated: true) // (at: sender, animated: true)
            }
        } else {
            //self.performSegue(withIdentifier: "segueAgregarPeriodo", sender: self)
            // Dismiss
            self.toolTip?.dismiss(animated: true)
            self.toolTip = nil
            _ = self.guardar()
        }
    }
    
    @IBAction func btnEscogerInstitucionOnTouchUpInside(_ sender: UIButton) {
        if Global().modoAsistido {
            if self.toolTip == nil {
                //self.toolTip = CMPopTipView(message: "Este es un demo de tooltip")
                self.toolTip = CMPopTipView(title: "Selección de Institución", message: "Listará las instituciones universitarias predifinidas en la app, ud. puede crear nuevas instituciones.  Toque aquí para ir a la pantalla.")
                //self.toolTip?.title = "Titulo del ToolTip"
                //self.toolTip?.titleFont =  UIFont(name: "Futura", size: 12)
                self.toolTip?.delegate = self
                
                self.toolTip?.dismissTapAnywhere = false
                
                self.toolTip?.textFont = UIFont(name: "Futura", size: 11)
                self.toolTip?.backgroundColor = UIColor.white
                
                self.toolTip?.textColor = UIColor.darkGray
                self.toolTip?.tag       = 4
                //print("tag<\(self.toolTip?.tag)!>")
                self.toolTip?.presentPointing(at: sender, in: self.view, animated: true) // (at: sender, animated: true)
            }
        } else {
            // Dismiss
            self.toolTip?.dismiss(animated: true)
            self.toolTip = nil
            self.performSegue(withIdentifier: "segueEscogerInstitucion", sender: self)
        }
    }

    
    @IBAction func btnCrearPeriodosOnTouchUpInside(_ sender: UIButton) {
        
        if Global().modoAsistido {
            if self.toolTip == nil {
                //self.toolTip = CMPopTipView(message: "Este es un demo de tooltip")
                self.toolTip = CMPopTipView(title: "Creación de Periodos", message: "Esta opción le permitirá crear uno o varios periodos de evaluación, de esta forma podrá crear el periodo actualmente vigente para llevar el registro de sus calificaciones.  Toque aquí para ir a la pantalla.")
                //self.toolTip?.title = "Titulo del ToolTip"
                //self.toolTip?.titleFont =  UIFont(name: "Futura", size: 12)
                self.toolTip?.delegate = self
                self.toolTip?.textFont = UIFont(name: "Futura", size: 11)
                self.toolTip?.backgroundColor = UIColor.white
                
                self.toolTip?.textColor = UIColor.darkGray
                self.toolTip?.tag       = 1
                //print("tag<\(self.toolTip?.tag)!>")
                self.toolTip?.presentPointing(at: sender, in: self.view, animated: true) // (at: sender, animated: true)
            }
        } else {
            // Dismiss
            self.toolTip?.dismiss(animated: true)
            self.toolTip = nil
            self.performSegue(withIdentifier: "segueAgregarPeriodo", sender: self)
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
                self.toolTip?.tag       = 3
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
    
    @IBAction func btnCalcularPonderadoOnTouchUpInside(_ sender: UIButton) {
        if Global().modoAsistido {
            if self.toolTip == nil {
                //self.toolTip = CMPopTipView(message: "Este es un demo de tooltip")
                self.toolTip = CMPopTipView(title: "Promedio Ponderado", message: "Activando este cálculo los promedios se calcularán utilizando los valores de los créditos otorgados a las asignaturas o materias.  Toca aquí para activarlo o desactivarlo.")
                //self.toolTip?.title = "Titulo del ToolTip"
                //self.toolTip?.titleFont =  UIFont(name: "Futura", size: 12)
                self.toolTip?.delegate = self
                self.toolTip?.textFont = UIFont(name: "Futura", size: 11)
                self.toolTip?.backgroundColor = UIColor.white
                
                self.toolTip?.textColor = UIColor.darkGray
                self.toolTip?.tag       = 2
                
                self.toolTip?.presentPointing(at: sender, in: self.view, animated: true) // (at: sender, animated: true)
            }
        } else {
            //self.performSegue(withIdentifier: "segueAgregarPeriodo", sender: self)
            // Dismiss
            self.toolTip?.dismiss(animated: true)
            self.toolTip = nil
            swPonderado.setOn(!swPonderado.isOn, animated: true)
        }
        
    }
    
    // MARK: - Procedimiento de preparación y validación de datos ingresados para guardado
    func prepararDatos(isDataReady isComplete: inout Bool) {
        isComplete = true
        
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
            
            let programa = NSEntityDescription.insertNewObject(forEntityName: "Programa", into: self.moc)
            
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
        } catch let error as NSError {
            print("No se pudo guardar los datos del programa.  Error: \(error)")
        }
        return canISave
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueEscogerInstitucion" {
            let vcInst = segue.destination as! VCInstituciones
            
            vcInst.delegate = self
            
        } else if segue.identifier == "segueEscogerEscala" {
            let vcEscala = segue.destination as! VCEscalas
            
            vcEscala.delegate = self
            vcEscala.boolCalledFromPrograma = true
            
        } else if segue.identifier == "segueAgregarPeriodo" {
            let vcPer = segue.destination as! VCPeriodo
            
            vcPer.programa = self.programa
            
        }
    }

}

extension VCPrograma: DataTransferDelegate {
    func send(data: Global.CDInstitucion) -> Bool {
        self.institucion = data
        
        //self.tfInstitucion.text = self.institucion?.descripcion.capitalized
        self.indiceInstitucion = (self.institucion?.indice)!

        //print("Indice de institucion: \(self.indiceInstitucion)")
        
        let instituciones = fetchData(entity: .institucion, byIndex: (self.indiceInstitucion))
        
        if instituciones.count > 0 {
            self.instituto = (instituciones.first! as! Institucion)
            self.tfInstitucion.text = self.instituto?.descripcion?.capitalized
            if self.programa != nil {
                self.programa!.setValue(self.instituto, forKey: "institucion")
            }
        } else {
            self.instituto = nil
        }

        return true
    }
    
    func send(data: Global.CDEscala) -> Bool {
        self.escala = data
        
        //tfEscala.text = self.escala?.descripcion.capitalized
        indiceEscala = (self.escala?.indice)!
  
        let escalas = fetchData(entity: .escala, byIndex: (self.indiceEscala))
        //print("\(escalas)")
        if escalas.count > 0 {
            self.escalaMedicion = (escalas.first! as! Escala)
            self.tfEscala.text = self.escalaMedicion?.descripcion?.capitalized
            if self.programa != nil {
                self.programa!.setValue(self.escalaMedicion, forKey: "escala")
            }
        }
        
        return true
    }

}

extension VCPrograma: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        //print("on trigger: \(activeTextField.text!)")
    }
    
}

extension VCPrograma: CMPopTipViewDelegate {
    func popTipViewWasDismissed(byUser popTipView: CMPopTipView!) {
        let tag = self.toolTip?.tag

        self.toolTip = nil
        
        self.toolTip?.removeFromSuperview()
        
        self.toolTip?.dismiss(animated: true)

        if tag == 1 {
            self.performSegue(withIdentifier: "segueAgregarPeriodo", sender: self)
        } else if tag == 2 {
            swPonderado.setOn(!swPonderado.isOn, animated: true)
        } else if tag == 3 {
            self.performSegue(withIdentifier: "segueEscogerEscala", sender: self)
        } else if tag == 4 {
            self.performSegue(withIdentifier: "segueEscogerInstitucion", sender: self)
        } else if tag == 5 {
            _ = self.guardar()
        } else {
            // do nothing
        }

    }
}

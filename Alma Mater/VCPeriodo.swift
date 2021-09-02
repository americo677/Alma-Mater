//
//  VCPeriodo.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 10/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCPeriodo: UIViewController {
    
    @IBOutlet weak var tfPrograma: UITextField!
    
    @IBOutlet weak var tfPeriodo: UITextField!
    
    @IBOutlet weak var tfFechaIni: UITextField!
    
    @IBOutlet weak var tfFechaFin: UITextField!
    
    @IBOutlet weak var tfDuracionPeriodo: UITextField!
    
    var programas = [AnyObject]()
    var programa: Programa? = nil
    
    var periodo: Periodo? = nil
    
    var periodos = [AnyObject]()
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    
    let datePickerIni: UIDatePicker = UIDatePicker()
    let datePickerFin: UIDatePicker = UIDatePicker()
    
    let dtFormatter: DateFormatter = DateFormatter()
    
    var activeTextField = UITextField()
    
    var pckrDuracionPeriodo = UIPickerView()
    
    var pckrPrograma = UIPickerView()

    var toolTip: CMPopTipView? = nil

    var boolEsNuevo: Bool = false
    var boolEsModificacion: Bool = false
    var boolEsConsulta: Bool = false
    
    var vPicker: UIView! = nil
    
    var douIndiceProgramaSeleccionado: Double = 0

    // MARK: - Inicializa formateadores numéricos
    func initFormatters() {
        // Preparación del formateador de fecha
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        // Preparación de los formateadores númericos
        //fmtFloat.numberStyle = .none
        //fmtFloat.maximumFractionDigits = 2
        
    }

    func initTextFields(_ programa: Programa? = nil) {
        if programa == nil {
            
            self.tfPrograma.text = ""
            self.tfPeriodo.text = ""
            self.tfFechaIni.text = ""
            self.tfFechaFin.text = ""
            
            self.loadPickerView(&self.pckrDuracionPeriodo, indiceSeleccionado:  Global.defaultIndex.duracionPeriodo, indicePorDefecto: Global.defaultIndex.duracionPeriodo, tag: 1, textField: self.tfDuracionPeriodo, opciones: Global.arreglo.nombreDuracion, accionDone: #selector(donePicker(for:)), accionCancel: #selector(cancelPicker(for:)))
            
        } else {
            // se cargan los datos si la vista es para consultar un programa
        }
    }

    
    // MARK: - Carga de la vista para el despliegue y selección del programa o curso.
    /*
    func initViewForPicker() {
        
        let rectForView = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 250)
        
        self.vPicker = UIView(frame: rectForView)
        
        self.view.addSubview(self.vPicker)
        
        self.programas = fetchData(entity: .programa, byIndex: nil)
        
        var arrProgramas = [String]()
        var arrIndiceProgramas = [Double]()
        
        for programa in self.programas {
            arrProgramas.append((programa as! Programa).nombre!)
            arrIndiceProgramas.append((programa as! Programa).indice)
        }
        
        self.douIndiceProgramaSeleccionado = 0
        
        self.loadPickerView(&self.pckrPrograma, indiceSeleccionado:  0, indicePorDefecto:0, tag: 2, textField: self.tfDuracionPeriodo, opciones: arrProgramas, accionDone: #selector(donePicker(for:)), accionCancel: #selector(cancelPicker(for:)))
    }
    */
    
    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        //initToolBar(toolbarColor: UIColor.customOceanBlue())
        
        if self.boolEsNuevo {
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Nuevo Periodo")
        } else if self.boolEsModificacion {
            initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Modificación de Periodo")
        } else {
            initToolBar(toolbarDesign: .toLeftBackToRighStyle, actions: [nil], title: "Consulta de Periodo")
        }

        self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        initFormatters()
        
        initDatePickers()
        
        // Inicializa los textfields y los pickerviews
        initTextFields()
        
        // initViewForPicker()
    }
    
    // MARK: - Inicializador de los UIDatePickers
    func initDatePickers() {
        datePickerIni.date = Date()
        datePickerIni.datePickerMode = UIDatePickerMode.date
        //datePickerIni.addTarget(self, action: #selector(TVCPresupuesto.handleDatePickerIni(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tfFechaIni.inputView = datePickerIni
        
        let tbFechaIni         = UIToolbar()
        tbFechaIni.barStyle    = UIBarStyle.default
        tbFechaIni.isTranslucent = true
        
        //toolBar.tintColor = UIColor.whiteColor()
        tbFechaIni.sizeToFit()
        
        let btnDoneFI = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.handleDatePickerIni(_:)))
        let btnSpaceFI = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let btnCancelFI = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.handleDatePickerIni(_:)))
        
        tbFechaIni.setItems([btnCancelFI, btnSpaceFI, btnDoneFI], animated: false)
        tbFechaIni.isUserInteractionEnabled = true
        
        self.tfFechaIni.inputAccessoryView = tbFechaIni
        
        
        datePickerFin.date = Date()
        datePickerFin.datePickerMode = UIDatePickerMode.date
        //datePickerFin.addTarget(self, action: #selector(TVCPresupuesto.handleDatePickerFin(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tfFechaFin.inputView = datePickerFin
        
        let tbFechaFin         = UIToolbar()
        tbFechaFin.barStyle    = UIBarStyle.default
        tbFechaFin.isTranslucent = true
        
        //toolBar.tintColor = UIColor.whiteColor()
        //UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        tbFechaFin.sizeToFit()
        
        let btnDoneFF = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.handleDatePickerFin(_:)))
        let btnSpaceFF = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let btnCancelFF = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.handleDatePickerFin(_:)))
        
        tbFechaFin.setItems([btnCancelFF, btnSpaceFF, btnDoneFF], animated: false)
        tbFechaFin.isUserInteractionEnabled = true
        
        self.tfFechaFin.inputAccessoryView = tbFechaFin
    }

    // MARK: - Manipulación de DatePickers
    func handleDatePickerIni(_ sender: UITextField) {
        let picker: UIDatePicker = tfFechaIni.inputView as! UIDatePicker
        
        tfFechaIni.text = dtFormatter.string(from: picker.date)
        
        periodo?.setValue(picker.date, forKey: "fechaInicial")
        
        tfFechaIni.resignFirstResponder()
    }
    
    func handleDatePickerFin(_ sender: UITextField) {
        let picker: UIDatePicker = tfFechaFin.inputView as! UIDatePicker
        tfFechaFin.text = dtFormatter.string(from: picker.date)
        
        periodo?.setValue(picker.date, forKey: "fechaFinal")
        
        tfFechaFin.resignFirstResponder()
    }
    
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
    func loadPickerView(_ pickerView: inout UIPickerView, indiceSeleccionado: Int, indicePorDefecto: Int = 0, tag: Int, textField tf: UITextField, opciones: Array<String>) {
        // Preparación del Picker de ipo de RegistroT
        pickerView     = UIPickerView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 250))
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
        
        self.vPicker.addSubview(pickerView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadPreferences()
        hideKeyboardWhenTappedAround()
        hidePopUpOnTap()
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
        //    if self.periodo == nil {
        //        self.periodo = self.programa?.periodoVigente()
        //    }
        //}
    }
    
    // MARK: - Muestra los datos enviados desde la vista VCProgramas para edición
    func showData() {
        
        if self.boolEsNuevo {
            if self.programa != nil {
                self.tfPrograma.text = self.programa?.nombre
            } else {
                self.tfPrograma.text = ""
            }
            self.tfPeriodo.text = ""
            self.tfFechaIni.text = ""
            self.tfFechaFin.text = ""
            self.pckrDuracionPeriodo.selectRow(Global.defaultIndex.duracionPeriodo, inComponent: 0, animated: true)
            self.tfPrograma.backgroundColor = UIColor.white
            self.tfPeriodo.backgroundColor = UIColor.white
            self.tfFechaIni.backgroundColor = UIColor.white
            self.tfFechaFin.backgroundColor = UIColor.white
            self.tfDuracionPeriodo.backgroundColor = UIColor.white
        } else {
            if self.programa != nil {
                
                if self.boolEsConsulta {
                    self.tfPrograma.backgroundColor = UIColor.lightGray
                    self.tfPeriodo.backgroundColor = UIColor.lightGray
                    self.tfFechaIni.backgroundColor = UIColor.lightGray
                    self.tfFechaFin.backgroundColor = UIColor.lightGray
                    self.tfDuracionPeriodo.backgroundColor = UIColor.lightGray
                } else {
                    self.tfPrograma.backgroundColor = UIColor.white
                    self.tfPeriodo.backgroundColor = UIColor.white
                    self.tfFechaIni.backgroundColor = UIColor.white
                    self.tfFechaFin.backgroundColor = UIColor.white
                    self.tfDuracionPeriodo.backgroundColor = UIColor.white
                }
                
                self.tfPrograma.text = self.programa?.nombre
                
                //self.periodo = self.programa?.periodoVigente()

                if self.periodo != nil {
                    self.tfPeriodo.text = self.periodo?.nombre
                    
                    self.tfFechaIni.text = dtFormatter.string(from: (self.periodo?.fechaInicial)! as Date)
                    self.tfFechaFin.text = dtFormatter.string(from: (self.periodo?.fechaFinal)! as Date)
                    
                    if self.periodo?.indiceDuracion != nil {
                        
                        let nsIndice = NSNumber.init(value: (self.periodo?.indiceDuracion)!)
                        
                        let indice: Int = nsIndice.intValue
                        
                        self.tfDuracionPeriodo.text = Global.arreglo.nombreDuracion[indice]
                    }
                }
            }
        }
    }

    // MARK: - Funciones de los UIPickerViews
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return Global.arreglo.nombreDuracion.count
        }
        return 0
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return Global.arreglo.nombreDuracion[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.tfDuracionPeriodo.text = Global.arreglo.nombreDuracion[row]
            //pickerView.isHidden = true
        }
    }
    
    // MARK: - Procedimiento de preparación y validación de datos ingresados para guardado
    func prepararDatos(isDataReady isComplete: inout Bool) {
        isComplete = true
        
        var fechi = Date()
        var fechf = Date()
        
        if self.boolEsNuevo {
            
            
            // nombre del programa
            if !self.tfPrograma.hasText {
            //    periodo.setValue(self.programa, forKey: "programa")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe seleccionar el programa o curso.", toFocus: self.tfPrograma)
            }
            
            // nombre del periodo
            if !self.tfPeriodo.hasText {
            //    periodo.setValue(self.tfPeriodo.text, forKey: "nombre")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre del periodo.", toFocus: self.tfPeriodo)
            }
            
            // fecha inicial
            if !self.tfFechaIni.hasText {
            //    periodo.setValue(dtFormatter.date(from: (self.tfFechaIni.text)!), forKey: "fechaInicial")
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la fecha de inicio del periodo.", toFocus: self.tfFechaIni)
            }
            
            // fecha final
            if !self.tfFechaFin.hasText {
            //    fechi = dtFormatter.date(from: (self.tfFechaIni.text)!)!
            //    fechf = dtFormatter.date(from: (self.tfFechaFin.text)!)!
                
            //    if fechi >= fechf {
            //        isComplete = false
            //        showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "La fecha final debe ser posterior a la fecha inicial del periodo.  Por favor verifique.", toFocus: self.tfFechaFin)
            //    } else {
            //        periodo.setValue(dtFormatter.date(from: (self.tfFechaFin.text)!), forKey: "fechaFinal")
            //    }
            //} else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la fecha final del periodo.", toFocus: self.tfFechaFin)
            }
            
            fechi = dtFormatter.date(from: (self.tfFechaIni.text)!)!
            fechf = dtFormatter.date(from: (self.tfFechaFin.text)!)!
            
            if fechi >= fechf {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "La fecha final debe ser posterior a la fecha inicial del periodo.  Por favor verifique.", toFocus: self.tfFechaFin)
            //} else {
            }
            
        
            let periodo = NSEntityDescription.insertNewObject(forEntityName: "Periodo", into: self.moc)
            
            let nuevoIndice: Double = (periodo as! Periodo).obtenerNuevoIndice()
            
            periodo.setValue(nuevoIndice, forKey: "indice")

            periodo.setValue(self.programa, forKey: "programa")
            
            periodo.setValue(self.tfPeriodo.text, forKey: "nombre")

            periodo.setValue(dtFormatter.date(from: (self.tfFechaIni.text)!), forKey: "fechaInicial")

            periodo.setValue(dtFormatter.date(from: (self.tfFechaFin.text)!), forKey: "fechaFinal")

            // duración
            if self.pckrDuracionPeriodo.selectedRow(inComponent: 0) != -1 && self.pckrDuracionPeriodo.selectedRow(inComponent: 0) != 0 {
                periodo.setValue(self.pckrDuracionPeriodo.selectedRow(inComponent: 0), forKey: "indiceDuracion")
            }
            
            periodo.setValue(self.programa, forKey: "programa")
            
        } else if self.boolEsModificacion {
            
            //self.programa?.removePeriodo(periodo: self.periodo!)
            
            // nombre del programa
            if self.tfPrograma.hasText {
                self.periodo!.setValue(self.programa, forKey: "programa")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe seleccionar el programa o curso.", toFocus: self.tfPrograma)
            }
            
            // nombre del periodo
            if self.tfPeriodo.hasText {
                self.periodo!.setValue(self.tfPeriodo.text, forKey: "nombre")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar el nombre del periodo.", toFocus: self.tfPeriodo)
            }
            
            // fecha inicial
            if self.tfFechaIni.hasText {
                self.periodo!.setValue(dtFormatter.date(from: (self.tfFechaIni.text)!), forKey: "fechaInicial")
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la fecha de inicio del periodo.", toFocus: self.tfFechaIni)
            }
            
            // fecha final
            if self.tfFechaFin.hasText {
                
                fechi = dtFormatter.date(from: (self.tfFechaIni.text)!)!
                fechf = dtFormatter.date(from: (self.tfFechaFin.text)!)!
                
                if fechi >= fechf {
                    isComplete = false
                    showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "La fecha final debe ser posterior a la fecha inicial del periodo.  Por favor verifique.", toFocus: self.tfFechaFin)
                } else {
                    self.periodo!.setValue(dtFormatter.date(from: (self.tfFechaFin.text)!), forKey: "fechaFinal")
                }
            } else {
                isComplete = false
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Debe ingresar la fecha final del periodo.", toFocus: self.tfFechaFin)
            }
            
            // duración
            if self.pckrDuracionPeriodo.selectedRow(inComponent: 0) != -1 && self.pckrDuracionPeriodo.selectedRow(inComponent: 0) != 0 {
                self.periodo!.setValue(self.pckrDuracionPeriodo.selectedRow(inComponent: 0), forKey: "indiceDuracion")
            }

            //self.programa?.setValue(self.periodo!, forKey: "periodo")
            //self.programa?.addPeriodo(periodo: self.periodo!)
            
            self.periodo?.setValue(self.programa, forKey: "programa")
        }
    }
    
    // MARK: - Precedimiento de guardado
    func guardar() -> Bool {
        var canISave: Bool = true
        do {
            prepararDatos(isDataReady: &canISave)
            
            if canISave {
                
                try self.moc.save()
                
                showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos del periodo fueron grabados con éxito.", toFocus: nil)
                
                self.loadPreferences()
            }
        } catch let error as NSError {
            print("No se pudo guardar los datos del periodo.  Error: \(error)")
        }
        return canISave
    }
    
    func btnGuardarOnTouchUpInside(_ sender: AnyObject) {
        // code for saving here
        
        let button = sender as! UIBarButtonItem
        // code for saving here
        if Global().modoAsistido {
            if self.toolTip == nil {
                //self.toolTip = CMPopTipView(message: "Este es un demo de tooltip")
                self.toolTip = CMPopTipView(title: "Guardado de Datos", message: "Con esta opción podrá almacenar o actualizar los datos registrados para el periodo en su dispositivo.  Toque aquí para guardar los datos.")
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
            _ = self.guardar()
        }
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
    }
}

extension VCPeriodo: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
}

extension VCPeriodo: CMPopTipViewDelegate {
    func popTipViewWasDismissed(byUser popTipView: CMPopTipView!) {
        let tag = self.toolTip?.tag
        
        self.toolTip = nil
        
        if tag == 1 {
            _ = self.guardar()
        }
    }
}

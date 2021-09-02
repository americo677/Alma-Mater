//
//  VCPeriodos.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 13/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class VCPeriodos: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var tvPeriodos: UITableView!
    
    var programa: Programa? = nil
    var programas = [AnyObject]()
    
    var periodo: Periodo? = nil
    
    var periodos = [AnyObject]()
    var periodosFiltrados = [AnyObject]()
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()

    let scSearchController = UISearchController(searchResultsController: nil)

    var boolCalledFromMenu: Bool = false
    
    //var vPicker: UIView! = nil
    
    var douIndiceProgramaSeleccionado: Double = 0

    var pckrPrograma = UIPickerView()
    
//    var tfPrograma: UITextField!

//    @IBOutlet weak var tfHide: UITextField!
    
    var arrProgramas = [String]()
    var arrIndiceProgramas = [Double]()
    
    let arrProgs = ["Programa 1", "Programa 2", "Programa 3"]
    
    //var activeTextField = UITextField()
    
    //var tfPrograma = UITextField()
    //var pckrPrograma = UIPickerView()
    //var indiceProgramaSeleccionado: Double = -1
    //var vPicker: UIView!

    //struct Dato {
    //    var indice: Double = 0
    //    var descripcion: String = ""
    //}
    
    //var programasUsuario: Array<Global.Dato> = []

    //var indicesPrograma = [Double]()
    //var nombresPrograma = [String]()

    // MARK: - Rutinas para selección y cancelación del pickerview
    func donePicker(for sender: UIBarButtonItem) {
        //self.activeTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    // MARK: - Rutinas para selección y cancelación del pickerview
    func cancelPicker(for sender: UIBarButtonItem) {
        //self.activeTextField.resignFirstResponder()
        self.view.endEditing(true)
    }

    
    // MARK: - Carga de la vista para el despliegue y selección del programa o curso.
    func initViewForPicker() {
        
        // Crea la vista para el despliegue del Picker para selección de programas.
        //let rectForView = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 250)
        
        //self.vPicker = UIView(frame: rectForView)
        
        //self.view.addSubview(self.vPicker)
        
        self.programas = fetchData(entity: .programa, byIndex: nil)
        
        for programa in self.programas {
            arrProgramas.append((programa as! Programa).nombre!)
            arrIndiceProgramas.append((programa as! Programa).indice)
        }
        
        self.douIndiceProgramaSeleccionado = 0
        
//        self.tfPrograma = UITextField()
        
        //self.loadPickerView(&self.pckrPrograma, indiceSeleccionado:  0, indicePorDefecto:0, tag: 1, textField: nil, opciones: arrProgs, accionDone: #selector(donePicker(for:)), accionCancel: #selector(cancelPicker(for:)))
    }

    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        initTableView(tableView: self.tvPeriodos, backgroundColor: UIColor.customUltraLightBlue())
        
        initToolBar(toolbarDesign: .toLeftBackToRightEditNewStyle, actions: [nil, #selector(self.btnEditOnTouchUpInside(_:)), #selector(self.btnNuevoOnTouchUpInside(_:))], title: "Mis Periodos")

        //initSearchBar(tableView: tvEvaluaciones)
        
        self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        //self.tvPeriodos.isHidden = true
        
        initViewForPicker()

        //initFormatters()
        
        //initDatePickers()
        
        //self.periodos = fetchData(entity: .programa, byIndex: nil)
        
        //for programa in self.periodos {
        //    indicesPrograma.append((programa as! Programa).indice)
        //    nombresPrograma.append((programa as! Programa).nombre!)
        //}
        
        //getData()
        
        //self.loadPickerView(&self.pckrPrograma, indiceSeleccionado:  0, indicePorDefecto:0, tag: 1, textField: self.tfPrograma, opciones: nombresPrograma, accionDone: #selector(donePicker(for:)), accionCancel: #selector(cancelPicker(for:)))
        
        //let cRect = CGRect(x: 0, y: 200, width: self.view.frame.width, height: 250)
        
        //vPicker = UIView.init(frame: cRect)
        
        //vPicker.backgroundColor = UIColor.clear
        
        //vPicker.addSubview(self.pckrPrograma)
        
        //self.view.addSubview(vPicker)
        
    }

    func getData() {
        self.programas = fetchData(entity: .programa, byIndex: 1)
        if self.programas.count > 0 {
            self.programa = self.programas.first as? Programa
            self.periodos = (self.programa?.obtenerPeriodosOrdernadoPorIndice())!
        }
        
        //indicesPrograma.removeAll()
        //nombresPrograma.removeAll()
        
        //if self.periodos.count > 0 {
        //    for programa in self.periodos {
        //        indicesPrograma.append((programa as! Programa).indice)
        //        nombresPrograma.append((programa as! Programa).nombre!)
        //    }
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPreferences()
        
        /*
        self.pckrPrograma = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 250))
        self.pckrPrograma.delegate = self
        self.pckrPrograma.dataSource = self
        self.pckrPrograma.tag = 1
        self.pckrPrograma.isHidden = false
        self.pckrPrograma.backgroundColor = UIColor.white
        self.pckrPrograma.showsSelectionIndicator = true

        let tb = UIToolbar()
        tb.barStyle = UIBarStyle.default
        tb.isTranslucent = true
        tb.sizeToFit()
        tb.backgroundColor = UIColor.brown

        let btnDone = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker(for:)))
        
        let btnSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let btnCancel = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker(for:)))
        
        tb.setItems([btnCancel, btnSpace, btnDone], animated: false)
        
        tb.isUserInteractionEnabled = true
        
        tfHide.inputView = self.pckrPrograma
        tfHide.inputAccessoryView = tb
        
        self.view.addSubview(self.pckrPrograma)
 */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        tvPeriodos.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //tvPeriodos.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Funciones de los UIPickerViews
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return self.arrProgramas.count
        } else if pickerView.tag == 2 {
            return self.arrProgs.count
        //} else {
        //    return Global.arreglo.nivelAcademico.count
        }
        return 0
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return self.arrProgramas[row]
        } else if pickerView.tag == 2 {
            return self.arrProgs[row]
            //} else {
            //    return Global.arreglo.nivelAcademico.count
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            douIndiceProgramaSeleccionado = NSNumber.init(value: row).doubleValue
            pickerView.isHidden = true
            self.tvPeriodos.isHidden = false
        } else if pickerView.tag == 2 {
            douIndiceProgramaSeleccionado = NSNumber.init(value: row).doubleValue
            pickerView.isHidden = true
            self.tvPeriodos.isHidden = false
        //} else {
        //    self.tfNivelAcademico.text = Global.arreglo.nivelAcademico[row]
        //    self.indiceNivelAcademico = (row as NSNumber).doubleValue
        //    self.programa?.setValue(self.indiceNivelAcademico, forKey: "indiceNivelAcademico")
        }
    }
    
    // MARK: - Acciones de botones
    
    func btnNuevoOnTouchUpInside(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "segueAgregarPeriodo", sender: self)
    }
    
    func btnEditOnTouchUpInside(_ sender: UIBarButtonItem) {
        if self.tvPeriodos.isEditing {
            sender.title = "Editar"
            self.tvPeriodos.setEditing(false, animated: true)
        } else {
            // el UIBarButtonItem debe tener como posible titulo cada titulo
            sender.title = "Aceptar"
            self.tvPeriodos.setEditing(true, animated: true)
        }
    }

    // MARK: - Funciones de los UIPickerViews
    /*
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return self.nombresPrograma.count
        }
        return 0
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.nombresPrograma[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.indiceProgramaSeleccionado = self.indicesPrograma[row]
    }
    */
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueAgregarPeriodo" {
            let vcP = segue.destination as! VCPeriodo
            vcP.programa = self.programa
            vcP.periodo = nil
            vcP.boolEsNuevo = true
        } else if segue.identifier == "segueMostrarPeriodo" {
            let vcP = segue.destination as! VCPeriodo
            vcP.programa =  self.programa
            vcP.periodo = self.periodo
            vcP.boolEsNuevo = false
            if self.tvPeriodos.isEditing {
                vcP.boolEsModificacion = true
            } else {
                vcP.boolEsConsulta = true
            }
        }
    }
}

//extension VCPeriodos: UITextFieldDelegate {
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if self.tfPrograma == textField {
//        }
//    }
//}

// MARK: - Extension para UISearchBar
extension VCPeriodos: UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: - Configuración de la UISearchBar
    func configSearchBar(tableView: UITableView) {
        // Carga un controlador de búsqueda para implementar una barra de búsqueda de presupuestos.

        self.automaticallyAdjustsScrollViewInsets = true
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        scSearchController.searchResultsUpdater = self
        
        scSearchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        self.scSearchController.searchBar.placeholder = "Buscar periodo..."
        
        //scSearchController.searchBar.scopeButtonTitles = ["Actives", "All", "Preserveds"]
        
        scSearchController.searchBar.delegate = self
        
        scSearchController.searchBar.sizeToFit()
        
        scSearchController.searchBar.showsCancelButton = false
        
        tableView.tableHeaderView = scSearchController.searchBar
        
        self.scSearchController.hidesNavigationBarDuringPresentation = false
        
        self.scSearchController.searchBar.searchBarStyle = .prominent
        
        self.scSearchController.searchBar.barStyle = .default
        
        //self.navigationItem. = self.scSearchController.searchBar
        
        let bottom: CGFloat = 0 // 50 // init value for bottom
        let top: CGFloat = 0 // 0 init value for top
        let left: CGFloat = 0
        let right: CGFloat = 0
        
        tableView.contentInset = UIEdgeInsetsMake(top, left, bottom, right)
        
        //self.tableView.tableHeaderView?.contentMode = .scaleToFill
        
        let coordY = 0 // self.view.frame.size.height - 94
        let initCoord: CGPoint = CGPoint(x:0, y:coordY)
        
        tableView.setContentOffset(initCoord, animated: true)
        
    }

    // MARK: - Procedimientos para la UISearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //let initPointForSearchBar: CGPoint = CGPoint(x:0, y:-44)
        //self.tableView.setContentOffset(initPointForSearchBar, animated: true)
        self.scSearchController.searchBar.resignFirstResponder()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        /*
         if scope == scopeActives {
         presupuestosFiltrados = presupuestos.filter { budget in return ((budget as! Presupuesto).descripcion?.lowercased().contains(searchText))! &&  (budget as! Presupuesto).activo?.boolValue == true }
         } else if scope == scopePreserveds {
         presupuestosFiltrados = presupuestos.filter { budget in return ((budget as! Presupuesto).descripcion?.lowercased().contains(searchText))! &&  (budget as! Presupuesto).activo?.boolValue == false }
         } else if scope == scopeAll {
         presupuestosFiltrados = presupuestos.filter { budget in return ((budget as! Presupuesto).descripcion?.lowercased().contains(searchText))! }
         }
         
         //presupuestosFiltrados = presupuestos.filter { budget in return ((budget as! Presupuesto).descripcion?.lowercased().contains(searchText))! &&  (budget as! Presupuesto).activo?.boolValue == true }
         
         //presupuestosFiltrados = presupuestos.filter( { (($0 as! Presupuesto).descripcion?.lowercased().range(of: searchText) != nil)} )
         
         self.tableView.reloadData()
         */
        
        if !searchText.isEmpty {
            self.periodosFiltrados = self.periodos.filter {
                periodo in return (
                    !((periodo as! Periodo).nombre != nil) ? false: (periodo as! Periodo).nombre!.lowercased().contains(searchText)
                    
                )
            }
        }
        self.tvPeriodos.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // nothing yet
        /*
         let searchBar = searchController.searchBar
         let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
         
         if searchController.searchBar.selectedScopeButtonIndex == 0 {
         filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!, scope: scopeActives)
         } else if searchController.searchBar.selectedScopeButtonIndex == 1 {
         filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!, scope: scopeAll)
         } else if searchController.searchBar.selectedScopeButtonIndex == 2 {
         filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!, scope: scopePreserveds)
         } else {
         filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!, scope: scope)
         }
         */
        
        filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: scSearchController)
    }
}

// MARK: - Extensión para UITableView
extension VCPeriodos: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Inicializador de la tableView de la vista
    func initTableView(tableView: UITableView, backgroundColor color: UIColor) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth]
        
        tableView.backgroundColor = color
        
        //let identifier = "celdaPrograma"
        //let myBundle = Bundle(for: VCProgramas.self)
        //let nib = UINib(nibName: "TVCCeldaPrograma", bundle: myBundle)
        
        //self.tvPeriodos.register(nib, forCellReuseIdentifier: identifier)
        
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.allowsSelectionDuringEditing = true
        
        initTableViewRowHeight(tableView: tableView)
    }
    
    func initTableViewRowHeight(tableView: UITableView) {
        tableView.rowHeight = Global.tableView.MAX_ROW_HEIGHT_PERIODOS
    }
    
    // MARK: - TableView functions
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSections exec...")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            if periodosFiltrados.count > 0 {
                return periodosFiltrados.count
            }
        } else {
            if periodos.count > 0 {
                return periodos.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("cellForRowAt exec...")
        
        let identifier = "celdaPeriodo"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) //as! UITableViewCell?
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            //as? UITableViewCell
        }

        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.periodo = periodosFiltrados[indexPath.row] as? Periodo
        } else {
            self.periodo = periodos[indexPath.row] as? Periodo
        }
        
        cell?.backgroundColor = UIColor.customUltraLightBlue()
        
        //cell?.textLabel?.textColor = UIColor.customLightColor()
        
        cell?.textLabel?.text = periodo?.nombre
        
        if self.periodo?.indiceDuracion != nil {
            let nsIndice = Int((self.periodo?.indiceDuracion)!)
            cell?.detailTextLabel?.text = Global.arreglo.nombreDuracion[nsIndice]
        } else {
            cell?.detailTextLabel?.text = ""
        }
        
        return cell!

        
        
        /*
        cell?.backgroundView?.backgroundColor = UIColor.customUltraLightBlue()
        cell?.backgroundColor = UIColor.customUltraLightBlue()
        
        cell?.textLabel?.text = self.periodo?.nombre?.capitalized
        
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.textLabel?.shadowColor = UIColor.lightGray
        cell?.textLabel?.shadowOffset = CGSize(width: 1, height: 1)
        
        return cell!
        */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.periodo = periodosFiltrados[indexPath.row] as? Periodo
        } else {
            self.periodo = periodos[indexPath.row] as? Periodo
        }
        
        
        if self.boolCalledFromMenu {
            // cuando se listan las escalas desde el menú
            self.performSegue(withIdentifier: "segueMostrarPeriodo", sender: self)
            
        } else {
            // cuando se listan las escalas desde VCPrograma
            //let escala = Global.CDEscala()
            
            //escala.indice = (self.escala?.indice)!
            //escala.descripcion = (self.escala?.descripcion)!
            //escala.tipo = (self.escala?.tipo)!
            //escala.indicePais = (self.escala?.indicePais)!
            //escala.valorMinParaAprobacion = (self.escala?.valorMinParaAprobacion)!
            
            //_ = self.delegate?.send(data: escala)
            
            //_ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            //#if LITE_VERSION
            //self.showCustomWarningAlert("This is the demo version.  To enjoy the full version of \(self.strAppTitle) we invite you to obtain the full version.  Thank you!.", toFocus: nil)
            //#endif
            
            //#if FULL_VERSION
            if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
                self.periodo = self.periodosFiltrados[indexPath.row] as? Periodo
            } else {
                self.periodo = self.periodos[indexPath.row] as? Periodo
            }
            
            self.moc.delete(self.periodo!)

            if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
                self.periodosFiltrados.remove(at: indexPath.row)
            } else {
                self.periodos.remove(at: indexPath.row)
            }
            
            do {
                try self.moc.save()
                
                tvPeriodos.deleteRows(at: [indexPath], with: .fade)
            } catch {
                let deleteError = error as NSError
                print(deleteError)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
    }
}

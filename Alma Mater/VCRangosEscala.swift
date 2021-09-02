//
//  VCRangosEscala.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 31/03/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class VCRangosEscala: UIViewController {

    @IBOutlet weak var tvRangos: UITableView!
    
    var programa: Programa? = nil
    
    var escala: Escala? = nil
    
    var rango: RangoEscala? = nil
    var rangos = [AnyObject]()
    var rangosFiltrados = [AnyObject]()
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()

    let scSearchController = UISearchController(searchResultsController: nil)

    let dtFormatter: DateFormatter = DateFormatter()
    let fmtFloat : NumberFormatter = NumberFormatter()

    // MARK: - Inicializa formateadores numéricos
    func initFormatters() {
        // Preparación del formateador de fecha
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        // Preparación de los formateadores númericos
        fmtFloat.numberStyle = .none
        fmtFloat.maximumFractionDigits = 2
        
    }

    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        initTableView(tableView: self.tvRangos, backgroundColor: UIColor.customUltraLightBlue())
        
        initToolBar(toolbarDesign: .toLeftBackToRightEditNewStyle, actions: [nil, #selector(self.btnEditOnTouchUpInside(_:)), #selector(self.btnNuevoOnTouchUpInside(_:))], title: "Rangos de Calificaciones")
        
        //initSearchBar(tableView: tvEvaluaciones)
        
        self.view.backgroundColor = UIColor.customUltraLightBlue()
        
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
    
    func fetchData() {
        
        if self.escala != nil {
            self.rangos = (self.escala?.obtenerRangos())!
        }
        
        //print("Escala: \(self.escala!)")
        //print(" ")
        //print(" ")
        //print(" ************************************ ")
        //print(" ")
        //print(" ")
        //print("Rangos: \(self.rangos)")
        //self.rango = self.rangos.first as? RangoEscala
        
        //self.periodos = (self.programa?.obtenerPeriodos())!
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tvRangos.reloadData()
        
        //print("viewDidAppear exec...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchData()
        
        //print("viewWillAppear exec...")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Acciones de botones
    
    func btnNuevoOnTouchUpInside(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "segueAgregarRangoEscala", sender: self)
    }
    
    func btnEditOnTouchUpInside(_ sender: UIBarButtonItem) {
        if self.tvRangos.isEditing {
            sender.title = "Editar"
            self.tvRangos.setEditing(false, animated: true)
        } else {
            // el UIBarButtonItem debe tener como posible titulo cada titulo
            sender.title = "Aceptar"
            self.tvRangos.setEditing(true, animated: true)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueAgregarRangoEscala" {
            let vcRE = segue.destination as! VCRangoEscala
            vcRE.boolEsNuevo = true
            vcRE.programa = nil
            vcRE.escalaMedicion = self.escala!
            vcRE.rango = nil
        } else if segue.identifier == "segueMostrarRangoEscala" {
            let vcRE = segue.destination as! VCRangoEscala
            vcRE.boolEsConsulta = true
            vcRE.programa = self.programa
            vcRE.escalaMedicion = self.escala
            vcRE.rango = self.rango
        } else if segue.identifier == "segueModificarRangoEscala" {
            let vcRE = segue.destination as! VCRangoEscala
            vcRE.boolEsModificacion = true
            vcRE.programa = self.programa
            vcRE.escalaMedicion = self.escala
            vcRE.rango = self.rango
        }
    }
    

}

// MARK: - Extension para UISearchBar
extension VCRangosEscala: UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: - Configuración de la UISearchBar
    func configSearchBar(tableView: UITableView) {
        // Carga un controlador de búsqueda para implementar una barra de búsqueda de presupuestos.
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        scSearchController.searchResultsUpdater = self
        
        scSearchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        self.scSearchController.searchBar.placeholder = "Buscar rango..."
        
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
            self.rangosFiltrados = self.rangos.filter {
                rango in return (
                    !((rango as! RangoEscala).descripcion != nil) ? false: (rango as! RangoEscala).descripcion!.lowercased().contains(searchText)
                    
                )
            }
        }
        self.tvRangos.reloadData()
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
extension VCRangosEscala: UITableViewDelegate, UITableViewDataSource {
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
        tableView.rowHeight = Global.tableView.MAX_ROW_HEIGHT_RANGOS
    }
    
    // MARK: - TableView functions
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSections exec...")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            if self.rangosFiltrados.count > 0 {
                return self.rangosFiltrados.count
            }
        } else {
            if self.rangos.count > 0 {
                return self.rangos.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("cellForRowAt exec...")
        
        let identifier = "celdaRango"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) //as! UITableViewCell?
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            //as? UITableViewCell
        }
        
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.rango = self.rangosFiltrados[indexPath.row] as? RangoEscala
        } else {
            self.rango = rangos[indexPath.row] as? RangoEscala
        }
        
        cell?.backgroundColor = UIColor.customUltraLightBlue()
        
        //cell?.textLabel?.textColor = UIColor.customLightColor()
        
        cell?.textLabel?.text = self.rango?.descripcion
        
        cell?.detailTextLabel?.text = "\((self.rango?.limiteInferior)!) a \( (self.rango?.limiteSuperior)!)"
            
            //self.rango?.limiteInferior,
        //if self.rango?.indiceDuracion != nil {
        //    let nsIndice = Int((self.rango?.indiceDuracion)!)
        //    cell?.detailTextLabel?.text = Global.arreglo.nombreDuracion[nsIndice]
        //} else {
        //    cell?.detailTextLabel?.text = ""
        //}
        
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
            self.rango = self.rangosFiltrados[indexPath.row] as? RangoEscala
        } else {
            self.rango = self.rangos[indexPath.row] as? RangoEscala
        }
        
        
        if self.tvRangos.isEditing {
            self.performSegue(withIdentifier: "segueModificarRangoEscala", sender: self)
        } else {
            self.performSegue(withIdentifier: "segueMostrarRangoEscala", sender: self)
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
             self.rango = self.rangosFiltrados[indexPath.row] as? RangoEscala
             } else {
             self.rango = self.rangos[indexPath.row] as? RangoEscala
             }
             
             
             //let boolPreservar: Bool = self.rango!.preservar as! Bool
             
             //if boolPreservar {
             //self.presupuesto?.setValue(false, forKey: smModelo.smPresupuesto.colActivo)
             //} else {
             self.moc.delete(self.rango!)
             //}
             
             if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
                 self.rangosFiltrados.remove(at: indexPath.row)
             } else {
                 self.rangos.remove(at: indexPath.row)
             }
             
             do {
                 try self.moc.save()
             
                 tableView.deleteRows(at: [indexPath], with: .fade)
             } catch {
                 let deleteError = error as NSError
                 print(deleteError)
             }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
    }
}


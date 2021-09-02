//
//  VCEscalas.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 28/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCEscalas: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tvEscalas: UITableView!
    
    weak var delegate: DataTransferDelegate?
    
    let scSearchController = UISearchController(searchResultsController: nil)
    
    var programa: Programa? = nil
    
    var escalas = [AnyObject]()
    var escalasFiltradas = [AnyObject]()
    var escala: Escala?
    
    var boolCalledFromMenu: Bool? = false
    var boolCalledFromPrograma: Bool? = false
    var boolCalledFromRango: Bool? = false
    var boolCalledToRangos: Bool? = true
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    
    // MARK: - Inicializador de la tableView de la vista
    func initTableView(tableView: UITableView, backgroundColor color: UIColor) {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth]
        
        tableView.backgroundColor = color
        
        //let identifier = "celdaPrograma"
        //let myBundle = Bundle(for: VCEvaluaciones.self)
        //let nib = UINib(nibName: "TVCCeldaPrograma", bundle: myBundle)
        //tableView.register(nib, forCellReuseIdentifier: identifier)
        
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.allowsSelectionDuringEditing = true
        
        //print("initTableView exec...")
        
        self.initTableViewRowHeight(tableView: tableView)
    }
    
    func initTableViewRowHeight(tableView: UITableView) {
        tableView.rowHeight = Global.tableView.MAX_ROW_HEIGHT_INSTITUCIONES
    }
    
    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        initTableView(tableView: self.tvEscalas, backgroundColor: UIColor.customUltraLightBlue())
        
        initToolBar(toolbarDesign: .toLeftBackToRightEditNewStyle, actions: [nil, #selector(self.btnEditOnTouchUpInside(_:)), #selector(self.btnNuevoOnTouchUpInside(_:))], title: "Escalas")

        let howMuchTimes = Global.defaults.float(forKey: Global.fstExeEscalas)
        
        if howMuchTimes == 0 {
            // Sólo se realiza en el primer lanzamiento de la app
            if loadInitJSON(jsonFile: "escalas", type: .escala) {
                print("Cargue exitoso!")
            }
        }
        
        Global.defaults.set(howMuchTimes + 1, forKey: Global.fstExeEscalas)
        
        configSearchBar(tableView: self.tvEscalas)
        
        self.view.backgroundColor = UIColor.customUltraLightBlue()
    }
    
    // MARK: - Consulta a la BD los presupuestos registrados
    func fetchData() {
        
        let data = NSFetchRequest<NSFetchRequestResult>(entityName: Escala.entity().managedObjectClassName!)
        
        data.entity = NSEntityDescription.entity(forEntityName: Escala.entity().managedObjectClassName!, in: self.moc)
        
        //data.propertiesToFetch = ["indice", "descripcion"]
        //data.resultType = .dictionaryResultType
        //data.
        //data.returnsObjectsAsFaults = false
        
        do {
            let escalas = try self.moc.fetch(data) as [AnyObject]
            
            self.escalas = escalas.sorted { ($0 as! Escala).descripcion! < ($1 as! Escala).descripcion! }
            
            //print("Total instituciones: \(self.instituciones?.count)")
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        //self.instituciones = self.institucion?.orderByDescription(orden: .ascendente)
        //print("fetchData exec...")
    }
    
    // MARK: - Configuración de la UISearchBar
    func configSearchBar(tableView: UITableView) {
        // Carga un controlador de búsqueda para implementar una barra de búsqueda de presupuestos.
        //self.automaticallyAdjustsScrollViewInsets = true //false //true //false
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        scSearchController.searchResultsUpdater = self
        
        scSearchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        self.scSearchController.searchBar.placeholder = "Buscar escala..."
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadPreferences()
        
        if self.programa == nil {
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tvEscalas.reloadData()
        
        //print("viewDidAppear exec...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchData()
        
        //print("viewWillAppear exec...")
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
            self.escalasFiltradas = self.escalas.filter {
                escala in return (
                    !((escala as! Escala).descripcion != nil) ? false: (escala as! Escala).descripcion!.lowercased().contains(searchText)
                    
                )
            }
        }
        self.tvEscalas.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSections exec...")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            if escalasFiltradas.count > 0 {
                return escalasFiltradas.count
            }
        } else {
            if escalas.count > 0 {
                return escalas.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("cellForRowAt exec...")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.escala = escalasFiltradas[indexPath.row] as? Escala
        } else {
            self.escala = escalas[indexPath.row] as? Escala
        }
        
        cell?.backgroundView?.backgroundColor = UIColor.customUltraLightBlue()
        cell?.backgroundColor = UIColor.customUltraLightBlue()
        
        cell?.textLabel?.text = escala?.descripcion?.capitalized
        
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.textLabel?.shadowColor = UIColor.lightGray
        cell?.textLabel?.shadowOffset = CGSize(width: 1, height: 1)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.escala = escalasFiltradas[indexPath.row] as? Escala
        } else {
            self.escala = escalas[indexPath.row] as? Escala
        }
        
        if self.boolCalledFromMenu! {
            // cuando se listan las escalas desde el menú
            
            if self.tvEscalas.isEditing {
                self.performSegue(withIdentifier: "segueMostrarEscalaCalificacion", sender: self)
            } else {
                self.performSegue(withIdentifier: "segueListarRangosEscala", sender: self)
            }
        } else if self.boolCalledFromPrograma! || self.boolCalledFromRango! {
            // cuando se listan las escalas desde VCPrograma
            let escala = Global.CDEscala()
            
            escala.indice = (self.escala?.indice)!
            escala.descripcion = (self.escala?.descripcion)!
            escala.tipo = (self.escala?.tipo)!
            escala.indicePais = (self.escala?.indicePais)!
            escala.valorMinParaAprobacion = (self.escala?.valorMinParaAprobacion)!
            
            _ = self.delegate?.send(data: escala)
            
            _ = self.navigationController?.popViewController(animated: true)
        } else if self.boolCalledToRangos! {
            self.performSegue(withIdentifier: "segueMostrarEscalaCalificacion", sender: self)
            
        }
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            //#if LITE_VERSION
            //self.showCustomWarningAlert("This is the demo version.  To enjoy the full version of \(self.strAppTitle) we invite you to obtain the full version.  Thank you!.", toFocus: nil)
            //#endif
            
            //#if FULL_VERSION
            
            // TODO: para implementar borrado de un rango de calificación
            
            if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
                self.escala = self.escalasFiltradas[indexPath.row] as? Escala
            } else {
                self.escala = self.escalas[indexPath.row] as? Escala
            }
            
            
            //let boolPreservar: Bool = self.rango!.preservar as! Bool
            
            //if boolPreservar {
            //self.presupuesto?.setValue(false, forKey: smModelo.smPresupuesto.colActivo)
            //} else {
            self.moc.delete(self.escala!)
            //}
            
            if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
                self.escalasFiltradas.remove(at: indexPath.row)
            } else {
                self.escalas.remove(at: indexPath.row)
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
    
    // MARK: - Acciones de botones
    
    func btnNuevoOnTouchUpInside(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "segueAgregarEscalaCalificacion", sender: self)
    }

    func btnEditOnTouchUpInside(_ sender: UIBarButtonItem) {
        if self.tvEscalas.isEditing {
            sender.title = "Editar"
            self.tvEscalas.setEditing(false, animated: true)
        } else {
            sender.title = "Aceptar"
            //editButton?.title = "Aceptar"
            self.tvEscalas.setEditing(true, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueAgregarEscalaCalificacion" {
            let vcEC = segue.destination as! VCEscalaCalificacion
            vcEC.programa = nil
            vcEC.escala = nil
            vcEC.boolEsNuevo = true
        } else if segue.identifier == "segueMostrarEscalaCalificacion" {
            if self.tvEscalas.isEditing {
                let vcEC = segue.destination as! VCEscalaCalificacion
                vcEC.programa = nil
                vcEC.escala = self.escala
                vcEC.boolEsNuevo = false
                vcEC.boolEsModificacion = true
            }
        } else if segue.identifier == "segueListarRangosEscala" {
            if !self.tvEscalas.isEditing {
                let vcRE = segue.destination as! VCRangosEscala
                vcRE.programa = self.programa
                vcRE.escala = self.escala
                //vcEC.boolEsNuevo = false
                //vcRE.boolEsModificacion = false
            }
        }
    }
    
}

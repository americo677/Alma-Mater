//
//  VCAsignaturas.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 13/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class VCAsignaturas: UIViewController {

    @IBOutlet weak var tvAsignaturas: UITableView!
    
    var programa: Programa? = nil
    var programas = [AnyObject]()
    
    var periodo: Periodo? = nil
    
    var asignatura: Asignatura? = nil
    
    var asignaturas = [AnyObject]()
    var asignaturasFiltradas = [AnyObject]()

    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    
    let scSearchController = UISearchController(searchResultsController: nil)


    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        initTableView(tableView: self.tvAsignaturas, backgroundColor: UIColor.customUltraLightBlue())
        
        initToolBar(toolbarDesign: .toLeftBackToRightEditNewStyle, actions: [nil, #selector(self.btnEditOnTouchUpInside(_:)), #selector(self.btnNuevoOnTouchUpInside(_:))], title: "Asignaturas")
        
        //let howMuchTimes = Global.defaults.float(forKey: Global.fstExeEscalas)
        
        //if howMuchTimes == 0 {
            // Sólo se realiza en el primer lanzamiento de la app
        //    if loadInitJSON(jsonFile: "escalas", type: .escala) {
        //        print("Cargue exitoso!")
        //    }
        //}
        
        //Global.defaults.set(howMuchTimes + 1, forKey: Global.fstExeEscalas)
        
        configSearchBar(tableView: self.tvAsignaturas)
        
        self.view.backgroundColor = UIColor.customUltraLightBlue()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadPreferences()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tvAsignaturas.reloadData()
        
        //print("viewDidAppear exec...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getData()
        
        //print("viewWillAppear exec...")
    }
    
    func getData() {
        self.programas = fetchData(entity: .programa, byIndex: 1)
        if self.programas.count > 0 {
            self.programa = self.programas.first as? Programa
            
            self.periodo = self.programa?.periodoVigente()
            
            self.asignaturas = (self.periodo?.obtenerAsignaturas())!
            
        }
        
    }
    
    func showData() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Acciones de botones
    
    func btnNuevoOnTouchUpInside(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "segueAgregarAsignatura", sender: self)
    }
    
    func btnEditOnTouchUpInside(_ sender: UIBarButtonItem) {
        if self.tvAsignaturas.isEditing {
            sender.title = "Editar"
            self.tvAsignaturas.setEditing(false, animated: true)
        } else {
            sender.title = "Aceptar"
            //editButton?.title = "Aceptar"
            self.tvAsignaturas.setEditing(true, animated: true)
        }
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

extension VCAsignaturas: UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: - Configuración de la UISearchBar
    func configSearchBar(tableView: UITableView) {
        // Carga un controlador de búsqueda para implementar una barra de búsqueda de presupuestos.
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        scSearchController.searchResultsUpdater = self
        
        scSearchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        self.scSearchController.searchBar.placeholder = "Buscar asignatura..."
        
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
            self.asignaturasFiltradas = self.asignaturas.filter {
                asignatura in return (
                    !((asignatura as! Asignatura).nombre != nil) ? false: (asignatura as! Asignatura).nombre!.lowercased().contains(searchText)
                    
                )
            }
        }
        self.tvAsignaturas.reloadData()
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
extension VCAsignaturas: UITableViewDelegate, UITableViewDataSource {
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
        tableView.rowHeight = Global.tableView.MAX_ROW_HEIGHT_ASIGNATURAS
    }
    
    // MARK: - TableView functions
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSections exec...")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            if asignaturasFiltradas.count > 0 {
                return asignaturasFiltradas.count
            }
        } else {
            if asignaturas.count > 0 {
                return asignaturas.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("cellForRowAt exec...")
        
        let identifier = "celdaAsignatura"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) //as! UITableViewCell?
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            //as? UITableViewCell
        }
        
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.asignatura = asignaturasFiltradas[indexPath.row] as? Asignatura
        } else {
            self.asignatura = asignaturas[indexPath.row] as? Asignatura
        }
        
        cell?.backgroundColor = UIColor.customUltraLightBlue()
        
        //cell?.textLabel?.textColor = UIColor.customLightColor()
        
        cell?.textLabel?.text = self.asignatura?.nombre
        
        //if self.asignatura?.indiceDuracion != nil {
        //    let nsIndice = Int((self.periodo?.indiceDuracion)!)
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
            self.asignatura = asignaturasFiltradas[indexPath.row] as? Asignatura
        } else {
            self.asignatura = asignaturas[indexPath.row] as? Asignatura
        }
        
        
        //if self.boolCalledFromMenu {
            // cuando se listan las escalas desde el menú
        //    self.performSegue(withIdentifier: "segueMostrarPeriodo", sender: self)
            
        //} else {
            // cuando se listan las escalas desde VCPrograma
            //let escala = Global.CDEscala()
            
            //escala.indice = (self.escala?.indice)!
            //escala.descripcion = (self.escala?.descripcion)!
            //escala.tipo = (self.escala?.tipo)!
            //escala.indicePais = (self.escala?.indicePais)!
            //escala.valorMinParaAprobacion = (self.escala?.valorMinParaAprobacion)!
            
            //_ = self.delegate?.send(data: escala)
            
            //_ = self.navigationController?.popViewController(animated: true)
        //}
        
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
                self.asignatura = self.asignaturasFiltradas[indexPath.row] as? Asignatura
            } else {
                self.asignatura = self.asignaturas[indexPath.row] as? Asignatura
            }
            
            self.moc.delete(self.periodo!)
            
            if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
                self.asignaturasFiltradas.remove(at: indexPath.row)
            } else {
                self.asignaturas.remove(at: indexPath.row)
            }
            
            do {
                try self.moc.save()
                
                tvAsignaturas.deleteRows(at: [indexPath], with: .fade)
            } catch {
                let deleteError = error as NSError
                print(deleteError)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
    }
}


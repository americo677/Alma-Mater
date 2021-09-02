//
//  VCInstituciones.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 14/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCInstituciones: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    
    @IBOutlet weak var tvInst: UITableView!
    
    weak var delegate: DataTransferDelegate?

    let scSearchController = UISearchController(searchResultsController: nil)
    
    var instituciones = [AnyObject]()
    var institucionesFiltradas = [AnyObject]()
    var institucion: Institucion?
    
    let moc = SingleManagedObjectContext.sharedInstance.getMOC()
    
    // MARK: - Inicializador de la tableView de la vista
    func initTableView(_ sender: AnyObject, backgroundColor color: UIColor) {
        
        self.tvInst.delegate = self
        self.tvInst.dataSource = self
        
        self.tvInst.frame = self.view.bounds
        self.tvInst.autoresizingMask = [.flexibleWidth]
        
        self.tvInst.backgroundColor = color
        
        //let identifier = "celdaPrograma"
        //let myBundle = Bundle(for: VCEvaluaciones.self)
        //let nib = UINib(nibName: "TVCCeldaPrograma", bundle: myBundle)
        
        //self.tvInstituciones.register(nib, forCellReuseIdentifier: identifier)
        
        self.tvInst.allowsMultipleSelectionDuringEditing = false
        self.tvInst.allowsSelectionDuringEditing = true
        
        //print("initTableView exec...")
        
        self.initTableViewRowHeight(self.tvInst)
    }
    
    func initTableViewRowHeight(_ tableView: UITableView) {
        self.tvInst.rowHeight = Global.tableView.MAX_ROW_HEIGHT_INSTITUCIONES

        //print("initTableViewRowHeight exec...")
    }
    
    func loadPreferences() {
        self.initTableView(self, backgroundColor: UIColor.customUltraLightBlue())

        //Global.defaults.set(0, forKey: Global.fstExeInstituciones)
        
        let howMuchTimes = Global.defaults.float(forKey: Global.fstExeInstituciones)
        
        if howMuchTimes == 0 {
            // Sólo se realiza en el primer lanzamiento de la app
            if loadInitJSON(jsonFile: "institucion", type: .institucion) {
                print("Cargue exitoso!")
            }
        }
        
        Global.defaults.set(howMuchTimes + 1, forKey: Global.fstExeInstituciones)
        

        self.view.backgroundColor = UIColor.customUltraLightBlue()
        
        //print("loadPreferences exec...")
        
        configSearchBar()
    }
    
    // MARK: - Consulta a la BD los presupuestos registrados
    func fetchData() {
        
        let data = NSFetchRequest<NSFetchRequestResult>(entityName: Institucion.entity().managedObjectClassName!)
        
        data.entity = NSEntityDescription.entity(forEntityName: Institucion.entity().managedObjectClassName!, in: self.moc)
        
        do {
            let instituciones = try self.moc.fetch(data) as [AnyObject]
            
            self.instituciones = instituciones.sorted { ($0 as! Institucion).descripcion! < ($1 as! Institucion).descripcion! }
            
            //print("Total instituciones: \(self.instituciones?.count)")
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    // MARK: - Configuración de la UISearchBar
    func configSearchBar() {
        // Carga un controlador de búsqueda para implementar una barra de búsqueda de presupuestos.
        //self.automaticallyAdjustsScrollViewInsets = true //false //true //false
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        scSearchController.searchResultsUpdater = self
        
        scSearchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        self.scSearchController.searchBar.placeholder = "Buscar institución..."
        
        //scSearchController.searchBar.scopeButtonTitles = ["Actives", "All", "Preserveds"]
        
        scSearchController.searchBar.delegate = self
        
        scSearchController.searchBar.sizeToFit()
        
        scSearchController.searchBar.showsCancelButton = false
        
        self.tvInst.tableHeaderView = scSearchController.searchBar
        
        self.scSearchController.hidesNavigationBarDuringPresentation = false
        
        self.scSearchController.searchBar.searchBarStyle = .prominent
        
        self.scSearchController.searchBar.barStyle = .default
        
        //self.navigationItem. = self.scSearchController.searchBar
        
        let bottom: CGFloat = 0 // 50 // init value for bottom
        let top: CGFloat = 0 // 0 init value for top
        let left: CGFloat = 0
        let right: CGFloat = 0
        
        self.tvInst.contentInset = UIEdgeInsetsMake(top, left, bottom, right)
        
        //self.tableView.tableHeaderView?.contentMode = .scaleToFill
        
        let coordY = 0 // self.view.frame.size.height - 94
        let initCoord: CGPoint = CGPoint(x:0, y:coordY)
        self.tvInst.setContentOffset(initCoord, animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPreferences()
        //print("viewDidLoad exec...")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tvInst.reloadData()
        
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
            self.institucionesFiltradas = self.instituciones.filter {
                institucion in return (
                    !((institucion as! Institucion).descripcion != nil) ? false: (institucion as! Institucion).descripcion!.lowercased().contains(searchText)
                
                )
            }
        }
        self.tvInst.reloadData()
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
            if institucionesFiltradas.count > 0 {
                return institucionesFiltradas.count
            }
        } else {
            if instituciones.count > 0 {
                return instituciones.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //print("cellForRowAt exec...")

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.institucion = institucionesFiltradas[indexPath.row] as? Institucion
        } else {
            self.institucion = instituciones[indexPath.row] as? Institucion
        }

        cell?.backgroundView?.backgroundColor = UIColor.customUltraLightBlue()
        cell?.backgroundColor = UIColor.customUltraLightBlue()
        
        cell?.textLabel?.text = institucion?.descripcion?.capitalized
        
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.textLabel?.shadowColor = UIColor.lightGray
        cell?.textLabel?.shadowOffset = CGSize(width: 1, height: 1)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            self.institucion = institucionesFiltradas[indexPath.row] as? Institucion
        } else {
            self.institucion = instituciones[indexPath.row] as? Institucion
        }
        
        //let inst = Global.STDataInstitucion(indice: Int.init(exactly: (self.institucion?.indice)!)!, descripcion: (self.institucion?.descripcion)!, indicePais: Int.init(exactly: (self.institucion?.indicePais)!)!)
        
        let inst = Global.CDInstitucion()
        

        
        //inst.indice = Int.init(exactly: (self.institucion?.indice)!)!
        //inst.descripcion = (self.institucion?.descripcion)!
        //inst.indicePais = Int.init(exactly: (self.institucion?.indicePais)!)!
        
        inst.indice = (self.institucion?.indice)!
        inst.descripcion = (self.institucion?.descripcion)!
        inst.indicePais = (self.institucion?.indicePais)!

        //let inst = Global.CDInstitucion(indice: Int.init(exactly: (self.institucion?.indice)!)!, descripcion: (self.institucion?.descripcion)!, indicePais: Int.init(exactly: (self.institucion?.indicePais)!)!)
        
        
        
        //var setInstitucion = [Any]()
        
        //setInstitucion.append( Int.init(exactly: (self.institucion?.indice)!)!)
        
        //setInstitucion.append((self.institucion?.descripcion)!)
        
        //setInstitucion.append(Int.init(exactly: (self.institucion?.indicePais)!)!)
        
        _ = self.delegate?.send(data: inst)

        _ = self.navigationController?.popViewController(animated: true)
    }
        
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}


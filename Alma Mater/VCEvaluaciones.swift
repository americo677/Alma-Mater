//
//  VCEvaluaciones.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 12/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class VCEvaluaciones: UIViewController, UITableViewDelegate, UITableViewDataSource, SideBlurBarDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tvEvaluaciones: UITableView!
    
    let scSearchController = UISearchController(searchResultsController: nil)

    var sideBlurBar: SideBlurBar = SideBlurBar()

    // MARK: - Inicializador de la tableView de la vista
    func initTableView(_ sender: AnyObject, backgroundColor color: UIColor) {
        self.tvEvaluaciones.delegate = self
        self.tvEvaluaciones.dataSource = self
        
        self.tvEvaluaciones.frame = self.view.bounds
        self.tvEvaluaciones.autoresizingMask = [.flexibleWidth]
        
        self.tvEvaluaciones.backgroundColor = color
        
        let identifier = "celdaPrograma"
        let myBundle = Bundle(for: VCEvaluaciones.self)
        let nib = UINib(nibName: "TVCCeldaPrograma", bundle: myBundle)
        
        self.tvEvaluaciones.register(nib, forCellReuseIdentifier: identifier)
        
        self.tvEvaluaciones.allowsMultipleSelectionDuringEditing = false
        self.tvEvaluaciones.allowsSelectionDuringEditing = true
        
        self.initTableViewRowHeight(self.tvEvaluaciones)
    }
    
    func initTableViewRowHeight(_ tableView: UITableView) {
        self.tvEvaluaciones.rowHeight = Global.tableView.MAX_ROW_HEIGHT_EVALUACIONES
    }

    func showSideBlurBar(_ sender: AnyObject) {
        self.sideBlurBar.showSideBlurBar(shouldOpen: !(self.sideBlurBar.isSideBlurBarOpen))
    }
    
    // MARK: - Carga inicial del menú lateral
    func initSideBlurBar() {
        self.sideBlurBar = SideBlurBar(sourceView: self.view, menuWidth: 220.0, sections: Global.arreglo.seccionesMenu, options: Global.arreglo.opcionesMenu)
        
        self.sideBlurBar.delegate = self

    }
    
    // MARK: - Configuración de la UISearchBar
    func initSearchBar(tableView: UITableView) {
        // Carga un controlador de búsqueda para implementar una barra de búsqueda de presupuestos.
        //self.automaticallyAdjustsScrollViewInsets = true //false //true //false
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        scSearchController.searchResultsUpdater = self
        
        scSearchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        self.scSearchController.searchBar.placeholder = "Buscar evaluación..."
        
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if sideBlurBar.isSideBlurBarOpen {
            showSideBlurBar(self)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if sideBlurBar.isSideBlurBarOpen {
            showSideBlurBar(self)
        }
        initSideBlurBar()
    }

    // MARK: - Carga inicial de la vista
    func loadPreferences(_ sender: AnyObject) {
        initTableView(self, backgroundColor: UIColor.customUltraLightBlue())
        
        initToolBar(toolbarDesign: .toLeftMenuToRightEditNewStyle, actions: [#selector(self.showSideBlurBar(_:)), #selector(self.btnEditOnTouchUpInside(_:)), #selector(self.btnNuevoOnTouchUpInside(_:))], title: "Mis Evaluaciones")
        
        initSearchBar(tableView: tvEvaluaciones)
        
        self.view.backgroundColor = UIColor.customUltraLightBlue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadPreferences(self)
        
        //let dbLoc =
        print("\(getPath("AlmaMaterDB.sqlite"))")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tvEvaluaciones.reloadData()
        
        initSideBlurBar()
    }

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
        
        if !(searchText.isEmpty) {
            /*self.regalosFiltrados = self.regalos.filter( {
             (!(($0 as! Regalo).descripcion != nil) ? false : ($0 as! Regalo).descripcion?.lowercased().contains(searchText))!
             || (!(($0 as! Regalo).motivo != nil) ? false : ($0 as! Regalo).motivo?.lowercased().contains(searchText))!
             || (!(($0 as! Regalo).para != nil) ? false : ($0 as! Regalo).para?.lowercased().contains(searchText))!
             } )
             */
        }
        
        self.tvEvaluaciones.reloadData()
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
    
    
    
    // MARK: - Procedimientos de la tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "celdaPrograma"
        var cell: TVCCeldaPrograma? = tableView.dequeueReusableCell(withIdentifier: identifier) as! TVCCeldaPrograma?
        
        //print("cellForRowAt is ok!")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier) as? TVCCeldaPrograma
        }
        /*
        cell?.backgroundColor = UIColor.customUltraLightBlue()
        
        //cell?.textLabel?.textColor = UIColor.customLightColor()
        
        cell?.lblPrograma.text = profesiones[indexPath.row]
        cell?.lblPrograma.textColor = UIColor.customDarkColor()
        cell?.lblPrograma.shadowColor = UIColor.customOceanBlue()
        cell?.lblPrograma.shadowOffset = CGSize(width: 0, height: 0.5)
        
        //cell?.textLabel?.text = profesiones[indexPath.row]
        
        cell?.lblPeriodoActual.text = "Primer semestre"
        cell?.lblPeriodoActual.textColor = .orange
        cell?.lblPeriodoActual.shadowColor = UIColor.customDarkColor()
        cell?.lblPeriodoActual.shadowOffset = CGSize(width: 0, height: 0.5)
        
        cell?.lblTagPromedioAcum.text = "Prom. Acum."
        cell?.lblTagPromedioAcum.shadowColor = UIColor.customDarkColor()
        cell?.lblTagPromedioAcum.shadowOffset = CGSize(width: 0, height: 0.5)
        
        cell?.lblPromedio.text = "\(EstadosGraficosPromedio.feliz.rawValue)"
        cell?.lblPromedio.textAlignment = .left
        //cell?.lblPromedio.backgroundColor = .green
        cell?.lblPromedio.shadowColor = UIColor.customDarkColor()
        cell?.lblPromedio.shadowOffset = CGSize(width: 0, height: 0.5)
        
        cell?.lblInstitucion.text = "U. Autonoma del Caribe"
        cell?.lblInstitucion.textAlignment = .left
        //cell?.lblPromedio.backgroundColor = .green
        cell?.lblInstitucion.shadowColor = UIColor.customDarkColor()
        cell?.lblInstitucion.shadowOffset = CGSize(width: 0, height: 0.5)
        */
        return cell!
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    func btnEditOnTouchUpInside(_ sender: AnyObject) {
        // put code here
    }
    
    func btnNuevoOnTouchUpInside(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "segueAgregarEvaluacion", sender: self)
    }
    
    func sideBlurBarDidSelectMenuOption(indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // programa
                // para el manejo de varios programas
                //self.performSegue(withIdentifier: "segueListarProgramas", sender: self)
                // para el manejo de un programa
                self.performSegue(withIdentifier: "segueAgregarPrograma", sender: self)
            } else if indexPath.row == 1 {
                // escala
                self.performSegue(withIdentifier: "segueListarEscalas", sender: self)
            } else if indexPath.row == 2 {
                // periodos
                self.performSegue(withIdentifier: "segueListarPeriodos", sender: self)
            } else if indexPath.row == 3 {
                // asignatura
                self.performSegue(withIdentifier: "segueListarAsignaturas", sender: self)
            } else if indexPath.row == 4 {
                // profesor
                self.performSegue(withIdentifier: "segueAgregarProfesor", sender: self)
            } else if indexPath.row == 5 {
                // corte
                self.performSegue(withIdentifier: "segueAgregarCorte", sender: self)
            } else if indexPath.row == 6 {
                // forma de evaluacion
                self.performSegue(withIdentifier: "segueAgregarFormaEvaluacion", sender: self)
            } else if indexPath.row == 7 {
                // evaluacion
                self.performSegue(withIdentifier: "segueAgregarEvaluacion", sender: self)
            }
            
        } else if indexPath.section == 1 {
            // sección de otros productos
            if indexPath.row == 0 {
                // programa
                self.performSegue(withIdentifier: "calculadora", sender: self)
            } else if indexPath.row == 1 {
                // escala
                self.performSegue(withIdentifier: "my finance", sender: self)
            } else if indexPath.row == 2 {
                // periodos
                self.performSegue(withIdentifier: "regalos", sender: self)
            }
        }
        //DispatchQueue.main.async {
        //    self.showCustomAlert(self, titleApp: "My App", strMensaje: "Has seleccionado el index: \(indexPath.row)", toFocus: nil)
        //}
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueAgregarPrograma" {
            
        //} else if segue.identifier == "segueListarProgramas" {
            
        } else if segue.identifier == "segueListarEscalas" {
            let vcEs = segue.destination as! VCEscalas
            vcEs.boolCalledFromMenu = true
        } else if segue.identifier == "segueListarPeriodos" {
            let vcPer = segue.destination as! VCPeriodos
            vcPer.boolCalledFromMenu = true
        } else if segue.identifier == "segueListarAsignaturas" {
            
        } else if segue.identifier == "segueAgregarProfesor" {
            
        } else if segue.identifier == "segueAgregarCorte" {
            
        } else if segue.identifier == "segueAgregarFormaEvaluacion" {
            
        } else if segue.identifier == "segueAgregarEvaluacion" {
            
        }
        
    }

}

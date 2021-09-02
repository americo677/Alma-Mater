//
//  VCProgramas.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 9/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class VCProgramas: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate { //SideBlurBarDelegate {

    @IBOutlet weak var tvProgramas: UITableView!
    
    //var sideBlurBar: SideBlurBar = SideBlurBar()
    
    let scSearchController = UISearchController(searchResultsController: nil)

    //var profesiones: Array<String> = ["Ingenieria de Sistemas", "Diseño Gráfico"]
    
    var programas = [AnyObject]()
    var programasFiltrados = [AnyObject]()
    
    let dtFormatter: DateFormatter = DateFormatter()
    let fmtFloat : NumberFormatter = NumberFormatter()

    enum EstadosGraficosPromedio: Character {
        case feliz = "😊"
        case tranquilo = "😌"
        case molesto = "😡"
        case triste = "😔"
    }
    
    // MARK: - Inicializa formateadores numéricos
    func initFormatters() {
        // Preparación del formateador de fecha
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        // Preparación de los formateadores númericos
        fmtFloat.numberStyle = .none
        fmtFloat.maximumFractionDigits = 2
        
    }

    // MARK: - Inicializador de la tableView de la vista
    func initTableView(_ sender: AnyObject, backgroundColor color: UIColor) {
        self.tvProgramas.delegate = self
        self.tvProgramas.dataSource = self
        
        self.tvProgramas.frame = self.view.bounds
        self.tvProgramas.autoresizingMask = [.flexibleWidth]
        
        self.tvProgramas.backgroundColor = color
        
        let identifier = "celdaPrograma"
        let myBundle = Bundle(for: VCProgramas.self)
        let nib = UINib(nibName: "TVCCeldaPrograma", bundle: myBundle)
        
        self.tvProgramas.register(nib, forCellReuseIdentifier: identifier)
        
        self.tvProgramas.allowsMultipleSelectionDuringEditing = false
        self.tvProgramas.allowsSelectionDuringEditing = true
        
        self.initTableViewRowHeight(self.tvProgramas)
    }
    
    func initTableViewRowHeight(_ tableView: UITableView) {
        self.tvProgramas.rowHeight = Global.tableView.MAX_ROW_HEIGHT_PROGRAMAS
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
        
        self.scSearchController.searchBar.placeholder = "Buscar programa..."
        
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

    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        initTableView(self, backgroundColor: UIColor.customUltraLightBlue())
        //initToolBar(toolbarColor: UIColor.customOceanBlue())
        initToolBar(toolbarDesign: .toLeftBackToRightEditNewStyle, actions: [nil, #selector(self.btnEditOnTouchUpInside(_:)), #selector(self.btnNuevoOnTouchUpInside(_:))], title: "Mis Programas")
        initSearchBar(tableView: tvProgramas)
        initFormatters()
        self.view.backgroundColor = UIColor.customUltraLightBlue()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadPreferences()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.getData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tvProgramas.reloadData()
        
        //initSideBlurBar()
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
        
        self.tvProgramas.reloadData()
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
    
    func getData() {
        self.programas = fetchData(entity: .programa, byIndex: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Acciones de botones
    
    func btnNuevoOnTouchUpInside(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "segueAgregarPrograma", sender: self)
    }
    
    func btnEditOnTouchUpInside(_ sender: UIBarButtonItem) {
        if self.tvProgramas.isEditing {
            
            //let editButton = self.navigationController?.toolbarItems?[1]
            
            //self.navigationController?.toolbarItems?[1].title = "Editar"
            sender.title = "Editar"

            //editButton?.title = "Editar"
            self.tvProgramas.setEditing(false, animated: true)
        } else {
            //let editButton = self.navigationController?.toolbarItems?[1]
            //self.navigationController?.toolbarItems?[1].title = "Aceptar"
            sender.title = "Aceptar"
            //editButton?.title = "Aceptar"
            self.tvProgramas.setEditing(true, animated: true)
        }
    }

    // MARK: - TableView functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "celdaPrograma"
        var cell: TVCCeldaPrograma? = tableView.dequeueReusableCell(withIdentifier: identifier) as! TVCCeldaPrograma?
        
        //print("cellForRowAt is ok!")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier) as? TVCCeldaPrograma
        }
        
        var programa: Programa?
        
        programa = programas[indexPath.row] as? Programa
        
        var instituto: Institucion?
        
        instituto = programa?.institucion
        
        
        cell?.backgroundColor = UIColor.customUltraLightBlue()
        
        //cell?.textLabel?.textColor = UIColor.customLightColor()
        
        cell?.lblPrograma.text = programa?.nombre
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
        
        cell?.lblPromedio.text = fmtFloat.string(from: NSNumber.init(value: (programa?.promedio)!))!
         // "\(EstadosGraficosPromedio.feliz.rawValue)"
        cell?.lblPromedio.textAlignment = .left
        //cell?.lblPromedio.backgroundColor = .green
        cell?.lblPromedio.shadowColor = UIColor.customDarkColor()
        cell?.lblPromedio.shadowOffset = CGSize(width: 0, height: 0.5)
        
        cell?.lblInstitucion.text = instituto?.descripcion?.capitalized
        cell?.lblInstitucion.textAlignment = .left
        //cell?.lblPromedio.backgroundColor = .green
        cell?.lblInstitucion.shadowColor = UIColor.customDarkColor()
        cell?.lblInstitucion.shadowOffset = CGSize(width: 0, height: 0.5)

        return cell!
    }

    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
            /*
            if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
                self.presupuesto = self.presupuestosFiltrados[indexPath.row] as? Presupuesto
            } else {
                self.presupuesto = self.presupuestosActivos[indexPath.row] as? Presupuesto
            }
            
            
            let boolPreservar: Bool = self.presupuesto!.preservar as! Bool
            
            if boolPreservar {
                self.presupuesto?.setValue(false, forKey: smModelo.smPresupuesto.colActivo)
            } else {
                self.moc.delete(self.presupuesto!)
            }
            
            if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
                self.presupuestosFiltrados.remove(at: indexPath.row)
            } else {
                self.presupuestosActivos.remove(at: indexPath.row)
            }
            
            do {
                try self.moc.save()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                let deleteError = error as NSError
                print(deleteError)
            }
 */
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //intSelectedIndex = indexPath.row
        
        if self.tvProgramas.isEditing {
            //self.performSegue(withIdentifier: "segueNewPresupuesto", sender: self)
            self.performSegue(withIdentifier: "segueAgregarPrograma", sender: self)
        } else {
            //self.performSegue(withIdentifier: "segueDetalle", sender: self)
            self.performSegue(withIdentifier: "segueAgregarPrograma", sender: self)
        }
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueAgregarPrograma" {
            if self.tvProgramas.isEditing {
                let programa = self.programas[(self.tvProgramas.indexPathForSelectedRow?.row)!] as! Programa
                
                let vcProg = segue.destination as! VCPrograma
                vcProg.programa = programa
            } else {
                let vcProg = segue.destination as! VCPrograma
                vcProg.programa = nil
            }
        }

    }

}

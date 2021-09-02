//
//  VCFormaEvaluacion.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 10/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class VCFormaEvaluacion: UIViewController {

    // MARK: - Carga inicial de la vista
    func loadPreferences() {
        
        //initToolBar(toolbarColor: UIColor.customOceanBlue())
        
        initToolBar(toolbarDesign: .toLeftBackToRightSaveStyle, actions: [nil, #selector(self.btnGuardarOnTouchUpInside(_:))], title: "Nueva Forma de Evaluación")
        
        //initSearchBar(tableView: tvEvaluaciones)
        
        self.view.backgroundColor = UIColor.customUltraLightBlue()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadPreferences()
    }
    
    func btnGuardarOnTouchUpInside(_ sender: AnyObject) {
        // code for saving here
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

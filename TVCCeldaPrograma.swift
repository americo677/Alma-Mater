//
//  TVCCeldaPrograma.swift
//  Alma Mater
//
//  Created by Américo Cantillo on 9/02/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class TVCCeldaPrograma: UITableViewCell {

    @IBOutlet weak var lblPrograma: UILabel!
    
    @IBOutlet weak var lblPeriodoActual: UILabel!
    
    @IBOutlet weak var lblPromedio: UILabel!
    
    @IBOutlet weak var lblTagPromedioAcum: UILabel!
    
    @IBOutlet weak var lblInstitucion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

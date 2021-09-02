//
//  DataTransfer.swift
//  Mis Regalos
//
//  Created by Américo Cantillo on 20/01/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import Foundation

protocol DataTransferDelegate: class {
    //func sendDataPersona(_ persona: CPersona!)
    //@objc optional func sendDataImageReceipt(_ image: UIImage?)
    //@objc optional func send(institucion: Global.STDataInstitucion)
    func send(data: Global.CDInstitucion) -> Bool
    func send(data: Global.CDEscala) -> Bool
}

// Esto implementa métodos opcionales Swift debe estar implementado como extensión y retornar valor booleano
extension DataTransferDelegate {
    
    func send(data: Global.CDInstitucion) -> Bool {
        return true
    }
    
    func send(data: Global.CDEscala) -> Bool {
        return true
    }
    
    
}

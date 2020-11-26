//
//  MemoryBoxTexts.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 09/11/20.
//

import Foundation

class MemoryBoxTexts {
    
    var isAccessibleCategory: Bool = false
    
    var addMemoryButtonText: String {
        if self.isAccessibleCategory {
            return "Adicionar"
        } else {
            return "Adicionar memória"
        }
    }
    
    var addFirstMemory: String {
        if self.isAccessibleCategory {
            return "Vamos adicionar sua primeira memória?"
        } else {
            return "Você ainda não guardou nenhuma memória. Vamos guardar uma?"
        }
    }
    
    var navigationTitle: String {
        if self.isAccessibleCategory {
            return "Memórias"
        } else {
            return "Minhas memórias"
        }
    }
}

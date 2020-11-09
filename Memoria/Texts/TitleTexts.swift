//
//  TitleTexts.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 09/11/20.
//

import Foundation

class TitleTexts {
    
    var isAccessibleCategory: Bool = false
    
    let today: String = "Hoje"
    let dontRememberWhen: String = "Não sei"
    let navigationTitle: String = "Informações"
    let descriptionTitle: String = "Descrição"
    let descriptionTextPlaceholder: String = "Descreva sua memória aqui..."
    let save: String = "Salvar"
    
    var titlePlaceholder: String {
        if self.isAccessibleCategory {
            return "Meu título..."
        } else {
            return "Insira um título aqui..."
        }
    }
    
    var happened1: String {
        if self.isAccessibleCategory {
            return "Foi"
        } else {
            return "Aconteceu"
        }
    }
    
    var happened2: String {
        if self.isAccessibleCategory {
            return "Foi há"
        } else {
            return "Aconteceu há"
        }
    }
    
    var titleQuestion: String {
        if self.isAccessibleCategory {
            return "Qual será o título da sua memória?"
        } else {
            return "Qual será o título da sua memória? Como você quer resumi-la?"
        }
    }
    
    var noNeedToBePrecise: String {
        if self.isAccessibleCategory {
            return "Pode ser só uma estimativa, tá bem?"
        } else {
            return "Não se preocupe com a exatidão! Pode ser uma estimativa, tá bem?"
        }
        
    }
    
    var descriptionSubtitle: String {
        if self.isAccessibleCategory {
            return "Faça uma breve descrição!"
        } else {
            return "Faça uma breve descrição para podermos guardar na sua caixinha de memórias!"
        }
    }
}

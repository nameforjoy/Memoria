//
//  QuestionTexts.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 09/11/20.
//

import Foundation

class QuestionTexts {

    // MARK: Common Text
    
    var isAccessibleCategory: Bool = false

    let recordAudioTitle: String = "Que tal gravar?"
    let recordAudioButtonTitle: String = "Gravar áudio"
    let takePhotoTitle: String = "E uma foto?"
    let save: String = "Salvar"
    
    var recordAudioSubtitle: String {
        if self.isAccessibleCategory {
            return "Faça um áudio contando pra gente!"
        } else {
            return "Você pode contar em áudio ou gravar algo que queira se lembrar futuramente!"
        }
    }
    
    var takePhotoSubtitle: String {
        if self.isAccessibleCategory {
            return "Adicione uma foto, imagem ou desenho."
        } else {
            return "Adicione uma foto, imagem ou desenho que esteja relacionada a essa memória."
        }
    }
    
    var takePhotoButtonTitle: String {
        if self.isAccessibleCategory {
            return "Pôr foto"
        } else {
            return "Adicionar foto"
        }
    }
    
    // MARK: Question specifics
    
    let textAnswerPlaceholder: String = "Descreva sua memória aqui..."
    
    var question: String {
        if self.isAccessibleCategory {
            return "Qual memória você quer nos contar?"
        } else {
            return "O que aconteceu ou está acontecendo? Como você gostaria de se lembrar disso?"
        }
    }
    
    var category: String {
        if self.isAccessibleCategory {
            return "Me conta!"
        } else {
            return "Conta pra mim!"
        }
    }
}

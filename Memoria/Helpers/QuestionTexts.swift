//
//  QuestionTexts.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 09/11/20.
//

import Foundation

enum Category: String {
    case senses = "Sentidos"
    case objects = "Objetos"
    case ambient = "Ambientação"
    case story = "História"
    case feelings = "Emoções"
    case learnings = "Aprendizados"
    case purpose = "Relevância"
}

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

    // MARK: Getting Questions

    static func getRandomQuestion(category: Category) -> String? {
        let senseQuestions = ["Essa memória possui alguma cor? Qual cor você relaciona a ela?",
                              "Tem alguma cena marcante sobre ela? Uma imagem que sempre vem a sua cabeça?",
                              "Existe algum jeito, mania ou olhar marcante? Algum gesto simbólico de alguém?",
                              "Você lembra de sentir algum cheiro? Como um perfume ou cheiro de comida?",
                              "Você estava comendo ou bebendo algo? Sentia o gosto de alguma coisa?",
                              "Existe um prato ou uma receita que te lembre essa memória? Qual seu gosto?",
                              "Você estava sentindo um gosto ou alguma sensação na boca?",
                              "Existe uma música nessa memória? Ou alguma música que te remeta a ela?",
                              "Você estava ouvindo algum som ou barulho? Existiam vozes, ruídos ou músicas?",
                              "Estava quente ou frio? Chovia ou fazia sol? Estava úmido?",
                              "Você lembra de alguma textura? Encostou em algo ou segurava alguma coisa?",
                              "Você estava se movimentando de alguma forma? Haviam outros movimentos?",
                              "Lembra de alguma sensação? Sentia dor, músculos tensos, ou talvez um relaxamento?"]

        let objectQuestions = ["Existe algum objeto que te lembre essa memória? Se o guardou, onde está?"]

        let ambientQuestions = ["Você lembra quais roupas estava usando? Existia algum adereço?",
                              "Onde você estava? Como era esse ambiente? Você consegue descrevê-lo?"]

        let storyQuestions = ["O que aconteceu? Como você gostaria de se lembrar disso? Pode dar mais detalhes?"]

        let feelingsQuestions = ["Como você estava se sentindo nesse momento ou época? O que estava pensando?",
                                 "Como você está se sentindo agora, relembrando essa memória?"]

        let learningsQuestions = ["O que você aprendeu com esse(s) momento(s)? O que traz consigo hoje?"]

        let purposeQuestions = ["Por que você está guardando essa memória? Por que ela é importante pra você?"]

        switch category {
        case .senses:
            return senseQuestions.randomElement()

        case .objects:
            return objectQuestions.randomElement()

        case .ambient:
            return ambientQuestions.randomElement()

        case .story:
            return storyQuestions.randomElement()

        case .feelings:
            return feelingsQuestions.randomElement()

        case .learnings:
            return learningsQuestions.randomElement()

        case .purpose:
            return purposeQuestions.randomElement()

        default:
            return ""
        }
    }
}

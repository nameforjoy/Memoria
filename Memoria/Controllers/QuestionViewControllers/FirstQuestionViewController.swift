//
//  FirstQuestionViewController.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 12/11/20.
//

import Foundation

class FirstQuestionViewController: QuestionTableViewController {

    override func viewDidLoad() {
        super.isLastQuestion = false
        super.viewDidLoad()

        self.question = QuestionTexts.getRandomQuestion(category: .senses)
        self.navigationItem.title = Category.senses.rawValue
    }
}

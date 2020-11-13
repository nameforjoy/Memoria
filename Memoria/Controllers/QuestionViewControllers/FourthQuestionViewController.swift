//
//  FourthQuestionViewController.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 12/11/20.
//

import Foundation

class FourthQuestionViewController: QuestionTableViewController {

    override func viewDidLoad() {
        super.isLastQuestion = false
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        self.question = QuestionTexts.getRandomQuestion(category: .feelings)
        self.navigationItem.title = Category.feelings.rawValue
    }
}

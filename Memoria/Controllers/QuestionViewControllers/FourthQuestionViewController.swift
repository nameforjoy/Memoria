//
//  FourthQuestionViewController.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 12/11/20.
//

import Foundation

class FourthQuestionViewController: QuestionTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.isLastQuestion = false

        self.question = QuestionTexts.getRandomQuestion(category: .feelings)
        self.navigationItem.title = Category.feelings.rawValue
    }
}

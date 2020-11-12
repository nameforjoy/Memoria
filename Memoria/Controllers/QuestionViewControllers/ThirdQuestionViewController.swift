//
//  ThirdQuestionViewController.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 12/11/20.
//

import Foundation

class ThirdQuestionViewController: QuestionTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.isLastQuestion = false

        self.question = QuestionTexts.getRandomQuestion(category: .ambient)
        self.navigationItem.title = Category.ambient.rawValue
    }
}

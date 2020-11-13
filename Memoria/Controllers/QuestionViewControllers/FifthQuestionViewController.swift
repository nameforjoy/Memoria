//
//  FifthQuestionViewController.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 12/11/20.
//

import Foundation

class FifthQuestionViewController: QuestionTableViewController {

    override func viewDidLoad() {
        super.isLastQuestion = true
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        self.question = QuestionTexts.getRandomQuestion(category: .story)
        self.navigationItem.title = Category.story.rawValue
    }
}

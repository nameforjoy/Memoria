//
//  SecondQuestionViewController.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 12/11/20.
//

import Foundation

class SecondQuestionViewController: QuestionTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.isLastQuestion = false

        self.question = QuestionTexts.getRandomQuestion(category: .objects)
        self.navigationItem.title = Category.objects.rawValue
    }
}

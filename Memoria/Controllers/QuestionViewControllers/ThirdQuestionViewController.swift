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

        self.question = "3Essa memória tem algum cheiro?"
        self.navigationItem.title = "Terceira"
    }
}

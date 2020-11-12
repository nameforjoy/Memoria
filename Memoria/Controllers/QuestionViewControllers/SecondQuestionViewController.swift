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

        self.question = "2Essa memória tem algum cheiro?"
        self.navigationItem.title = "Segunda"
    }
}

//
//  MySecondScreen.swift
//  HW6_UITableView
//
//  Created by Roman Cheremin on 29/10/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

//Класс-наследник UIViewController, определяющий вид экрана, после нажатия ячейки в RootViewController'e, делегат - RootViewController
class MySecondScreen: UIViewController {
    
    private var rowIndex: IndexPath!
    private var cell: Cell!
    
    var delegate: TableViewDelegateForMyScreen?
    
    lazy var textField: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        text.backgroundColor = UIColor(red:0.11, green:0.05, blue:0.05, alpha:1.0)
        text.textColor = UIColor(red:0.83, green:0.76, blue:0.76, alpha:1.0)
        text.frame = CGRect(x: 20, y: 370, width: self.view.frame.size.width - 40, height: 150)
        text.layer.cornerRadius = 15
        text.textAlignment = .center
        text.text = cell.lable
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.83, green:0.76, blue:0.76, alpha:1.0)
        view.addSubview(textField)
        textField.delegate = self
    }
    
    convenience init() {
        self.init(rowIndex: nil, cell: nil)
    }
    
    init(rowIndex: IndexPath?, cell: Cell?) {
        super.init(nibName: nil, bundle: nil)
        self.cell = cell!
        self.rowIndex = rowIndex
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Расширение, с методом, где MySecondScreen вызывает через делегата метод меняющий текст в ячейке tableView делегата
extension MySecondScreen: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.changeRowLable(rowIndex: self.rowIndex, lable: textField.text)
    }
}

//Протокол, который обязывает класс реализующий его, иметь метод, меняющий текст в ячейке
protocol TableViewDelegateForMyScreen {
    func changeRowLable(rowIndex: IndexPath, lable: String)
}


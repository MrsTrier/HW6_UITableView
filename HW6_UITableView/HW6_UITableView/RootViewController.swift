//
//  RootViewController.swift
//  HW6_UITableView
//
//  Created by Roman Cheremin on 29/10/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

//Класс-насследник UIViewController, экран содержащий UITableView
class RootViewController: UIViewController {
    
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    
    //Изменяемая структура, хранящая title - название секции в tableView и cellsInSection - массив структур, каждая из которых хранит данные об одной ячейке tableView
    private var sectionOfMyTable: [SectionOfMyTable] = [
        SectionOfMyTable(title: "", cellsInSection: [CellWithSubtitle(lable: "This is my first TableView!", image: "account", subtitle: "Set up iCloud")]),
        SectionOfMyTable(title: "", cellsInSection: [Cell(lable: "I can create different sections in my table", image: "settings"), Cell(lable: "I am impressed!", image: "hand")]),
        SectionOfMyTable(title: "", cellsInSection: [Cell(lable: "And different formating too!", image: "key")]),
        SectionOfMyTable(title: "", cellsInSection: [Cell(lable: "Icons", image: "maps"), Cell(lable: "Color", image: "safari"), Cell(lable: "Titles", image: "news"), Cell(lable: "Subtitles", image: "photos"), Cell(lable: "AccessoryType", image: "siry"), Cell(lable: "and more", image: "steve")]),
        SectionOfMyTable(title: "", cellsInSection: [Cell(lable: "Wonderfull", image: "game_center")]),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Table"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        updateLayout(with: view.frame.size)
    }
    
    private func updateLayout(with size: CGSize) {
        tableView.frame = CGRect.init(origin: .zero, size: size)
    }
}

//Класс-наследник UITableViewCell, отвечающий за переиспользование ячек, сбрасывает настройки ячейки до дефолтных
class TableViewCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
}

//Расширение для работы с tableView, RootViewController - делегат tableView
extension RootViewController: UITableViewDelegate {
    
    //    Метод позволяющий регулировать размер шапок для секций в случае если шапка секции не имеет текста
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var invisible = UIView()
        if section == 1 {
            invisible.backgroundColor = .clear
        }
        return invisible
    }
    
    //    Метод определяющий размер шапок для секций
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40.0
        }
        return 25.0
    }
    
    //    Метод отвечающий за переход на второй экран по нажатию ячейки tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !((indexPath.row == 0) && (indexPath.section == 0)) {
            var screen1 = MySecondScreen(rowIndex: indexPath, cell:
                sectionOfMyTable[indexPath.section].cellsInSection[indexPath.row] as! Cell)
            screen1.delegate = self
            navigationController?.pushViewController(screen1, animated: true)
        }
    }
}

//Расширение позволяющее использовать методы UITableViewDataSource, и передать контент в tableView для отображения
extension RootViewController: UITableViewDataSource {
    
    //    Обязательный метод UITableViewDataSource, который передает tableView информацию о количестве секции для tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionOfMyTable.count
    }
    
    //    Обязательный метод UITableViewDataSource, который передает tableView информацию о количестве ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionOfMyTable[section].cellsInSection.count
    }
    
    //    Метод заполняющий контентом (иконки и лейбл) ячейки tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "TableViewCell")
        
        cell.textLabel?.text = sectionOfMyTable[indexPath.section].cellsInSection[indexPath.row].lable
        cell.imageView?.image = UIImage(named: sectionOfMyTable[indexPath.section].cellsInSection[indexPath.row].image)
        cell.accessoryType = .disclosureIndicator
        
        //Код, который фиксирует размер иконки для каждой ячейки
        let itemSize = CGSize.init(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        cell.imageView?.image!.draw(in: imageRect)
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Строчка благодаря которой высота ячейки увеличивается или уменьшается в зависимости от количества строк в ячейке
        cell.textLabel?.numberOfLines = 0
        
        //Код форматирующий нулевую ячейку с subtitle
        if ((indexPath.row == 0) && (indexPath.section == 0)) {
            guard let cellData = sectionOfMyTable[indexPath.section].cellsInSection[indexPath.row] as? CellWithSubtitle else {
                return UITableViewCell()
            }
            cell.detailTextLabel?.text = cellData.subtitle
            cell.textLabel?.textColor = .blue
            cell.accessoryType = .none
        }
        return cell
    }
}

//Расширение позволяющее обновить lable ячейки в случае если на втором экране пользователь внёс изменения
extension RootViewController: TableViewDelegateForMyScreen {
    func changeRowLable(rowIndex: IndexPath, lable: String) {
        sectionOfMyTable[rowIndex.section].cellsInSection[rowIndex.row].lable = lable
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

protocol BaseCellProtocol {
    var lable: String { get set }
    var image: String { get }
}

struct Cell: BaseCellProtocol {
    var lable: String
    var image: String
}

struct CellWithSubtitle: BaseCellProtocol {
    var lable: String
    var image: String
    var subtitle: String
}

struct SectionOfMyTable {
    var title: String
    var cellsInSection: [BaseCellProtocol]
}

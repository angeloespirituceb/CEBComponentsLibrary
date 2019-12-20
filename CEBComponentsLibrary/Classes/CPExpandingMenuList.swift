//
//  CPExpandingMenuList.swift
//  Cebu Pacific
//
//  Created by Rowan de Chavez on 16/12/2019.
//  Copyright © 2019 Randell Joseph Ramirez. All rights reserved.
//

import UIKit
import SwiftyJSON
import AccordionSwift
import SnapKit

public struct CountryCellModel {
    let name: String
    let countryCode: String
}

public struct TerminalCellModel {
    let name: String
    let stationCode: String
}

class ParentTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel = UILabel();
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.textColor = .black;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview();
            make.leading.equalTo(self.contentView.snp.centerX).offset(-60)
        }
        
    }
    
}

class ChildTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel = UILabel();
    var imageIcon: UIImageView = UIImageView();
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.contentView.addSubview(titleLabel)
        self.titleLabel.textColor = .gray;
        self.titleLabel.textAlignment = .left
        self.titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview();
            make.leading.equalTo(self.contentView.snp.centerX).offset(5);
        }
        
        self.contentView.addSubview(self.imageIcon)
        self.imageIcon.image = UIImage.init(named: "alarm_on")
        self.imageIcon.tintColor = .gray
        self.imageIcon.snp.makeConstraints { (make) in
            make.width.equalTo(20);
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.contentView.snp.centerX).offset(-10);
        }
    }
}

open class CPExpandingMenuList: UIView {
    
    var tableView1: UITableView = UITableView()
    var tableView2: UITableView = UITableView()
    var stackContainer: UIStackView = UIStackView()
    
    typealias ParentCellModel = Parent<CountryCellModel, TerminalCellModel>
    typealias ParentCellConfig = CellViewConfig<ParentCellModel, ParentTableViewCell>
    typealias ChildCellConfig = CellViewConfig<TerminalCellModel, ChildTableViewCell>
    
    var dataSourceProvider: DataSourceProvider<DataSource<ParentCellModel>, ParentCellConfig, ChildCellConfig>?
    var dataSourceProvider2: DataSourceProvider<DataSource<ParentCellModel>, ParentCellConfig, ChildCellConfig>?
    
    var dataValues: [ParentCellModel] = [];
    
    open var onChooseChild:((TerminalCellModel?) -> Void)? = nil
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required public init(jsonData: [Any]) {
        super.init(frame: .zero)
        
        initElements(data: jsonData)
        self.setUpContainers()
        self.configDataSource();
    }
    
    private func initElements(data: [Any]) {
        self.dataValues = data.map { (countryObject) -> ParentCellModel in
            guard let country = countryObject as? [String: Any], let countryName = country["name"] as? String, let countryCode = country["countryCode"] as? String, let terminals = country["originStations"] as? [[String: Any]] else {
                return Parent(state: .collapsed, item: CountryCellModel(name: "", countryCode: ""), children: [TerminalCellModel]())
            }
            
            let countryModel = CountryCellModel(name: countryName, countryCode: countryCode);
            let terminalModels = terminals.map { (terminalObject) -> TerminalCellModel in
                guard let terminalName = terminalObject["fullName"] as? String, let stationCode = terminalObject["stationCode"]  as? String else {
                    return TerminalCellModel(name: "", stationCode: "")
                }
                
                return TerminalCellModel(name: terminalName, stationCode: stationCode);
            }
            
            return Parent(state: .collapsed, item: countryModel, children: terminalModels)
        }
    }
    
    func setUpContainers() {
        stackContainer.alignment = .fill
        stackContainer.distribution = .fillEqually
        addSubview(stackContainer);
        
        tableView1.register(ParentTableViewCell.self, forCellReuseIdentifier: "ParentCell")
        tableView1.register(ChildTableViewCell.self, forCellReuseIdentifier: "ChildCell")
        tableView2.register(ParentTableViewCell.self, forCellReuseIdentifier: "ParentCell")
        tableView2.register(ChildTableViewCell.self, forCellReuseIdentifier: "ChildCell")
        
        tableView1.separatorStyle = .none
        tableView2.separatorStyle = .none
        tableView1.bounces = false
        tableView2.bounces = false
        
        stackContainer.addArrangedSubview(tableView1)
        stackContainer.addArrangedSubview(tableView2)
        
        stackContainer.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

extension CPExpandingMenuList {
    
    private func configDataSource() {
        
        let dataCount = self.dataValues.count
        let half = dataCount / 2 + dataCount % 2
        let head = self.dataValues[0..<half]
        let tail = self.dataValues[half..<dataCount]
        
        let dataSource = DataSource(sections: Section(Array(head)))
        let dataSource1 = DataSource(sections: Section(Array(tail)))
        
        let parentCellConfig = CellViewConfig<ParentCellModel, ParentTableViewCell>(
        reuseIdentifier: "ParentCell") { (cell, model, tableView, indexPath) -> ParentTableViewCell in
            cell.selectionStyle = .none
            cell.titleLabel.text = model?.item.name
            cell.titleLabel.textAlignment = .left
            return cell
        }
        
        let childCellConfig = CellViewConfig<TerminalCellModel, ChildTableViewCell>(
        reuseIdentifier: "ChildCell") { (cell, item, tableView, indexPath) -> ChildTableViewCell in
            cell.titleLabel.text = item?.name
            return cell
        }
        
        let didSelectParentCell = { (tableView: UITableView, indexPath: IndexPath, item: ParentCellModel?) -> Void in
            print("Parent cell \(item!.item.name) tapped")
        }
        
        let didSelectChildCell = { (tableView: UITableView, indexPath: IndexPath, item: TerminalCellModel?) -> Void in
            self.onChooseChild?(item)
        }
        
        let heightForParentCell = { (tableView: UITableView, indexPath: IndexPath, item: ParentCellModel?) -> CGFloat in
            return 55
        }
        
        let heightForChildCell = { (tableView: UITableView, indexPath: IndexPath, item: TerminalCellModel?) -> CGFloat in
            return 40
        }
        
        let scrollViewDidScroll = { (scrollView: UIScrollView) -> Void in
            print(scrollView.contentOffset)
            
        }
        
        dataSourceProvider = DataSourceProvider(
            dataSource: dataSource,
            parentCellConfig: parentCellConfig,
            childCellConfig: childCellConfig,
            didSelectParentAtIndexPath: didSelectParentCell,
            didSelectChildAtIndexPath: didSelectChildCell,
            heightForParentCellAtIndexPath: heightForParentCell,
            heightForChildCellAtIndexPath: heightForChildCell,
            scrollViewDidScroll: scrollViewDidScroll,
            numberOfExpandedParentCells: .single
        )
        
        dataSourceProvider2 = DataSourceProvider(
            dataSource: dataSource1,
            parentCellConfig: parentCellConfig,
            childCellConfig: childCellConfig,
            didSelectParentAtIndexPath: didSelectParentCell,
            didSelectChildAtIndexPath: didSelectChildCell,
            heightForParentCellAtIndexPath: heightForParentCell,
            heightForChildCellAtIndexPath: heightForChildCell,
            scrollViewDidScroll: scrollViewDidScroll,
            numberOfExpandedParentCells: .single
        )
        
        tableView1.dataSource = dataSourceProvider?.tableViewDataSource
        tableView1.delegate = dataSourceProvider?.tableViewDelegate
        
        tableView2.dataSource = dataSourceProvider2?.tableViewDataSource
        tableView2.delegate = dataSourceProvider2?.tableViewDelegate
    }
}

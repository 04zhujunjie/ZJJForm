//
//  MainController.swift
//  ZJJForm
//
//  Created by weiqu on 2021/5/12.
//

import UIKit

class MainController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ZJJForm"
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier:cellId)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellId)
        }
        cell?.accessoryType = .disclosureIndicator
        if indexPath.row == 0 {
            cell?.textLabel?.text = "基本"
        }else{
            cell?.textLabel?.text = "自定义"
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(NormalController(), animated: true)
        }else{
            self.navigationController?.pushViewController(CustomController(), animated: true)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

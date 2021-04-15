//
//  TableCellViewModel.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/14/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//

import UIKit

protocol TableCellViewDelegate {
    func onClickCell(name: String)
}


class TableCellViewModel: UITableViewCell{
    @IBOutlet weak var labelName: UILabel!
    
    var cellDelegate: TableCellViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func cellClick(_ sender: Any) {
        cellDelegate?.onClickCell(name: labelName.text!)
    }
    
}

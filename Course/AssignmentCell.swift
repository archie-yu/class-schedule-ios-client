//
//  AssignmentCell.swift
//  Course
//
//  Created by Archie Yu on 2016/11/20.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class AssignmentCell : MGSwipeTableCell {
    
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var assignment: UILabel!
    @IBOutlet weak var assignmentContent: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var card: UILabel!
    
    func initViews() {
        // Change style
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier:String?)
    {
        super.init(style:style, reuseIdentifier: reuseIdentifier);
        initViews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        initViews();
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews();
        
        // 
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

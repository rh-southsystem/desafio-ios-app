//
//  CustomTableViewCell.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var event: Event?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        let idLbl = UILabel()
      
        if let id = event?.id {
            idLbl.text = "\(id)"
            idLbl.textColor = .black
            idLbl.font = UIFont.systemFont(ofSize: 15)
        }
        
        let nameLbl = UILabel()
        nameLbl.text = event?.name
        nameLbl.textColor = .black
        nameLbl.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        let descriptionLbl = UILabel()
        descriptionLbl.text = event?.description
        descriptionLbl.textColor = .black
        descriptionLbl.font = UIFont.systemFont(ofSize: 12)
        descriptionLbl.numberOfLines = 7
        descriptionLbl.center = center
        
        
        stackView.addArrangedSubview(idLbl)
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(descriptionLbl)
        
        addSubview(stackView)
        
        stackView.anchor(
            top: (topAnchor,0),
            left: (leftAnchor,0),
            right: (rightAnchor,0),
            bottom: (bottomAnchor,0)
        )
        
        descriptionLbl.anchor(
            left: (stackView.leftAnchor, 30),
            right: (stackView.rightAnchor, 30)
        )
    }
    
    func setup(event: Event) {
        self.event = event
    }
}

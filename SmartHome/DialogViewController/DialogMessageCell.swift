

import Foundation
import UIKit
class DialogMessageCell: UITableViewCell {


    let messageLabel = UILabel()
    let dateLabel = UILabel()
    let bubbleBackgroundView = UIView()
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
   
    let imageBackgroundView = UIView()

    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!

    var chatMessage: DialogModel.Message! {
        didSet {
            bubbleBackgroundView.backgroundColor = chatMessage.isMy ? #colorLiteral(red: 0.831372549, green: 0.9254901961, blue: 0.8196078431, alpha: 1)
 : .white
            
            messageLabel.textColor = chatMessage.isMy ? UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.0) : .black

            messageLabel.text = chatMessage.value
            dateLabel.text = chatMessage.dt
            dateLabel.font = UIFont.systemFont(ofSize: 12.0)
            dateLabel.textColor = chatMessage.isMy ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3514554795) : #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
            
            if !chatMessage.isMy {
                leadingConstraint?.isActive = true
                trailingConstraint?.isActive = false
            } else {
                leadingConstraint?.isActive = false
                trailingConstraint?.isActive = true
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        backgroundColor = .clear
        bubbleBackgroundView.backgroundColor = .yellow

        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.numberOfLines = 1

        addSubview(bubbleBackgroundView)
        addSubview(messageImageView)
        addSubview(messageLabel)
        addSubview(dateLabel)
        
        let constraints = [

            messageLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 4),
            
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width/2),

            dateLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
            dateLabel.rightAnchor.constraint(equalTo: messageLabel.rightAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageImageView.topAnchor, constant: -8),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            ]
        NSLayoutConstraint.activate(constraints)

        messageImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        
        messageImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        
        messageImageView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 8).isActive = true
        messageImageView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -8).isActive = true
      

        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false

        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
    }
    
    override func layoutSubviews() {
        bubbleBackgroundView.relayout()
        messageLabel.relayout()
        messageImageView.relayout()
        dateLabel.relayout()
        
    }


}

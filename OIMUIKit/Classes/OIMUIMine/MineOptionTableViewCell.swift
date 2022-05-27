





import UIKit

class MineOptionTableViewCell: UITableViewCell {
    
    let avatarImageView: UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    let titleLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 16)
        v.textColor = StandardUI.color_333333
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(StandardUI.margin_22)
            make.centerY.equalToSuperview()
            make.size.equalTo(22)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
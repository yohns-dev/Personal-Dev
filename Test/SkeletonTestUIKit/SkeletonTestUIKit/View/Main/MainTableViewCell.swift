import UIKit
import SkeletonView

class MainTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        setupUI()
        setupSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupSkeleton() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        titleLabel.isSkeletonable = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        
        titleLabel.skeletonTextLineHeight = .relativeToFont
        titleLabel.lastLineFillPercent = 100
        titleLabel.linesCornerRadius = 4
        titleLabel.skeletonLineSpacing = 10
        titleLabel.skeletonTextNumberOfLines = .inherited
    }
    
    func configure(text: String) {
        titleLabel.text = text
    }
    
}

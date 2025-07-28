import UIKit
import SkeletonView

class SkeletonAnimationViewViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    var placeholders = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSkeleton()
        setupUI()
        setupAnimationButtons()
        showPulse()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        var last: UIView? = nil
        for _ in 0..<6 {
            let placeholderLabel = UILabel()
            placeholderLabel.isSkeletonable = true
            placeholderLabel.skeletonTextLineHeight = .relativeToConstraints
            placeholderLabel.lastLineFillPercent = 100 //만들 때 한개만 만들기 때문에 지정을 해주면 길이를 조절할 수 있음.
            placeholderLabel.linesCornerRadius = 4
            placeholderLabel.skeletonTextNumberOfLines = .inherited
            
            placeholderLabel.text = " "
            placeholderLabel.backgroundColor = .clear
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(placeholderLabel)
            placeholders.append(placeholderLabel)
            NSLayoutConstraint.activate([
                placeholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                placeholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                placeholderLabel.heightAnchor.constraint(equalToConstant: 20),
                placeholderLabel.topAnchor.constraint(equalTo: last?.bottomAnchor ?? contentView.topAnchor, constant: last == nil ? 20 : 12)
            ])
            last = placeholderLabel
        }
        last?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    private func setupSkeleton() {
        view.isSkeletonable = true
        scrollView.isSkeletonable = true
        contentView.isSkeletonable = true
    }
    
    private func setupAnimationButtons() {
        let titles = ["Pulse", "Gradient", "Custom Fade"]
        let actions: [UIAction] = [
            UIAction {[weak self] _ in self?.showPulse() },
            UIAction {[weak self] _ in self?.showGradient() },
            UIAction {[weak self] _ in self?.showCustomFade() }
        ]
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.heightAnchor.constraint(equalToConstant: 44)
        ])
        for (i, t) in titles.enumerated() {
            let animationButton = UIButton(type: .system)
            animationButton.setTitle(t, for: .normal)
            animationButton.addAction(actions[i], for: .touchUpInside)
            stack.addArrangedSubview(animationButton)
        }
    }
    
    // MARK: Animation Methods
    private func showPulse() {
        scrollView.showAnimatedSkeleton(
            usingColor: .lightGray,
            transition: .crossDissolve(0.25)
        )
    }

    private func showGradient() {
        let gradient = SkeletonGradient(baseColor: .clouds)
        let animation = SkeletonAnimationBuilder()
            .makeSlidingAnimation(withDirection: .topBottom, duration: 1.5)
        
        scrollView.showAnimatedGradientSkeleton(
            usingGradient: gradient,
            animation: animation,
            transition: .crossDissolve(0.3)
        )
    }

    private func showCustomFade() {
        scrollView.showAnimatedSkeleton { layer in
            let anim = CABasicAnimation(keyPath: "opacity")
            anim.fromValue = 0.3
            anim.toValue = 1.0
            anim.duration = 1.0
            anim.autoreverses = true
            anim.repeatCount = .infinity
            return anim
        }
    }
    
    
}

#Preview {
    SkeletonAnimationViewViewController()
}

import UIKit
import SkeletonView

class SkeletonAnimationViewViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    var placeholders = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtons()
        showPulse()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.isSkeletonable = true
        scrollView.isSkeletonable = true
        contentView.isSkeletonable = true
        
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
            let lbl = UILabel()
            lbl.isSkeletonable = true
            lbl.text = " "
            lbl.backgroundColor = .clear
            lbl.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(lbl)
            placeholders.append(lbl)
            NSLayoutConstraint.activate([
                lbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                lbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                lbl.heightAnchor.constraint(equalToConstant: 20),
                lbl.topAnchor.constraint(equalTo: last?.bottomAnchor ?? contentView.topAnchor, constant: last == nil ? 20 : 12)
            ])
            last = lbl
        }
        last?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    private func setupButtons() {
        let titles = ["Pulse", "Gradient", "Custom Fade"]
        let selectors: [Selector] = [#selector(showPulse),
                                     #selector(showGradient),
                                     #selector(showCustomFade)]
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
            let btn = UIButton(type: .system)
            btn.setTitle(t, for: .normal)
            btn.addTarget(self, action: selectors[i], for: .touchUpInside)
            stack.addArrangedSubview(btn)
        }
    }
    
    // MARK: Animation Methods
    
    @objc private func showPulse() {
        scrollView.showAnimatedSkeleton(
            usingColor: .lightGray,
            transition: .crossDissolve(0.25)
        )
    }

    @objc private func showGradient() {
        let gradient = SkeletonGradient(baseColor: .clouds)
        let animation = SkeletonAnimationBuilder()
            .makeSlidingAnimation(withDirection: .topBottom, duration: 1.5)
        
        scrollView.showAnimatedGradientSkeleton(
            usingGradient: gradient,
            animation: animation,
            transition: .crossDissolve(0.3)
        )
    }

    @objc private func showCustomFade() {
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

import UIKit
import SkeletonView

class ViewController: UIViewController {
    private let viewNameList: [String] = [
        "SkeletonAnimation",
        "not yet",
        "not yet",
        "not yet",
        "not yet"
    ]
    
    private let tableView = UITableView()
    private var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        initLoading()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.isSkeletonable = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isSkeletonable = true
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    private func initLoading()  {
        tableView.showAnimatedGradientSkeleton()
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            isLoading = false
            tableView.stopSkeletonAnimation()
            tableView.hideSkeleton()
            tableView.reloadData()
        }
    }
}


// MARK: SkeletonTableViewDelegate

extension ViewController: SkeletonTableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            print("111111")
            let skeletonVC = SkeletonAnimationViewViewController()
            navigationController?.pushViewController(skeletonVC, animated: true)
        default:
            print("ss")
        }
    }
    
    
}

// MARK: SkeletonTableViewDataSource

extension ViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        cell.isSkeletonable = true
        cell.textLabel?.isSkeletonable = true
        
        cell.configure(text: viewNameList[indexPath.row])
        return cell
    }
    
    
    
    
}

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    private var localServer: LocalHTTPServer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view
        view.backgroundColor = .systemBackground
        
        // Start local server
        setupLocalServer()
        
        // Create a button to open the web view
        let openWebViewButton = UIButton(type: .system)
        openWebViewButton.setTitle("Open Login Page", for: .normal)
        openWebViewButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        openWebViewButton.backgroundColor = .systemBlue
        openWebViewButton.setTitleColor(.white, for: .normal)
        openWebViewButton.layer.cornerRadius = 10
        openWebViewButton.addTarget(self, action: #selector(openWebViewTapped), for: .touchUpInside)
        
        // Set up constraints
        openWebViewButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openWebViewButton)
        
        NSLayoutConstraint.activate([
            openWebViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openWebViewButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            openWebViewButton.widthAnchor.constraint(equalToConstant: 200),
            openWebViewButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupLocalServer() {
        localServer = LocalHTTPServer()
        localServer?.start()
    }
    
    @objc private func openWebViewTapped() {
        guard let serverURL = localServer?.serverURL else {
            print("Local server not running")
            return
        }
        
        // Create and present SFSafariViewController with HTTP URL
        let safariViewController = SFSafariViewController(url: serverURL)
        safariViewController.delegate = self
        safariViewController.modalPresentationStyle = .pageSheet
        
        present(safariViewController, animated: true, completion: nil)
    }
    
    deinit {
        localServer?.stop()
    }
}

// MARK: - SFSafariViewControllerDelegate
extension ViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // Called when the user taps the "Done" button
        dismiss(animated: true, completion: nil)
    }
}
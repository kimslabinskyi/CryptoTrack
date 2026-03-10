//
//  UIAlertController.swift
//  CryptoTrack
//
//  Created by Kim on 15.11.2025.
//

import UIKit
import MessageUI


extension UIAlertController {
    static func apiMessage() -> UIAlertController {
        let alert = UIAlertController(
            title: "Limited API Data",
            message: "We apologize, but please note that the data provided by the API is limited in scope. If you'd like to access more detailed information, feel free to reach out to us at kim.sl.developer@gmail.com for further assistance.",
            preferredStyle: .alert
        )
        
        let doneAction = UIAlertAction(title: "Done", style: .default)
        let emailAction = UIAlertAction(title: "Write to email", style: .default) { _ in
            EmailComposer.shared.compose(
                to: "kim.sl.developer@gmail.com",
                subject: "CryptoTrack: More detailed data",
                body: "Hi,\n\nI’d like to access more detailed API data.\n\nThanks!"
            )
        }
        
        alert.addAction(emailAction)
        alert.addAction(doneAction)
        
        alert.preferredAction = doneAction
        return alert
    }
    
    static func info(_ title: String?, _ message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}


final class EmailComposer: NSObject, MFMailComposeViewControllerDelegate {
    static let shared = EmailComposer()

    func compose(to: String, subject: String, body: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([to])
            mailVC.setSubject(subject)
            mailVC.setMessageBody(body, isHTML: false)

            topPresenter()?.present(mailVC, animated: true)
        } else {
            openMailtoFallback(to: to, subject: subject, body: body)
        }
    }

    // Dismiss the composer when user finishes
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }

    // MARK: - Helpers

    private func topPresenter(from root: UIViewController? = {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }()) -> UIViewController? {
        if let nav = root as? UINavigationController { return topPresenter(from: nav.visibleViewController) }
        if let tab = root as? UITabBarController { return topPresenter(from: tab.selectedViewController) }
        if let presented = root?.presentedViewController { return topPresenter(from: presented) }
        return root
    }

    private func openMailtoFallback(to: String, subject: String, body: String) {
        // Encode subject/body for URL safety
        let enc = { (s: String) -> String in
            s.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? s
        }
        let urlString = "mailto:\(to)?subject=\(enc(subject))&body=\(enc(body))"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

//
//  ViewController.swift
//  ShareWithInstagram
//
//  Created by Cho SeongHyun on 2017. 8. 14..
//  Copyright © 2017년 Naver. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var documentsInteractionsController: UIDocumentInteractionController!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func share(_ sender: UIButton) {
//        presentActivityViewController()
        shareOnInstagram()
    }

    private func presentActivityViewController() {
        let activityViewController = UIActivityViewController(activityItems: ["Title"], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func shareOnInstagram() {
        guard let image = imageView.image else { return }
        
        shareOnInstagram(image, text: "텍스트")
    }
    
}

extension ViewController: UIDocumentInteractionControllerDelegate {
    func shareOnInstagram(_ photo: UIImage, text: String?) {
        let instagramUrl = URL(string: "instagram://app")!
        
        if UIApplication.shared.canOpenURL(instagramUrl) {
            let imageData = UIImageJPEGRepresentation(photo, 1.0)!
            let captionString = text ?? ""
            
            let writePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("instagram.ig")
            do {
                try imageData.write(to: writePath)
                documentsInteractionsController = UIDocumentInteractionController(url: writePath)
                documentsInteractionsController.delegate = self
                documentsInteractionsController.uti = "com.instagram.photo"
                documentsInteractionsController.annotation = ["InstagramCaption": captionString]
                documentsInteractionsController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
            }catch {
                return
            }
        } else {
            let alertController = UIAlertController(title: "Install Instagram", message: "You need Instagram app installed to use this feature. Do you want to install it now?", preferredStyle: .alert)
            let installAction = UIAlertAction(title: "Install", style: .default, handler: { (action) in
                //redirect to instagram
            })
            alertController.addAction(installAction)
            
            let laterAction = UIAlertAction(title: "Later", style: .cancel, handler: nil)
            alertController.addAction(laterAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
}

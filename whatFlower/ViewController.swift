//
//  ViewController.swift
//  whatFlower
//
//  Created by Pushpinder Pal Singh on 26/01/20.
//  Copyright © 2020 Pushpinder Pal Singh. All rights reserved.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let image = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userImage
            guard let cliImage = CIImage(image: userImage) else {
                fatalError("You failed this mission")
            }
            detect(image: cliImage)
        }
        image.dismiss(animated: true, completion: nil)
    }
    
    func detect (image : CIImage){
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else{
            fatalError("Model Failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            let classification = request.results?.first as? VNClassificationObservation
            self.navigationItem.title = classification?.identifier.capitalized
        }
        let handler = VNImageRequestHandler(ciImage: image)
               do{
                try handler.perform([request])
               }
               catch{
                   print(error)
               }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(image, animated: true, completion: nil)
    }
    
}


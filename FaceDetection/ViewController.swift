//
//  AppDelegate.swift
//  FaceDetection
//
//  Created by VikGolovach on 07.09.2021.
//
import UIKit
import CoreImage
class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var slider: UISlider!
    var leftEyeCircle = UIView()
    var rightEyeCircle = UIView()
    var leftEyeCenter: CGPoint!
    var rightEyeCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = 0.0
        self.slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        detectEyes()
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        let currentValue = CGFloat(slider.value) * 100
        leftEyeCircle.frame.size = CGSize(width: currentValue, height: currentValue)
        leftEyeCircle.center = leftEyeCenter
        leftEyeCircle.layer.cornerRadius = leftEyeCircle.frame.size.width / 2
        rightEyeCircle.frame.size = CGSize(width: currentValue, height: currentValue)
        rightEyeCircle.center = rightEyeCenter
        rightEyeCircle.layer.cornerRadius = leftEyeCircle.frame.size.width / 2
    }
    
    
    
    func detectEyes() {
        guard let personciImage = CIImage(image: myImage.image!) else {return}
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector!.features(in: personciImage)
        // add coordinates
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        for face in faces as! [CIFaceFeature] {
            print("Found bounds are \(face.bounds)")
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
                var faceViewBounds = face.leftEyePosition.applying(transform)
                let viewSize = myImage.bounds.size
                let scale = min(viewSize.width / ciImageSize.width, viewSize.height / ciImageSize.height)
                let offsetX = (viewSize.width - ciImageSize.width * scale) / 2 
                let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
                faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
                faceViewBounds.x += offsetX
                faceViewBounds.y += offsetY
                let point = CGPoint(x: faceViewBounds.x, y: faceViewBounds.y)
                leftEyeCircle.frame.size = CGSize(width: 5, height: 5)
                leftEyeCircle.center = point
                leftEyeCenter = point
                leftEyeCircle.layer.cornerRadius = leftEyeCircle.frame.size.width / 2
                leftEyeCircle.layer.borderWidth = 2
                leftEyeCircle.layer.borderColor = UIColor.red.cgColor
                leftEyeCircle.backgroundColor = UIColor.clear
                myImage.addSubview(leftEyeCircle)
            }
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
                var faceViewBounds = face.rightEyePosition.applying(transform)
                let viewSize = myImage.bounds.size
                let scale = min(viewSize.width / ciImageSize.width, viewSize.height / ciImageSize.height)
                let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
                let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
                faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
                faceViewBounds.x += offsetX
                faceViewBounds.y += offsetY
                let point = CGPoint(x: faceViewBounds.x, y: faceViewBounds.y)
                rightEyeCircle.frame.size = CGSize(width: 5, height: 5)
                rightEyeCircle.center = point
                rightEyeCenter = point
                rightEyeCircle.layer.cornerRadius = leftEyeCircle.frame.size.width / 2
                rightEyeCircle.layer.borderWidth = 2
                rightEyeCircle.layer.borderColor = UIColor.red.cgColor
                rightEyeCircle.backgroundColor = UIColor.clear
                myImage.addSubview(rightEyeCircle)
            }
        }
    }
}



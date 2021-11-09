//
//  UpgradeSuccessfulViewController.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 09.11.21.
//

import UIKit

class UpgradeSuccessfulViewController: UIViewController {

    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeExplanationLabel: UILabel!
    @IBOutlet weak var getStartedButton: FredKitButton!
    
    @objc static var viewController: UpgradeSuccessfulViewController {
        return UpgradeSuccessfulViewController(nibName: "UpgradeSuccessfulViewController", bundle: Bundle.module)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        activeLabel.text = "\(FredKitSubscriptionManager.shared.proTitle!) Active"
        activeExplanationLabel.text = "You now have access to all Pro features! On top of that, you‘re supporting the further development of \(UIApplication.shared.appName)!"
        
        let attributedString = NSAttributedString(string: "Let‘s get started", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ])
        getStartedButton.setAttributedTitle(attributedString, for: .normal)
        // Do any additional setup after loading the view.
    }

    @IBAction func getStarted(_ sender: Any) {
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn) {
            self.getStartedButton.alpha = 0.0
        }
        
        

        
        if #available(iOS 13.0, *) {
            self.showFireworks()
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
        
    }
    
    @available(iOS 13.0, *)
    func showFireworks() {
        
        let size = self.view.bounds
        let host = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        host.backgroundColor = UIColor.clear
        
        self.view.addSubview(host)

        let particlesLayer = CAEmitterLayer()
        particlesLayer.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        particlesLayer.backgroundColor = UIColor.clear.cgColor
        particlesLayer.isOpaque = false

        host.layer.addSublayer(particlesLayer)
        host.layer.masksToBounds = true
        host.layer.backgroundColor = UIColor.clear.cgColor
        host.layer.isOpaque = false

        particlesLayer.emitterShape = .point
        particlesLayer.emitterPosition = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height)
        particlesLayer.emitterSize = CGSize(width: 0.0, height: 0.0)
        particlesLayer.emitterMode = .outline
        particlesLayer.renderMode = .additive


        let cell1 = CAEmitterCell()

        cell1.name = "Parent"
        cell1.birthRate = 5.0
        cell1.lifetime = 4.5
        cell1.velocity = 340.0
        cell1.velocityRange = 100.0
        cell1.yAcceleration = 10.0
        cell1.emissionLongitude = -90.0 * (.pi / 180.0)
        cell1.emissionRange = 45.0 * (.pi / 180.0)
        cell1.scale = 0.0
        cell1.color = UIColor.systemBlue.cgColor
        cell1.redRange = 0.9
        cell1.greenRange = 0.9
        cell1.blueRange = 0.9



        let image1_1 = UIImage(named: "Spark", in: Bundle.module, with: nil)?.cgImage

        let subcell1_1 = CAEmitterCell()
        subcell1_1.contents = image1_1
        subcell1_1.name = "Trail"
        subcell1_1.birthRate = 45.0
        subcell1_1.lifetime = 0.5
        subcell1_1.beginTime = 0.01
        subcell1_1.duration = 1.7
        subcell1_1.velocity = 80.0
        subcell1_1.velocityRange = 100.0
        subcell1_1.xAcceleration = 100.0
        subcell1_1.yAcceleration = 350.0
        subcell1_1.emissionLongitude = -360.0 * (.pi / 180.0)
        subcell1_1.emissionRange = 22.5 * (.pi / 180.0)
        subcell1_1.scale = 0.5
        subcell1_1.scaleSpeed = 0.13
        subcell1_1.alphaSpeed = -0.7
        subcell1_1.color = UIColor.systemBlue.cgColor



        let image1_2 = UIImage(named: "Spark", in: Bundle.module, with: nil)?.cgImage

        let subcell1_2 = CAEmitterCell()
        subcell1_2.contents = image1_2
        subcell1_2.name = "Firework"
        subcell1_2.birthRate = 20000.0
        subcell1_2.lifetime = 15.0
        subcell1_2.beginTime = 1.6
        subcell1_2.duration = 0.1
        subcell1_2.velocity = 190.0
        subcell1_2.yAcceleration = 80.0
        subcell1_2.emissionRange = 360.0 * (.pi / 180.0)
        subcell1_2.spin = 114.6 * (.pi / 180.0)
        subcell1_2.scale = 0.1
        subcell1_2.scaleSpeed = 0.09
        subcell1_2.alphaSpeed = -0.7
        subcell1_2.color = UIColor.white.cgColor

        cell1.emitterCells = [subcell1_1, subcell1_2]

        particlesLayer.emitterCells = [cell1]


    }
    
}

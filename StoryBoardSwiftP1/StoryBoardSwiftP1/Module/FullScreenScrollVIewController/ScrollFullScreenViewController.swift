//
//  ScrollFullScreenViewController.swift
//  StoryBoardSwiftP1
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class ScrollFullScreenViewController: UIViewController {
    
    @IBAction func HalfScrollButton(_ sender: Any) {
        let vc = HalfScreenScrollViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

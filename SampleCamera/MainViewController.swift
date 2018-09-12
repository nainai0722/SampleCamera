//
//  MainViewController.swift
//  SampleCamera
//
//  Created by Takashi Sawada on 2018/01/25.
//  Copyright © 2018年 Takashi Sawada. All rights reserved.
//

import UIKit

// UIImagePickerControllerDelegate,UINavigationControllerDelegateを追加しておく
class MainViewController: UIViewController, FilterListViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedIndex : Int = 0
    var selectedStr : String = ""
    func FilterListViewController(_ controller: FilterListViewController, didSelectFilter strfilter: String, index: Int) {
        selectedIndex = index
        selectedStr = strfilter
        if strfilter.isEmpty {
             selectedIndex = 0
            
            myImageView.image = myImage
            
            return
        }
        
        let selectedFilter : CIFilter = CIFilter(name: selectedStr)!
 
        let ciImage : CIImage = CIImage(image: myImage!)!
        
        selectedFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filteredImage : CIImage = selectedFilter.outputImage{
            
            let context = CIContext(options: nil)
            
            let cgiImage = context.createCGImage(filteredImage, from: filteredImage.extent)
            
            let image = UIImage(cgImage: cgiImage!, scale: UIScreen.main.scale, orientation:  myImage.imageOrientation)
            
            myImageView.image = image
        }
    }
    

    @IBOutlet weak var myImageView: UIImageView!    // 追加したアウトレット
    @IBOutlet weak var myLabel: UILabel!    // 追加したアウトレット
    
    var myImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoveFilterListView"{
            let controller: FilterListViewController = segue.destination as! FilterListViewController
            
            controller.delegate = self
            
            controller.selectedIndex = selectedIndex
        }
    }
    
    // MARK: -
    @IBAction func onCameraButtonTapped(_ sender: UIBarButtonItem) {
        let controller: UIAlertController = UIAlertController(title: "", message: "どの方法で写真を読み込みますか？", preferredStyle: UIAlertControllerStyle.actionSheet)
        // 1つ目の選択肢
        controller.addAction(UIAlertAction(title: "写真を撮影する", style: UIAlertActionStyle.default, handler: { (action) in
            self.selectedCamera()
        }))
        // 2つめの選択肢
        controller.addAction(UIAlertAction(title: "カメラロールから読み込む", style: UIAlertActionStyle.default, handler: { (action) in
            self.selectedLibrary()
        }))
        // キャンセルボタンを用意。自動的に用意されるわけではないので、手動で追加する
        controller.addAction(UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:nil))
        // UIAlertControllerを表示する
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonTapped(_ sender: UIBarButtonItem) {
        
        if myImageView.image == nil {
            let controller: UIAlertController = UIAlertController(title: "", message: "写真が選ばれていません", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(myImageView.image!, self, #selector(self.showResultSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func onEditButtonTapped(_ sender: UIBarButtonItem) {
        if myImageView.image == nil {
            let controller : UIAlertController = UIAlertController(title: "", message:"写真が選ばれていません。まず右下のボタンから写真を読み込んでください", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            return
        }
        self.performSegue(withIdentifier: "MoveFilterListView", sender: nil)
    }
    @objc func showResultSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer){
        var title:String = "保存完了！"
        var message:String = "カメラロールに画像を保存しました"
        
        if error != nil {
            title = "エラー"
            message = "保存失敗"
        }
        
        let controller: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 撮影、選択した写真が正しく取得できたかをチェック
        // UIImagePickerControllerOriginalImageで取得した写真を取り出せる
        if let editedImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // UIImageViewに画像をセット
            myImageView.image = editedImage
            // オリジナルデータをセット
            myImage = editedImage
            
            selectedIndex = 0
        }
        // 画像が正しく表示されるようであれば、注意書きを消す
        if myImageView.image != nil {
            myLabel.isHidden = true
        }
        // UIImagePickerControllerを閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    func selectedCamera() {
        // カメラが使用できるかをチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            // UIImagePickerControllerのインスタンスを生成
            let picker:UIImagePickerController = UIImagePickerController()
            
            // カメラを起動する
            picker.sourceType = UIImagePickerControllerSourceType.camera
            
            // UIImagePickerControllerDelegateを自身に設定
            picker.delegate = self
            
            // UIImagePickerController（カメラ画面）を表示
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func selectedLibrary() {
        // 写真のライブラリが読み込めるかをチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            // UIImagePickerControllerのインスタンスを生成
            let picker:UIImagePickerController = UIImagePickerController()
            
            // カメラロールから写真を読み込む
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            // UIImagePickerControllerDelegateを自身に設定
            picker.delegate = self
            
            // UIImagePickerController（写真の読み込み画面）を表示
            self.present(picker, animated: true, completion: nil)
        }
    }
}

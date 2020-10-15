//
//  FileViewController.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 24.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import UIKit
import WebKit
import AVKit

final class FileViewController: UIViewController, WKNavigationDelegate, AVPlayerViewControllerDelegate {
    
    var presenter : ViewToFilePresenterProtocol?
    
    fileprivate let playerController = AVPlayerViewController()
    fileprivate var audioPlayer = AVAudioPlayer()
    fileprivate var videoPlayer = AVPlayer()
    
    fileprivate let startAudio = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    fileprivate let stopAudio = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fileProcessing()
        playerController.delegate = self
    }
}

extension FileViewController : PresenterToFileViewProtocol{
    
    func openFile (fileType: String, fileURL: URL, fileName : String){
        
        switch fileType {
        case "pdf":
            document(fileURL: fileURL, fileName : fileName, fileType : fileType)
        case "png", "heic", "webp", "bmp", "gif", "jpe", "jpeg", "jpg", "svg", "tif", "tiff":
            image(fileURL: fileURL, fileName : fileName)
        case "webm","mp2","mpa","mpe","mpeg","mpg","mpv2","qt","mov","movie","flv","mp4","ts","3gp","3gpp","3gp2","3gpp2","avi","wmv":
            video(fileURL: fileURL, fileName : fileName, fileType: fileType)
        case "wma","mp3","m4a","ogg","wav":
            audio(fileURL: fileURL, fileName : fileName, fileType: fileType)
        default:
            view.backgroundColor = .white
            errorAlert(errorMessage : "Неизвестный формат файла \(fileName)!")
        }
    }
    
    private func image(fileURL : URL, fileName : String){
        let data = try? Data(contentsOf: fileURL)
        navigationItem.title = "\(fileName.lowercased())"
        view.backgroundColor = .white
        view.addBackground(imageData : data!)
    }
    
    private func video(fileURL : URL, fileName : String, fileType : String){
        view.backgroundColor = .black
        navigationItem.title = "\(fileName.lowercased())"
        videoPlayer = AVPlayer(url: fileURL)
        playerController.player = videoPlayer
        present(playerController, animated: true) {
            self.videoPlayer.play()
        }
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if playerViewController.isBeingDismissed {
            playerViewController.dismiss(animated: false) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func document(fileURL : URL, fileName : String, fileType : String){
        
        let webView: WKWebView!
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        navigationItem.title = "\(fileName.lowercased())"
        let data = try! Data(contentsOf: fileURL)
        DispatchQueue.main.async {
            webView.load(data, mimeType: "application/\(fileType)", characterEncodingName: "", baseURL: fileURL.deletingLastPathComponent())
        }
    }
    
    private func audio(fileURL : URL, fileName : String, fileType : String){
        view.backgroundColor = .white
        navigationItem.title = "\(fileName.lowercased())"
        startAudio.setImage(UIImage(named: "startPlayer_icon"), for: .normal)
        startAudio.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        stopAudio.setImage(UIImage(named: "stopPlayer_icon"), for: .normal)
        stopAudio.addTarget(self, action: #selector(stopAction), for: .touchUpInside)
        
        startAudio.center = self.view.center
        stopAudio.center = self.view.center
        
        self.view.addSubview(startAudio)
        self.view.addSubview(stopAudio)
        
        stopAudio.alpha = 1
        startAudio.alpha = 0
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.prepareToPlay()
        } catch {
            errorAlert(errorMessage : "Ошибка: Не получается произвести файл \(fileName)!")
        }
        audioPlayer.play()
    }
    
    @objc private func startAction()  {
        audioPlayer.play()
        stopAudio.alpha = 1
        startAudio.alpha = 0
    }
    
    @objc private func stopAction()  {
        audioPlayer.stop()
        stopAudio.alpha = 0
        startAudio.alpha = 1
    }
    
    override func willMove(toParent parent: UIViewController?)
    {
        super.willMove(toParent: parent)
        if parent == nil
        {
            audioPlayer.stop()
            clearCache()
        }
    }
    
    private func errorAlert(errorMessage : String){
        
        let alert = UIAlertController(title: "Ошибка!", message: "\(errorMessage)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func clearCache(){
        let cacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileManager = FileManager.default
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
            for file in directoryContents {
                do {
                    try fileManager.removeItem(at: file)
                }
                catch let error as NSError {
                    errorAlert(errorMessage : "Ошибка: \(error)")
                }
            }
        } catch let error as NSError {
            errorAlert(errorMessage : "Ошибка: \(error.localizedDescription)")
        }
    }
}

extension UIView {
    func addBackground(imageData : Data) {
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(data: imageData)
        
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFit
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }}

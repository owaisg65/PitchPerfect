//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Owais Gaffas on 12/03/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recodingLabel: UILabel!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI(isRecording: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func RecordAudio(_ sender: Any) {
        
        setUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: Stop Recoding
    
    @IBAction func stopRecoding(_ sender: Any) {
        setUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not seccessful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "stopRecording" else { return }
        guard let playSoundsVC = segue.destination as? PlaySoundsViewController else { return }
        guard let recordedAudioURL = sender as? URL else { return }
        playSoundsVC.recordedAudioURL = recordedAudioURL
        
    }
    
    // MARK: setUI
    
    func setUI(isRecording: Bool) {
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
        recodingLabel.text = isRecording ? "Recoding in Progress" : "Tap to Record..."
    }
}


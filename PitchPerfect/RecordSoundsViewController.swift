//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Peter Burgner on 3/28/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
   // MARK: class variables
    var audioRecorder: AVAudioRecorder!
    enum RecordingState {case startRecording, resetRecording}

    // MARK: IBOutlets
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: view functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(.resetRecording)
        self.navigationItem.title = "Record"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: recording functions
    @IBAction func recordAction(_ sender: Any) {
        configureUI(.startRecording)
        
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
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(.resetRecording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was unsuccessful")
        }
    }
    
    // MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let audioURL = sender as! URL
            playSoundsVC.recordedAudioURL = audioURL
        }
    }
    
    // MARK: UI functions
    func configureUI(_ recordingState: RecordingState) {
        switch(recordingState) {
        case .startRecording:
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            recordLabel.text = "Recording in Progress"
        case .resetRecording:
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordLabel.text = "Tap to Record"
        }
    }
    
}

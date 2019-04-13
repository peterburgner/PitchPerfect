//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Peter Burgner on 4/6/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit
import AVFoundation

    // MARK: PlaySoundsViewController: UIViewController

class PlaySoundsViewController: UIViewController {
 
    // MARK: IBOutlet
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopPlaybackButton: UIButton!
    
    // MARK: class variables
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    // MARK: playback button types
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    // MARK: sound functions
    
    @IBAction func playSound(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }

        configureUI(.playing)
    }
    
    @IBAction func stopPlayback(_ sender: Any) {
        stopAudio()
    }
    
    
    // MARK: view functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        self.navigationItem.title = "Choose Playback Effect"
        // elegant way to set contentMode for button (left in approach in Storyboard in addition to be able to review later)
        for button:UIButton in [slowButton, fastButton, highPitchButton, lowPitchButton, echoButton, reverbButton] {
            button.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
}

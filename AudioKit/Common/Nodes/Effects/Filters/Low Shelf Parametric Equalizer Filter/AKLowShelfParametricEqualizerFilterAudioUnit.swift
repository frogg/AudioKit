//
//  AKLowShelfParametricEqualizerFilterAudioUnit.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AVFoundation

public class AKLowShelfParametricEqualizerFilterAudioUnit: AKAudioUnitBase {

    func setParameter(_ address: AKLowShelfParametricEqualizerFilterParameter, value: Double) {
        setParameterWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    func setParameterImmediately(_ address: AKLowShelfParametricEqualizerFilterParameter, value: Double) {
        setParameterImmediatelyWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    var cornerFrequency: Double = 1000 {
        didSet { setParameter(.cornerFrequency, value: cornerFrequency) }
    }
    var gain: Double = 1.0 {
        didSet { setParameter(.gain, value: gain) }
    }
    var q: Double = 0.707 {
        didSet { setParameter(.Q, value: q) }
    }

    var rampTime: Double = 0.0 {
        didSet { setParameter(.rampTime, value: rampTime) }
    }

    public override func initDSP(withSampleRate sampleRate: Double,
                                 channelCount count: AVAudioChannelCount) -> UnsafeMutableRawPointer! {
        return createLowShelfParametricEqualizerFilterDSP(Int32(count), sampleRate)
    }

    override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let flags: AudioUnitParameterOptions = [.flag_IsReadable, .flag_IsWritable, .flag_CanRamp]

        let cornerFrequency = AUParameterTree.createParameter(
            withIdentifier: "cornerFrequency",
            name: "Corner Frequency (Hz)",
            address: AUParameterAddress(0),
            min: 12.0,
            max: 20000.0,
            unit: .hertz,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        let gain = AUParameterTree.createParameter(
            withIdentifier: "gain",
            name: "Gain",
            address: AUParameterAddress(1),
            min: 0.0,
            max: 10.0,
            unit: .generic,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        let q = AUParameterTree.createParameter(
            withIdentifier: "q",
            name: "Q",
            address: AUParameterAddress(2),
            min: 0.0,
            max: 2.0,
            unit: .generic,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        

        setParameterTree(AUParameterTree.createTree(withChildren: [cornerFrequency, gain, q]))
        cornerFrequency.value = 1000
        gain.value = 1.0
        q.value = 0.707
    }

    public override var canProcessInPlace: Bool { get { return true; }}

}
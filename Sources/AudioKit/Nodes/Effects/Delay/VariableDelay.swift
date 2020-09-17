// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// A delay line with cubic interpolation.
public class VariableDelay: Node, AKComponent, AKToggleable {

    public static let ComponentDescription = AudioComponentDescription(effect: "vdla")

    public typealias AKAudioUnitType = InternalAU

    public private(set) var internalAU: AKAudioUnitType?

    // MARK: - Parameters

    public static let timeDef = NodeParameterDef(
        identifier: "time",
        name: "Delay time (Seconds)",
        address: akGetParameterAddress("VariableDelayParameterTime"),
        range: 0 ... 10,
        unit: .seconds,
        flags: .default)

    /// Delay time (in seconds) This value must not exceed the maximum delay time.
    @Parameter public var time: AUValue

    public static let feedbackDef = NodeParameterDef(
        identifier: "feedback",
        name: "Feedback (%)",
        address: akGetParameterAddress("VariableDelayParameterFeedback"),
        range: 0 ... 1,
        unit: .generic,
        flags: .default)

    /// Feedback amount. Should be a value between 0-1.
    @Parameter public var feedback: AUValue

    // MARK: - Audio Unit

    public class InternalAU: AudioUnitBase {

        public override func getParameterDefs() -> [NodeParameterDef] {
            [VariableDelay.timeDef,
             VariableDelay.feedbackDef]
        }

        public override func createDSP() -> AKDSPRef {
            akCreateDSP("VariableDelayDSP")
        }

        public func setMaximumTime(_ maximumTime: AUValue) {
            akVariableDelaySetMaximumTime(dsp, maximumTime)
        }
    }

    // MARK: - Initialization

    /// Initialize this delay node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - time: Delay time (in seconds) This value must not exceed the maximum delay time.
    ///   - feedback: Feedback amount. Should be a value between 0-1.
    ///   - maximumTime: The maximum delay time, in seconds.
    ///
    public init(
        _ input: Node,
        time: AUValue = 0,
        feedback: AUValue = 0,
        maximumTime: AUValue = 5
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AKAudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            audioUnit.setMaximumTime(maximumTime)

            self.time = time
            self.feedback = feedback
        }
        connections.append(input)
    }
}

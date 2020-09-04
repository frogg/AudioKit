// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit
import XCTest

class AKPeakLimiterTests: XCTestCase {

    func testAttackDuration() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKPeakLimiter(input, attackDuration: 0.02)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

    func testDecayDuration() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKPeakLimiter(input, decayDuration: 0.03)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

    func testDefault() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKPeakLimiter(input)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

    func testParameters() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKPeakLimiter(input, attackDuration: 0.02, decayDuration: 0.03, preGain: 1)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

    func testPreGain() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKPeakLimiter(input, preGain: 1)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }
}

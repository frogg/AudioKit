// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit
import XCTest

class AKBandRejectButterworthFilterTests: XCTestCase {

    func testBandwidth() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKBandRejectButterworthFilter(input, bandwidth: 200)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

    func testCenterFrequency() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKBandRejectButterworthFilter(input, centerFrequency: 1_500)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

    func testDefault() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKBandRejectButterworthFilter(input)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

    func testParameters() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKBandRejectButterworthFilter(input, centerFrequency: 1_500, bandwidth: 200)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

}

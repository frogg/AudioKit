// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#include "SoundpipeDSPBase.h"
#include "ParameterRamper.h"
#include "soundpipe.h"

enum FlatFrequencyResponseReverbParameter : AUParameterAddress {
    FlatFrequencyResponseReverbParameterReverbDuration,
};

class FlatFrequencyResponseReverbDSP : public SoundpipeDSPBase {
private:
    sp_allpass *allpass0;
    sp_allpass *allpass1;
    float loopDuration = 0.1;
    ParameterRamper reverbDurationRamp;

public:
    FlatFrequencyResponseReverbDSP() {
        parameters[FlatFrequencyResponseReverbParameterReverbDuration] = &reverbDurationRamp;
    }

    void setLoopDuration(float duration) {
        loopDuration = duration;
        reset();
    }

    void init(int channelCount, double sampleRate) override {
        SoundpipeDSPBase::init(channelCount, sampleRate);
        sp_allpass_create(&allpass0);
        sp_allpass_init(sp, allpass0, loopDuration);
        sp_allpass_create(&allpass1);
        sp_allpass_init(sp, allpass1, loopDuration);
    }

    void deinit() override {
        SoundpipeDSPBase::deinit();
        sp_allpass_destroy(&allpass0);
        sp_allpass_destroy(&allpass1);
    }

    void reset() override {
        SoundpipeDSPBase::reset();
        if (!isInitialized) return;
        sp_allpass_init(sp, allpass0, loopDuration);
        sp_allpass_init(sp, allpass1, loopDuration);
    }

    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override {
        for (int frameIndex = 0; frameIndex < frameCount; ++frameIndex) {
            int frameOffset = int(frameIndex + bufferOffset);

            float reverbDuration = reverbDurationRamp.getAndStep();
            allpass0->revtime = reverbDuration;
            allpass1->revtime = reverbDuration;

            float *tmpin[2];
            float *tmpout[2];
            for (int channel = 0; channel < channelCount; ++channel) {
                float *in  = (float *)inputBufferLists[0]->mBuffers[channel].mData  + frameOffset;
                float *out = (float *)outputBufferList->mBuffers[channel].mData + frameOffset;
                if (channel < 2) {
                    tmpin[channel] = in;
                    tmpout[channel] = out;
                }
                if (!isStarted) {
                    *out = *in;
                    continue;
                }

                if (channel == 0) {
                    sp_allpass_compute(sp, allpass0, in, out);
                } else {
                    sp_allpass_compute(sp, allpass1, in, out);
                }
            }
        }
    }
};

AK_API void akFlatFrequencyResponseSetLoopDuration(DSPRef dspRef, float duration) {
    auto dsp = dynamic_cast<FlatFrequencyResponseReverbDSP *>(dspRef);
    assert(dsp);
    dsp->setLoopDuration(duration);
}

AK_REGISTER_DSP(FlatFrequencyResponseReverbDSP)
AK_REGISTER_PARAMETER(FlatFrequencyResponseReverbParameterReverbDuration)


#include "CineBroadcasterPipeline.h"

#include <videocore/rtmp/RTMPSession.h>
#include <videocore/transforms/RTMP/AACPacketizer.h>
#include <videocore/transforms/RTMP/H264Packetizer.h>
#include <videocore/transforms/Split.h>

#include <videocore/mixers/Apple/AudioMixer.h>
#include <videocore/sources/iOS/CameraSource.h>
#include <videocore/sources/iOS/MicSource.h>
#include <videocore/mixers/iOS/GLESVideoMixer.h>
#include <videocore/transforms/iOS/AACEncode.h>
#include <videocore/transforms/iOS/H264Encode.h>

namespace Broadcaster {
    
    void
    CineBroadcasterPipeline::startRtmpSession(std::string uri, int frameWidth, int frameHeight, int bitRate, int fps,
                                              int channelCount, int sampleRateHz)
    {

        m_outputSession.reset(new videocore::RTMPSession(uri, [=](videocore::RTMPSession& session, ClientState_t state) {
            
            switch(state) {
                    
                case kClientStateSessionStarted:
                {
                    std::cout << "RTMP Started\n";
                    this->m_state = kSessionStateStarted;
                    this->setupGraph(frameWidth, frameHeight, fps, bitRate, channelCount, sampleRateHz);
                    this->m_callback(kSessionStateStarted) ;
                }
                    break;
                case kClientStateError:
                {
                    std::cout << "RTMP Error\n";
                    m_state = kSessionStateError;
                    this->m_callback(kSessionStateError);
                }
                    break;
                case kClientStateNotConnected:
                {
                    std::cout << "RTMP Ended\n";
                    m_state = kSessionStateEnded;
                    this->m_callback(kSessionStateEnded);
                }
                    break;
                default:
                    break;
            }
            
        }) );
        videocore::RTMPSessionParameters_t sp(0.);
        
        sp.setData(frameWidth, frameHeight, 1. / static_cast<double>(fps), bitRate, 44100);
        
        m_outputSession->setSessionParameters(sp);
    }
    
    void
    CineBroadcasterPipeline::setupGraph(int frameWidth, int frameHeight, int fps, int bitRate,
                                        int channelCount, int sampleRateHz)
    {
        m_audioTransformChain.clear();
        m_videoTransformChain.clear();
        
        {
            // Add audio mixer
            // int outChannelCount, int outFrequencyInHz, int outBitsPerChannel, double frameDuration
            const double aacPacketTime = 1024. / sampleRateHz;
            addTransform(m_audioTransformChain,
                         std::make_shared<videocore::Apple::AudioMixer>(channelCount, sampleRateHz, 16, aacPacketTime));
        }
        {
            // Add video mixer
            auto mixer = std::make_shared<videocore::iOS::GLESVideoMixer>(frameWidth, frameHeight, 1. / static_cast<double>(fps));
            addTransform(m_videoTransformChain, mixer);
        }
        {
            // Add splits
            // Splits would be used to add different graph branches at various stages. For example, if you wish to record an
            // MP4 file while streaming to RTMP.
            auto videoSplit = std::make_shared<videocore::Split>();
            m_videoSplit = videoSplit;
            addTransform(m_videoTransformChain, videoSplit);
        }
        
        if(m_pbOutput) {
            m_videoSplit->setOutput(m_pbOutput);
        }
        
        {
            // Add encoders
            addTransform(m_audioTransformChain, std::make_shared<videocore::iOS::AACEncode>(sampleRateHz, channelCount));
            addTransform(m_videoTransformChain, std::make_shared<videocore::iOS::H264Encode>(frameWidth, frameHeight, fps, bitRate));
        }
        
        addTransform(m_audioTransformChain, std::make_shared<videocore::rtmp::AACPacketizer>());
        addTransform(m_videoTransformChain, std::make_shared<videocore::rtmp::H264Packetizer>());
        
        m_videoTransformChain.back()->setOutput(this->m_outputSession);
        m_audioTransformChain.back()->setOutput(this->m_outputSession);
        
        const auto epoch = std::chrono::steady_clock::now();
        for(auto it = m_videoTransformChain.begin() ; it != m_videoTransformChain.end() ; ++it) {
            (*it)->setEpoch(epoch);
        }
        for(auto it = m_audioTransformChain.begin() ; it != m_audioTransformChain.end() ; ++it) {
            (*it)->setEpoch(epoch);
        }
        
        
        // Create sources
        {   
            // Add camera source
            m_cameraSource = std::make_shared<videocore::iOS::CameraSource>(frameWidth/2, frameHeight/2, frameWidth, frameHeight, frameWidth, frameHeight, float(frameWidth) / float(frameHeight));
            std::dynamic_pointer_cast<videocore::iOS::CameraSource>(m_cameraSource)->setupCamera(fps, false);
            m_cameraSource->setOutput(m_videoTransformChain.front());
            std::dynamic_pointer_cast<videocore::iOS::CameraSource>(m_cameraSource)->setAspectMode(videocore::iOS::CameraSource::kAspectFill);
        }
        {
            // Add mic source
            m_micSource = std::make_shared<videocore::iOS::MicSource>();
            m_micSource->setOutput(m_audioTransformChain.front());
        }
    }

    void
    CineBroadcasterPipeline::addTransform(std::vector<std::shared_ptr<videocore::ITransform> > &chain, std::shared_ptr<videocore::ITransform> transform)
    {
        if( chain.size() > 0 ) {
            chain.back()->setOutput(transform);
        }
        chain.push_back(transform);
    }

    void
    CineBroadcasterPipeline::setPBCallback(CinePixelBufferCallback callback)
    {
        if(m_videoSplit && m_pbOutput) {
            m_videoSplit->removeOutput(m_pbOutput);
        }
        m_pbOutput = std::make_shared<CinePixelBufferOutput>(callback);
        if(m_videoSplit) {
            m_videoSplit->setOutput(m_pbOutput);
        }
    }
};
#include <videocore/transforms/IOutputSession.hpp>
#include <videocore/transforms/ITransform.hpp>
#include <videocore/sources/ISource.hpp>
#include <videocore/mixers/IMixer.hpp>
#include <videocore/transforms/Split.h>

#include "CinePixelBufferOutput.h"

#include <vector>

#ifndef __sample__CinePipeline_h
#define __sample__CinePipeline_h


namespace Broadcaster {
 
    enum SessionState {
        kSessionStateNone,
        kSessionStateStarted,
        kSessionStateEnded,
        kSessionStateError
    } ;
    
    using SessionStateCallback = std::function<void(SessionState state)>;
    
    class CineBroadcasterPipeline {
        public:
            CineBroadcasterPipeline(SessionStateCallback callback) : m_callback(callback) {};
            CineBroadcasterPipeline() {};

            
            void setPBCallback(CinePixelBufferCallback callback) ;
            
            // Starting a new session will end the current session.
            void startRtmpSession(std::string uri, int frame_w, int frame_h, int bitrate, int fps, int channelCount, int sampleRateHz);
            
            
        private:
            void setupGraph(int frame_w, int frame_h, int fps, int bitrate, int channelCount, int sampleRateHz);
            void addTransform(std::vector< std::shared_ptr<videocore::ITransform> > & chain, std::shared_ptr<videocore::ITransform> transform);
            
        private:
            std::shared_ptr<CinePixelBufferOutput> m_pbOutput;
            std::shared_ptr<videocore::ISource> m_micSource;
            std::shared_ptr<videocore::ISource> m_cameraSource;
            std::shared_ptr<videocore::Split> m_videoSplit;
            
            std::vector< std::shared_ptr<videocore::ITransform> > m_audioTransformChain;
            std::vector< std::shared_ptr<videocore::ITransform> > m_videoTransformChain;
            
            std::shared_ptr<videocore::IOutputSession> m_outputSession;
            
            SessionStateCallback m_callback;
            
            SessionState m_state;
    };
}

#endif
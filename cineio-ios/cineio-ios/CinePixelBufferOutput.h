#ifndef __Broadcaster__CinePixelBufferOutput__
#define __Broadcaster__CinePixelBufferOutput__

#include <iostream>
#include <videocore/transforms/IOutput.hpp>

namespace Broadcaster {
    
    using CinePixelBufferCallback = std::function<void(const uint8_t* const data, size_t size)> ;
    
    class CinePixelBufferOutput : public videocore::IOutput
    {
    public:
        CinePixelBufferOutput(CinePixelBufferCallback callback) ;
        
        void pushBuffer(const uint8_t* const data, size_t size, videocore::IMetadata& metadata) ;
        
    private:
        
        CinePixelBufferCallback m_callback;
    };
}
#endif /* defined(__Broadcaster__CinePixelBufferOutput__) */

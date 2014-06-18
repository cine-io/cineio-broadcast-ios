#include "CinePixelBufferOutput.h"

namespace Broadcaster {
 
    CinePixelBufferOutput::CinePixelBufferOutput(CinePixelBufferCallback callback)
    : m_callback(callback)
    {
        
    }
    
    void
    CinePixelBufferOutput::pushBuffer(const uint8_t *const data, size_t size, videocore::IMetadata &metadata)
    {
        if(m_callback) {
            m_callback(data, size);
        }
    }
}

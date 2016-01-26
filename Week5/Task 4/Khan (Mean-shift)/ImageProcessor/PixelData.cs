using System;
using System.Collections.Generic;
using System.Text;

namespace ImageProcessor
{
    public struct BGRA
    {
        public byte blue;
        public byte green;
        public byte red;
        public byte alpha;
    }
    public struct PixelData
    {
        public float Ch1;
        public float Ch2;
        public float Ch3;

        public PixelData(float channel1, float channel2, float channel3)
        {
            Ch1 = channel1;
            Ch2 = channel2;
            Ch3 = channel3;
        }
    }
}

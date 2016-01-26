using System;
using System.Collections.Generic;
using System.Text;

namespace ImageProcessor
{
    public unsafe class Colour
    {
        public enum Types { RGB, HSV, HSV2, IHLS, NRGB, RGI, HCL, LAB, HSI, XYZ, YIQ, InvariantRGB, YCbCr, HSV36, OpponentAxes };

        public static PixelData GetPixelData(BGRA* pixel, Types model)
        {
            PixelData pd = new PixelData(0, 0, 0);
            switch (model)
            {
                case Types.RGB:
                    pd.Ch1 = pixel->red;
                    pd.Ch2 = pixel->green;
                    pd.Ch3 = pixel->blue;
                    break;
                default:
                    throw new Exception("Conversion not implemented");
            }
            return pd;
        }
        
    }
}

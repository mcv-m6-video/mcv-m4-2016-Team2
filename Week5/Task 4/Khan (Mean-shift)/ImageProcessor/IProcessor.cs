using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

using Statistic;

namespace ImageProcessor
{
    public interface IProcessor
    {
        Histogram Create1DHistogram(Bitmap bitmap, int numBinsCh1, int numBinsCh2, int numBinsCh3, Rectangle targetRoi, Rectangle searchRoi);
        
    }
}

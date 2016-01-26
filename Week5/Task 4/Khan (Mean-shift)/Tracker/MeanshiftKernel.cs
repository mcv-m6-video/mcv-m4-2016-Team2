using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

using UIGraphic;
using ImageProcessor;

namespace Tracker
{
    public class MeanshiftKernel : Meanshift, ITracker
    {
        #region ITracker Members

        public MeanshiftKernel()
        {
            _imgProc = new KernelProcessor();    
        }

        public override void CreateTargetModel(Bitmap bitmap, int binCountCh1, int binCountCh2, int binCountCh3, Window targetRoi, Window searchRoi)
        {
            base.CreateTargetModel(bitmap, binCountCh1, binCountCh2, binCountCh3, targetRoi, searchRoi);
        }

        public override void Track(Bitmap bitmap, out Window targetRoi, out Window searchRoi, out Dictionary<string, string> information)
        {         
            base.Track(bitmap, out targetRoi, out searchRoi, out information);
        }

        public override Bitmap ProcessedImage
        {
            get { return _processedImage; }
        }

        #endregion
    }
}

using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

using Statistic;

namespace ImageProcessor
{
    public unsafe class KernelBgProcessor : IProcessor
    {
        public KernelBgProcessor() { }

        public Histogram Create1DHistogram(Bitmap bitmap, int numBinsCh1, int numBinsCh2, int numBinsCh3, Rectangle targetRoi, Rectangle searchRoi)
        {
            Bitmap bmp = (Bitmap)bitmap.Clone(searchRoi, bitmap.PixelFormat);
            Histogram histFg = new Histogram(numBinsCh1, numBinsCh2, numBinsCh3);
            Histogram histBg = new Histogram(numBinsCh1, numBinsCh2, numBinsCh3);
            float total = 0;
            int idx = 0;

            //Find centre image
            int Xc = bmp.Width / 2;
            int Yc = bmp.Height / 2;
            //Get window width & height
            int roiWidth = bmp.Width;
            int roiHeight = bmp.Height;
            float kernelDistance = 0;
            float kernelValue = 0;
            //Normalised Space coordinates
            float Xn = 0;
            float Yn = 0;


            UnsafeBitmap fastBitmap = new UnsafeBitmap(bmp);
            fastBitmap.LockBitmap();
            Point size = fastBitmap.Size;

            for (int y = 0; y < size.Y; y++)
            {
                BGRA* pPixel = fastBitmap[0, y];
                for (int x = 0; x < size.X; x++)
                {
                    //Find the normalised X & Y coordinates
                    Xn = (float)2 * (x - Xc) / roiWidth;
                    Yn = (float)-2 * (y - Yc) / roiHeight;

                    //Find the weight for the Coordinate by applying the Kernel 					
                    kernelDistance = (float)Math.Sqrt(Math.Pow(Xn, 2) + Math.Pow(Yn, 2));

                    if (Math.Pow(kernelDistance, 2) < 1)
                        kernelValue = (float)(2 * (1 - kernelDistance) / Math.PI);
                    else
                        kernelValue = 0;

                    //get the bin index for the current pixel colour
                    idx = _imgProc.GetSingleBinIndex(numBinsCh1, numBinsCh2, numBinsCh3, pPixel);
                    
                    //separate background and forground
                    if ((x >= targetRoi.Left) && (x <= targetRoi.Right) &&
                        (y >= targetRoi.Bottom) && (y <= targetRoi.Top))
                    {
                        //background
                        histBg.Data[idx] += kernelValue;                        
                    }
                    else
                    {
                        //forground
                        histFg.Data[idx] += kernelValue;                        
                    }

                    //increment the pointer
                    pPixel++;
                }
            }

            fastBitmap.UnlockBitmap();

            //Weight background
            float hMin = histBg.MinimumNonZero;
            float hVal = 0;
            int count = 0;
            for (count = 0; count < histBg.Data.Length; count++)
            {
                hVal = (histBg.Data[count] != 0) ? hMin / histBg.Data[count] : 1;
                hVal = (hVal > 1) ? 1 : hVal;

                histBg.Data[count] = hVal;
            }

            //Weight the forground with background
            total = 0;
            for (count = 0; count < histFg.Data.Length; count++)
            {
                histFg.Data[count] = histFg.Data[count] * histBg.Data[count];
                total += histFg.Data[count];
            }

            //Normalise
            if (total > 0)
                histFg.Normalise(total);
            
            return histFg;
        }

        public void SetTargetRoi(Rectangle roi)
        {
            _targetRoi = roi;
        }

        private Processor _imgProc = new Processor();
        private Rectangle _targetRoi;
    }
}

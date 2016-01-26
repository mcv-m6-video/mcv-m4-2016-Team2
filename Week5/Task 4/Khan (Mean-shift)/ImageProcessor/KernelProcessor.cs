using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

using Statistic;

namespace ImageProcessor
{
    public unsafe class KernelProcessor : IProcessor
    {
        public KernelProcessor(){}

        public Histogram Create1DHistogram(Bitmap bitmap, int numBinsCh1, int numBinsCh2, int numBinsCh3, Rectangle targetRoi, Rectangle searchRoi)
        {
            //ingore searchRoi
            Bitmap bmp = (Bitmap)bitmap.Clone(targetRoi, bitmap.PixelFormat);
            Histogram hist = new Histogram(numBinsCh1, numBinsCh2, numBinsCh3);
            int idx = 0;
            //Find centre image
            int Xc = bmp.Width / 2;
            int Yc = bmp.Height / 2;
            //Get window width & height
            int roiWidth = bmp.Width;
            int roiHeight = bmp.Height;
            float kernelDistance = 0;
            float kernelValue = 0;
            float totalKernelValue = 0;
            //Normalised Space coordinates
            float Xn = 0;
            float Yn = 0;

            UnsafeBitmap fastBitmap = new UnsafeBitmap(bmp);
            fastBitmap.LockBitmap();
            Point size = fastBitmap.Size;
            BGRA* pPixel;

            for (int y = 0; y < size.Y; y++)
            {
                pPixel = fastBitmap[0, y];
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
                    hist.Data[idx] += kernelValue;
                    totalKernelValue += kernelValue;

                    //increment the pointer
                    pPixel++;
                }
            }

            fastBitmap.UnlockBitmap();

            //normalise
            if (totalKernelValue > 0)
                hist.Normalise(totalKernelValue);

            return hist;
        }

        private Processor _imgProc = new Processor();
    }
}

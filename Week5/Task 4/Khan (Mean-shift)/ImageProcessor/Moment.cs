using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

using Statistic;

namespace ImageProcessor
{
    public unsafe class Moment
    {
        public Moment() { }

        public Moment(Bitmap bitmap)
        {
            FindMoments(bitmap);
            FindParameters(bitmap);
            WriteParameters();
        }

        public float ZerothMoment { get { return _zerothMoment; } }
        public float FirstMomentX { get { return _firstMomentX; } }
        public float FirstMomentY { get { return _firstMomentY; } }
        public float SecondMomentX { get { return _secondMomentX; } }
        public float SecondMomentY { get { return _secondMomentY; } }
        public float FirstMomentXY { get { return _firstMomentXY; } }
        public int Length { get { return (int)_length; } }
        public int Width { get { return (int)_width; } }
        public float RollRadians { get { return _rollRad; } }
        public float ToRadians(float angle)
        {
            return (3.14160f /  180.0f) * angle; 
        }
        public float ToDegrees(float angle)
        {
            return (180.0f / 3.14160f) * angle; 
        }
        public Dictionary<string, string> Information
        {
            get { return _information; }
        }
        private void FindMoments(Bitmap bitmap)
        {
            UnsafeBitmap fastBitmap = new UnsafeBitmap(bitmap);
            fastBitmap.LockBitmap();
            Point size = fastBitmap.Size;

            for (int y = 0; y < size.Y; y++)
            {
                BGRA* pPixel = fastBitmap[0, y];
                for (int x = 0; x < size.X; x++)
                {
                    //Find moments - for backprojection image r, g, b intensities are the same
                    _firstMomentX += pPixel->red * x;
                    _firstMomentY += pPixel->red * y;
                    _secondMomentX += pPixel->red * x * x;
                    _secondMomentY += pPixel->red * y * y;
                    _firstMomentXY += pPixel->red * x * y;
                    _zerothMoment += pPixel->red;
            
                    //increment the pointer
                    pPixel++;
                }
            }

            fastBitmap.UnlockBitmap();

        }

        protected void FindParameters(Bitmap bitmap)
        {
            int Xc = bitmap.Width / 2;
            int Yc = bitmap.Height / 2;

            
            float a = (_secondMomentX / _zerothMoment) - (float)(Xc * Xc);
            float b = 2 * ((_firstMomentXY / _zerothMoment) - (float)(Xc * Yc));
            float c = (_secondMomentY / _zerothMoment) - (float)(Yc * Yc);
            float aplusc = a + c;
            float aminusc = a - c;
            float bacsqrt = (float)Math.Sqrt(b * b + aminusc * aminusc);

            _length = (float)Math.Sqrt((aplusc + bacsqrt) * 0.5);
            _width = (float)Math.Sqrt((aminusc + bacsqrt) * 0.5);

            _rollRad = (float)Math.Atan(2 * b / Math.Abs((a - c))) / 2;            
        }

        protected virtual void WriteParameters()
        {
            _information.Add("Zeroth Moment", ZerothMoment.ToString());
            _information.Add("First Moment X", FirstMomentX.ToString());
            _information.Add("First Moment Y", FirstMomentY.ToString());
            _information.Add("First Moment XY", FirstMomentXY.ToString());
            _information.Add("Second Moment X", SecondMomentX.ToString());
            _information.Add("Second Moment Y", SecondMomentY.ToString());
            _information.Add("Length", Length.ToString());
            _information.Add("Width", Width.ToString());
            _information.Add("Roll", ToDegrees(RollRadians).ToString());
        }

        protected float _length = 0;
        protected float _width = 0;
        protected float _rollRad = 0;
        protected float _zerothMoment = 0;
        protected float _firstMomentX = 0;
        protected float _firstMomentY = 0;
        protected float _secondMomentX = 0;
        protected float _secondMomentY = 0;
        protected float _firstMomentXY = 0;
        protected Dictionary<string, string> _information = new Dictionary<string, string>();
    }

    public unsafe class MSMoment : Moment
    {
        public MSMoment(Bitmap bitmap, Histogram target, Histogram candidate)
        {
            FindMoments(bitmap, target, candidate);
            //FindParameters(bitmap);
            //WriteParameters();
        }

        public MSMoment() { }
        public Bitmap CroppedImage
        {
            get { return _croppedBmp; }
            set { _croppedBmp = value; }
        }
        public Histogram CandidateHistogram
        {
            get { return _candidateHistogram; }
            set { _candidateHistogram = value; }
        }
        public Histogram TargetHistogram
        {
            get { return _targetHistogram; }
            set { _targetHistogram = value; }
        }
        public void FindMoments()
        {
            FindMoments(_croppedBmp, _targetHistogram, _candidateHistogram);
        }
        private void FindMoments(Bitmap croppedBitmap, Histogram target, Histogram candidate)
        {
            float weight = 0;
            
            UnsafeBitmap fastBitmap = new UnsafeBitmap(croppedBitmap);
            fastBitmap.LockBitmap();
            Point size = fastBitmap.Size;
            int idx = 0;
            
            for (int y = 0; y < size.Y; y++)
            {
                BGRA* pPixel = fastBitmap[0, y];
                for (int x = 0; x < size.X; x++)
                {
                    //find the bin index where the value of this colour falls
                    idx = _imgProc.GetSingleBinIndex(target.BinCount1, target.BinCount2, target.BinCount3, pPixel);
                    //find weight at this pixel location
                    weight = CreateValidWeight(target.Data[idx], candidate.Data[idx]);
                    
                    //find weighted moments
                    _firstMomentX += x * weight;
                    _firstMomentY += y * weight;
                    _secondMomentX += x * x * weight;
                    _secondMomentY += y * y * weight;
                    _firstMomentXY += x * y * weight;
                    _zerothMoment += weight;

                    //increment the pointer
                    pPixel++;
                }
            }

            fastBitmap.UnlockBitmap();

            
        }

        private float CreateValidWeight(float targetValue, float candidateValue)
        {
            float w = targetValue / candidateValue;

            if (float.IsNaN(w))//check 0/0
                w = 0;
            else if (float.IsInfinity(w))//check x/0
                w = (float)Math.Sqrt(targetValue);
            else
                w = (float)Math.Sqrt(w);

            return w;
        }

        Processor _imgProc = new Processor();
        private Bitmap _croppedBmp = null;
        private Histogram _targetHistogram = null;
        private Histogram _candidateHistogram = null;
    }
}

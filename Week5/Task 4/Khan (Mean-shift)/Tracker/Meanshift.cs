using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

using ImageProcessor;
using UIGraphic;
using Statistic;

namespace Tracker
{
    public class Meanshift : ITracker
    {
        public Meanshift()
        {
            _imgProc = new Processor(); //create image processor
        }

        #region ITracker Members

        public virtual void CreateTargetModel(Bitmap bitmap, int binCountCh1, int binCountCh2, int binCountCh3, Window targetRoi, UIGraphic.Window searchRoi)
        {
            _targetRoi = targetRoi;
            _searchRoi = searchRoi;

            //set previous centre values
            _previousCentreX = _targetRoi.CentreX;
            _previousCentreY = _targetRoi.CentreY;

            searchRoi.EnsureLimits(); //make sure it is not out of the picture
            
            //create target histogram
            _histTarget = _imgProc.Create1DHistogram(bitmap, binCountCh1, binCountCh2, binCountCh3, targetRoi.RegionOfInterest, _searchRoi.RegionOfInterest);
        }

        public virtual void Track(Bitmap bitmap, out Window targetRoi, out Window searchRoi, out Dictionary<string, string> information)
        {
            const int MEANSHIFT_ITERATIONS = 30;
            const int DISTANCE_ITERATIONS = 30;

            float bhatCoeff1 = 0;
            float bhatCoeff2 = 0;
            int dIterations = 0;
            int msIterations = 0;
            float distance = 0;
            Bitmap cropped = null;
            int centreX = _targetRoi.CentreX;
            int centreY = _targetRoi.CentreY;
                        
            //Limit the iterations to a fixed number to avoid performance degradation
            do
            {
                _searchRoi.EnsureLimits();
                //Find candidate model at the region of interest
                _histCand = _imgProc.Create1DHistogram(bitmap, _histTarget.BinCount1, _histTarget.BinCount2, _histTarget.BinCount3, _targetRoi.RegionOfInterest, _searchRoi.RegionOfInterest);

                //Get BC
                bhatCoeff1 = Metric.Evaluate(new BhattacharryyaCoefficient(_histTarget, _histCand));

                //Calculate moments                
                cropped = GetImageSection(bitmap, _targetRoi);//crop the region of interest                
                _moment = new MSMoment(cropped, _histTarget, _histCand);
                                
                //Find the new centre
                centreX = _targetRoi.RegionOfInterest.X + (int)(_moment.FirstMomentX / _moment.ZerothMoment);
                centreY = _targetRoi.RegionOfInterest.Y + (int)(_moment.FirstMomentY / _moment.ZerothMoment);
                
                //Move the roi & search window to the new centroid
                _targetRoi.Offset(centreX - _targetRoi.CentreX, centreY - _targetRoi.CentreY);
                _searchRoi.Offset(centreX - _searchRoi.CentreX, centreY - _searchRoi.CentreY);
                
                //Find candidate model at the new location
                _searchRoi.EnsureLimits();
                _histCand = _imgProc.Create1DHistogram(bitmap, _histTarget.BinCount1, _histTarget.BinCount2, _histTarget.BinCount3, _targetRoi.RegionOfInterest, _searchRoi.RegionOfInterest);

                //Get BC at the new location
                bhatCoeff2 = Metric.Evaluate(new BhattacharryyaCoefficient(_histTarget, _histCand));

                while ((bhatCoeff2 < bhatCoeff1) && (dIterations < DISTANCE_ITERATIONS))
                {
                    centreX = (int)Math.Ceiling(((float)(centreX + _previousCentreX)) / 2);
                    centreY = (int)Math.Ceiling(((float)(centreY + _previousCentreY)) / 2);

                    //Move ROI to the new location
                    _targetRoi.Offset(centreX - _targetRoi.CentreX, centreY - _targetRoi.CentreY);
                    _searchRoi.Offset(centreX - _searchRoi.CentreX, centreY - _searchRoi.CentreY);
                                        
                    //Find candidate model at the new location
                    _searchRoi.EnsureLimits();
                    _histCand = _imgProc.Create1DHistogram(bitmap, _histTarget.BinCount1, _histTarget.BinCount2, _histTarget.BinCount3, _targetRoi.RegionOfInterest, _searchRoi.RegionOfInterest);

                    //Get BC at the new location
                    bhatCoeff2 = Metric.Evaluate(new BhattacharryyaCoefficient(_histTarget, _histCand));

                    dIterations++;
                }

                //Calculate the distance between two vectors
                distance = (float)Math.Sqrt(Math.Pow((centreX - _previousCentreX), 2)
                    + Math.Pow((centreY - _previousCentreY), 2));

                _previousCentreX = centreX;
                _previousCentreY = centreY;

                msIterations++;

            } while ((distance >= 0.1) && (msIterations < MEANSHIFT_ITERATIONS));
                       
            //save info
            //_moment.Information.Clear();
            _moment.Information.Add("Meanshift Iterations: ", msIterations.ToString());
            _moment.Information.Add("Bhattacharyya Coeff: ", bhatCoeff2.ToString());

            //check validity
            if (centreX > 0 && centreY > 0)
            {
                //Move the roi & search window to the new centroid
                _targetRoi.Offset(centreX - _targetRoi.CentreX, centreY - _targetRoi.CentreY);
                _searchRoi.Offset(centreX - _searchRoi.CentreX, centreY - _searchRoi.CentreY);

                _moment.Information.Add("Centroid: ", _targetRoi.CentreX.ToString() + ", " + _targetRoi.CentreY.ToString());

                //_processedImage = Drawer.DrawMoment(bitmap, _moment, new Point(centreX, centreY));
                _processedImage = Drawer.DrawWindow(bitmap, _targetRoi, Color.Red);
                _processedImage = Drawer.DrawWindow(bitmap, _searchRoi, Color.Yellow);
            }

            //save ROIs for next frame
            targetRoi = _targetRoi;
            searchRoi = _searchRoi;
            information = _moment.Information;
        }

        public virtual Bitmap ProcessedImage
        {
            get { return _processedImage; }
        }

        #endregion

        private Bitmap GetImageSection(Bitmap bmp, Window roi)
        {
            roi.EnsureLimits(); //make sure it is not out of the picture
            //return _imgProc.Crop(bmp, roi.RegionOfInterest);
            return bmp.Clone(roi.RegionOfInterest, bmp.PixelFormat); //select the section            
        }

        protected IProcessor _imgProc = null;
        protected Bitmap _processedImage = null;
        private Histogram _histTarget = null;
        private Histogram _histCand = null;        
        private Window _targetRoi;
        private Window _searchRoi;
        private MSMoment _moment = new MSMoment();
        private int _previousCentreX = 0;
        private int _previousCentreY = 0;
    }
}

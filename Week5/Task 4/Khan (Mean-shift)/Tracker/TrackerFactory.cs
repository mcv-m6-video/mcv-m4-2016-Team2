using System;
using System.Collections.Generic;
using System.Text;

namespace Tracker
{
    public enum TrackerType { CENTROID, MEANSHIFT, MEANSHIFTKERNEL, MEANSHIFTKERNELBG }

    public class TrackerFactory
    {
        public TrackerFactory(TrackerType type)
        {
            _type = type;
            CreateTracker();
        }

        public ITracker Tracker
        {
            get 
            {
                if (_tracker == null)
                    CreateTracker();

                return _tracker; 
            }
        }

        private void CreateTracker()
        { //only single type for now
            switch (_type)
            {
                case TrackerType.CENTROID:
                    _tracker = new Centroid();
                    break;
                case TrackerType.MEANSHIFT:
                    _tracker = new Meanshift();
                    break;
                case TrackerType.MEANSHIFTKERNEL:
                    _tracker = new MeanshiftKernel();
                    break;
                case TrackerType.MEANSHIFTKERNELBG:
                    _tracker = new MeanshiftKernelBg();
                    break;
            }
        }

        ITracker _tracker = null;
        TrackerType _type = TrackerType.CENTROID; //default to Centroid Tracker
    }
}

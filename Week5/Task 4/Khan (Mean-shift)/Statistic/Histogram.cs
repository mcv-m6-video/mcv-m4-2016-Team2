using System;
using System.Collections.Generic;
using System.Text;

namespace Statistic
{
    public class Histogram
    {
        public Histogram(int binCount1, int binCount2, int binCount3)
        {
            _binCount1 = binCount1;
            _binCount2 = binCount2;
            _binCount3 = binCount3;

            _data = new float[binCount1 * binCount2 * binCount3];
        }

        public int BinCount1 { get { return _binCount1; } }
        public int BinCount2 { get { return _binCount2; } }
        public int BinCount3 { get { return _binCount3; } }

        public float[] Data
        {
            get { return _data; }
        }

        public void Normalise(float total)
        {
            for (int i = 0; i < _data.Length; i++)
            {
                _data[i] = _data[i] / total;
            }
        }

        public float FindMean()
        {
            float m = 0;

            for (int i = 0; i < _data.Length; i++)
            {
                m += _data[i];
            }

            return m / _data.Length;
        }

        public float MinimumNonZero
        {
            get
            {
                float m = 0;
                int count = 0;

                Array.Sort(_data);

                do
                {
                    m = _data[count];
                    count++;

                } while ((count < _data.Length) && (m == 0));

                return m;
            }
        }
        
        private float[] _data;
        private int _binCount1;
        private int _binCount2;
        private int _binCount3;
    }
}

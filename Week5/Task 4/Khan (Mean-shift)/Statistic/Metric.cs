using System;
using System.Collections.Generic;
using System.Text;

namespace Statistic
{
    public class Metric
    {
        public static float Evaluate(IMetric metric)
        {
            return metric.Evaluate();
        }        
    }

    public class BhattacharryyaCoefficient : IMetric
    {
        public BhattacharryyaCoefficient(Histogram hist1, Histogram hist2)
        {
            _hist1 = hist1;
            _hist2 = hist2;
        }

        #region IMetric Members

        public float Evaluate()
        {
            float coeff = 0;

            for (int i = 0; i < _hist1.Data.Length; i++)
            {
                coeff += (float)Math.Sqrt(_hist1.Data[i] * _hist2.Data[i]);                
            }

            return coeff;
        }

        #endregion

        Histogram _hist1 = null;
        Histogram _hist2 = null;
    }
}

using System;
using System.Drawing;
using System.Windows.Forms;
using System.Collections.Generic;

using UIGraphic;

namespace Tracker
{
	/// <summary>
	/// Summary description for ITracker.
	/// </summary>
	public interface ITracker
	{		
		void CreateTargetModel(Bitmap bitmap, int binCountCh1, int binCountCh2, int binCountCh3, Window targetRoi, Window searchRoi);

        void Track(Bitmap bitmap, out Window targetRoi, out Window searchRoi, out Dictionary<string, string> information);

        Bitmap ProcessedImage { get;}

        //Dictionary<string, string> Information { get;}        
	}

}

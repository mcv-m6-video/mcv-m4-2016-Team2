using System;
using System.Drawing;
using System.Drawing.Imaging;

using ImageProcessor;

namespace Tracker
{
	/// <summary>
	/// Summary description for MeanShift.
	/// </summary>
	public class MeanShift : ITracker
	{
		private const int MEANSHIFT_ITERATIONS = 15;

		private Model _targetModel = null;
		private Model _candidateModel = null;
		private Model _targetLModel = null;
		private Model _candidateLModel = null;
		private Model _targetBrightnessModel = null;
		private Model _candidateBrightnessModel = null;
		private Model _targetSaturationModel = null;
		private Model _candidateSaturationModel = null;
		private int _oldCentreX = 0;
		private int _oldCentreY = 0;
		int _imageWidth = 0;
		int _imageHeight = 0;
		int _roiWidth = 0;
		int _roiHeight = 0;
		int _roiSize = 0;
		int _previousTargetCentreX = 0;
		int _previousTargetCentreY = 0;	
		int _numberOfBins = 0;
		int _msIterations = 0;
		Bitmap _backProjImage = null;

		enum TrackingComponent {HUE, SATURATION, VALUE, RED, GREEN, BLUE};
		
		public MeanShift()
		{
		}

		public MeanShift(int numberOfBins)
		{
			_numberOfBins = numberOfBins;
			Processor.NumberOfBins = numberOfBins;
		}

		public Model TargetModel
		{
			get {return _targetModel;}
		}

		public Model CandidateModel
		{
			get {return _candidateModel;}
		}

		public Model TargetLModel
		{
			get {return _targetLModel;}
		}

		public Model CandidateLModel
		{
			get {return _candidateLModel;}
		}

		public int Iterations
		{
			get {return _msIterations;}
		}

		public Bitmap BackProjectionImage
		{
			get {return _backProjImage; }
		}

		public void CreateTargetModel(Bitmap bmp, Rectangle window)
		{			
			_imageWidth = bmp.Width;
			_imageHeight = bmp.Height;
			_roiWidth = window.Width;
			_roiHeight = window.Height;	

			_targetLModel = Processor.CreateHsModel(bmp, window);

			//PrintModel(_targetLModel, "target");
			//_targetLModel = Processor.CreateHueModel(bmp, window);			
			//_targetBrightnessModel = Processor.CreateValueModel(bmp, window);
			//_targetSaturationModel = Processor.CreateSaturationModel(bmp, window);

			//window = Track(bmp, window);
			_previousTargetCentreX = (int) Math.Ceiling((window.Left + window.Right) / 2);
			_previousTargetCentreY = (int) Math.Ceiling((window.Top + window.Bottom) / 2);	
			
			
		}

		protected int ImageWidth
		{
			get {return _imageWidth;}
		}

		protected int ImageHeight
		{
			get {return _imageHeight;}
		}

		protected int OldCentreX
		{
			get {return _oldCentreX;}
			set {_oldCentreX = value;}
		}

		protected int OldCentreY
		{
			get {return _oldCentreY;}
			set {_oldCentreY = value;}
		}

		protected int CentreX
		{
			get {return _previousTargetCentreX;}
			set {_previousTargetCentreX = value;}
		}

		protected int CentreY
		{
			get {return _previousTargetCentreY;}
			set {_previousTargetCentreY = value;}
		}

		protected int ROIWidth
		{
			get {return _roiWidth;}
			set {_roiWidth = value;}
		}

		protected int ROIHeight
		{
			get {return _roiHeight;}
			set {_roiHeight = value;}
		}

		protected int ROISize
		{
			get {return _roiSize;}
			set {_roiSize = value;}
		}



		protected void FindMeanshiftVector(Bitmap bmp, Rectangle window, float[,] probabilityMap, ref float meanshiftX, ref float meanshiftY, ref float zerothMoment)
		{
			zerothMoment = 0; //zeroth moment
			meanshiftX = 0; //first moment for x(col)
			meanshiftY = 0; //first moment for y(col)

			//Find zeroth moment
			for (int col=window.Left; col<window.Right; col++)
			{
				for (int row=window.Top; row<window.Bottom; row++)
				{
					zerothMoment += probabilityMap[row, col];
				}
			}
			//Find first moment for x(col) and y(row)
			for (int col=window.Left; col<window.Right; col++)
			{
				for (int row=window.Top; row<window.Bottom; row++)
				{
					meanshiftX += (float) (col * probabilityMap[row, col]);
					meanshiftY += (float) (row * probabilityMap[row, col]);
				}
			}
			//Find the new centroid
			//x is cols
			meanshiftX = (float) (meanshiftX / zerothMoment);
			//y is rows
			meanshiftY = (float) (meanshiftY / zerothMoment);

			meanshiftX = float.IsNaN(meanshiftX)? 0 : meanshiftX;
			meanshiftX = float.IsInfinity(meanshiftX) ? 0 : meanshiftX;	
			meanshiftY = float.IsNaN(meanshiftY)? 0 : meanshiftY;
			meanshiftY = float.IsInfinity(meanshiftY) ? 0 : meanshiftY;	
		}

		public virtual Rectangle Track(Bitmap bmp, Rectangle window)
		{
			//Meanshift vector
			float msX = 0;
			float msY = 0;
			float hueWeight = 0;
			float satWeight = 0;
			float valWeight = 0;
			float totalWeight = 0;
			//Colour value index
			int hueValue = 0;
			int satValue = 0;
			int valValue = 0;
			//Find the correct bin range
			int binRange = 256 / _numberOfBins;	
			
//			_previousTargetCentreX = 0;
//			_previousTargetCentreY = 0;
			_msIterations = 0;

			_backProjImage = (Bitmap) bmp.Clone();							
			
			//Limit the iterations to a fixed number to avoid performance degradation
			for (_msIterations=0; _msIterations<MEANSHIFT_ITERATIONS; _msIterations++)
			{
				//Find the new candidate model
				_candidateLModel = null;
				_candidateLModel = Processor.CreateHsModel(bmp, window);
				//_candidateBrightnessModel = Processor.CreateValueModel(bmp, window);
				//_candidateSaturationModel = Processor.CreateSaturationModel(bmp, window);
				//PrintModel(_candidateLModel, "candidate");

				//Crop the image for less processing time 
				Bitmap croppedBmp = bmp.Clone(new Rectangle(window.Left, window.Top, window.Right-window.Left, window.Bottom-window.Top),PixelFormat.Format24bppRgb);
				//croppedBmp.Save("Model\\cropped0.bmp", ImageFormat.Bmp);
				//string t = "Start X: " + _centreX.ToString() + " Y: " + _centreY.ToString() + "\r\n";;

				totalWeight = 0; //clean up the accumulating variables
				msX = 0;
				msY = 0;
				
				//Find meanshift vector
				for (int y=window.Top; y<window.Bottom; y++)
				{
					for (int x=window.Left; x<window.Right; x++)
					{
						//Get the colour value at this location which serves as an index to 
						//the bins	
						Processor.GetHsvComponents(croppedBmp, x-window.Left, y-window.Top, ref hueValue, ref satValue, ref valValue);
						
						//Processor.GetHsvComponents((Bitmap)bmp.Clone(), x, y, ref hueValue, ref satValue, ref valValue);
						
						//TODO - Should we take square root?
						hueWeight = (float) (_targetLModel.Bins.Item(hueValue / binRange).Value / _candidateLModel.Bins.Item(hueValue / binRange).Value);
						hueWeight = float.IsNaN(hueWeight) ? 0 : hueWeight;
						hueWeight = float.IsInfinity(hueWeight) ? 0 : hueWeight;
						
						satWeight = (float) (_targetLModel.Bins.Item(satValue / binRange).Value / _candidateLModel.Bins.Item(satValue / binRange).Value);
						satWeight = float.IsNaN(satWeight) ? 0 : satWeight;
						satWeight = float.IsInfinity(satWeight) ? 0 : satWeight;

//						valWeight = (float) Math.Sqrt(_targetLModel.Bins.Item(valValue / binRange).Value / _candidateLModel.Bins.Item(valValue / binRange).Value);
//						valWeight = float.IsNaN(valWeight) ? 0 : valWeight;
//						valWeight = float.IsInfinity(valWeight) ? 0 : valWeight;

						msX += x * (hueWeight + satWeight + valWeight);
						msY += y * (hueWeight + satWeight + valWeight);
						totalWeight += (hueWeight + satWeight + valWeight);

						hueWeight = (float) _targetLModel.Bins.Item(hueValue / binRange).Value / _candidateLModel.Bins.Item(hueValue / binRange).Value;
						hueWeight = float.IsNaN(hueWeight) ? 0 : hueWeight;
						hueWeight = float.IsInfinity(hueWeight) ? 0 : hueWeight;
						hueWeight = Math.Min(hueWeight * 255, 255);
						_backProjImage.SetPixel(x, y, Color.FromArgb((int)hueWeight,
							(int)hueWeight, (int)hueWeight));
				
					}
				}
				//Find the meanshift vector
				if (totalWeight > 1)
				{
					msX = msX / totalWeight;
					msY = msY / totalWeight;
					//return the new window based on the current centre
					//window = GetNewTargetWindow(window, msX, msY);
				}
//				if (Math.Sqrt(1-BhattacharyyaCoefficient) < 0.2)
//					break;
//				else
//				{
//					//Move the window's centre to the meanshift vector
//					window = GetNewTargetWindow(window, (int)Math.Ceiling(msX), (int)Math.Ceiling(msY));
//					//window.Offset((int) (_previousTargetCentreX - targetCentreX), (int) (_previousTargetCentreY - targetCentreY));
//					//update the centre value
//					_previousTargetCentreX = (int)Math.Ceiling(msX);
//					_previousTargetCentreY = (int)Math.Ceiling(msY);					
//				}
				//Check if the centre has not moved, then the target is localised and break
				if (Math.Abs(_previousTargetCentreX - (int)Math.Ceiling(msX)) == 0 && Math.Abs(_previousTargetCentreY - (int)Math.Ceiling(msY)) == 0)
					break;
				else
				{
					//Move the window's centre to the meanshift vector
					window = GetNewTargetWindow(window, (int)Math.Ceiling(msX), (int)Math.Ceiling(msY));
					//window.Offset((int) (_previousTargetCentreX - targetCentreX), (int) (_previousTargetCentreY - targetCentreY));
					//update the centre value
					_previousTargetCentreX = (int)Math.Ceiling(msX);
					_previousTargetCentreY = (int)Math.Ceiling(msY);					
				}
			}
			
			//t += "MS X: " + msX.ToString() + " Y: " + msY.ToString();
			//PrintWindow(t);

			//_backProjImage = Processor.OverlayWindow(_backProjImage, window, Color.Yellow);
				
			return window;
		}

		public float BhattacharyyaCoefficient
		{
			get
			{
				float coeff = 0;
				for (int i=0; i<_targetLModel.Bins.Count; i++)
				{
					coeff += (float) Math.Sqrt(_targetLModel.Bins.Item(i).Value * _candidateLModel.Bins.Item(i).Value);
				}
				return coeff;
			}
		}

		private Rectangle GetNewTargetWindow(Rectangle window, int meanshiftX, int meanshiftY)
		{
			int windowX = (window.Left + window.Right) / 2;
			int windowY = (window.Top + window.Bottom) /2;
		
			//Centre the new window at windowX & windowY
			if (meanshiftX > windowX)
				meanshiftX = window.Left + (meanshiftX - windowX);
			else
				meanshiftX = window.Left - (windowX - meanshiftX);
			
			if (meanshiftY > windowY)
				meanshiftY = window.Top + (meanshiftY - windowY);
			else
				meanshiftY = window.Top - (windowY - meanshiftY);

			//look out for negative values
			meanshiftX = (meanshiftX < 0) ? 0 : meanshiftX;
			meanshiftY = (meanshiftY < 0) ? 0 : meanshiftY;

			//adjust the size if going out of the window size: 320*240
			if (meanshiftX + window.Width >= 320)
				meanshiftX = 320 - window.Width;
			if (meanshiftY + window.Height >= 240)
				meanshiftY = 240 - window.Height;
			
			return new Rectangle(meanshiftX, meanshiftY, window.Width, window.Height);
		}

		int count = 0;
		private void PrintWindow(string text)
		{
			if (text != "")
			{
				System.IO.StreamWriter file = new System.IO.StreamWriter("Model\\window" + (count++).ToString() + ".txt");
				file.WriteLine(text);
				file.Close();
			}
		}

		private void PrintModel(Model model, string name)
		{
			string t = "";
			for (int c=0;c<model.Bins.Count;c++)
			{
				t += "," + model.Bins.Item(c).Value.ToString();
			}
			t = t.Remove(0,1);
			System.IO.StreamWriter file = new System.IO.StreamWriter("Model\\" + name + (count++).ToString() + ".txt");
			file.WriteLine(t);
			file.Close();
		}

		
	}
}

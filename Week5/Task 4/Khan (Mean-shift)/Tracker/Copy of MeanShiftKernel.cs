using System;
using System.Drawing;
using System.Drawing.Imaging;

using ImageProcessor;

namespace Tracker
{
	/// <summary>
	/// Summary description for MeanShiftKernel.
	/// </summary>
	public class MeanShiftKernel : ITracker
	{
		private const int MEANSHIFT_ITERATIONS = 15;

		private Model _targetModel = null;
		private Model _candidateModel = null;
		private Model _targetLModel = null;
		private Model _candidateLModel = null;
		int _previousTargetCentreX = 0;
		int _previousTargetCentreY = 0;
		float _centreOffsetX = 0;
		float _centreOffsetY = 0;
		int count = 0;	
		int _numberOfBins = 0;
		
		public MeanShiftKernel(int numberOfBins)
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
			get {return 0;}
		}

		public Bitmap BackProjectionImage
		{
			get {return null; }
		}

		public void CreateTargetModel(Bitmap bmp, Rectangle window)
		{			
			_targetLModel = Processor.CreateHueModelWithEpanichnekovKernel(bmp, window);
			//bmp.Clone(window, PixelFormat.Format24bppRgb).Save("Model\\t.jpg",System.Drawing.Imaging.ImageFormat.Jpeg);
			//PrintTargetModel(window);

			//Find the centre Yo of the target
			_previousTargetCentreX = (window.Left + window.Right) / 2;
			_previousTargetCentreY = (window.Top + window.Bottom) / 2;
			//string t = "Count: " + count + " window: " + window.ToString() + " msX: " + _previousTargetCentreX.ToString() + " msY: " + _previousTargetCentreY.ToString()  + "\r\n";
			//PrintWindow(t);
		}
				
		public virtual Rectangle Track(Bitmap bmp, Rectangle window)
		{	
			//Get window width & height
			int width = window.Width;
			int height = window.Height;	
			//Centre of the window
			int Xc = (window.Left + window.Right) / 2;
			int Yc = (window.Top + window.Bottom) / 2;
			//Normalised Space coordinates & kernel distance
			float Xn = 0;
			float Yn = 0;
			//Meanshift vector
			float msX = 0;
			float msY = 0;
			float weight = 0;
			float totalWeight = 0;
			//Colour value index
			int colourValue = 0;
			//Centre of meanshift
			int targetCentreX = 0;
			int targetCentreY = 0;			
			//Find the correct bin range
			int binRange = 256 / _numberOfBins;		
						
			//Find the new candidate model
			_candidateLModel = Processor.CreateHueModelWithEpanichnekovKernel(bmp, window);
			//Crop the image for less processing time 
			Bitmap croppedBmp = bmp.Clone(new Rectangle(window.Left, window.Top, window.Right-window.Left, window.Bottom-window.Top),PixelFormat.Format24bppRgb);
			
			string t = "Start X: " + _previousTargetCentreX.ToString() + " Y: " + _previousTargetCentreY.ToString() + "\r\n";;

			int loopCount = 0;
			//Do maximum of 15 reps
			for (loopCount=0; loopCount<MEANSHIFT_ITERATIONS; loopCount++)
			{
				//Find meanshift vector
				for (int y=window.Top; y<window.Bottom; y++)
				{
					for (int x=window.Left; x<window.Right; x++)
					{
						//Find the normalised x & y
						Xn = 2 * (x - Xc) / (float) width;
						Yn = 2 * (y - Yc) / (float) height;
						if (float.IsNaN(Xn))
							Xn = 0;
						if (float.IsNaN(Yn))
							Yn = 0;
						//Get the colour value at this location which serves as an index to 
						//the bins							
						colourValue = Processor.GetHueComponent(bmp, x, y);
						//Find meanshift vector components
						weight = _targetLModel.Bins[colourValue / binRange] / _candidateLModel.Bins[colourValue / binRange];
						if (float.IsNaN(weight))
							weight = 0;
						msX += Xn * weight;
						msY += Yn * weight;
						totalWeight += weight;
					}
				}
				//Find the meanshift vector
				msX = msX / totalWeight;
				msY = msY / totalWeight;
				//Find the centre in the image space
				targetCentreX = Xc + (int)(msX * width) / 2;
				targetCentreY = Yc + (int)(msY * height) / 2;
				//Check if the centre has not moved, then the target is localised and break
				if ((_previousTargetCentreX == targetCentreX) && (_previousTargetCentreY == targetCentreY))
					break;
				else
				{
					//Move the window's centre to the meanshift vector
					window = GetNewTargetWindow(window, targetCentreX, targetCentreY);
					//window.Offset((int) (_previousTargetCentreX - targetCentreX), (int) (_previousTargetCentreY - targetCentreY));
					//update the centre value
					_previousTargetCentreX = targetCentreX;
					_previousTargetCentreY = targetCentreY;					
				}
			}

			t += "Iteration Count: " + loopCount.ToString() + "\r\n";
			t += "MS X: " + _previousTargetCentreX.ToString() + " Y: " + _previousTargetCentreY.ToString();
			PrintWindow(t);
			count++;
			//return the new window based on the current centre
			//window.Offset((int) (_previousTargetCentreX - targetCentreX), (int) (_previousTargetCentreY - targetCentreY));
			return GetNewTargetWindow(window, targetCentreX, targetCentreY);;
			//return the new window on the candidate target
			//return MoveMeanShiftVector(bmp, window);			
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

		private Rectangle MoveMeanShiftVector(Bitmap bmp, Rectangle window)
		{
			//Find meanshift vector in X & Y direction
			float meanshiftX = 0;
			float meanshiftY = 0;	
			string t = "";
				
			//Iterate to move the meanshift vector closer to the centre. Loop until the 
			//current pixel moves less than one pixel from the previous pixel in the image space
			for (int i=0; i<15; i++)
			{
				count++;
				//Find the new candidate model
				_candidateModel = Processor.CreateHueHistogramWithEpanechnikovKernel(bmp, window);				
				//bmp.Clone(window, PixelFormat.Format24bppRgb).Save("Model\\c" + count.ToString() + ".jpg",System.Drawing.Imaging.ImageFormat.Jpeg);
				
				//PrintTargetModel();
				//PrintCandidateModel(window);

				//Find meanshift vector
				FindMeanShiftVector2(ref meanshiftX, ref meanshiftY);
				
				if ((_previousTargetCentreX == meanshiftX) && (_previousTargetCentreY == meanshiftY))
					break;
				else
				{
					_centreOffsetX = meanshiftX - _previousTargetCentreX;
					_centreOffsetY = meanshiftY - _previousTargetCentreY;
					_previousTargetCentreX = (int)meanshiftX;
					_previousTargetCentreY = (int)meanshiftY;
//					window = GetNewSearchWindow2(window, _centreOffsetX, _centreOffsetY);

					window = GetNewSearchWindow2(window, meanshiftX, meanshiftY);
				}
				
				t += "Count: " + count + " window: " + window.ToString() + " msX: " + meanshiftX.ToString() + " msY: " + meanshiftY.ToString()  + "\r\n";
				PrintWindow(t);
			}
			

			return window;
		}

		private void PrintWindow(string text)
		{
			if (text != "")
			{
				System.IO.StreamWriter file = new System.IO.StreamWriter("Model\\window" + count.ToString() + ".txt");
				file.WriteLine(text);
				file.Close();
			}
		}

		private void PrintCandidateModel(Rectangle window)
		{
			string text2 = "";
			
			for (int j=window.Top; j<window.Bottom; j++)
			{
				for (int i=window.Left; i<window.Right; i++)
				{
					text2 += _candidateModel.GetCoordinateValue(i, j).ToString() + ",";
				}		
				text2 += "\r\n";
			}
			
			System.IO.StreamWriter file = new System.IO.StreamWriter("Model\\candidatemodel" + count.ToString() + ".txt");
			file.WriteLine(text2);
			file.Close();

		}

		private void PrintTargetModel(Rectangle window)
		{
			string text2 = "";
			float val = 0;
			Bitmap bmp = (Bitmap) Image.FromFile("Model\\0.bmp");
			
			for (int j=window.Top; j<window.Bottom; j++)
			{
				for (int i=window.Left; i<window.Right; i++)
				{
					val = _targetModel.GetCoordinateValue(i, j);
					text2 += val.ToString() + ",";
					bmp.SetPixel(i, j, GetColor(val));
				}		
				text2 += "\r\n";
			}
			
			bmp.Save("Model\\target.bmp", ImageFormat.Bmp);			
			
			System.IO.StreamWriter file = new System.IO.StreamWriter("Model\\targetmodel" + count.ToString() + ".txt");
			file.WriteLine(text2);
			file.Close();

		}

		private Color GetColor(float val)
		{
			return Color.FromArgb((int) val, Color.Gray);			
		}
		
		private Rectangle GetNewSearchWindow2(Rectangle window, float meanshiftX, float meanshiftY)
		{
			float windowX = (float) (window.Left + window.Right) / 2;
			float windowY = (float) (window.Top + window.Bottom) /2;

			meanshiftX = windowX - (meanshiftX * (float)window.Width) / 2;
			meanshiftY = windowY - (meanshiftY * (float)window.Height) / 2;

			//Centre the new window at windowX & windowY
			if (meanshiftX > windowX)
				meanshiftX = (float)window.Left + (meanshiftX - windowX);
			else
				meanshiftX = (float)window.Left - (windowX - meanshiftX);
			
			if (meanshiftY > windowY)
				meanshiftY = (float)window.Top + (meanshiftY - windowY);
			else
				meanshiftY = (float)window.Top - (windowY - meanshiftY);

			//look out for negative values
			meanshiftX = (meanshiftX < 0) ? 0 : meanshiftX;
			meanshiftY = (meanshiftY < 0) ? 0 : meanshiftY;

			//adjust the size if going out of the window size: 320*240
			if (meanshiftX + window.Width >= 320)
				meanshiftX = 320 - window.Width;
			if (meanshiftY + window.Height >= 240)
				meanshiftY = 240 - window.Height;
			
			return new Rectangle((int) meanshiftX, (int) meanshiftY, window.Width, window.Height);
		}

		private Rectangle GetNewSearchWindow(Rectangle window, int windowX, int windowY)
		{
			int winCentreX = (window.Left + window.Right) / 2;
			int winCentreY = (window.Top + window.Bottom) / 2;

			//Centre the new window at windowX & windowY
			if (windowX >= winCentreX)
				windowX = window.Left + (windowX - winCentreX);
			else
				windowX = window.Left - (winCentreX - windowX);
			
			if (windowY >= winCentreY)
				windowY = window.Top + (windowY - winCentreY);
			else
				windowY = window.Top - (winCentreY - windowY);

			//look out for negative values
			windowX = (windowX < 0) ? 0 : windowX;
			windowY = (windowY < 0) ? 0 : windowY;

			//adjust the size if going out of the window size: 320*240
			if (windowX + window.Width >= 320)
				windowX = 320 - window.Width;
			if (windowY + window.Height >= 240)
				windowY = 240 - window.Height;
			
			return new Rectangle((int) windowX, (int) windowY, window.Width, window.Height);
		}

		private void MapNormalisedSpaceToImageSpace(Rectangle window, float normalX, float normalY, ref int imageX, ref int imageY)
		{
			imageX = (int)((normalX * (float)window.Width /2) + (float)(window.Left + window.Right) / 2);
			imageY = (int)((normalY * (float)window.Height /2) + (float)(window.Bottom + window.Top) / 2);
				
//			float winCentreX = (window.Left + window.Right) / 2;
//			float winCentreY = (window.Top + window.Bottom) / 2;
//
//			if (normalX == 0) //On the centre
//				imageX = (int) winCentreX;
//			else if (normalX < 0) //In left hand side - negative
//				imageX = (int) (winCentreX + (winCentreX - window.Left) * normalX);
//			else  //In right hand side - positive
//				imageX = (int) (winCentreX + (window.Right - winCentreX) * normalX);
//
//			if (normalY == 0) //On the centre
//				imageY = (int) winCentreY;
//			else if (normalY < 0) //In bottom section - negative
//				imageY = (int) (winCentreY - (window.Bottom - winCentreY) * normalY);
//			else  //In top section - positive
//				imageY = (int) (winCentreY - (winCentreY - window.Top) * normalY);
//
//			if (imageX == 0)
//				imageX = window.Left;
//
//			if (imageY == 0)
//				imageY = window.Top;
//			
		}

		private void FindMeanShiftVector2(ref float meanshiftX, ref float meanshiftY)
		{
			//Find meanshift vector in X & Y direction
			float totalWeight = 0;
			float msX = 0;
			float msY = 0;
			Bin candidateBin = null;
			Coordinate candidateCoord = null;
			float weight = 0;
			meanshiftX = 0;
			meanshiftY = 0;
			float t = 0;

			string text = "";
			
			for (int i=0; i<_candidateModel.Bins.Count; i++)
			{
				candidateBin = _candidateModel.Bins.Item(i);				
				for (int j=0; j<candidateBin.Coordinates.Count; j++)
				{
					candidateCoord = candidateBin.Coordinates.Item(j);
					//For this pixel of the candidate, get the Bin value for the same pixel
					//in the target model. Use normalised coordinates because the image space
					//coordinates would keep on changing as the ROI window moves
					t = _targetModel.GetBinValueByCoordinate(candidateCoord.NormalisedX, candidateCoord.NormalisedY);
					//Find the weight
					weight = (float) Math.Sqrt(t / candidateBin.NormalisedValue); 					
					//If there is 0/0, then use 0 otherwise the actual weight
					weight = float.IsNaN(weight)? 0 : weight;
					weight = float.IsInfinity(weight) ? 0 : weight;	
					//text += "X: " + candidateCoord.X.ToString() + " Y: " + candidateCoord.Y.ToString() + " W: " + weight.ToString() + "\r\n";
					//Get total of X by multiplying the actual pixel location value by the weight
					msX += candidateCoord.NormalisedX * weight;
					//Get total of Y by multiplying the actual pixel location value by the weight
					msY += candidateCoord.NormalisedY * weight;
					//Keep the total weight
					totalWeight += weight;
				}
			}

			meanshiftX = msX / totalWeight;
			meanshiftY = msY / totalWeight;

//			text += "MSX: " + meanshiftX.ToString() + " MSY: " + meanshiftY.ToString();
//			System.IO.StreamWriter file = new System.IO.StreamWriter("Model\\meanshift" + count.ToString() + ".txt");
//			file.WriteLine(text);
//			file.Close();
		}

		private void FindMeanShiftVector(ref float meanshiftX, ref float meanshiftY)
		{
			//Find meanshift vector in X & Y direction
			float totalWeight = 0f;
			float msX = 0f;
			float msY = 0f;
			Bin candidateBin = null;
			Bin targetBin = null;
			float weight = 0f;
			meanshiftX = 0;
			meanshiftY = 0;
			Coordinate coord = null;
			float val = 0;
			Bitmap bmp = (Bitmap) Image.FromFile("Model\\0.bmp");
			
			for (int i=0; i<_candidateModel.Bins.Count; i++)
			{
				candidateBin = _candidateModel.Bins.Item(i);
				targetBin = _targetModel.Bins.Item(i);
				
				for (int j=0; j<candidateBin.Coordinates.Count; j++)
				{	
					coord = candidateBin.Coordinates.Item(j);
					float t = _targetModel.Bins.GetCoordinateColorValue(coord.X, coord.Y);
					weight = t / coord.ColorValue; 					

					//If there is 0/0, then use 0 otherwise the actual weight
					weight = float.IsNaN(weight)? 0 : weight;
					weight = float.IsInfinity(weight) ? 0 : weight;

					bmp.SetPixel(coord.X, coord.Y, GetColor((int)weight));

					//Get total of X by multiplying the actual pixel location value by the weight
					val = coord.NormalisedX * weight;
					msX += val; //coord.NormalisedX * weight;
					//Get total of Y by multiplying the actual pixel location value by the weight
					msY += coord.NormalisedY * weight;
					//Keep the total weight
					totalWeight += weight;
				}
			}

			meanshiftX = msX / totalWeight;
			meanshiftY = msY / totalWeight;

			bmp.Save("Model\\candidate.bmp", ImageFormat.Bmp);
			
					
		}

		public float BhattacharyyaCoefficient
		{
			get
			{
				float coeff = 0;
				for (int i=0; i<_targetModel.Bins.Count; i++)
				{
					coeff += (float) Math.Sqrt(_targetModel.Bins.Item(i).NormalisedValue * _candidateModel.Bins.Item(i).NormalisedValue);
				}
				return coeff;
			}
		}

		
	}
}

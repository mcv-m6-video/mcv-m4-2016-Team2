using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Threading;

using ImageProcessor;
using Tracker;
using UIGraphic;
using Statistic;

namespace CVMeanshift
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
            
        private void Form1_Load(object sender, EventArgs e)
        {            
            _path = "..\\..\\";
            //Load images   
            _isTracking = false;                 
        }

        //create the target selector
        private void CreateSelector()
        {
            if (_selector == null)
            {
                _selector = new Selector(picPreview.Width, picPreview.Height);
                _selector.TargetROISelected = new Selector.TargetSelected(this.CreateTargetModel);
                //wire preview window events to selector's events
                picPreview.MouseDown += new MouseEventHandler(_selector.OnMouseDown);
                picPreview.MouseMove += new MouseEventHandler(_selector.OnMouseMove);
                picPreview.MouseUp += new MouseEventHandler(_selector.OnMouseUp);
            }
        }

        //create the model when the target is slected
        private void CreateTargetModel()
        {
            //create the model
            Tracker.CreateTargetModel((Bitmap)picPreview.Image, Bin1, Bin2, Bin3, _selector.TargetWindow, _selector.SearchWindow);
            //show target histogram
            DisplayHistogram(ref _histTarget, picPreview, picTargetHist);
         }

        private void DisplayHistogram(ref Histogram hist, PictureBox picBox, PictureBox histBox)
        {
            Image bmp = picBox.Image;
            if (bmp != null)
            {
                hist = CreateHistogram((Bitmap)bmp);
                histBox.Refresh(); //force paint event
            }            
        }

        private int Bin1
        {
            get { return Convert.ToInt32(textBox1.Text); }
        }

        private int Bin2
        {
            get { return Convert.ToInt32(textBox2.Text); }
        }

        private int Bin3
        {
            get { return Convert.ToInt32(textBox3.Text); }
        }

        //creates the histograms
        private Histogram CreateHistogram(Bitmap img)
        {
            return _imgProc.Create1DHistogram(img, Bin1, Bin2, Bin3);
        }

        //Displays the histogram
        private void DisplayModel(Histogram model, int height, int width, PaintEventArgs e, Color color, int binRange)
        {
            if (model != null)
            {
                Pen p = new Pen(color, 1);
                SolidBrush b = new SolidBrush(color);
                float[] copy = new float[model.Data.Length];
                Array.Copy(model.Data, copy, model.Data.Length);
                Array.Sort(copy);
                float max = copy[copy.Length - 1];
                float scale = height / max;
                if (float.IsNaN(scale))
                    scale = 1;
                //Approximation: divide by total bins and remove 4 from width to account for picbox border
                float w = (float)(width - 4) / (float)(model.Data.Length); 
                for (int count = 0; count < model.Data.Length; count++)
                {
                    if (model.Data[count] > 0)
                    {
                        e.Graphics.DrawRectangle(p, (float)count * w, (float)height - (model.Data[count] * scale), w, model.Data[count] * scale);
                        e.Graphics.FillRectangle(b, (float)count * w, (float)height - (model.Data[count] * scale), w, model.Data[count] * scale);

                    }
                }
            }
        }

       private void DisplayInformation(Dictionary<string, string> information)
        {
            lblInfo.Text = "";
            foreach (KeyValuePair<string, string> kv in information)
            {
                lblInfo.Text += kv.Key + ": " + kv.Value + Environment.NewLine;
            }
            lblInfo.Refresh();
        }
                
        //Track the object
        private void TrackObject(Bitmap bmp)
        {
            //run track on the tracker to find centroid
            Window roi;
            Window searchRoi;
            Dictionary<string, string> information;

            Tracker.Track(bmp, out roi, out searchRoi, out information);
            
            Bitmap b = Tracker.ProcessedImage;

            //Draw the centroid if valid
            if (roi.CentreX > 0 && roi.CentreY > 0)
            {
                //Display Info
                DisplayInformation(information);
            }

            picPreview.Image = b;
            picPreview.Refresh();

            //Display the candidate histogram
            if (_tracker.GetType().Name != "Centroid")
                DisplayHistogram(ref _histCandidate, picPreview, picCandidateHist);

            //Drawer.DrawWindow(picPreview, roi, Color.Red);
            //Drawer.DrawWindow(picPreview, searchRoi, Color.Yellow);
        }

        private ITracker Tracker
        {
            get
            {
                if (_tracker == null)
                    CreateTracker();

                return _tracker;
            }
        }

        private void CreateTracker()
        {            
            if (radTrackerCentroid.Checked)
                _tracker = new TrackerFactory(TrackerType.CENTROID).Tracker;
            else if (radTrackerMS.Checked)
                _tracker = new TrackerFactory(TrackerType.MEANSHIFT).Tracker;
            else if (radTrackerMSK.Checked)
                _tracker = new TrackerFactory(TrackerType.MEANSHIFTKERNEL).Tracker;
            else if (radTrackerMSKBG.Checked)
                _tracker = new TrackerFactory(TrackerType.MEANSHIFTKERNELBG).Tracker;
        }
           
        #region "CONTROL EVENTS"
        private void picTargetHist_Paint(object sender, PaintEventArgs e)
        {
            DisplayModel(_histTarget, picTargetHist.Height, picTargetHist.Width, e, Color.Red, Bin1 * Bin2 * Bin3);
        }

        private void picCandidateHist_Paint(object sender, PaintEventArgs e)
        {
            DisplayModel(_histCandidate, picCandidateHist.Height, picCandidateHist.Width, e, Color.Blue, Bin1 * Bin2 * Bin3);
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            if (_count < _trackSequenceCount)
            {
                //set the next image
                Bitmap bmp = (Bitmap)Image.FromFile(_path + "\\" + _count + _imageFileExtension);
                TrackObject(bmp); //do tracking
                _count++; //move to next image
            }
            else
            {
                btnTrack.Text = "Start Tracking";
                _count = 0;
                timer1.Enabled = false;
                timer1.Stop();
            }
        }
   
        private void btnLoadSequence_Click(object sender, EventArgs e)
        {
            folderBrowserDialog1.SelectedPath = "C:\\CodeProject\\AviSequence";
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {

                Cursor.Current = Cursors.WaitCursor;

                //_isTracking = true;
                _path = folderBrowserDialog1.SelectedPath;

                picPreview.Image = null;
                picPreview.Refresh();
                _histTarget = null;
                _histCandidate = null;
                picTargetHist.Refresh();
                picCandidateHist.Refresh();
                lblInfo.Text = "";
                _count = 0;
                string imagePath = "";
                Bitmap b = null;

                string[] files = Directory.GetFiles(_path, "*.jpg");

                if (files.Length > 0)
                {
                    imagePath = files[0];
                    b = (Bitmap)Image.FromFile(imagePath);
                }
                else
                {
                    files = Directory.GetFiles(_path, "*.bmp");
                    imagePath = files[0];
                    b = (Bitmap)Image.FromFile(imagePath);
                    _imageFileExtension = ".bmp";
                }
                picPreview.Image = b;
                FileInfo fi = new FileInfo(imagePath);
                _imageFileExtension = fi.Extension;
                picPreview.Refresh();

                _trackSequenceCount = files.Length;
                                
                CreateSelector();

                Cursor.Current = Cursors.Default;
            }
        }

       
        private void btnTrack_Click(object sender, EventArgs e)
        {
            //start the frame grabber
            if (btnTrack.Text == "Start Tracking")
            {
                _isTracking = true;
                btnTrack.Text = "Stop Tracking";

                timer1.Enabled = true;
                timer1.Start();
            }
            else if (btnTrack.Text == "Stop Tracking")
            {
                timer1.Stop();
                timer1.Enabled = false;                
                btnTrack.Text = "Start Tracking";
            }
        }
        #endregion

        string _imageFileExtension = ".jpg";
        int _trackSequenceCount = 0;
        int _count = 0;
        string _path = "";
        Processor _imgProc = new Processor();
        Histogram _histTarget = null;
        Histogram _histCandidate = null;
        Selector _selector = null;
        ITracker _tracker = null;
        bool _isTracking = false;
                
    }
}
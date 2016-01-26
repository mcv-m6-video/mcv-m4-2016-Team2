using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace UIGraphic
{
    public class Selector
    {
        public delegate void TargetSelected();
        public TargetSelected TargetROISelected;

        public Selector(int maxWidth, int maxHeight)
        {
            _maxHeight = maxHeight;
            _maxWidth = maxWidth;
        }

        public Window TargetWindow
        {
            get { return _window; }
        }

        public Window SearchWindow
        {
            get { return _windowBig; }
        }

        public void Reset()
        {
            _window = null;
            _windowBig = null;            
        }

        public void OnMouseDown(Object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                _window = new Window(e.X, e.Y, _maxWidth, _maxHeight);
                _windowBig = new Window(e.X, e.Y, _maxWidth, _maxHeight);
            }
        }

        public void OnMouseMove(Object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                _window.AdjustWindow();
                _windowBig.AdjustWindow();

                _window.EndPoint = new Point(e.X, e.Y);
                _windowBig.EndPoint = new Point(e.X, e.Y);
                
                PictureBox picBox = (PictureBox)sender;
                picBox.Refresh();

                Drawer.DrawWindow(picBox, _window, Color.Red);	
            }
        }

        public void OnMouseUp(Object sender, MouseEventArgs e)
        {
            _window.AdjustWindow();
            _windowBig.AdjustWindow();

            AdjustBiggerWindow();

            PictureBox picBox = (PictureBox)sender;
            Drawer.DrawWindow(picBox, _window, Color.Red);
            Drawer.DrawWindow(picBox, _windowBig, Color.Yellow);

            //call delegate            
            TargetROISelected();
        }
	
        void AdjustBiggerWindow()
        {   
            //Store the current centre for adjusting the scaled window centre
            int Xc = CentreBigWindow.X;
            int Yc = CentreBigWindow.Y;
            
            //Scale
            _windowBig.EndPoint = new Point(_window.EndPoint.X + 15, _window.EndPoint.Y + 15);
            
            _windowBig.AdjustWindow();

            _windowBig.Offset(Xc - CentreBigWindow.X, Yc - CentreBigWindow.Y);
        }

        private Point CentreBigWindow
        {
            get { return new Point((_windowBig.RegionOfInterest.Left + _windowBig.RegionOfInterest.Right) / 2, (_windowBig.RegionOfInterest.Top + _windowBig.RegionOfInterest.Bottom) / 2); }
        }

        private Window _window = null;
        private Window _windowBig = null;        
        private int _maxWidth = 0;
        private int _maxHeight = 0;
    }

}

using System;
using System.Drawing;
using System.Drawing.Imaging;

namespace UIGraphic
{
	/// <summary>
	/// Summary description for Window.
	/// </summary>

    public class Window
    {
        public Window(int x, int y, int maxWidth, int maxHeight)
        {
            _maxWidth = maxWidth;
            _maxHeight = maxHeight;
            Initialise(x, y);
        }

        //public Window()
        //{
        //    Initialise(0, 0);
        //}

        public Point EndPoint
        {
            get { return _end; }
            set { _end = value; }
        }
        public Rectangle RegionOfInterest
        {
            get { return _rect; }
            set { _rect = value; }
        }

        public void Offset(int x, int y)
        {
            _rect.Offset(x, y);
            EnsureLimits();
        }

        public int CentreX
        {
            get {return _rect.X + (int)((float)_rect.Width * 0.5);}            
        }

        public int CentreY
        {
            get { return _rect.Y + (int)((float)_rect.Height * 0.5); }
        }

        public void EnsureLimits()
        {
            //validate position
            if (_rect.X < 0)
                _rect.X = 0;

            if (_rect.Y < 0)
                _rect.Y = 0;

            //validate size
            if (_rect.X + _rect.Width > _maxWidth - 2)
                _rect.Width = _maxWidth - _rect.X - 4;

            if (_rect.Y + _rect.Height > _maxHeight - 2)
                _rect.Height = _maxHeight - _rect.Y - 4;            
        }

        internal void AdjustWindow()
        {
            //Started top left, ended bottom right
            if (_end.X > _start.X && _end.Y > _start.Y)
            {
                _adjustedStart = _start;
                _adjustedEnd = _end;
                _adjustedSize = new Size(_adjustedEnd.X - _adjustedStart.X, _adjustedEnd.Y - _adjustedStart.Y);

                _rect.Location = _adjustedStart;
                _rect.Size = _adjustedSize;

                EnsureLimits();
            }

            ////Started bottom right, ended top left
            //if (_end.X < _start.X && _end.Y < _start.Y)
            //{
            //    _adjustedEnd = _start;
            //    _adjustedStart = _end;
            //    _adjustedSize = new Size(_adjustedEnd.X - _adjustedStart.X, _adjustedEnd.Y - _adjustedStart.Y);
            //    return;
            //}

            ////Started top right left, ended bottom left
            //if (_end.X < _start.X && _end.Y > _start.Y)
            //{
            //    _adjustedStart.X = _end.X;
            //    _adjustedStart.Y = _start.Y;
            //    _adjustedEnd.X = _start.X;
            //    _adjustedEnd.Y = _end.Y;
            //    _adjustedSize = new Size(_adjustedEnd.X - _adjustedStart.X, _adjustedEnd.Y - _adjustedStart.Y);
            //    return;
            //}

            ////Started bottom left, ended top right
            //if (_end.X > _start.X && _end.Y < _start.Y)
            //{
            //    _adjustedStart.X = _start.X;
            //    _adjustedStart.Y = _end.Y;
            //    _adjustedEnd.X = _end.X;
            //    _adjustedEnd.Y = _start.Y;
            //    _adjustedSize = new Size(_adjustedEnd.X - _adjustedStart.X, _adjustedEnd.Y - _adjustedStart.Y);
            //    return;
            //}
        }

        private void Initialise(int x, int y)
        {
            _start = Point.Empty;
            _end = Point.Empty;
            _adjustedStart = Point.Empty;
            _adjustedEnd = Point.Empty;
            _adjustedSize = Size.Empty;

            _start.X = x;
            _start.Y = y;
            _adjustedStart.X = x;
            _adjustedStart.Y = y;

            _rect = Rectangle.Empty;
        }

        private Point _start;
        private Point _end;
        private Point _adjustedStart;
        private Point _adjustedEnd;
        private Size _adjustedSize;
        private Rectangle _rect;
        private int _maxWidth = 0;
        private int _maxHeight = 0;  
    }
}

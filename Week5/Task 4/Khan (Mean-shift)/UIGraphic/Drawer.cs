using System;
using System.Windows.Forms;
using System.Drawing;
using System.Drawing.Imaging;

using ImageProcessor;

namespace UIGraphic
{
	/// <summary>
	/// Summary description for Graphics.
	/// </summary>
	public class Drawer
	{
        public static void DrawWindow(PictureBox picBox, Window roi, Color color)
		{
            Graphics g = picBox.CreateGraphics();
            Pen p = new Pen(color, 2);
            ControlPaint.DrawReversibleFrame(picBox.RectangleToScreen(roi.RegionOfInterest), color, FrameStyle.Dashed);
            g.DrawRectangle(p, roi.RegionOfInterest);
            g.Dispose();

            //Graphics g = Graphics.FromImage(picBox.Image);
            //Pen p = new Pen(color, 2);
            //g.DrawRectangle(p, roi.RegionOfInterest);
            //g.Dispose();
            //picBox.Refresh();
		}

        public static Bitmap DrawMeanshiftInfo(Bitmap bitmap, int msIterations, Rectangle targetRoi, Rectangle searchRoi, Point centre)
        {
            Graphics g = Graphics.FromImage((Image)bitmap);
            Pen p = new Pen(Color.Red, 2);
            g.DrawRectangle(p, targetRoi);
            string msg = "Centroid: " + centre.X.ToString() + ", " + centre.Y.ToString()
                + Environment.NewLine + "MS Iterations: " + msIterations.ToString();
            g.DrawString(msg, new Font(FontFamily.GenericSerif, 8), p.Brush, 5, 5);
            p = new Pen(Color.Yellow, 2);
            g.DrawRectangle(p, searchRoi);
            g.Dispose();
            return bitmap;            
        }

        public static Bitmap DrawWindow(Bitmap bitmap, Window roi, Color color)
        {
            Graphics g = Graphics.FromImage((Image)bitmap);
            Pen p = new Pen(color, 2);
            g.DrawRectangle(p, roi.RegionOfInterest);
            g.Dispose();
            return bitmap;            
        }

        public static Bitmap DrawWindow(Bitmap bitmap, Window[] roi, Color[] color)
        {
            Graphics g = Graphics.FromImage((Image)bitmap);
            for (int i = 0; i < roi.Length; i++)
            {
                Pen p = new Pen(color[i], 2);
                g.DrawRectangle(p, roi[i].RegionOfInterest);
                g.Dispose();
            }
            return bitmap;
        }

        public static Bitmap DrawMoment(Bitmap bitmap, Moment moment, Point centre)
        {
            Graphics g = Graphics.FromImage(bitmap);
            Pen p = new Pen(Color.Red, 2);
            Pen pw = new Pen(Color.Blue, 2);

            int l = moment.Length;
            int w = moment.Width;

            //ROLL -90 to +90
            float rollAngleDeg = moment.ToDegrees(moment.RollRadians);
            float rollAngleRad = moment.RollRadians;

            if (rollAngleDeg < 0) //4th quadrant
            {
                rollAngleDeg = -1 * rollAngleDeg;
                g.DrawLine(p, centre, new Point(centre.X + (int)Math.Ceiling(l * Math.Cos(moment.ToRadians(rollAngleDeg))),
                    centre.Y + (int)Math.Ceiling(l * Math.Sin(moment.ToRadians(rollAngleDeg))))); //centroid to top with l
                g.DrawLine(p, centre, new Point(centre.X - (int)Math.Ceiling(l * Math.Cos(moment.ToRadians(rollAngleDeg))),
                    centre.Y - (int)Math.Ceiling(l * Math.Sin(moment.ToRadians(rollAngleDeg))))); //centroid to bottom with l
                g.DrawLine(pw, centre,
                    new Point(centre.X - (int)Math.Ceiling(w * Math.Cos(moment.ToRadians(90.0f - rollAngleDeg))),
                    centre.Y + (int)Math.Ceiling(w * Math.Sin(moment.ToRadians(90.0f - rollAngleDeg))))); //centroid to right with w
                g.DrawLine(pw, centre,
                    new Point(centre.X + (int)Math.Ceiling(w * Math.Cos(moment.ToRadians(90.0f - rollAngleDeg))),
                    centre.Y - (int)Math.Ceiling(w * Math.Sin(moment.ToRadians(90.0f - rollAngleDeg))))); //centroid to left with w            
            }
            else //1st quadrant
            {
                g.DrawLine(p, centre, new Point(centre.X + (int)Math.Ceiling(l * Math.Cos(rollAngleRad)),
                    centre.Y - (int)Math.Ceiling(l * Math.Sin(rollAngleRad)))); //centroid to top with l
                g.DrawLine(p, centre, new Point(centre.X - (int)Math.Ceiling(l * Math.Cos(rollAngleRad)),
                    centre.Y + (int)Math.Ceiling(l * Math.Sin(rollAngleRad)))); //centroid to bottom with l
                g.DrawLine(pw, centre,
                    new Point(centre.X + (int)Math.Ceiling(w * Math.Cos(moment.ToRadians(90.0f - rollAngleDeg))),
                    centre.Y + (int)Math.Ceiling(w * Math.Sin(moment.ToRadians(90.0f - rollAngleDeg))))); //centroid to right with w
                g.DrawLine(pw, centre,
                    new Point(centre.X - (int)Math.Ceiling(w * Math.Cos(moment.ToRadians(90.0f - rollAngleDeg))),
                    centre.Y - (int)Math.Ceiling(w * Math.Sin(moment.ToRadians(90.0f - rollAngleDeg))))); //centroid to left with w
            }

            g.Dispose();

            return bitmap;
        }

	}
}

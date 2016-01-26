namespace CVMeanshift
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.picPreview = new System.Windows.Forms.PictureBox();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.picTargetHist = new System.Windows.Forms.PictureBox();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.textBox3 = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.lblInfo = new System.Windows.Forms.Label();
            this.btnLoadSequence = new System.Windows.Forms.Button();
            this.btnTrack = new System.Windows.Forms.Button();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.picCandidateHist = new System.Windows.Forms.PictureBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.radTrackerCentroid = new System.Windows.Forms.RadioButton();
            this.radTrackerMS = new System.Windows.Forms.RadioButton();
            this.radTrackerMSK = new System.Windows.Forms.RadioButton();
            this.radTrackerMSKBG = new System.Windows.Forms.RadioButton();
            ((System.ComponentModel.ISupportInitialize)(this.picPreview)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picTargetHist)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picCandidateHist)).BeginInit();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // picPreview
            // 
            this.picPreview.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.picPreview.Location = new System.Drawing.Point(12, 12);
            this.picPreview.Name = "picPreview";
            this.picPreview.Size = new System.Drawing.Size(100, 50);
            this.picPreview.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.picPreview.TabIndex = 0;
            this.picPreview.TabStop = false;
            // 
            // imageList1
            // 
            this.imageList1.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit;
            this.imageList1.ImageSize = new System.Drawing.Size(16, 16);
            this.imageList1.TransparentColor = System.Drawing.Color.Transparent;
            // 
            // picTargetHist
            // 
            this.picTargetHist.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.picTargetHist.Location = new System.Drawing.Point(12, 310);
            this.picTargetHist.Name = "picTargetHist";
            this.picTargetHist.Size = new System.Drawing.Size(270, 74);
            this.picTargetHist.TabIndex = 6;
            this.picTargetHist.TabStop = false;
            this.picTargetHist.Paint += new System.Windows.Forms.PaintEventHandler(this.picTargetHist_Paint);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(98, 282);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(32, 20);
            this.textBox1.TabIndex = 8;
            this.textBox1.Text = "4";
            // 
            // textBox2
            // 
            this.textBox2.Location = new System.Drawing.Point(136, 282);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new System.Drawing.Size(32, 20);
            this.textBox2.TabIndex = 8;
            this.textBox2.Text = "4";
            // 
            // textBox3
            // 
            this.textBox3.Location = new System.Drawing.Point(174, 282);
            this.textBox3.Name = "textBox3";
            this.textBox3.Size = new System.Drawing.Size(32, 20);
            this.textBox3.TabIndex = 8;
            this.textBox3.Text = "4";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 288);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(80, 13);
            this.label1.TabIndex = 9;
            this.label1.Text = "Histogram Size:";
            // 
            // lblInfo
            // 
            this.lblInfo.AutoSize = true;
            this.lblInfo.Location = new System.Drawing.Point(299, 315);
            this.lblInfo.Name = "lblInfo";
            this.lblInfo.Size = new System.Drawing.Size(0, 13);
            this.lblInfo.TabIndex = 10;
            // 
            // btnLoadSequence
            // 
            this.btnLoadSequence.Location = new System.Drawing.Point(288, 437);
            this.btnLoadSequence.Name = "btnLoadSequence";
            this.btnLoadSequence.Size = new System.Drawing.Size(101, 23);
            this.btnLoadSequence.TabIndex = 11;
            this.btnLoadSequence.Text = "Load Sequence";
            this.btnLoadSequence.UseVisualStyleBackColor = true;
            this.btnLoadSequence.Click += new System.EventHandler(this.btnLoadSequence_Click);
            // 
            // btnTrack
            // 
            this.btnTrack.Location = new System.Drawing.Point(395, 437);
            this.btnTrack.Name = "btnTrack";
            this.btnTrack.Size = new System.Drawing.Size(101, 23);
            this.btnTrack.TabIndex = 12;
            this.btnTrack.Text = "Start Tracking";
            this.btnTrack.UseVisualStyleBackColor = true;
            this.btnTrack.Click += new System.EventHandler(this.btnTrack_Click);
            // 
            // timer1
            // 
            this.timer1.Interval = 10;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // folderBrowserDialog1
            // 
            this.folderBrowserDialog1.ShowNewFolderButton = false;
            // 
            // picCandidateHist
            // 
            this.picCandidateHist.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.picCandidateHist.Location = new System.Drawing.Point(12, 390);
            this.picCandidateHist.Name = "picCandidateHist";
            this.picCandidateHist.Size = new System.Drawing.Size(270, 74);
            this.picCandidateHist.TabIndex = 6;
            this.picCandidateHist.TabStop = false;
            this.picCandidateHist.Paint += new System.Windows.Forms.PaintEventHandler(this.picCandidateHist_Paint);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.radTrackerMSKBG);
            this.groupBox1.Controls.Add(this.radTrackerMSK);
            this.groupBox1.Controls.Add(this.radTrackerMS);
            this.groupBox1.Controls.Add(this.radTrackerCentroid);
            this.groupBox1.Location = new System.Drawing.Point(361, 5);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(128, 118);
            this.groupBox1.TabIndex = 13;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Tracker";
            // 
            // radTrackerCentroid
            // 
            this.radTrackerCentroid.AutoSize = true;
            this.radTrackerCentroid.Location = new System.Drawing.Point(5, 19);
            this.radTrackerCentroid.Name = "radTrackerCentroid";
            this.radTrackerCentroid.Size = new System.Drawing.Size(64, 17);
            this.radTrackerCentroid.TabIndex = 0;
            this.radTrackerCentroid.TabStop = true;
            this.radTrackerCentroid.Text = "Centroid";
            this.radTrackerCentroid.UseVisualStyleBackColor = true;
            // 
            // radTrackerMS
            // 
            this.radTrackerMS.AutoSize = true;
            this.radTrackerMS.Checked = true;
            this.radTrackerMS.Location = new System.Drawing.Point(5, 43);
            this.radTrackerMS.Name = "radTrackerMS";
            this.radTrackerMS.Size = new System.Drawing.Size(71, 17);
            this.radTrackerMS.TabIndex = 1;
            this.radTrackerMS.TabStop = true;
            this.radTrackerMS.Text = "Meanshift";
            this.radTrackerMS.UseVisualStyleBackColor = true;
            // 
            // radTrackerMSK
            // 
            this.radTrackerMSK.AutoSize = true;
            this.radTrackerMSK.Location = new System.Drawing.Point(5, 66);
            this.radTrackerMSK.Name = "radTrackerMSK";
            this.radTrackerMSK.Size = new System.Drawing.Size(104, 17);
            this.radTrackerMSK.TabIndex = 1;
            this.radTrackerMSK.TabStop = true;
            this.radTrackerMSK.Text = "Meanshift Kernel";
            this.radTrackerMSK.UseVisualStyleBackColor = true;
            // 
            // radTrackerMSKBG
            // 
            this.radTrackerMSKBG.AutoSize = true;
            this.radTrackerMSKBG.Location = new System.Drawing.Point(5, 89);
            this.radTrackerMSKBG.Name = "radTrackerMSKBG";
            this.radTrackerMSKBG.Size = new System.Drawing.Size(122, 17);
            this.radTrackerMSKBG.TabIndex = 1;
            this.radTrackerMSKBG.TabStop = true;
            this.radTrackerMSKBG.Text = "Meanshift Kernel BG";
            this.radTrackerMSKBG.UseVisualStyleBackColor = true;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(499, 472);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.btnTrack);
            this.Controls.Add(this.btnLoadSequence);
            this.Controls.Add(this.lblInfo);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textBox3);
            this.Controls.Add(this.textBox2);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.picCandidateHist);
            this.Controls.Add(this.picTargetHist);
            this.Controls.Add(this.picPreview);
            this.Name = "Form1";
            this.Text = "Computer Vision - Meanshift Tracking";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.picPreview)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picTargetHist)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picCandidateHist)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox picPreview;
        private System.Windows.Forms.ImageList imageList1;
        private System.Windows.Forms.PictureBox picTargetHist;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.TextBox textBox2;
        private System.Windows.Forms.TextBox textBox3;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label lblInfo;
        private System.Windows.Forms.Button btnLoadSequence;
        private System.Windows.Forms.Button btnTrack;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private System.Windows.Forms.PictureBox picCandidateHist;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.RadioButton radTrackerMSKBG;
        private System.Windows.Forms.RadioButton radTrackerMSK;
        private System.Windows.Forms.RadioButton radTrackerMS;
        private System.Windows.Forms.RadioButton radTrackerCentroid;
    }
}


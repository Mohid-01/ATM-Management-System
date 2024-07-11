using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ATMManagementSystem.Forms
{
    public partial class Receipt : Form
    {
        public bool rccpt = false;
        DataTransfer transferDel;
        public Receipt(DataTransfer del)
        {
            InitializeComponent();
            transferDel = del;
        }


        private void wantRecBtn_Click_1(object sender, EventArgs e)
        {
            rccpt = true;
            transferDel.Invoke(rccpt);
            this.Visible = false;
        }

        private void CancelReceiptBtn_Click(object sender, EventArgs e)
        {
            rccpt = false;
            transferDel.Invoke(rccpt);
            this.Visible = false;
        }
    }
}

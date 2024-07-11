using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Threading;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Windows.Forms;

namespace ATMManagementSystem.Forms
{
    public delegate void DataTransfer(bool data);

    public partial class ATM_Interface : Form
    {
        public DataTransfer transferDelegate;
        string acc = "";
        string cash = "";
        int transactionID = 0;
        string card = "";
        int bank = 0;
        int pin = 0;
        
        public bool Receiptneed = false;
        public ATM_Interface()
        {
            InitializeComponent();
            transferDelegate += new DataTransfer(ReceiveInput);

        }

        private void bunifuPictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void BalanceInquiryBtn_Click(object sender, EventArgs e)
        {
            ah.Text = cash;
            cashwith.SelectedIndex = 10;
            

        }

        private void CheckCardBtn_Click(object sender, EventArgs e)
        {
            var con = Configuration.getInstance().getConnection();
            SqlCommand user = new SqlCommand("select FirstName+' '+LastName as Name, A.Balance from Card_ C join Account a ON A.AccountNumber = C.AccountNumber Join Customer CS ON CS.CustomerID = a.FounderCustomerID where C.Card_Number = '"+CardNumbettxt.Text.ToString()+"' AND C.PIN = "+Pintxt.Text.ToString()+";", con);
            SqlDataReader userReader = user.ExecuteReader();
            while (userReader.Read())
            {
                acc = userReader[0].ToString();
                cash = userReader[1].ToString();
                card = CardNumbettxt.Text;
                pin = int.Parse(Pintxt.Text);

            }
            userReader.Close();
            if (acc != "")
            {
                AccTitleLbl.Text = acc;
                availableCash.Text = cash;
                cashwith.SelectedIndex = 1; 
            }
            else
            {
                MessageBox.Show("Please Enter Correct Card Information!");
                CardNumbettxt.Text = "";
                Pintxt.Text = "";
            }


        }
        public void viewReceipt()
        {
           
            //declerations
            ParameterField pd = new ParameterField();
            ParameterField transID = new ParameterField();
            CrystalReport1 receipt = new CrystalReport1();
            ParameterDiscreteValue value = new ParameterDiscreteValue();
            ParameterDiscreteValue val = new ParameterDiscreteValue();
            // first descrete value
            value.Value = card;
            ParameterValues param = new ParameterValues();
            param.Add(value);
            //showing form 
            ReceiptForm rec = new ReceiptForm();
            receipt.Parameter_cardID.CurrentValues = param;
            rec.crystalReportViewer1.ReportSource = receipt;
            TextObject text = (TextObject)receipt.ReportDefinition.Sections["Section2"].ReportObjects["Text4"];
            text.Text = "20";
            rec.Show();

            CancelPinBtn.PerformClick();


        }

        private void CashWithdrawal_Click(object sender, EventArgs e)
        {
            cashwith.SelectedIndex = 2;
        }

        private void AmountTxt_KeyPress(object sender, KeyPressEventArgs e)
        {
            e.Handled = !char.IsDigit(e.KeyChar) && !char.IsControl(e.KeyChar);
        }

        private void Withdrawbtn_Click(object sender, EventArgs e)
        {
            Receipt rcpt = new Receipt(transferDelegate);
            try
            {
                int entery = int.Parse(AmountTxt.Text.ToString());
                if (entery % 500 != 0)
                {
                    MessageBox.Show("Entered Amount is Not Valid Enter Again!");
                    AmountTxt.Text = "";
                    cashwith.SelectedIndex = 2;
                }
                else
                {
                    cashwith.SelectedIndex = 5;
                    rcpt.Visible = true;

                }

            }
            catch(Exception c)
            {
                MessageBox.Show("Enter Correct Value");
                AmountTxt.Text = "";

            }



        }
        public void ReceiveInput(bool data)
        {
            
            withdraw();
            Receiptneed = data;
            if (Receiptneed)
            {
                viewReceipt();
            }
            goback();
            

        }
        private void withdraw()
        {
            SqlTransaction trans = null;
            var con = Configuration.getInstance().getConnection();
            
            using (SqlConnection conn = new SqlConnection( @"Data Source=(local);Initial Catalog=DatabaseDesign-GID11;Integrated Security=True;MultipleActiveResultSets=True"))
            {
                conn.Open();
                trans = conn.BeginTransaction();
                
                try
                {


                    //check entered amount

                    if (int.Parse(cash) < int.Parse(AmountTxt.Text.ToString()))
                    {
                        MessageBox.Show("Entered Amount is greater than your available cash!");
                        AmountTxt.Text = "";
                        cashwith.SelectedIndex = 2;
                    }
                    else
                    {
                        SqlCommand transID = new SqlCommand("SELECT MAX(TransactionID) FROM [Transaction]", conn,trans);
                        SqlDataReader rd = transID.ExecuteReader();
                        while (rd.Read())
                        {
                            transactionID = int.Parse(rd[0].ToString());
                        }
                        transactionID = transactionID + 1;
                        // insert in tranasction
                        SqlCommand cmd = new SqlCommand("INSERT INTO [Transaction] VALUES(" + transactionID + ", '" + card + "', 'Cash Withdrawal', NULL, 1, GETDATE(), " + cash + ", (" + (int.Parse(cash) - int.Parse(AmountTxt.Text.ToString())) + "-(select TERMINALFEE from [ATM-Machine] where ATM_ID = 1)))", conn, trans);
                        cmd.CommandType = CommandType.Text;
                        cmd.ExecuteNonQuery();
                        //insert in withdrawal
                        SqlCommand cmd1 = new SqlCommand("INSERT INTO Withdrawl values(" + transactionID + "," + AmountTxt.Text.ToString() + ")", conn, trans);
                        cmd1.CommandType = CommandType.Text;
                        cmd1.ExecuteNonQuery();
                        //Update Account Balance
                        SqlCommand cmd2 = new SqlCommand("UPDATE Account SET Balance = Balance - ((select TERMINALFEE from [ATM-Machine] where ATM_ID = 1)+ "+AmountTxt.Text+") where AccountNumber = (SELECT AccountNumber FROM Card_ where Card_Number = '"+card+"')", conn, trans);
                        cmd2.CommandType = CommandType.Text;
                        cmd2.ExecuteNonQuery();
                        //Update atm cash
                        SqlCommand cmd3 = new SqlCommand(" Update [ATM-Machine] SET CashAvailable = CashAvailable - " + AmountTxt.Text.ToString() + " where ATM_ID = 1", conn, trans);
                        cmd3.CommandType = CommandType.Text;
                        cmd3.ExecuteNonQuery();

                        SqlCommand cmd4 = new SqlCommand(" UPDATE[Transaction] SET [Status] = 'Completed' where TransactionID = " + transactionID + ";", conn,trans);
                        cmd4.ExecuteNonQuery();

                        trans.Commit();
                        MessageBox.Show("Transaction Successfull!");
                        cashwith.SelectedIndex = 3;


                    }
                    
                    

                }
                catch (Exception c)
                {
                    MessageBox.Show("Transaction Unsuccessful! Please try again later");
                    trans.Rollback();
                    SqlCommand cmd5 = new SqlCommand(" UPDATE[Transaction] SET [Status] = 'Incomplete' where TransactionID = " + transactionID + ";", con);
                    cmd5.ExecuteNonQuery();

                }
                finally
                {
                    conn.Close();
                }

            }

        }

        private void CancelAmountBtn_Click(object sender, EventArgs e)
        {
            CardNumbettxt.Text = "";
            Pintxt.Text = "";
            CancelPinBtn.PerformClick();
            goback();
            
        }

        private void cancelTrans_Click(object sender, EventArgs e)
        {

            CardNumbettxt.Text = "";
            Pintxt.Text = "";
            OLDPINtxt.Text = "";
            NewPinTxt.Text = "";
            AmountTxt.Text = "";
            cashwith.SelectedIndex = 0;
            goback();

        }
        public void goback()
        {
            CardNumbettxt.Text = "";
            Pintxt.Text = "";
            OLDPINtxt.Text = "";
            NewPinTxt.Text = "";
            AmountTxt.Text = "";
            TransferAmountTxt.Text = "";
            AccountTxt.Text = "";
            AccountTxt.Show();
            bunifuButton3.Show();
            abort.Show();
            TransferAmountTxt.Hide();
            bunifuButton4.Hide();
            TrasferBtn.Hide();
            cashwith.SelectedIndex = 0;
        }

        private void changePin_Click(object sender, EventArgs e)
        {
            cashwith.SelectedIndex = 4;
        }

        private void CashTransferBtn_Click(object sender, EventArgs e)
        {
            cashwith.SelectedIndex = 8;
        }

        private void UserSideBtn_Click(object sender, EventArgs e)
        {
            cashwith.SelectedIndex = 0;
        }

        private void ClientSideBtn_Click(object sender, EventArgs e)
        {

            this.Close();
        }

        private void btn500_Click(object sender, EventArgs e)
        {
  
            Bunifu.UI.WinForms.BunifuButton.BunifuButton btn = (Bunifu.UI.WinForms.BunifuButton.BunifuButton)sender;
            AmountTxt.Text = (Int32.Parse(btn.Text)).ToString();
        }

        private void tabPage2_Click(object sender, EventArgs e)
        {
            
        }

        private void tabPage3_Enter(object sender, EventArgs e)
        {
            AccTitlePinLBL.Text = acc;
            AccCashPinLbl.Text = cash;
        }

        private void SavePinBtn_Click(object sender, EventArgs e)
        {
            bool correct = false;
            var con = Configuration.getInstance().getConnection();
            SqlCommand varify = new SqlCommand("SELECT PIN FROM Card_ where Card_Number = "+card+";",con);
            SqlDataReader dr = varify.ExecuteReader();
            while (dr.Read())
            {
                if (OLDPINtxt.Text == dr[0].ToString())
                {
                    correct = true;
                }
            }
            if (correct)
            {
                SqlCommand changePin = new SqlCommand("Update Card_ set PIN = " + NewPinTxt.Text + "where Card_Number = " + card + " and PIN = " + OLDPINtxt.Text + ";", con);
                changePin.ExecuteNonQuery();
                MessageBox.Show("PIN Changed Successfully!");

            }
            else
            {
                MessageBox.Show("Incorrect PIN");
               
            }
            CancelPinBtn.PerformClick();
            goback();

        }

        private void ATM_Interface_Load(object sender, EventArgs e)
        {
            CardNumbettxt.MaxLength = 13;
            Pintxt.MaxLength = 4;
        }

        private void MiniStatementBtn_Click(object sender, EventArgs e)
        {
            cashwith.SelectedIndex = 6;
            MiniStatement receipt = new MiniStatement();
            ParameterDiscreteValue value = new ParameterDiscreteValue();
            ParameterDiscreteValue Va = new ParameterDiscreteValue();
            // first descrete value
            value.Value = card;
            ParameterValues param = new ParameterValues();
            param.Add(value);
            ParameterValues para = new ParameterValues();
            Va.Value = cash;
            para.Add(Va);

            //showing form 
            MiniStatementForm rec = new MiniStatementForm();
            receipt.Parameter_CardID.CurrentValues = param;
            
            rec.crystalReportViewer1.ReportSource = receipt;
            TextObject text = (TextObject)receipt.ReportDefinition.Sections["Section2"].ReportObjects["cashObj"];
            text.Text = cash;
            rec.Show();
            goback();

        }

        private void tabPage2_Enter(object sender, EventArgs e)
        {
            
           
        }

        private void DepositBtn_Click(object sender, EventArgs e)
        {
            cashwith.SelectedIndex = 6;

        }

        private void CashDepositBtn_Click(object sender, EventArgs e)
        {
            string Account = "", Opening = "", customer = "", bank = "";
            cashwith.SelectedIndex = 7;
            var con = Configuration.getInstance().getConnection();
            SqlCommand user = new SqlCommand("Select AccountNumber,Balance, CONVERT(date, OpeningDate) as [Openening Date], (Select FirstName+' '+LastName from Customer Where CustomerID = a.FounderCustomerID) as Customer, (Select BankName FROM Bank where Bank_ID = A.Bank_ID) as Bank from Account A where A.AccountNumber = (Select AccountNumber from Card_ where Card_Number = '"+card+"')", con);
            SqlDataReader userReader = user.ExecuteReader();
            while (userReader.Read())
            {
                Account = userReader[0].ToString();
                Opening = userReader[2].ToString();
                customer = userReader[3].ToString();
                bank = userReader[4].ToString();

            }
            userReader.Close();
            Acclbl.Text = customer;
            infoCashlbl.Text = cash;
            opendate.Text = Opening;
            AccN.Text = Account;
            BankNamelbl.Text = bank;
        }

        private void bunifuLabel32_Click(object sender, EventArgs e)
        {

        }

        private void CancelDepo_Click(object sender, EventArgs e)
        {
            cashToDeposittxt.Text = "";
                goback();
        }

        private void bunifuButton1_Click(object sender, EventArgs e)
        {
            goback();
        }

        private void DepositcashBtn_Click(object sender, EventArgs e)
        {
            try
            {
                if (cashToDeposittxt.Text != "" && int.Parse(cashToDeposittxt.Text.ToString()) % 500 == 0)
                {
                    SqlTransaction trans = null;
                    var con = Configuration.getInstance().getConnection();

                    using (SqlConnection conn = new SqlConnection(@"Data Source=(local);Initial Catalog=DatabaseDesign-GID11;Integrated Security=True;MultipleActiveResultSets=True"))
                    {
                        conn.Open();
                        trans = conn.BeginTransaction();

                        try
                        {


                            //check entered amount


                            SqlCommand transID = new SqlCommand("SELECT MAX(TransactionID) FROM [Transaction]", conn, trans);
                            SqlDataReader rd = transID.ExecuteReader();
                            while (rd.Read())
                            {
                                transactionID = int.Parse(rd[0].ToString());
                            }
                            transactionID = transactionID + 1;
                            // insert in tranasction
                            SqlCommand cmd = new SqlCommand("INSERT INTO [Transaction] VALUES(" + transactionID + ", '" + card + "', 'Cash Deposit', NULL, 1, GETDATE(), " + cash + ", (" + (int.Parse(cash) + int.Parse(cashToDeposittxt.Text.ToString())) + " - (select TERMINALFEE from [ATM-Machine] where ATM_ID = 1)))", conn, trans);
                            cmd.CommandType = CommandType.Text;
                            cmd.ExecuteNonQuery();
                            //insert in Deposit
                            SqlCommand cmd1 = new SqlCommand("INSERT INTO CashDeposit values(" + transactionID + "," + cashToDeposittxt.Text.ToString() + ")", conn, trans);
                            cmd1.CommandType = CommandType.Text;
                            cmd1.ExecuteNonQuery();
                            //Update Account Balance
                            SqlCommand cmd2 = new SqlCommand("UPDATE Account SET Balance = Balance + " + cashToDeposittxt.Text + " where AccountNumber = (SELECT AccountNumber FROM Card_ where Card_Number = '" + card + "')", conn, trans);
                            cmd2.CommandType = CommandType.Text;
                            cmd2.ExecuteNonQuery();
                            //Update atm cash
                            SqlCommand cmd3 = new SqlCommand(" Update [ATM-Machine] SET CashAvailable = CashAvailable + " + cashToDeposittxt.Text + " where ATM_ID = 1", conn, trans);
                            cmd3.CommandType = CommandType.Text;
                            cmd3.ExecuteNonQuery();

                            SqlCommand cmd4 = new SqlCommand(" UPDATE[Transaction] SET [Status] = 'Completed' where TransactionID = " + transactionID + ";", conn, trans);
                            cmd4.ExecuteNonQuery();

                            trans.Commit();
                            MessageBox.Show("Transaction Successfull!");


                        }
                        catch (Exception c)
                        {
                            MessageBox.Show("Transaction Unsuccessful! Please try again later");
                            trans.Rollback();
                            SqlCommand cmd5 = new SqlCommand(" UPDATE[Transaction] SET [Status] = 'Incomplete' where TransactionID = " + transactionID + ";", con);
                            cmd5.ExecuteNonQuery();

                        }
                        finally
                        {
                            conn.Close();
                        }
                        conn.Close();

                    }
                    viewDepositReceipt();

                }
                else
                {
                    MessageBox.Show("Enter Correct Amount First!");
                }
            }
            catch(Exception g)
            {
                MessageBox.Show("Enter Correct Amount First!");
            }
            
           
            

            goback();

        }
        public void viewDepositReceipt()
        {
           
            depositreport receipt = new depositreport();
            ParameterDiscreteValue value = new ParameterDiscreteValue();
            ParameterDiscreteValue val = new ParameterDiscreteValue();
            // first descrete value
            value.Value = card;
            ParameterValues param = new ParameterValues();
            param.Add(value);
            //showing form 
            Deposit rec = new Deposit();
            receipt.Parameter_cardID.CurrentValues = param;
            rec.crystalReportViewer1.ReportSource = receipt;
            TextObject text = (TextObject)receipt.ReportDefinition.Sections["Section2"].ReportObjects["Text12"];
            text.Text = "20";
            rec.Show();
            goback();
        }

        private void HBL_Click(object sender, EventArgs e)
        {
            bank = 1;
            AccountTxt.Text = "";
            AccountTxt.Show();
            bunifuButton3.Show();
            abort.Show();
            initially();
            cashwith.SelectedIndex = 9;
        }

        private void UBL_Click(object sender, EventArgs e)
        {
            bank = 2;
            AccountTxt.Text = "";
            AccountTxt.Show();
            bunifuButton3.Show();
            abort.Show();
            initially();
            cashwith.SelectedIndex = 9;
        }

        private void BAL_Click(object sender, EventArgs e)
        {
            bank = 3;
            AccountTxt.Text = "";
            AccountTxt.Show();
            bunifuButton3.Show();
            abort.Show();
            initially();
            cashwith.SelectedIndex = 9;

        }

        private void MCB_Click(object sender, EventArgs e)
        {
            bank = 4;
            AccountTxt.Text = "";
            AccountTxt.Show();
            bunifuButton3.Show();
            abort.Show();
            initially();
            cashwith.SelectedIndex = 9;
        }

        private void Khushali_Click(object sender, EventArgs e)
        {
            bank = 5;
            AccountTxt.Text = "";
            AccountTxt.Show();
            bunifuButton3.Show();
            abort.Show();
            initially();
            cashwith.SelectedIndex = 9;

        }

        private void Allied_Click(object sender, EventArgs e)
        {
            bank = 6;
            AccountTxt.Text = "";
            AccountTxt.Show();
            bunifuButton3.Show();
            abort.Show();
            initially();
            cashwith.SelectedIndex = 9;

        }

        private void bunifuFlatButton7_Click(object sender, EventArgs e)
        {
            AccountTxt.Text = "";
            goback();
        }

        private void bunifuButton3_Click(object sender, EventArgs e)
        {
            var con = Configuration.getInstance().getConnection();
            string  acc = AccountTxt.Text.ToString();
            SqlCommand cmd = new SqlCommand("SELECT Card_Number FROM Card_ Where AccountNumber = "+acc+ " AND Bank_ID ="+bank+" ;", con);
            string Check = "";
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                Check = reader[0].ToString();
            }
            reader.Close();
            if(Check != "" && Check != card)
            {
                string Account = "", customer = "", bank = "";

                SqlCommand user = new SqlCommand("Select AccountNumber, (Select FirstName+' '+LastName from Customer Where CustomerID = a.FounderCustomerID) as Customer, (Select BankName  FROM Bank where Bank_ID = A.Bank_ID) as Bank from Account A where A.AccountNumber = " + acc + ";", con);
                SqlDataReader userReader = user.ExecuteReader();
                while (userReader.Read())
                {
                    Account = userReader[0].ToString();
                    customer = userReader[1].ToString();
                    bank = userReader[2].ToString();

                }
                userReader.Close();
                secAccTitle.Text = customer;
                SecBank.Text = bank;
                SecAccNumber.Text = Account;
                makeInVisible();
                bunifuButton4.Show();
                TrasferBtn.Show();
                TransferAmountTxt.Show();


            }
            else if (Check == card)
            {
                MessageBox.Show("Sender and Receiver share same wallet!");
            }
            else
            {
                MessageBox.Show("Account Doesn't Exists!");
                goback();
            }


            
            
        }

        private void abort_Click(object sender, EventArgs e)
        {
            goback();
        }

        private void bunifuButton4_Click(object sender, EventArgs e)
        {
            TransferAmountTxt.Text = "";
            AccountTxt.Text = "";
            AccountTxt.Show();
            bunifuButton3.Show();
            abort.Show();
            TransferAmountTxt.Hide();
            bunifuButton4.Hide();
            TrasferBtn.Hide();
            goback();

        }
        private void makeInVisible()
        {
            
            AccountTxt.Hide();
            bunifuButton3.Hide();
            abort.Hide();
        }
        private void initially()
        {
            AccountTxt.Text = "";
            secAccTitle.Text = "-------";
            SecAccNumber.Text ="-------";
            SecBank.Text = "-------"; 
            bunifuButton4.Hide();
            TrasferBtn.Hide();
            TransferAmountTxt.Hide();
        }

        private void TrasferBtn_Click(object sender, EventArgs e)
        {

            if (int.Parse(TransferAmountTxt.Text.ToString()) <= int.Parse(cash) && int.Parse(TransferAmountTxt.Text.ToString()) <= int.Parse(cashAvail()))
            {
                SqlTransaction trans = null;
                var con = Configuration.getInstance().getConnection();

                using (SqlConnection conn = new SqlConnection(@"Data Source=(local);Initial Catalog=DatabaseDesign-GID11;Integrated Security=True;MultipleActiveResultSets=True"))
                {
                    conn.Open();
                    trans = conn.BeginTransaction();

                    try
                    {


                        //check entered amount


                        SqlCommand transID = new SqlCommand("SELECT MAX(TransactionID) FROM [Transaction]", conn, trans);
                        SqlDataReader rd = transID.ExecuteReader();
                        while (rd.Read())
                        {
                            transactionID = int.Parse(rd[0].ToString());
                        }
                        transactionID = transactionID + 1;
                        // insert in tranasction
                        SqlCommand cmd = new SqlCommand("INSERT INTO [Transaction] VALUES(" + transactionID + ", '" + card + "', 'Account Transfer', NULL, 1, GETDATE(), " + cash + ", (" + (int.Parse(cash) + int.Parse(TransferAmountTxt.Text.ToString())) + " - (select TERMINALFEE from [ATM-Machine] where ATM_ID = 1)))", conn, trans);
                        cmd.CommandType = CommandType.Text;
                        cmd.ExecuteNonQuery();
                        //insert in Transfer
                        SqlCommand cmd1 = new SqlCommand("INSERT INTO CashDeposit values(" + transactionID + "," + TransferAmountTxt.Text.ToString() + ")", conn, trans);
                        cmd1.CommandType = CommandType.Text;
                        cmd1.ExecuteNonQuery();
                        //Update Account Balance
                        SqlCommand cmd2 = new SqlCommand("UPDATE Account SET Balance = Balance + " + TransferAmountTxt.Text + " where AccountNumber = (SELECT AccountNumber FROM Card_ where Card_Number = '" + card + "')", conn, trans);
                        cmd2.CommandType = CommandType.Text;
                        cmd2.ExecuteNonQuery();
                        //Update second account
                        SqlCommand cmd3 = new SqlCommand("UPDATE Account SET Balance = Balance + "+TransferAmountTxt.Text.ToString()+" where AccountNumber = "+AccountTxt.Text+";", conn, trans);
                        cmd3.CommandType = CommandType.Text;
                        cmd3.ExecuteNonQuery();

                        SqlCommand cmd4 = new SqlCommand(" UPDATE[Transaction] SET [Status] = 'Completed' where TransactionID = " + transactionID + ";", conn, trans);
                        cmd4.ExecuteNonQuery();

                        trans.Commit();
                        MessageBox.Show("Transaction Successfull!");


                    }
                    catch (Exception c)
                    {
                        MessageBox.Show("Transaction Unsuccessful! Please try again later");
                        trans.Rollback();
                        SqlCommand cmd5 = new SqlCommand(" UPDATE[Transaction] SET [Status] = 'Incomplete' where TransactionID = " + transactionID + ";", con);
                        cmd5.ExecuteNonQuery();

                    }
                    finally
                    {
                        conn.Close();
                    }
                    conn.Close();

                }

            }
            else
            {
                MessageBox.Show("Entered amount is greater than available amount");
            }
            goback();
        }
        private string cashAvail()
        {
            string ACash = "";
            var con = Configuration.getInstance().getConnection();
            SqlCommand user = new SqlCommand("select CashAvailable FROM [ATM-Machine] where ATM_ID = 1", con);
            SqlDataReader userReader = user.ExecuteReader();
            while (userReader.Read())
            {
                ACash = userReader[0].ToString();

            }
            userReader.Close();
            return ACash;
        }

        private void AnotherAccDepositBtn_Click(object sender, EventArgs e)
        {
            cashwith.SelectedIndex = 8;
        }

        private void ah_Click(object sender, EventArgs e)
        {

        }

        private void bunifuLabel14_Click(object sender, EventArgs e)
        {

        }
    }
}

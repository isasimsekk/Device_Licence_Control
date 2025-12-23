using System;
using System.Collections.Generic;
using System.Data;

namespace Device_Licence_Control
{
    public partial class Register : System.Web.UI.Page
    {
        private List<string> emailsList = new List<string>();
        private List<string> phonesList = new List<string>();
        private List<string> phoneTypesList = new List<string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is already logged in
            if (Utils.SessionManager.IsUserLoggedIn(this))
            {
                Response.Redirect("Dashboard.aspx");
            }

            // Clear message on initial page load
            if (!IsPostBack)
            {
                lblMessage.Text = "";
                lblMessage.CssClass = "message-box";
            }
            else
            {
                LoadEmailsList();
                LoadPhonesList();
            }
        }

        protected void btnAddEmail_Click(object sender, EventArgs e)
        {
            LoadEmailsList();
            
            string newEmail = txtEmail1.Text.Trim();
            
            if (string.IsNullOrWhiteSpace(newEmail))
            {
                ShowError("Please enter an email address.");
                return;
            }
            
            if (!IsValidEmail(newEmail))
            {
                ShowError("Please enter a valid email address.");
                return;
            }
            
            if (emailsList.Contains(newEmail))
            {
                ShowError("This email is already added.");
                return;
            }
            
            emailsList.Add(newEmail);
            SaveEmailsList();
            txtEmail1.Text = "";
            BindEmailsRepeater();
        }

        protected void rptEmails_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            LoadEmailsList();
            
            if (e.CommandName == "RemoveEmail")
            {
                int index = int.Parse(e.CommandArgument.ToString());
                
                if (index >= 0 && index < emailsList.Count)
                {
                    emailsList.RemoveAt(index);
                    SaveEmailsList();
                    BindEmailsRepeater();
                }
            }
        }

        protected void btnAddPhone_Click(object sender, EventArgs e)
        {
            LoadPhonesList();
            
            string newPhone = txtPhone1.Text.Trim();
            string phoneType = Request.Form["phoneType1"] ?? "Mobile";
            
            if (string.IsNullOrWhiteSpace(newPhone))
            {
                ShowError("Please enter a phone number.");
                return;
            }
            
            if (!IsValidPhone(newPhone))
            {
                ShowError("Please enter a valid phone number (at least 7 digits).");
                return;
            }
            
            if (phonesList.Contains(newPhone))
            {
                ShowError("This phone number is already added.");
                return;
            }
            
            phonesList.Add(newPhone);
            phoneTypesList.Add(phoneType);
            SavePhonesList();
            txtPhone1.Text = "";
            BindPhonesRepeater();
        }

        protected void rptPhones_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            LoadPhonesList();
            
            if (e.CommandName == "RemovePhone")
            {
                int index = int.Parse(e.CommandArgument.ToString());
                
                if (index >= 0 && index < phonesList.Count)
                {
                    phonesList.RemoveAt(index);
                    phoneTypesList.RemoveAt(index);
                    SavePhonesList();
                    BindPhonesRepeater();
                }
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            LoadEmailsList();
            LoadPhonesList();
            
            string fullName = txtFullName.Text.Trim();
            string city = txtCity.Text.Trim();
            string country = txtCountry.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            // 1. Validation
            if (string.IsNullOrWhiteSpace(fullName) || string.IsNullOrWhiteSpace(password))
            {
                ShowError("Full Name and Password are required.");
                return;
            }

            if (emailsList.Count == 0)
            {
                ShowError("Please add at least one email address.");
                return;
            }

            if (phonesList.Count == 0)
            {
                ShowError("Please add at least one phone number.");
                return;
            }

            if (password.Length < 1)
            {
                ShowError("Password cannot be empty.");
                return;
            }

            // Validate password is numeric
            int passwordNumber;
            if (!int.TryParse(password, out passwordNumber))
            {
                ShowError("Password must contain only numbers (0-9).");
                return;
            }

            // Check if passwords match
            if (password != confirmPassword)
            {
                ShowError("Passwords do not match. Please try again.");
                txtPassword.Text = "";
                txtConfirmPassword.Text = "";
                return;
            }

            // 2. Check if user already exists
            DBConnection db = new DBConnection();
            string checkQuery = "SELECT COUNT(*) FROM [User] WHERE FullName = '" + fullName + "'";
            
            try
            {
                DataSet dsCheck = db.getSelect(checkQuery);
                int userCount = Convert.ToInt32(dsCheck.Tables[0].Rows[0][0]);
                
                if (userCount > 0)
                {
                    ShowError("This Full Name is already registered. Please use a different name or login.");
                    return;
                }

                // 3. Insert new user into database
                string insertUserQuery = "INSERT INTO [User] (FullName, City, Country, Password, IsActive, isAdmin, CreatedAt) " +
                                       "VALUES ('" + fullName + "', '" + city + "', '" + country + "', " + passwordNumber + ", 1, 0, GETDATE())";

                bool userSuccess = db.execute(insertUserQuery);

                if (!userSuccess)
                {
                    ShowError("An error occurred while creating your account. Please try again.");
                    return;
                }

                // 4. Get the UserId of the newly created user
                string getUserIdQuery = "SELECT UserId FROM [User] WHERE FullName = '" + fullName + "'";
                DataSet dsUserId = db.getSelect(getUserIdQuery);
                
                if (dsUserId.Tables[0].Rows.Count == 0)
                {
                    ShowError("An error occurred while retrieving your account. Please try again.");
                    return;
                }

                int newUserId = Convert.ToInt32(dsUserId.Tables[0].Rows[0]["UserId"]);

                // 5. Insert emails - last email as primary
                for (int i = 0; i < emailsList.Count; i++)
                {
                    bool isPrimary = (i == emailsList.Count - 1) ? true : false;
                    string insertEmailQuery = "INSERT INTO [UserEmail] (UserId, Email, IsPrimary) " +
                                            "VALUES (" + newUserId + ", '" + emailsList[i] + "', " + (isPrimary ? 1 : 0) + ")";
                    db.execute(insertEmailQuery);
                }

                // 6. Insert phones
                for (int i = 0; i < phonesList.Count; i++)
                {
                    string insertPhoneQuery = "INSERT INTO [UserPhone] (UserId, PhoneNumber, PhoneType) " +
                                            "VALUES (" + newUserId + ", '" + phonesList[i] + "', '" + phoneTypesList[i] + "')";
                    db.execute(insertPhoneQuery);
                }

                ShowSuccess("Account created successfully! You can now login with your credentials.");
                
                // Clear form
                ClearForm();

                // Redirect to login after 2 seconds
                System.Threading.Thread.Sleep(2000);
                Response.Redirect("Login.aspx");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Registration Error: " + ex.Message);
                ShowError("An error occurred during registration. Please try again later.");
            }
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private bool IsValidPhone(string phone)
        {
            // Remove common phone characters and check if at least 7 digits remain
            string digits = System.Text.RegularExpressions.Regex.Replace(phone, "[^0-9]", "");
            return digits.Length >= 7;
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message-box error-msg";
        }

        private void ShowSuccess(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message-box success-msg";
        }

        private void ClearForm()
        {
            txtFullName.Text = "";
            txtCity.Text = "";
            txtCountry.Text = "";
            txtEmail1.Text = "";
            txtPhone1.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            emailsList.Clear();
            phonesList.Clear();
            phoneTypesList.Clear();
            Session["emailsList"] = null;
            Session["phonesList"] = null;
            Session["phoneTypesList"] = null;
            BindEmailsRepeater();
            BindPhonesRepeater();
        }

        private void SaveEmailsList()
        {
            Session["emailsList"] = emailsList;
        }

        private void SavePhonesList()
        {
            Session["phonesList"] = phonesList;
            Session["phoneTypesList"] = phoneTypesList;
        }

        private void LoadEmailsList()
        {
            if (Session["emailsList"] != null)
            {
                emailsList = (List<string>)Session["emailsList"];
            }
            else
            {
                emailsList = new List<string>();
            }
        }

        private void LoadPhonesList()
        {
            if (Session["phonesList"] != null)
            {
                phonesList = (List<string>)Session["phonesList"];
                phoneTypesList = (List<string>)Session["phoneTypesList"];
            }
            else
            {
                phonesList = new List<string>();
                phoneTypesList = new List<string>();
            }
        }

        private void BindEmailsRepeater()
        {
            rptEmails.DataSource = emailsList;
            rptEmails.DataBind();
        }

        private void BindPhonesRepeater()
        {
            var phoneData = new List<dynamic>();
            for (int i = 0; i < phonesList.Count; i++)
            {
                phoneData.Add(new { Phone = phonesList[i], Type = phoneTypesList[i] });
            }
            rptPhones.DataSource = phoneData;
            rptPhones.DataBind();
        }

        // Helper methods for repeater data binding
        public string GetPhoneNumber(object item)
        {
            dynamic phone = item;
            return phone.Phone;
        }

        public string GetPhoneType(object item)
        {
            dynamic phone = item;
            return phone.Type;
        }
    }
}

using System;
using System.Data;

namespace Device_Licence_Control
{
    public partial class CreateKey : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Utils.SessionManager.IsUserLoggedIn(this))
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int userId = Utils.SessionManager.GetUserId(this);
                litUserName.Text = Utils.SessionManager.GetUserFullName(this);
                txtOwnerID.Text = userId.ToString();
                LoadPackages();
            }
        }

        private void LoadPackages()
        {
            try
            {
                DBConnection db = new DBConnection();
                string query = "SELECT PackageID, PackageModel, Version FROM [dbo].[Package] ORDER BY PackageModel";
                DataSet ds = db.getSelect(query);

                ddlPackage.Items.Clear();
                ddlPackage.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select Package --", ""));

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        string packageID = row["PackageID"].ToString();
                        string packageModel = row["PackageModel"].ToString();
                        string version = row["Version"].ToString();
                        string displayText = packageModel + " (v" + version + ")";
                        ddlPackage.Items.Add(new System.Web.UI.WebControls.ListItem(displayText, packageID));
                    }
                }
                else
                {
                    ddlPackage.Items.Add(new System.Web.UI.WebControls.ListItem("-- No Packages Available --", ""));
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadPackages Error: " + ex.Message);
                ShowError("Error loading packages: " + ex.Message);
            }
        }

        protected void btnCreateKey_Click(object sender, EventArgs e)
        {
            try
            {
                string ownerID = txtOwnerID.Text.Trim();
                string packageID = ddlPackage.SelectedValue;
                string status = "not transferred";

                if (string.IsNullOrWhiteSpace(packageID))
                {
                    ShowError("Please select a package.");
                    return;
                }

                string key = GenerateActivationKey();

                DBConnection db = new DBConnection();
                string query = string.Format(
                    "INSERT INTO [dbo].[ActivationKey] (Key, OwnerID, PackageID, CreatedDate, Status) VALUES ('{0}', {1}, {2}, GETDATE(), '{3}')",
                    key,
                    ownerID,
                    packageID,
                    status
                );

                bool success = db.execute(query);

                if (success)
                {
                    ShowSuccess("Activation key created successfully! Key: " + key);
                    ddlPackage.SelectedIndex = 0;
                }
                else
                {
                    ShowError("Failed to create activation key. Please try again.");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CreateKey Error: " + ex.Message);
                ShowError("An error occurred while creating the key: " + ex.Message);
            }
        }

        private string GenerateActivationKey()
        {
            const string prefix = "KEY";
            const string letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

            var random = new Random();

            int numberPart = random.Next(0, 10000);
            string numericSegment = numberPart.ToString("D4");

            var letterSegment = new System.Text.StringBuilder(3);
            for (int i = 0; i < 3; i++)
            {
                letterSegment.Append(letters[random.Next(letters.Length)]);
            }

            return $"{prefix}-{numericSegment}-{letterSegment}";
        }


        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Utils.SessionManager.ClearUserSession(this);
            Response.Redirect("Login.aspx");
        }

        private void ShowSuccess(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message-box success";
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message-box error";
        }
    }
}

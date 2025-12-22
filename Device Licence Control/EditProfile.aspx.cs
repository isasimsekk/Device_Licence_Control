using System;

namespace Device_Licence_Control
{
    public partial class EditProfile : System.Web.UI.Page
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
                string userFullName = Utils.SessionManager.GetUserFullName(this);
                litUserName.Text = userFullName;
                txtFullName.Text = userFullName;
                txtFullName.Enabled = false;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                string currentPassword = txtCurrentPassword.Text.Trim();
                string newPassword = txtNewPassword.Text.Trim();
                string confirmPassword = txtConfirmPassword.Text.Trim();

                // Validate current password
                if (string.IsNullOrWhiteSpace(currentPassword))
                {
                    ShowError("Current password is required.");
                    return;
                }

                // Get current user
                string userFullName = Utils.SessionManager.GetUserFullName(this);
                int userId = Utils.SessionManager.GetUserId(this);

                // Verify current password
                DBConnection db = new DBConnection();
                string verifyQuery = "SELECT COUNT(*) FROM [User] WHERE UserId = " + userId + " AND Password = " + currentPassword;
                
                System.Data.DataSet dsVerify = db.getSelect(verifyQuery);
                
                if (dsVerify == null || dsVerify.Tables.Count == 0 || dsVerify.Tables[0].Rows.Count == 0)
                {
                    ShowError("Current password is incorrect.");
                    return;
                }

                int count = Convert.ToInt32(dsVerify.Tables[0].Rows[0][0]);
                if (count == 0)
                {
                    ShowError("Current password is incorrect.");
                    return;
                }

                // If user wants to change password
                if (!string.IsNullOrWhiteSpace(newPassword))
                {
                    // Validate new password
                    if (newPassword.Length < 6)
                    {
                        ShowError("New password must be at least 6 characters long.");
                        return;
                    }

                    // Check if passwords match
                    if (newPassword != confirmPassword)
                    {
                        ShowError("New password and confirmation password do not match.");
                        return;
                    }

                    // Update password
                    string updateQuery = "UPDATE [User] SET Password = " + newPassword + " WHERE UserId = " + userId;
                    bool success = db.execute(updateQuery);

                    if (success)
                    {
                        lblMessage.Text = "Password updated successfully.";
                        lblMessage.CssClass = "message-box success";
                        txtCurrentPassword.Text = "";
                        txtNewPassword.Text = "";
                        txtConfirmPassword.Text = "";
                    }
                    else
                    {
                        ShowError("Failed to update password. Please try again.");
                    }
                }
                else
                {
                    // No password change, just show success message
                    lblMessage.Text = "Profile saved successfully.";
                    lblMessage.CssClass = "message-box success";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Save Profile Error: " + ex.Message);
                ShowError("An error occurred while saving your profile.");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewProfile.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Utils.SessionManager.ClearUserSession(this);
            Response.Redirect("Login.aspx");
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message-box error";
        }
    }
}

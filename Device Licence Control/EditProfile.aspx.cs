using System;
using System.Data.SqlClient;

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

                LoadUserLocationData();
            }
        }

        private void LoadUserLocationData()
        {
            try
            {
                int userId = Utils.SessionManager.GetUserId(this);
                DBConnection db = new DBConnection();
                string query = "SELECT City, Country FROM [User] WHERE UserId = " + userId;

                System.Data.DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    System.Data.DataRow row = ds.Tables[0].Rows[0];
                    txtCity.Text = row["City"] != System.DBNull.Value ? row["City"].ToString() : "";
                    txtCountry.Text = row["Country"] != System.DBNull.Value ? row["Country"].ToString() : "";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUserLocationData Error: " + ex.Message);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                string currentPassword = txtCurrentPassword.Text.Trim();
                string newPassword = txtNewPassword.Text.Trim();
                string confirmPassword = txtConfirmPassword.Text.Trim();
                string city = txtCity.Text.Trim();
                string country = txtCountry.Text.Trim();

                if (string.IsNullOrWhiteSpace(currentPassword))
                {
                    ShowError("Current password is required.");
                    return;
                }

                int userId = Utils.SessionManager.GetUserId(this);

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

                bool updatePassword = false;

                if (!string.IsNullOrWhiteSpace(newPassword))
                {
                    if (newPassword.Length < 6)
                    {
                        ShowError("New password must be at least 6 characters long.");
                        return;
                    }

                    if (newPassword != confirmPassword)
                    {
                        ShowError("New password and confirmation password do not match.");
                        return;
                    }

                    updatePassword = true;
                }

                if (updatePassword)
                {
                    string updateQuery = "UPDATE [User] SET Password = " + newPassword + " WHERE UserId = " + userId;
                    bool passwordSuccess = db.execute(updateQuery);

                    if (!passwordSuccess)
                    {
                        ShowError("Failed to update password. Please try again.");
                        return;
                    }
                }

                bool locationSuccess = UpdateUserLocation(userId, city, country);

                if (locationSuccess)
                {
                    lblMessage.Text = updatePassword ? "Profile and password updated successfully." : "Profile updated successfully.";
                    lblMessage.CssClass = "message-box success";
                    txtCurrentPassword.Text = "";
                    txtNewPassword.Text = "";
                    txtConfirmPassword.Text = "";
                }
                else
                {
                    ShowError("Failed to update location information. Please try again.");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Save Profile Error: " + ex.Message);
                ShowError("An error occurred while saving your profile.");
            }
        }

        private bool UpdateUserLocation(int userId, string city, string country)
        {
            try
            {
                DBConnection db = new DBConnection();

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UserId", userId),
                    new SqlParameter("@City", string.IsNullOrWhiteSpace(city) ? (object)DBNull.Value : city),
                    new SqlParameter("@Country", string.IsNullOrWhiteSpace(country) ? (object)DBNull.Value : country)
                };

                return db.ExecuteStoredProcedure("UpdateUserLocation", parameters);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("UpdateUserLocation Error: " + ex.Message);
                return false;
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

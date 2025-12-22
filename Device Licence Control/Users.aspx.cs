using System;
using System.Data;

namespace Device_Licence_Control
{
    public partial class Users : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Utils.SessionManager.IsUserLoggedIn(this))
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!Utils.SessionManager.IsUserAdmin(this))
            {
                Response.Redirect("Dashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            try
            {
                DBConnection db = new DBConnection();
                string query = "SELECT UserId, FullName, IsActive, isAdmin FROM [User]";
                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0)
                {
                    rptUsers.DataSource = ds.Tables[0];
                    rptUsers.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUsers Error: " + ex.Message);
                lblMessage.Text = "An error occurred while loading users.";
                lblMessage.CssClass = "message-box error-msg";
            }
        }

        protected void rptUsers_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "MakeAdmin")
            {
                int userId = 0;
                if (int.TryParse(e.CommandArgument.ToString(), out userId) && userId > 0)
                {
                    try
                    {
                        DBConnection db = new DBConnection();
                        string updateQuery = "UPDATE [User] SET isAdmin = 1 WHERE UserId = " + userId;
                        bool success = db.execute(updateQuery);

                        if (success)
                        {
                            lblMessage.Text = "User promoted to admin successfully.";
                            lblMessage.CssClass = "message-box success-msg";
                            LoadUsers();
                        }
                        else
                        {
                            lblMessage.Text = "Failed to update user role.";
                            lblMessage.CssClass = "message-box error-msg";
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("MakeAdmin Error: " + ex.Message);
                        lblMessage.Text = "An error occurred while updating user role.";
                        lblMessage.CssClass = "message-box error-msg";
                    }
                }
            }
            else if (e.CommandName == "Deactivate")
            {
                int userId = 0;
                if (int.TryParse(e.CommandArgument.ToString(), out userId) && userId > 0)
                {
                    if (userId == Utils.SessionManager.GetUserId(this))
                    {
                        lblMessage.Text = "You cannot deactivate your own account.";
                        lblMessage.CssClass = "message-box error-msg";
                        return;
                    }

                    try
                    {
                        DBConnection db = new DBConnection();
                        string updateQuery = "UPDATE [User] SET IsActive = 0 WHERE UserId = " + userId;
                        bool success = db.execute(updateQuery);

                        if (success)
                        {
                            lblMessage.Text = "User account deactivated successfully.";
                            lblMessage.CssClass = "message-box success-msg";
                            LoadUsers();
                        }
                        else
                        {
                            lblMessage.Text = "Failed to deactivate user.";
                            lblMessage.CssClass = "message-box error-msg";
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Deactivate Error: " + ex.Message);
                        lblMessage.Text = "An error occurred while deactivating the user.";
                        lblMessage.CssClass = "message-box error-msg";
                    }
                }
            }
        }
    }
}

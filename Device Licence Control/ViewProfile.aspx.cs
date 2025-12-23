using System;
using System.Data;

namespace Device_Licence_Control
{
    public partial class ViewProfile : System.Web.UI.Page
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
                
                LoadUserProfile();
            }
        }

        private void LoadUserProfile()
        {
            try
            {
                string userFullName = Utils.SessionManager.GetUserFullName(this);
                
                DBConnection db = new DBConnection();
                string query = "SELECT UserId, FullName, IsActive, isAdmin, CreatedAt, City, Country FROM [User] WHERE FullName = '" + userFullName + "'";
                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];
                    
                    int userId = Convert.ToInt32(row["UserId"]);
                    string fullName = row["FullName"].ToString();
                    bool isActive = Convert.ToBoolean(row["IsActive"]);
                    bool isAdmin = Convert.ToBoolean(row["isAdmin"]);
                    DateTime createdDate = Convert.ToDateTime(row["CreatedAt"]);
                    string city = row["City"] != DBNull.Value ? row["City"].ToString() : "";
                    string country = row["Country"] != DBNull.Value ? row["Country"].ToString() : "";

                    litFullName.Text = fullName;
                    litUserId.Text = userId.ToString();
                    litProfileFullName.Text = fullName;
                    litRole.Text = isAdmin 
                        ? "<span class=\"badge badge-admin\">Administrator</span>" 
                        : "<span class=\"badge badge-user\">User</span>";
                    litStatus.Text = isActive 
                        ? "<span class=\"badge badge-active\">Active</span>" 
                        : "<span class=\"badge badge-inactive\">Inactive</span>";
                    litCreatedDate.Text = createdDate.ToString("MMMM dd, yyyy");
                    
                    // Display location information
                    if (!string.IsNullOrWhiteSpace(city) || !string.IsNullOrWhiteSpace(country))
                    {
                        litLocation.Text = string.Format("{0}{1}{2}",
                            city,
                            (!string.IsNullOrWhiteSpace(city) && !string.IsNullOrWhiteSpace(country)) ? ", " : "",
                            country);
                    }
                    else
                    {
                        litLocation.Text = "<span style=\"color: #bdc3c7;\">Not specified</span>";
                    }
                }
                else
                {
                    lblMessage.Text = "Unable to load user profile.";
                    lblMessage.CssClass = "message-box error";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUserProfile Error: " + ex.Message);
                lblMessage.Text = "An error occurred while loading your profile.";
                lblMessage.CssClass = "message-box error";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Utils.SessionManager.ClearUserSession(this);
            Response.Redirect("Login.aspx");
        }
    }
}

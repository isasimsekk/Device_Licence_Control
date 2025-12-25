using System;

namespace Device_Licence_Control
{
    public partial class Dashboard : System.Web.UI.Page
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

                bool isAdmin = Utils.SessionManager.IsUserAdmin(this);
                pnlAdminButton.Visible = isAdmin;
                pnlAdminNotice.Visible = isAdmin;

                LoadStatistics();
            }
        }

        private void LoadStatistics()
        {
            try
            {
                Data.StatisticsDAL statsDAL = new Data.StatisticsDAL();
                
                int activeUserCount = statsDAL.GetActiveUserCount();
                int totalDeviceCount = statsDAL.GetTotalRegisteredDeviceCount();
                int totalKeysCount = statsDAL.GetTotalActivationKeysCount();
                int unassignedKeysCount = statsDAL.GetUnassignedKeysCount();
                int totalAssignmentsCount = statsDAL.GetTotalAssignmentsCount();
                
                litActiveUserCount.Text = activeUserCount.ToString();
                litTotalDeviceCount.Text = totalDeviceCount.ToString();
                litTotalKeysCount.Text = totalKeysCount.ToString();
                litUnassignedKeysCount.Text = unassignedKeysCount.ToString();
                litTotalAssignmentsCount.Text = totalAssignmentsCount.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading statistics: " + ex.Message);
                litActiveUserCount.Text = "0";
                litTotalDeviceCount.Text = "0";
                litTotalKeysCount.Text = "0";
                litUnassignedKeysCount.Text = "0";
                litTotalAssignmentsCount.Text = "0";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Utils.SessionManager.ClearUserSession(this);
            Response.Redirect("Login.aspx");
        }
    }
}

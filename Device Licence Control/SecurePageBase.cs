using System;

namespace Device_Licence_Control
{
    /// <summary>
    /// Base page class to enforce authentication across all secure pages
    /// </summary>
    public class SecurePageBase : System.Web.UI.Page
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            // Check if user is logged in
            if (!Utils.SessionManager.IsUserLoggedIn(this))
            {
                Response.Redirect("~/Login.aspx");
            }
        }

        /// <summary>
        /// Get current logged-in user's full name
        /// </summary>
        protected string CurrentUserName
        {
            get { return Utils.SessionManager.GetUserFullName(this); }
        }

        /// <summary>
        /// Check if current user is admin
        /// </summary>
        protected bool IsCurrentUserAdmin
        {
            get { return Utils.SessionManager.IsUserAdmin(this); }
        }

        /// <summary>
        /// Logout current user
        /// </summary>
        protected void LogoutUser()
        {
            Utils.SessionManager.ClearUserSession(this);
            Response.Redirect("~/Login.aspx");
        }
    }
}

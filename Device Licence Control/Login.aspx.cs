using System;
using Device_Licence_Control.Business;
using Device_Licence_Control.Models;
using Device_Licence_Control.Utils;

namespace Device_Licence_Control
{
    public partial class Login : System.Web.UI.Page
    {
        private AuthenticationBLL authBLL;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is already logged in
            if (SessionManager.IsUserLoggedIn(this))
            {
                Response.Redirect("Dashboard.aspx");
            }

            // Clear message on initial page load - don't show red line on first visit
            if (!IsPostBack)
            {
                lblMessage.Text = "";
                lblMessage.CssClass = "message-box"; // Keep it hidden
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            authBLL = new AuthenticationBLL();

            string userIDInput = txtUserID.Text.Trim();
            string passwordInput = txtPassword.Text.Trim();

            string errorMessage;

            // Validate UserID is a number
            int userID;
            if (!int.TryParse(userIDInput, out userID))
            {
                lblMessage.Text = "User ID must be a valid number.";
                lblMessage.CssClass = "message-box error-msg";
                txtPassword.Text = "";
                return;
            }

            // Authenticate user using business logic
            User user = authBLL.AuthenticateUser(userID, passwordInput, out errorMessage);

            if (user != null)
            {
                // User authenticated successfully
                SessionManager.SetUserSession(this, user);
                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                // Authentication failed, display error message with proper styling
                lblMessage.Text = errorMessage;
                lblMessage.CssClass = "message-box error-msg"; // Show error message in red
                txtPassword.Text = ""; // Clear password field for security
            }
        }
    }
}

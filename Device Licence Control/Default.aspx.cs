using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Device_Licence_Control
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to Login if user is not logged in
            if (!Utils.SessionManager.IsUserLoggedIn(this))
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // If already logged in, redirect to Dashboard
            Response.Redirect("Dashboard.aspx");
        }
    }
}
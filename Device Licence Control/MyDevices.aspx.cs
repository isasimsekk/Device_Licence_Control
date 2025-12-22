using System;
using System.Data;

namespace Device_Licence_Control
{
    public partial class MyDevices : System.Web.UI.Page
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
                litUserName.Text = Utils.SessionManager.GetUserFullName(this);
                LoadMyRegisteredDevices();
            }
        }

        private void LoadMyRegisteredDevices()
        {
            try
            {
                int userId = Utils.SessionManager.GetUserId(this);

                DBConnection db = new DBConnection();

                // Query user's registered devices with device type name and manufacturer
                string query = @"
                    SELECT 
                        rd.DeviceID,
                        rd.DeviceName,
                        dt.TypeName AS DeviceType,
                        dt.Manufacturer,
                        rd.SerialNumber,
                        rd.RegisterDate,
                        rd.Status
                    FROM [dbo].[RegisteredDevice] rd
                    LEFT JOIN [dbo].[DeviceType] dt ON rd.DeviceTypeID = dt.DeviceTypeID
                    WHERE rd.OwnerID = " + userId + @"
                    ORDER BY rd.RegisterDate DESC";

                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    gvMyDevices.DataSource = ds.Tables[0];
                    gvMyDevices.DataBind();
                    pnlDevices.Visible = true;
                    pnlEmpty.Visible = false;
                }
                else
                {
                    pnlDevices.Visible = false;
                    pnlEmpty.Visible = true;
                }

                lblMessage.Text = string.Empty;
                lblMessage.CssClass = "message-box";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadMyRegisteredDevices Error: " + ex.Message);
                ShowError("Error loading devices: " + ex.Message);
            }
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

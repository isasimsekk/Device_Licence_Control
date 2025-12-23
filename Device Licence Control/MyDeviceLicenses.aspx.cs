using System;
using System.Data;

namespace Device_Licence_Control
{
    public partial class MyDeviceLicenses : System.Web.UI.Page
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
                LoadMyDeviceLicenses();
            }
        }

        private void LoadMyDeviceLicenses()
        {
            try
            {
                int userId = Utils.SessionManager.GetUserId(this);

                DBConnection db = new DBConnection();

                // Query user's device licenses from KeyDeviceAssignment table
                string query = @"
                SELECT 
                    kda.KeyDeviceAssignmentID,
                    kda.ActivationKeyID,
                    dt.typeName AS DeviceModel,       
                    rd.DeviceName,                    
                    kda.AssignmentDate,
                    rd.Status,                        
                    rd.RegisterDate AS CreatedDate    
                FROM [dbo].[KeyDeviceAssignment] kda
                INNER JOIN [dbo].[ActivationKey] ak ON kda.ActivationKeyID = ak.ActivationKeyID
                INNER JOIN [dbo].[RegisteredDevice] rd ON kda.DeviceID = rd.DeviceID
                LEFT JOIN [dbo].[DeviceType] dt ON rd.DeviceTypeID = dt.DeviceTypeID
                WHERE ak.OwnerID = " + userId + @"
                ORDER BY kda.AssignmentDate DESC";

                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    gvDeviceLicenses.DataSource = ds.Tables[0];
                    gvDeviceLicenses.DataBind();
                    pnlLicenses.Visible = true;
                    pnlEmpty.Visible = false;
                }
                else
                {
                    pnlLicenses.Visible = false;
                    pnlEmpty.Visible = true;
                }

                lblMessage.Text = string.Empty;
                lblMessage.CssClass = "message-box";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadMyDeviceLicenses Error: " + ex.Message);
                ShowError("Error loading device licenses: " + ex.Message);
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

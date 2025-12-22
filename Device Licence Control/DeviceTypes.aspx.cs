using System;
using System.Data;

namespace Device_Licence_Control
{
    public partial class DeviceTypes : System.Web.UI.Page
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
                litUserName.Text = Utils.SessionManager.GetUserFullName(this);
                LoadDeviceTypes();
            }
        }

        private void LoadDeviceTypes()
        {
            try
            {
                DBConnection db = new DBConnection();
                string query = "SELECT DeviceTypeID, TypeName, Manufacturer FROM [dbo].[DeviceType] ORDER BY TypeName";
                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    gvDeviceTypes.DataSource = ds.Tables[0];
                    gvDeviceTypes.DataBind();
                    pnlTypes.Visible = true;
                    pnlEmpty.Visible = false;
                }
                else
                {
                    pnlTypes.Visible = false;
                    pnlEmpty.Visible = true;
                }

                lblMessage.Text = string.Empty;
                lblMessage.CssClass = "message-box";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadDeviceTypes Error: " + ex.Message);
                ShowError("Error loading device types: " + ex.Message);
            }
        }

        protected void btnAddType_Click(object sender, EventArgs e)
        {
            try
            {
                string typeName = txtTypeName.Text.Trim();
                string manufacturer = txtManufacturer.Text.Trim();

                if (string.IsNullOrWhiteSpace(typeName))
                {
                    ShowError("Type name is required.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(manufacturer))
                {
                    ShowError("Manufacturer is required.");
                    return;
                }

                DBConnection db = new DBConnection();
                string query = string.Format(
                    "INSERT INTO [dbo].[DeviceType] (TypeName, Manufacturer) VALUES ('{0}', '{1}')",
                    typeName.Replace("'", "''"),
                    manufacturer.Replace("'", "''")
                );

                bool success = db.execute(query);

                if (success)
                {
                    ShowSuccess("Device type added successfully.");
                    txtTypeName.Text = "";
                    txtManufacturer.Text = "";
                    LoadDeviceTypes();
                }
                else
                {
                    ShowError("Failed to add device type. Please try again.");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("AddDeviceType Error: " + ex.Message);
                ShowError("An error occurred while adding the device type: " + ex.Message);
            }
        }

        protected void gvDeviceTypes_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteType")
            {
                try
                {
                    int deviceTypeId = Convert.ToInt32(e.CommandArgument);

                    DBConnection db = new DBConnection();
                    string query = "DELETE FROM [dbo].[DeviceType] WHERE DeviceTypeID = " + deviceTypeId;
                    bool success = db.execute(query);

                    if (success)
                    {
                        ShowSuccess("Device type deleted successfully.");
                        LoadDeviceTypes();
                    }
                    else
                    {
                        ShowError("Failed to delete device type. Please try again.");
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("DeleteDeviceType Error: " + ex.Message);
                    ShowError("An error occurred while deleting the device type: " + ex.Message);
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Utils.SessionManager.ClearUserSession(this);
            Response.Redirect("Login.aspx");
        }

        private void ShowSuccess(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message-box success";
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message-box error";
        }
    }
}

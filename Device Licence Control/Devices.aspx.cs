using System;
using System.Data;

namespace Device_Licence_Control
{
    public partial class Devices : System.Web.UI.Page
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
                string userFullName = Utils.SessionManager.GetUserFullName(this);
                litUserName.Text = userFullName;
                LoadDeviceTypes();
                LoadDevices();
            }
        }

        private void LoadDeviceTypes()
        {
            try
            {
                DBConnection db = new DBConnection();
                string query = "SELECT DeviceTypeId, DeviceTypeName FROM [DeviceType] ORDER BY DeviceTypeName";
                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ddlDeviceType.DataSource = ds.Tables[0];
                    ddlDeviceType.DataTextField = "DeviceTypeName";
                    ddlDeviceType.DataValueField = "DeviceTypeId";
                    ddlDeviceType.DataBind();
                    ddlDeviceType.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Device Type --", ""));
                }
                else
                {
                    ddlDeviceType.Items.Clear();
                    ddlDeviceType.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- No Device Types Available --", ""));
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadDeviceTypes Error: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Stack Trace: " + ex.StackTrace);
                ShowError("Error loading device types: " + ex.Message);
            }
        }

        private void LoadDevices()
        {
            try
            {
                DBConnection db = new DBConnection();
                string query = @"
                    SELECT 
                        DeviceId, 
                        DeviceName, 
                        DeviceTypeId, 
                        DeviceModel, 
                        SerialNumber 
                    FROM [Device]
                    ORDER BY DeviceId DESC
                ";
                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0)
                {
                    gvDevices.DataSource = ds.Tables[0];
                    gvDevices.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadDevices Error: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Stack Trace: " + ex.StackTrace);
                ShowError("Error loading devices: " + ex.Message);
            }
        }

        protected void btnAddDevice_Click(object sender, EventArgs e)
        {
            try
            {
                string deviceName = txtDeviceName.Text.Trim();
                string deviceTypeId = ddlDeviceType.SelectedValue;
                string deviceModel = txtDeviceModel.Text.Trim();
                string serialNumber = txtSerialNumber.Text.Trim();

                if (string.IsNullOrWhiteSpace(deviceName))
                {
                    ShowError("Device name is required.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(deviceTypeId))
                {
                    ShowError("Device type is required.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(deviceModel))
                {
                    ShowError("Device model is required.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(serialNumber))
                {
                    ShowError("Serial number is required.");
                    return;
                }

                DBConnection db = new DBConnection();
                string query = string.Format(
                    "INSERT INTO [Device] (DeviceName, DeviceTypeId, DeviceModel, SerialNumber) VALUES ('{0}', {1}, '{2}', '{3}')",
                    deviceName.Replace("'", "''"),
                    deviceTypeId,
                    deviceModel.Replace("'", "''"),
                    serialNumber.Replace("'", "''")
                );

                bool success = db.execute(query);

                if (success)
                {
                    ShowSuccess("Device added successfully.");
                    txtDeviceName.Text = "";
                    ddlDeviceType.SelectedIndex = 0;
                    txtDeviceModel.Text = "";
                    txtSerialNumber.Text = "";
                    LoadDevices();
                }
                else
                {
                    ShowError("Failed to add device. Please try again.");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("AddDevice Error: " + ex.Message);
                ShowError("An error occurred while adding the device: " + ex.Message);
            }
        }

        protected void gvDevices_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteDevice")
            {
                try
                {
                    int deviceId = Convert.ToInt32(e.CommandArgument);

                    DBConnection db = new DBConnection();
                    string query = "DELETE FROM [Device] WHERE DeviceId = " + deviceId;
                    bool success = db.execute(query);

                    if (success)
                    {
                        ShowSuccess("Device deleted successfully.");
                        LoadDevices();
                    }
                    else
                    {
                        ShowError("Failed to delete device. Please try again.");
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("DeleteDevice Error: " + ex.Message);
                    ShowError("An error occurred while deleting the device: " + ex.Message);
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

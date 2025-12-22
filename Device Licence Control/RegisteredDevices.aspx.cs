using System;
using System.Data;

namespace Device_Licence_Control
{
    public partial class RegisteredDevices : System.Web.UI.Page
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
                LoadUsers();
                LoadDeviceTypes();
                SetDefaultRegisterDate();
            }
        }

        private void LoadUsers()
        {
            try
            {
                DBConnection db = new DBConnection();
                string query = "SELECT UserID, FullName FROM [dbo].[User] ORDER BY FullName";
                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ddlUser.DataSource = ds.Tables[0];
                    ddlUser.DataTextField = "FullName";
                    ddlUser.DataValueField = "UserID";
                    ddlUser.DataBind();
                    ddlUser.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select User --", ""));
                }
                else
                {
                    ddlUser.Items.Clear();
                    ddlUser.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- No Users Available --", ""));
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUsers Error: " + ex.Message);
                ShowError("Error loading users: " + ex.Message);
            }
        }

        private void LoadDeviceTypes()
        {
            try
            {
                DBConnection db = new DBConnection();
                string query = "SELECT DeviceTypeID, TypeName FROM [dbo].[DeviceType] ORDER BY TypeName";
                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ddlDeviceType.DataSource = ds.Tables[0];
                    ddlDeviceType.DataTextField = "TypeName";
                    ddlDeviceType.DataValueField = "DeviceTypeID";
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
                ShowError("Error loading device types: " + ex.Message);
            }
        }

        private void SetDefaultRegisterDate()
        {
            txtRegisterDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        }

        protected void btnRegisterDevice_Click(object sender, EventArgs e)
        {
            try
            {
                string userId = ddlUser.SelectedValue;
                string deviceTypeId = ddlDeviceType.SelectedValue;
                string deviceName = txtDeviceName.Text.Trim();
                string serialNumber = txtSerialNumber.Text.Trim();
                string registerDate = txtRegisterDate.Text.Trim();

                if (string.IsNullOrWhiteSpace(userId))
                {
                    ShowError("Please select a user.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(deviceTypeId))
                {
                    ShowError("Please select a device type.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(deviceName))
                {
                    ShowError("Device name is required.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(serialNumber))
                {
                    ShowError("Serial number is required.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(registerDate))
                {
                    ShowError("Registration date is required.");
                    return;
                }

                DBConnection db = new DBConnection();
                string query = string.Format(
                    "INSERT INTO [dbo].[RegisteredDevice] (OwnerID, DeviceTypeID, DeviceName, SerialNumber, RegisterDate, Status) VALUES ({0}, {1}, '{2}', '{3}', CONVERT(DATE, '{4}', 120), 'Unregistered')",
                    userId,
                    deviceTypeId,
                    deviceName.Replace("'", "''"),
                    serialNumber.Replace("'", "''"),
                    registerDate
                );

                bool success = db.execute(query);

                if (success)
                {
                    ShowSuccess("Device registered successfully.");
                    ClearForm();
                }
                else
                {
                    ShowError("Failed to register device. Please try again.");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("RegisterDevice Error: " + ex.Message);
                ShowError("An error occurred while registering the device: " + ex.Message);
            }
        }

        private void ClearForm()
        {
            ddlUser.SelectedIndex = 0;
            ddlDeviceType.SelectedIndex = 0;
            txtDeviceName.Text = "";
            txtSerialNumber.Text = "";
            SetDefaultRegisterDate();
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

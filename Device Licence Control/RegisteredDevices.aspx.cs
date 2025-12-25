using System;
using System.Data;

namespace Device_Licence_Control
{
    public partial class RegisteredDevices : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (!Utils.SessionManager.IsUserLoggedIn(this))
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Check if user is admin
            if (!Utils.SessionManager.IsUserAdmin(this))
            {
                Response.Redirect("Dashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUsers();
                LoadDeviceTypes();
                LoadRegisteredDevices();

                // Display current user name
                litUserName.Text = Utils.SessionManager.GetUserFullName(this);
            }
        }

        private void LoadUsers()
        {
            try
            {
                DBConnection db = new DBConnection();
                string query = "SELECT UserId, FullName FROM [User] ORDER BY FullName";
                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ddlUser.DataSource = ds.Tables[0];
                    ddlUser.DataTextField = "FullName";
                    ddlUser.DataValueField = "UserId";
                    ddlUser.DataBind();
                }

                // Add default item at the beginning
                ddlUser.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select User --", ""));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUsers Error: " + ex.Message);
                ShowMessage("Error loading users: " + ex.Message, "error");
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
                }

                // Add default item at the beginning
                ddlDeviceType.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Device Type --", ""));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadDeviceTypes Error: " + ex.Message);
                ShowMessage("Error loading device types: " + ex.Message, "error");
            }
        }

        private void LoadRegisteredDevices()
        {
            try
            {
                DBConnection db = new DBConnection();
                string query = @"
                    SELECT 
                        rd.DeviceID,
                        rd.DeviceName,
                        rd.SerialNumber,
                        rd.OwnerID,
                        u.FullName as OwnerName,
                        dt.TypeName,
                        rd.RegisterDate,
                        rd.[Status]
                    FROM [dbo].[RegisteredDevice] rd
                    INNER JOIN [User] u ON rd.OwnerID = u.UserId
                    INNER JOIN [dbo].[DeviceType] dt ON rd.DeviceTypeID = dt.DeviceTypeID
                    ORDER BY rd.RegisterDate DESC";
                
                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    gvRegisteredDevices.DataSource = ds.Tables[0];
                    gvRegisteredDevices.DataBind();
                    pnlDevicesList.Visible = true;
                    pnlNoDevices.Visible = false;
                }
                else
                {
                    pnlDevicesList.Visible = false;
                    pnlNoDevices.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadRegisteredDevices Error: " + ex.Message);
                ShowMessage("Error loading devices: " + ex.Message, "error");
            }
        }

        protected void btnRegisterDevice_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(ddlUser.SelectedValue))
                {
                    ShowMessage("Please select a user.", "error");
                    return;
                }

                if (string.IsNullOrEmpty(ddlDeviceType.SelectedValue))
                {
                    ShowMessage("Please select a device type.", "error");
                    return;
                }

                if (string.IsNullOrEmpty(txtDeviceName.Text.Trim()))
                {
                    ShowMessage("Please enter a device name.", "error");
                    return;
                }

                if (string.IsNullOrEmpty(txtSerialNumber.Text.Trim()))
                {
                    ShowMessage("Please enter a serial number.", "error");
                    return;
                }

                if (string.IsNullOrEmpty(txtRegisterDate.Text.Trim()))
                {
                    ShowMessage("Please enter a registration date.", "error");
                    return;
                }

                int userID = int.Parse(ddlUser.SelectedValue);
                int typeID = int.Parse(ddlDeviceType.SelectedValue);
                string deviceName = txtDeviceName.Text.Trim().Replace("'", "''");
                string serialNumber = txtSerialNumber.Text.Trim().Replace("'", "''");
                DateTime registerDate = DateTime.Parse(txtRegisterDate.Text);

                // Insert device using executeWithException to get actual errors
                DBConnection db = new DBConnection();
                string insertQuery = string.Format(
                    "INSERT INTO [dbo].[RegisteredDevice] (OwnerID, DeviceTypeID, DeviceName, SerialNumber, RegisterDate, [Status]) " +
                    "VALUES ({0}, {1}, '{2}', '{3}', '{4:yyyy-MM-dd}', 'unregistered')",
                    userID, typeID, deviceName, serialNumber, registerDate);

                db.executeWithException(insertQuery);

                ShowMessage("Device registered successfully!", "success");
                txtDeviceName.Text = "";
                txtSerialNumber.Text = "";
                txtRegisterDate.Text = "";
                ddlUser.SelectedValue = "";
                ddlDeviceType.SelectedValue = "";
                LoadRegisteredDevices();
            }
            catch (FormatException ex)
            {
                System.Diagnostics.Debug.WriteLine("RegisterDevice FormatException: " + ex.Message);
                ShowMessage("Error: Invalid date format or numeric value. Please check your input.", "error");
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine("RegisterDevice SqlException: " + ex.Message);
                ShowMessage("Database Error: " + ex.Message, "error");
            }
            catch (ArgumentException ex)
            {
                System.Diagnostics.Debug.WriteLine("RegisterDevice ArgumentException: " + ex.Message);
                ShowMessage("Error: Invalid argument - " + ex.Message, "error");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("RegisterDevice Error: " + ex.GetType().Name + " - " + ex.Message);
                ShowMessage("Error (" + ex.GetType().Name + "): " + ex.Message, "error");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Utils.SessionManager.ClearUserSession(this);
            Response.Redirect("Login.aspx");
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = type == "error" ? "message-box error" : "message-box success";
        }
    }
}

using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Device_Licence_Control
{
    public partial class Assignment : System.Web.UI.Page
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
                LoadDevices();
                LoadActivationKeys();
                LoadAssignments();
            }
        }

        private void LoadDevices()
        {
            try
            {
                int userId = Utils.SessionManager.GetUserId(this);

                DBConnection db = new DBConnection();
                string query = @"
                    SELECT rd.DeviceID, rd.DeviceName, dt.TypeName
                    FROM [dbo].[RegisteredDevice] rd
                    LEFT JOIN [dbo].[DeviceType] dt ON rd.DeviceTypeID = dt.DeviceTypeID
                    WHERE rd.OwnerID = " + userId + @"
                    ORDER BY rd.DeviceName";

                DataSet ds = db.getSelect(query);

                ddlDevice.Items.Clear();
                ddlDevice.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select Device --", ""));

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        string deviceId = row["DeviceID"].ToString();
                        string deviceName = row["DeviceName"].ToString();
                        string typeName = row["TypeName"].ToString();
                        string displayText = deviceName + (string.IsNullOrEmpty(typeName) ? "" : " (" + typeName + ")");
                        ddlDevice.Items.Add(new System.Web.UI.WebControls.ListItem(displayText, deviceId));
                    }
                }
                else
                {
                    ddlDevice.Items.Add(new System.Web.UI.WebControls.ListItem("-- No Devices Available --", ""));
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadDevices Error: " + ex.Message);
                ShowError("Error loading devices: " + ex.Message);
            }
        }

        private void LoadActivationKeys()
        {
            try
            {
                int userId = Utils.SessionManager.GetUserId(this);

                string connectionString = ConfigurationManager.ConnectionStrings["conStr"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    string query = @"
                        SELECT ak.ActivationKeyID, ak.[Key], p.PackageModel
                        FROM [dbo].[ActivationKey] ak
                        JOIN [dbo].[Package] p ON ak.PackageID = p.PackageID
                        WHERE ak.OwnerID = @OwnerID 
                        AND ak.Status = 'not transferred'
                        AND ak.ActivationKeyID NOT IN (
                            SELECT ActivationKeyID FROM [dbo].[KeyDeviceAssignment]
                        )
                        ORDER BY ak.CreatedDate DESC";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@OwnerID", userId);

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    ddlActivationKey.Items.Clear();
                    ddlActivationKey.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select Activation Key --", ""));

                    if (dt.Rows.Count > 0)
                    {
                        foreach (DataRow row in dt.Rows)
                        {
                            string keyId = row["ActivationKeyID"].ToString();
                            string key = row["Key"].ToString();
                            string packageModel = row["PackageModel"].ToString();
                            string displayText = key.Substring(0, Math.Min(16, key.Length)) + "... (" + packageModel + ")";
                            ddlActivationKey.Items.Add(new System.Web.UI.WebControls.ListItem(displayText, keyId));
                        }
                    }
                    else
                    {
                        ddlActivationKey.Items.Add(new System.Web.UI.WebControls.ListItem("-- No Available Keys --", ""));
                    }

                    con.Close();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadActivationKeys Error: " + ex.Message);
                ShowError("Error loading activation keys: " + ex.Message);
            }
        }

        private void LoadAssignments()
        {
            try
            {
                int userId = Utils.SessionManager.GetUserId(this);

                DBConnection db = new DBConnection();
                string query = @"
                    SELECT 
                        kda.KeyDeviceAssignmentID,
                        ak.[Key],
                        rd.DeviceName,
                        dt.TypeName AS DeviceModel,
                        kda.AssignmentDate
                    FROM [dbo].[KeyDeviceAssignment] kda
                    INNER JOIN [dbo].[ActivationKey] ak ON kda.ActivationKeyID = ak.ActivationKeyID
                    INNER JOIN [dbo].[RegisteredDevice] rd ON kda.DeviceID = rd.DeviceID
                    LEFT JOIN [dbo].[DeviceType] dt ON rd.DeviceTypeID = dt.DeviceTypeID
                    WHERE ak.OwnerID = " + userId + @"
                    ORDER BY kda.AssignmentDate DESC";

                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    gvAssignments.DataSource = ds.Tables[0];
                    gvAssignments.DataBind();
                    pnlAssignments.Visible = true;
                    pnlEmpty.Visible = false;
                }
                else
                {
                    pnlAssignments.Visible = false;
                    pnlEmpty.Visible = true;
                }

                lblMessage.Text = string.Empty;
                lblMessage.CssClass = "message-box";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadAssignments Error: " + ex.Message);
                ShowError("Error loading assignments: " + ex.Message);
            }
        }

        protected void btnAssign_Click(object sender, EventArgs e)
        {
            try
            {
                string deviceId = ddlDevice.SelectedValue;
                string keyId = ddlActivationKey.SelectedValue;

                if (string.IsNullOrWhiteSpace(deviceId))
                {
                    ShowError("Please select a device.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(keyId))
                {
                    ShowError("Please select an activation key.");
                    return;
                }

                string connectionString = ConfigurationManager.ConnectionStrings["conStr"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    string query = @"
                        INSERT INTO [dbo].[KeyDeviceAssignment] 
                        (ActivationKeyID, DeviceID, AssignmentDate) 
                        VALUES (@ActivationKeyID, @DeviceID, GETDATE());
                        
                        UPDATE [dbo].[ActivationKey] 
                        SET Status = 'transferred' 
                        WHERE ActivationKeyID = @ActivationKeyID";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@ActivationKeyID", int.Parse(keyId));
                    cmd.Parameters.AddWithValue("@DeviceID", int.Parse(deviceId));

                    int result = cmd.ExecuteNonQuery();

                    if (result > 0)
                    {
                        ShowSuccess("Assignment created successfully!");
                        LoadDevices();
                        LoadActivationKeys();
                        LoadAssignments();
                    }
                    else
                    {
                        ShowError("Failed to create assignment. Please try again.");
                    }

                    con.Close();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Assign Error: " + ex.Message);
                ShowError("An error occurred: " + ex.Message);
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

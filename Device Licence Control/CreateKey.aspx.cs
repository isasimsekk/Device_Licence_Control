using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Device_Licence_Control
{
    public partial class CreateKey : System.Web.UI.Page
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
                int userId = Utils.SessionManager.GetUserId(this);
                litUserName.Text = Utils.SessionManager.GetUserFullName(this);
                txtOwnerID.Text = userId.ToString();
                LoadPackages();
                LoadUserKeys();
            }
        }

        private void LoadPackages()
        {
            try
            {
                DBConnection db = new DBConnection();
                string query = "SELECT PackageID, PackageModel, Version FROM [dbo].[Package] ORDER BY PackageModel";
                DataSet ds = db.getSelect(query);

                ddlPackage.Items.Clear();
                ddlPackage.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select Package --", ""));

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        string packageID = row["PackageID"].ToString();
                        string packageModel = row["PackageModel"].ToString();
                        string version = row["Version"].ToString();
                        string displayText = packageModel + " (v" + version + ")";
                        ddlPackage.Items.Add(new System.Web.UI.WebControls.ListItem(displayText, packageID));
                    }
                }
                else
                {
                    ddlPackage.Items.Add(new System.Web.UI.WebControls.ListItem("-- No Packages Available --", ""));
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadPackages Error: " + ex.Message);
                ShowError("Error loading packages: " + ex.Message);
            }
        }

        private void LoadUserKeys()
        {
            try
            {
                int userId = Utils.SessionManager.GetUserId(this);
                
                string connectionString = ConfigurationManager.ConnectionStrings["conStr"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    
                    string query = @"SELECT 
                                        ak.[Key], 
                                        p.PackageModel AS Label, 
                                        ak.CreatedDate, 
                                        ak.Status 
                                    FROM [dbo].[ActivationKey] ak 
                                    JOIN [dbo].[Package] p ON ak.PackageID = p.PackageID 
                                    WHERE ak.OwnerID = @OwnerID 
                                    ORDER BY ak.CreatedDate DESC";
                    
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@OwnerID", userId);
                    
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    
                    if (dt.Rows.Count > 0)
                    {
                        gvKeys.DataSource = dt;
                        gvKeys.DataBind();
                        pnlKeys.Visible = true;
                        pnlEmpty.Visible = false;
                    }
                    else
                    {
                        pnlKeys.Visible = false;
                        pnlEmpty.Visible = true;
                    }
                    
                    con.Close();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUserKeys Error: " + ex.Message);
                ShowError("Error loading your keys: " + ex.Message);
            }
        }

        protected void btnCreateKey_Click(object sender, EventArgs e)
        {
            try
            {
                string ownerID = txtOwnerID.Text.Trim();
                string packageID = ddlPackage.SelectedValue;

                if (string.IsNullOrWhiteSpace(packageID))
                {
                    ShowError("Please select a package.");
                    return;
                }

                string key = GenerateActivationKey();

                try
                {
                    bool success = CreateActivationKeyViaStoredProcedure(key, int.Parse(ownerID), int.Parse(packageID));

                    if (success)
                    {
                        ShowSuccess("Activation key created successfully!");
                        ddlPackage.SelectedIndex = 0;
                        LoadUserKeys();
                    }
                    else
                    {
                        ShowError("Failed to create activation key. Please try again.");
                    }
                }
                catch (SqlException sqlEx)
                {
                    System.Diagnostics.Debug.WriteLine("SQL Error: " + sqlEx.Message);
                    System.Diagnostics.Debug.WriteLine("SQL Error Details: " + sqlEx.InnerException?.Message);
                    ShowError("Database error: " + sqlEx.Message);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CreateKey Error: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("CreateKey Error Details: " + ex.InnerException?.Message);
                ShowError("An error occurred: " + ex.Message);
            }
        }

        private bool CreateActivationKeyViaStoredProcedure(string key, int ownerID, int packageID)
        {
            try
            {
                DBConnection db = new DBConnection();

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Key", key),
                    new SqlParameter("@OwnerID", ownerID),
                    new SqlParameter("@PackageID", packageID)
                };

                return db.ExecuteStoredProcedure("usp_CreateActivationKey", parameters);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CreateActivationKeyViaStoredProcedure Error: " + ex.Message);
                throw;
            }
        }

        private string GenerateActivationKey()
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            Random random = new Random();
            string key = "";

            for (int i = 0; i < 64; i++)
            {
                key += chars[random.Next(chars.Length)];
            }

            return key;
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

using System;
using System.Data;

namespace Device_Licence_Control
{
    public partial class Packages : System.Web.UI.Page
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
                LoadPackages();
            }
        }

        private void LoadPackages()
        {
            try
            {
                DBConnection db = new DBConnection();
                string query = "SELECT PackageID, PackageModel, Version, FullName FROM [dbo].[Package] ORDER BY PackageModel";
                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    gvPackages.DataSource = ds.Tables[0];
                    gvPackages.DataBind();
                    pnlPackages.Visible = true;
                    pnlEmpty.Visible = false;
                }
                else
                {
                    pnlPackages.Visible = false;
                    pnlEmpty.Visible = true;
                }

                lblMessage.Text = string.Empty;
                lblMessage.CssClass = "message-box";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadPackages Error: " + ex.Message);
                ShowError("Error loading packages: " + ex.Message);
            }
        }

        protected void btnAddPackage_Click(object sender, EventArgs e)
        {
            try
            {
                string version = txtVersion.Text.Trim();
                string packageModel = txtPackageModel.Text.Trim();

                if (string.IsNullOrWhiteSpace(packageModel))
                {
                    ShowError("Package model is required.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(version))
                {
                    ShowError("Version is required.");
                    return;
                }

                DBConnection db = new DBConnection();
                
                string query = string.Format(
                    "INSERT INTO [dbo].[Package] (PackageModel, Version) VALUES ('{0}', '{1}')",
                    packageModel.Replace("'", "''"),
                    version.Replace("'", "''")
                );

                bool success = db.execute(query);

                if (success)
                {
                    ShowSuccess("Package added successfully.");
                    txtVersion.Text = "";
                    txtPackageModel.Text = "";
                    LoadPackages();
                }
                else
                {
                    ShowError("Failed to add package. Please try again.");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("AddPackage Error: " + ex.Message);
                ShowError("An error occurred while adding the package: " + ex.Message);
            }
        }

        protected void gvPackages_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeletePackage")
            {
                try
                {
                    int packageId = Convert.ToInt32(e.CommandArgument);

                    DBConnection db = new DBConnection();
                    string query = "DELETE FROM [dbo].[Package] WHERE PackageID = " + packageId;
                    bool success = db.execute(query);

                    if (success)
                    {
                        ShowSuccess("Package deleted successfully.");
                        LoadPackages();
                    }
                    else
                    {
                        ShowError("Failed to delete package. Please try again.");
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("DeletePackage Error: " + ex.Message);
                    ShowError("An error occurred while deleting the package: " + ex.Message);
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

<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Diagnostic</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .diagnostic-container { background-color: #f5f5f5; padding: 20px; border-radius: 5px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .info { color: blue; }
        pre { background-color: #fff; padding: 10px; border: 1px solid #ccc; overflow-x: auto; }
        .section { margin-bottom: 30px; border-bottom: 2px solid #ccc; padding-bottom: 20px; }
    </style>
</head>
<body>
    <div class="diagnostic-container">
        <h1>?? Device Licence Control - Database Diagnostic</h1>
        
        <div class="section">
            <h2>Connection String</h2>
            <%
                string conStr = System.Configuration.ConfigurationManager.ConnectionStrings["conStr"]?.ConnectionString;
                if (string.IsNullOrEmpty(conStr))
                {
                    Response.Write("<p class='error'>? Connection string 'conStr' not found in Web.config</p>");
                }
                else
                {
                    Response.Write("<p><strong>Configured Connection String:</strong></p>");
                    Response.Write("<pre>" + System.Web.HttpUtility.HtmlEncode(conStr) + "</pre>");
                }
            %>
        </div>

        <div class="section">
            <h2>Database Connection Test</h2>
            <%
                if (!string.IsNullOrEmpty(conStr))
                {
                    try
                    {
                        using (System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(conStr))
                        {
                            con.Open();
                            Response.Write("<p class='success'>? Successfully connected to SQL Server</p>");
                            Response.Write("<p><strong>Database:</strong> " + con.Database + "</p>");
                            Response.Write("<p><strong>Server:</strong> " + con.DataSource + "</p>");
                            con.Close();
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<p class='error'>? Connection Failed</p>");
                        Response.Write("<p><strong>Error:</strong> " + System.Web.HttpUtility.HtmlEncode(ex.Message) + "</p>");
                        if (ex.InnerException != null)
                        {
                            Response.Write("<p><strong>Inner Error:</strong> " + System.Web.HttpUtility.HtmlEncode(ex.InnerException.Message) + "</p>");
                        }
                    }
                }
            %>
        </div>

        <div class="section">
            <h2>[User] Table Check</h2>
            <%
                if (!string.IsNullOrEmpty(conStr))
                {
                    try
                    {
                        using (System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(conStr))
                        {
                            con.Open();
                            
                            // Check if table exists
                            string checkTableQuery = @"
                                SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES 
                                WHERE TABLE_NAME = '[User]' OR TABLE_NAME = 'User'";
                            
                            System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(checkTableQuery, con);
                            int tableCount = (int)cmd.ExecuteScalar();
                            
                            if (tableCount > 0)
                            {
                                Response.Write("<p class='success'>? [User] table exists</p>");
                                
                                // Get row count
                                string rowCountQuery = "SELECT COUNT(*) FROM [User]";
                                cmd = new System.Data.SqlClient.SqlCommand(rowCountQuery, con);
                                int rowCount = (int)cmd.ExecuteScalar();
                                Response.Write("<p><strong>Total users in database:</strong> " + rowCount + "</p>");
                                
                                if (rowCount > 0)
                                {
                                    Response.Write("<p class='success'>? Database has user records</p>");
                                }
                                else
                                {
                                    Response.Write("<p class='error'>? No user records found - Please insert test users</p>");
                                }
                            }
                            else
                            {
                                Response.Write("<p class='error'>? [User] table does not exist</p>");
                                Response.Write("<p>Please create the table with this SQL:</p>");
                                Response.Write("<pre>CREATE TABLE [User] (\n");
                                Response.Write("    UserId INT PRIMARY KEY IDENTITY(1,1),\n");
                                Response.Write("    FullName NVARCHAR(100) NOT NULL UNIQUE,\n");
                                Response.Write("    Password INT NOT NULL,\n");
                                Response.Write("    IsActive BIT NOT NULL DEFAULT 1,\n");
                                Response.Write("    IsAdmin BIT NOT NULL DEFAULT 0,\n");
                                Response.Write("    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()\n");
                                Response.Write(")</pre>");
                            }
                            
                            con.Close();
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<p class='error'>? Error checking table</p>");
                        Response.Write("<p><strong>Error:</strong> " + System.Web.HttpUtility.HtmlEncode(ex.Message) + "</p>");
                    }
                }
            %>
        </div>

        <div class="section">
            <h2>Troubleshooting Steps</h2>
            <ol>
                <li><strong>If Connection Failed:</strong>
                    <ul>
                        <li>Verify SQL Server is running (Services ? SQL Server)</li>
                        <li>Check if server name is correct (ISA\SQLEXPRESS)</li>
                        <li>Ensure database "DeviceLicenseDB" exists</li>
                        <li>Check if Windows Authentication is enabled</li>
                    </ul>
                </li>
                <li><strong>If Table Not Found:</strong>
                    <ul>
                        <li>Copy the SQL script above</li>
                        <li>Open SQL Server Management Studio</li>
                        <li>Connect to ISA\SQLEXPRESS</li>
                        <li>Select DeviceLicenseDB database</li>
                        <li>Open New Query window</li>
                        <li>Paste and execute the SQL script</li>
                    </ul>
                </li>
                <li><strong>If No Users Found:</strong>
                    <ul>
                        <li>Insert test users with this SQL:</li>
                        <li><code>INSERT INTO [User] (FullName, Password, IsActive, IsAdmin) VALUES ('Test User', 1234, 1, 0)</code></li>
                    </ul>
                </li>
            </ol>
        </div>

        <div class="section">
            <h2>Next Steps</h2>
            <p>Once all tests pass (green checkmarks), you can:</p>
            <ol>
                <li><a href="Login.aspx">Go to Login Page</a></li>
                <li>Try logging in with your test users</li>
                <li>If still getting errors, check browser console (F12) for details</li>
            </ol>
        </div>
    </div>
</body>
</html>

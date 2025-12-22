<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateKey.aspx.cs" Inherits="Device_Licence_Control.CreateKey" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Activation Key - Device Control</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f0f2f5; }
        .navbar { background-color: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { font-size: 24px; }
        .navbar-right { display: flex; gap: 15px; align-items: center; }
        .navbar-user { display: flex; gap: 20px; align-items: center; }
        .navbar-user span { font-size: 14px; }
        .btn-dashboard { background-color: #3498db; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; transition: background-color 0.3s; text-decoration: none; display: inline-block; }
        .btn-dashboard:hover { background-color: #2980b9; }
        .btn-logout { background-color: #e74c3c; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; transition: background-color 0.3s; }
        .btn-logout:hover { background-color: #c0392b; }
        .container { padding: 30px; max-width: 1200px; margin: 0 auto; }
        .header-section { background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .header-section h2 { color: #2c3e50; margin-bottom: 10px; }
        .form-section { background-color: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .form-section h3 { color: #2c3e50; margin-bottom: 20px; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; color: #2c3e50; font-weight: 600; margin-bottom: 8px; }
        .form-group input, .form-group select { width: 100%; padding: 12px; border: 1px solid #bdc3c7; border-radius: 4px; font-size: 14px; }
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #3498db; box-shadow: 0 0 5px rgba(52, 152, 219, 0.5); }
        .form-group input:disabled { background-color: #ecf0f1; color: #7f8c8d; cursor: not-allowed; }
        .btn-create { background-color: #27ae60; color: white; padding: 12px 24px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; transition: background-color 0.3s; }
        .btn-create:hover { background-color: #229954; }
        .message-box { padding: 15px; border-radius: 4px; margin-bottom: 20px; font-weight: 600; }
        .message-box.error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .btn-back { background-color: #95a5a6; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; text-decoration: none; display: inline-block; margin-bottom: 20px; }
        .btn-back:hover { background-color: #7f8c8d; }
        .info-box { background-color: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; padding: 15px; border-radius: 4px; margin-bottom: 20px; }
        .keys-table { width: 100%; border-collapse: collapse; background-color: white; box-shadow: 0 4px 10px rgba(0,0,0,0.1); margin-top: 20px; }
        .keys-table thead { background-color: #2c3e50; color: white; }
        .keys-table thead th { padding: 15px; text-align: left; font-weight: 600; }
        .keys-table tbody td { padding: 15px; border-bottom: 1px solid #ecf0f1; font-size: 13px; }
        .keys-table tbody tr:hover { background-color: #f8f9fa; }
        .empty-state { text-align: center; padding: 40px; color: #7f8c8d; }
        .empty-state h3 { color: #2c3e50; margin-bottom: 10px; }
        .status-badge { display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-not-transferred { background-color: #ffeaa7; color: #2d3436; }
        .status-transferred { background-color: #a3e4d7; color: #0b5345; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1>Device Licence Control</h1>
            <div class="navbar-right">
                <asp:HyperLink ID="hlDashboard" runat="server" NavigateUrl="Dashboard.aspx" CssClass="btn-dashboard">Dashboard</asp:HyperLink>
                <div class="navbar-user">
                    <span>Welcome, <strong><asp:Literal ID="litUserName" runat="server"></asp:Literal></strong></span>
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
                </div>
            </div>
        </div>

        <div class="container">
            <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="Dashboard.aspx" CssClass="btn-back">Back to Dashboard</asp:HyperLink>

            <div class="header-section">
                <h2>Create Activation Key</h2>
                <p>Generate a new activation key for your account.</p>
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message-box"></asp:Label>

            <div class="info-box">
                <strong>Note:</strong> Your activation key will be automatically created with "Not Transferred" status. You can use this key to activate your devices.
            </div>

            <div class="form-section">
                <h3>Create New Key</h3>
                
                <div class="form-group">
                    <label>Your ID (Owner ID)</label>
                    <asp:TextBox ID="txtOwnerID" runat="server" Enabled="false"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Select Package</label>
                    <asp:DropDownList ID="ddlPackage" runat="server">
                        <asp:ListItem Value="" Text="-- Select Package --"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label>Status</label>
                    <asp:TextBox ID="txtStatus" runat="server" Enabled="false" Text="Not Transferred"></asp:TextBox>
                </div>

                <asp:Button ID="btnCreateKey" runat="server" Text="Create Key" CssClass="btn-create" OnClick="btnCreateKey_Click" />
            </div>

            <div class="form-section">
                <h3>Your Activation Keys</h3>
                
                <asp:Panel ID="pnlKeys" runat="server">
                    <div style="overflow-x: auto;">
                        <asp:GridView ID="gvKeys" runat="server" AutoGenerateColumns="False" CssClass="keys-table">
                            <Columns>
                                <asp:BoundField DataField="Key" HeaderText="Activation Key" />
                                <asp:BoundField DataField="Label" HeaderText="Package" />
                                <asp:BoundField DataField="CreatedDate" HeaderText="Created Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                <asp:BoundField DataField="Status" HeaderText="Status" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
                    <h3>No Keys Found</h3>
                    <p>Create your first activation key using the form above.</p>
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
</html>

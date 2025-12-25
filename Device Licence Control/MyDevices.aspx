<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyDevices.aspx.cs" Inherits="Device_Licence_Control.MyDevices" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Devices - Device Control</title>
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
        .header-section p { color: #7f8c8d; }
        .message-box { padding: 15px; border-radius: 4px; margin-bottom: 20px; font-weight: 600; }
        .message-box.error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .message-box.success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .message-box.info { background-color: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        .devices-container { background-color: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .devices-container h3 { color: #2c3e50; margin-bottom: 20px; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        .devices-table { width: 100%; border-collapse: collapse; background-color: white; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .devices-table thead { background-color: #2c3e50; color: white; }
        .devices-table thead th { padding: 15px; text-align: left; font-weight: 600; }
        .devices-table tbody td { padding: 15px; border-bottom: 1px solid #ecf0f1; }
        .devices-table tbody tr:hover { background-color: #f8f9fa; }
        .btn-back { background-color: #95a5a6; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; text-decoration: none; display: inline-block; margin-bottom: 20px; }
        .btn-back:hover { background-color: #7f8c8d; }
        .empty-state { text-align: center; padding: 40px; color: #7f8c8d; }
        .empty-state h3 { color: #2c3e50; margin-bottom: 10px; }
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
                <h2>My Registered Devices</h2>
                <p>View all devices registered to your account.</p>
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message-box"></asp:Label>

            <div class="devices-container">
                <h3>Your Devices</h3>
                
                <asp:Panel ID="pnlDevices" runat="server">
                    <div style="overflow-x: auto;">
                        <asp:GridView ID="gvMyDevices" runat="server" AutoGenerateColumns="True" CssClass="devices-table">
                        </asp:GridView>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
                    <h3>No Devices Registered</h3>
                    <p>You don't have any registered devices yet. Register a device to see it here.</p>
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
</html>

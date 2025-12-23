<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisteredDevices.aspx.cs" Inherits="Device_Licence_Control.RegisteredDevices" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register Device for User - Device Control</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f0f2f5; }
        .navbar { background-color: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { font-size: 24px; }
        .navbar-right { display: flex; gap: 15px; align-items: center; }
        .navbar-user { display: flex; gap: 20px; align-items: center; }
        .navbar-user span { font-size: 14px; }
        .btn-admin { background-color: #f39c12; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; transition: background-color 0.3s; text-decoration: none; display: inline-block; }
        .btn-admin:hover { background-color: #e67e22; }
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
        .btn-add { background-color: #27ae60; color: white; padding: 12px 24px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; transition: background-color 0.3s; }
        .btn-add:hover { background-color: #229954; }
        .btn-unregister { background-color: #e74c3c; color: white; padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; font-weight: 600; transition: background-color 0.3s; }
        .btn-unregister:hover { background-color: #c0392b; }
        .message-box { padding: 15px; border-radius: 4px; margin-bottom: 20px; font-weight: 600; }
        .message-box.error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .message-box.success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .btn-back { background-color: #95a5a6; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; text-decoration: none; display: inline-block; margin-bottom: 20px; }
        .btn-back:hover { background-color: #7f8c8d; }
        .devices-table { width: 100%; border-collapse: collapse; background-color: white; }
        .devices-table thead { background-color: #34495e; color: white; }
        .devices-table thead th { padding: 12px; text-align: left; font-weight: 600; }
        .devices-table tbody td { padding: 12px; border-bottom: 1px solid #ecf0f1; }
        .devices-table tbody tr:hover { background-color: #f8f9fa; }
        .empty-state { text-align: center; padding: 30px; color: #7f8c8d; }
        .empty-state p { margin: 10px 0; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1>Device Licence Control</h1>
            <div class="navbar-right">
                <asp:HyperLink ID="hlAdminPanel" runat="server" NavigateUrl="AdminPanel.aspx" CssClass="btn-admin">Admin Panel</asp:HyperLink>
                <div class="navbar-user">
                    <span>Welcome, <strong><asp:Literal ID="litUserName" runat="server"></asp:Literal></strong></span>
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
                </div>
            </div>
        </div>

        <div class="container">
            <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="AdminPanel.aspx" CssClass="btn-back">Back to Admin Panel</asp:HyperLink>

            <div class="header-section">
                <h2>Register Device for User</h2>
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message-box"></asp:Label>

            <div class="form-section">
                <h3>Device Registration Form</h3>
                
                <div class="form-group">
                    <label>Select User (Owner)</label>
                    <asp:DropDownList ID="ddlUser" runat="server">
                        <asp:ListItem Value="" Text="-- Select User --"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label>Device Type</label>
                    <asp:DropDownList ID="ddlDeviceType" runat="server">
                        <asp:ListItem Value="" Text="-- Select Device Type --"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label>Device Name</label>
                    <asp:TextBox ID="txtDeviceName" runat="server" placeholder="Enter device name"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Serial Number</label>
                    <asp:TextBox ID="txtSerialNumber" runat="server" placeholder="Enter serial number"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Registration Date</label>
                    <asp:TextBox ID="txtRegisterDate" runat="server" Type="date"></asp:TextBox>
                </div>

                <asp:Button ID="btnRegisterDevice" runat="server" Text="Register Device" CssClass="btn-add" OnClick="btnRegisterDevice_Click" />
            </div>

            <div class="form-section">
                <h3>Registered Devices</h3>
                
                <asp:Panel ID="pnlDevicesList" runat="server">
                    <div style="overflow-x: auto;">
                        <asp:GridView ID="gvRegisteredDevices" runat="server" AutoGenerateColumns="False" CssClass="devices-table" OnRowCommand="gvRegisteredDevices_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="DeviceID" HeaderText="Device ID" />
                                <asp:BoundField DataField="DeviceName" HeaderText="Device Name" />
                                <asp:BoundField DataField="SerialNumber" HeaderText="Serial Number" />
                                <asp:BoundField DataField="OwnerName" HeaderText="Owner" />
                                <asp:BoundField DataField="TypeName" HeaderText="Device Type" />
                                <asp:BoundField DataField="RegisterDate" HeaderText="Register Date" DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:BoundField DataField="Status" HeaderText="Status" />
                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:Button ID="btnUnregister" runat="server" Text="Unregister" CssClass="btn-unregister" CommandName="UnregisterDevice" CommandArgument='<%# Eval("DeviceID") + "," + Eval("OwnerID") %>' OnClientClick="return confirm('Are you sure you want to unregister this device?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlNoDevices" runat="server" CssClass="empty-state" Visible="false">
                    <p>No registered devices found.</p>
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
</html>

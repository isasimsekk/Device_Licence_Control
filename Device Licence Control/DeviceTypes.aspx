<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeviceTypes.aspx.cs" Inherits="Device_Licence_Control.DeviceTypes" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Device Types - Device Control</title>
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
        .message-box { padding: 15px; border-radius: 4px; margin-bottom: 20px; font-weight: 600; }
        .message-box.error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .message-box.success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .btn-back { background-color: #95a5a6; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; text-decoration: none; display: inline-block; margin-bottom: 20px; }
        .btn-back:hover { background-color: #7f8c8d; }
        .types-table { width: 100%; border-collapse: collapse; background-color: white; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .types-table thead { background-color: #2c3e50; color: white; }
        .types-table thead th { padding: 15px; text-align: left; font-weight: 600; }
        .types-table tbody td { padding: 15px; border-bottom: 1px solid #ecf0f1; }
        .types-table tbody tr:hover { background-color: #f8f9fa; }
        .btn-delete { background-color: #e74c3c; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; font-weight: 600; }
        .btn-delete:hover { background-color: #c0392b; }
        .empty-state { text-align: center; padding: 40px; color: #7f8c8d; }
        .empty-state h3 { color: #2c3e50; margin-bottom: 10px; }
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
            <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="AdminPanel.aspx" CssClass="btn-back">? Back to Admin Panel</asp:HyperLink>

            <div class="header-section">
                <h2>Manage Device Types</h2>
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message-box"></asp:Label>

            <div class="form-section">
                <h3>Add New Device Type</h3>
                
                <div class="form-group">
                    <label>Type Name</label>
                    <asp:TextBox ID="txtTypeName" runat="server" placeholder="Enter device type name (e.g., Laptop, Desktop)"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Manufacturer</label>
                    <asp:TextBox ID="txtManufacturer" runat="server" placeholder="Enter manufacturer name (e.g., Dell, HP)"></asp:TextBox>
                </div>

                <asp:Button ID="btnAddType" runat="server" Text="Add Device Type" CssClass="btn-add" OnClick="btnAddType_Click" />
            </div>

            <div class="form-section">
                <h3>Existing Device Types</h3>
                
                <asp:Panel ID="pnlTypes" runat="server">
                    <div style="overflow-x: auto;">
                        <asp:GridView ID="gvDeviceTypes" runat="server" AutoGenerateColumns="False" OnRowCommand="gvDeviceTypes_RowCommand" CssClass="types-table">
                            <Columns>
                                <asp:BoundField DataField="DeviceTypeID" HeaderText="Type ID" />
                                <asp:BoundField DataField="TypeName" HeaderText="Type Name" />
                                <asp:BoundField DataField="Manufacturer" HeaderText="Manufacturer" />
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:Button ID="btnDelete" runat="server" CommandName="DeleteType" CommandArgument='<%# Eval("DeviceTypeID") %>' Text="Delete" CssClass="btn-delete" OnClientClick="return confirm('Are you sure you want to delete this device type?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
                    <h3>No Device Types Found</h3>
                    <p>Start by adding a new device type.</p>
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
</html>

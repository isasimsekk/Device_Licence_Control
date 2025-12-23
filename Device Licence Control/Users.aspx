<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="Device_Licence_Control.Users" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Users Management - Device Control</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f0f2f5; }
        .navbar { 
            background-color: #2c3e50; 
            color: white; 
            padding: 15px 30px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        .navbar h1 { font-size: 24px; }
        .navbar-links { display: flex; gap: 15px; }
        .btn-back { 
            background-color: #3498db; 
            color: white; 
            padding: 8px 16px; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 14px; 
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
        }
        .btn-back:hover { 
            background-color: #2980b9; 
        }
        .container { padding: 30px; max-width: 1200px; margin: 0 auto; }
        .header { 
            background-color: white; 
            padding: 20px; 
            border-radius: 8px; 
            box-shadow: 0 4px 10px rgba(0,0,0,0.1); 
            margin-bottom: 30px;
        }
        .header h2 { 
            color: #2c3e50; 
            margin-bottom: 10px; 
        }
        .header p { 
            color: #7f8c8d; 
        }
        .section { 
            background-color: white; 
            padding: 20px; 
            border-radius: 8px; 
            box-shadow: 0 4px 10px rgba(0,0,0,0.1); 
        }
        .users-table { 
            width: 100%; 
            border-collapse: collapse; 
        }
        .users-table th { 
            background-color: #ecf0f1; 
            color: #2c3e50; 
            padding: 12px; 
            text-align: left; 
            font-weight: 600;
            border-bottom: 2px solid #bdc3c7;
        }
        .users-table td { 
            padding: 12px; 
            border-bottom: 1px solid #ecf0f1; 
        }
        .users-table tbody tr:hover {
            background-color: #f8f9fa;
        }
        .badge-admin { 
            background-color: #27ae60; 
            color: white; 
            padding: 4px 8px; 
            border-radius: 3px; 
            font-size: 12px;
        }
        .badge-user { 
            background-color: #95a5a6; 
            color: white; 
            padding: 4px 8px; 
            border-radius: 3px; 
            font-size: 12px;
        }
        .badge-active { 
            background-color: #27ae60; 
            color: white; 
            padding: 4px 8px; 
            border-radius: 3px; 
            font-size: 12px;
        }
        .badge-inactive { 
            background-color: #e74c3c; 
            color: white; 
            padding: 4px 8px; 
            border-radius: 3px; 
            font-size: 12px;
        }
        .btn-action { 
            padding: 6px 12px; 
            border: none; 
            border-radius: 3px; 
            cursor: pointer; 
            font-size: 12px;
            margin-right: 5px;
            transition: background-color 0.3s;
        }
        .btn-make-admin { 
            background-color: #f39c12; 
            color: white; 
        }
        .btn-make-admin:hover { 
            background-color: #e67e22; 
        }
        .btn-deactivate { 
            background-color: #e74c3c; 
            color: white; 
        }
        .btn-deactivate:hover { 
            background-color: #c0392b; 
        }
        .btn-delete { 
            background-color: #c0392b; 
            color: white; 
        }
        .btn-delete:hover { 
            background-color: #a93226; 
        }
        .btn-action:disabled {
            background-color: #95a5a6;
            cursor: not-allowed;
        }
        .message-box { 
            padding: 15px; 
            border-radius: 4px; 
            margin-bottom: 20px;
            display: none;
            border-left: 4px solid;
        }
        .message-box.success-msg {
            background-color: #d5f4e6;
            color: #27ae60;
            border-left-color: #27ae60;
            display: block;
        }
        .message-box.error-msg {
            background-color: #fadbd8;
            color: #c0392b;
            border-left-color: #e74c3c;
            display: block;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }
        .empty-state p {
            font-size: 16px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1>Users Management</h1>
            <div class="navbar-links">
                <asp:HyperLink ID="hlBackDashboard" runat="server" NavigateUrl="Dashboard.aspx" CssClass="btn-back">Back to Dashboard</asp:HyperLink>
            </div>
        </div>

        <div class="container">
            <div class="header">
                <h2>Manage System Users</h2>
                <p>View and manage all users in the system. Promote users to admin, deactivate accounts, or delete users permanently.</p>
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message-box"></asp:Label>

            <div class="section">
                <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                    <HeaderTemplate>
                        <table class="users-table">
                            <thead>
                                <tr>
                                    <th style="width: 60px;">ID</th>
                                    <th>Full Name</th>
                                    <th style="width: 100px;">Status</th>
                                    <th style="width: 100px;">Role</th>
                                    <th style="width: 350px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("UserId") %></td>
                            <td><%# Eval("FullName") %></td>
                            <td>
                                <%# Convert.ToBoolean(Eval("IsActive")) ? 
                                    "<span class=\"badge-active\">Active</span>" : 
                                    "<span class=\"badge-inactive\">Inactive</span>" %>
                            </td>
                            <td>
                                <%# Convert.ToBoolean(Eval("isAdmin")) ? 
                                    "<span class=\"badge-admin\">Admin</span>" : 
                                    "<span class=\"badge-user\">User</span>" %>
                            </td>
                            <td>
                                <asp:Button ID="btnMakeAdmin" runat="server" 
                                    Text="Make Admin" 
                                    CssClass="btn-action btn-make-admin" 
                                    CommandName="MakeAdmin" 
                                    CommandArgument='<%# Eval("UserId") %>' 
                                    Visible='<%# !Convert.ToBoolean(Eval("isAdmin")) %>' 
                                    OnClientClick="return confirm('Are you sure you want to promote this user to admin?');" />
                                
                                <asp:Button ID="btnDeactivate" runat="server" 
                                    Text="Deactivate" 
                                    CssClass="btn-action btn-deactivate" 
                                    CommandName="Deactivate" 
                                    CommandArgument='<%# Eval("UserId") %>' 
                                    Visible='<%# Convert.ToBoolean(Eval("IsActive")) %>' 
                                    OnClientClick="return confirm('Are you sure you want to deactivate this user?');" />
                                
                                <asp:Button ID="btnDelete" runat="server" 
                                    Text="Delete" 
                                    CssClass="btn-action btn-delete" 
                                    CommandName="DeleteUser" 
                                    CommandArgument='<%# Eval("UserId") %>' 
                                    OnClientClick="return confirm('Are you sure you want to permanently delete this user? This action cannot be undone.');" />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </form>
</body>
</html>

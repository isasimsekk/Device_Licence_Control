<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminPanel.aspx.cs" Inherits="Device_Licence_Control.AdminPanel" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Panel - Device Control</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f0f2f5;
        }

        .navbar {
            background-color: #2c3e50;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

            .navbar h1 {
                font-size: 24px;
            }

        .navbar-right {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .navbar-user {
            display: flex;
            gap: 20px;
            align-items: center;
        }

            .navbar-user span {
                font-size: 14px;
            }

        .btn-dashboard {
            background-color: #3498db;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
        }

            .btn-dashboard:hover {
                background-color: #2980b9;
            }

        .btn-logout {
            background-color: #e74c3c;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

            .btn-logout:hover {
                background-color: #c0392b;
            }

        .container {
            padding: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .admin-header {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

            .admin-header h2 {
                color: #2c3e50;
            }

            .admin-header a {
                background-color: #3498db;
                color: white;
                padding: 10px 20px;
                border-radius: 4px;
                text-decoration: none;
                font-weight: 600;
                transition: background-color 0.3s;
            }

                .admin-header a:hover {
                    background-color: #2980b9;
                }

        .message-box {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-weight: 600;
        }

            .message-box.error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .message-box.success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1>Device Licence Control</h1>
            <div class="navbar-right">
                <asp:HyperLink ID="hlDashboard" runat="server" NavigateUrl="Dashboard.aspx" CssClass="btn-dashboard">Dashboard</asp:HyperLink>
                <div class="navbar-user">
                    <span>Welcome, <strong>
                        <asp:Literal ID="litUserName" runat="server"></asp:Literal></strong></span>
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
                </div>
            </div>
        </div>

        <div class="container">
            <div class="admin-header">
                <h2>Admin Panel - User Management</h2>
                <asp:HyperLink ID="hlUsers" runat="server" NavigateUrl="Users.aspx">Manage Users (Advanced)</asp:HyperLink>
            </div>
            <asp:Label ID="lblMessage" runat="server" CssClass="message-box"></asp:Label>

            <div class="admin-header">
                <h2>Register Device for User</h2>
                <asp:HyperLink ID="hlRegisteredDevices" runat="server" NavigateUrl="RegisteredDevices.aspx">Register Device</asp:HyperLink>
            </div>
            <asp:Label ID="Label2" runat="server" CssClass="message-box"></asp:Label>

            <div class="admin-header">
                <h2>Manage Device Types</h2>
                <asp:HyperLink ID="hlDeviceTypes" runat="server" NavigateUrl="DeviceTypes.aspx">Add/Delete Device Types</asp:HyperLink>
            </div>
            <asp:Label ID="Label3" runat="server" CssClass="message-box"></asp:Label>

            <div class="admin-header">
                <h2>Manage Packages</h2>
                <asp:HyperLink ID="hlPackages" runat="server" NavigateUrl="Packages.aspx">Add/Delete Packages</asp:HyperLink>
            </div>
            <asp:Label ID="Label4" runat="server" CssClass="message-box"></asp:Label>
        </div>

    </form>
</body>
</html>

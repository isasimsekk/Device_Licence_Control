<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Device_Licence_Control.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard - Device Control</title>
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

        .btn-admin {
            background-color: #f39c12;
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

            .btn-admin:hover {
                background-color: #e67e22;
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
            max-width: 1100px;
            margin: 0 auto;
        }

        .welcome-card {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

            .welcome-card h2 {
                color: #2c3e50;
                margin-bottom: 10px;
            }

            .welcome-card p {
                color: #7f8c8d;
                line-height: 1.6;
            }

        .admin-notice {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            border-radius: 4px;
            margin-top: 20px;
            color: #856404;
        }

        .statistics-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            text-align: center;
            color: white;
        }

        .stat-card.active-users {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .stat-card.registered-devices {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

            .stat-card .stat-number {
                font-size: 24px;
                font-weight: bold;
                margin: 5px 0;
            }

            .stat-card .stat-label {
                font-size: 12px;
                opacity: 0.9;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

        .features-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .feature-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            text-align: center;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            height: 100%;
            justify-content: center;
        }

            .feature-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            }

            .feature-card h3 {
                color: #2c3e50;
                margin-bottom: 10px;
            }

            .feature-card p {
                color: #7f8c8d;
                font-size: 14px;
                line-height: 1.5;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1>Device Licence Control</h1>
            <div class="navbar-right">
                <asp:Panel ID="pnlAdminButton" runat="server" Visible="false">
                    <asp:HyperLink ID="hlAdminPanel" runat="server" NavigateUrl="AdminPanel.aspx" CssClass="btn-admin">Admin Panel</asp:HyperLink>
                </asp:Panel>

                <div class="navbar-user">
                    <span>Welcome, <strong>
                        <asp:Literal ID="litUserName" runat="server"></asp:Literal></strong></span>
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
                </div>
            </div>
        </div>

        <div class="container">
            <div class="welcome-card">
                <h2>Welcome to Dashboard</h2>
                <p>You have successfully logged in to the Device Licence Control System.</p>

                <div class="statistics-section">
                    <div class="stat-card active-users">
                        <div class="stat-label">Active Users</div>
                        <div class="stat-number">
                            <asp:Literal ID="litActiveUserCount" runat="server">0</asp:Literal>
                        </div>
                    </div>
                    <div class="stat-card registered-devices">
                        <div class="stat-label">Registered Devices</div>
                        <div class="stat-number">
                            <asp:Literal ID="litTotalDeviceCount" runat="server">0</asp:Literal>
                        </div>
                    </div>
                    <div class="stat-card" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                        <div class="stat-label">Total Keys</div>
                        <div class="stat-number">
                            <asp:Literal ID="litTotalKeysCount" runat="server">0</asp:Literal>
                        </div>
                    </div>
                    <div class="stat-card" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                        <div class="stat-label">Unassigned Keys</div>
                        <div class="stat-number">
                            <asp:Literal ID="litUnassignedKeysCount" runat="server">0</asp:Literal>
                        </div>
                    </div>
                    <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                        <div class="stat-label">Total Assignments</div>
                        <div class="stat-number">
                            <asp:Literal ID="litTotalAssignmentsCount" runat="server">0</asp:Literal>
                        </div>
                    </div>
                </div>

                <asp:Panel ID="pnlAdminNotice" runat="server" Visible="false">
                    <div class="admin-notice">
                        <strong>Administrator Access:</strong> You have administrative privileges for this system. Click the "Admin Panel" button to manage user accounts and system configuration.
                    </div>
                </asp:Panel>
            </div>

            <div class="features-section">
                <asp:HyperLink ID="hlViewProfile" runat="server" NavigateUrl="ViewProfile.aspx" CssClass="feature-card">
                    <h3>View Profile</h3>
                    <p>Access and manage your account information and preferences.</p>
                </asp:HyperLink>
                <asp:HyperLink ID="hlMyDeviceLicenses" runat="server" NavigateUrl="MyDeviceLicenses.aspx" CssClass="feature-card">
                    <h3>My Device Licenses</h3>
                    <p>Monitor and manage your device licenses.</p>
                </asp:HyperLink>
                <asp:HyperLink ID="hlMyDevices" runat="server" NavigateUrl="MyDevices.aspx" CssClass="feature-card">
                    <h3>My Devices</h3>
                    <p>View and manage devices associated with your account.</p>
                </asp:HyperLink>
                <asp:HyperLink ID="hlCreateKey" runat="server" NavigateUrl="CreateKey.aspx" CssClass="feature-card">
                    <h3>Create A New Key</h3>
                    <p>Create key for your device.</p>
                </asp:HyperLink>
                <asp:HyperLink ID="hlAssignment" runat="server" NavigateUrl="Assignment.aspx" CssClass="feature-card">
                    <h3>Assignment</h3>
                    <p>Assign your keys to your devices</p>
                </asp:HyperLink>
            </div>
        </div>
    </form>
</body>
</html>

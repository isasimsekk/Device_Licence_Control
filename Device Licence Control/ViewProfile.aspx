<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewProfile.aspx.cs" Inherits="Device_Licence_Control.ViewProfile" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Profile - Device Control</title>
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
        .container { padding: 30px; max-width: 800px; margin: 0 auto; }
        .profile-card { background-color: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .profile-header { text-align: center; margin-bottom: 30px; border-bottom: 2px solid #ecf0f1; padding-bottom: 20px; }
        .profile-header h2 { color: #2c3e50; margin-bottom: 10px; font-size: 28px; }
        .profile-header p { color: #7f8c8d; font-size: 16px; }
        .profile-section { margin-bottom: 25px; }
        .profile-section h3 { color: #2c3e50; font-size: 16px; margin-bottom: 10px; border-left: 4px solid #3498db; padding-left: 12px; }
        .profile-info { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-item { background-color: #f8f9fa; padding: 15px; border-radius: 4px; }
        .info-label { color: #7f8c8d; font-size: 13px; font-weight: 600; text-transform: uppercase; margin-bottom: 5px; }
        .info-value { color: #2c3e50; font-size: 16px; font-weight: 600; }
        .badge { display: inline-block; padding: 6px 12px; border-radius: 4px; font-size: 13px; font-weight: 600; color: white; }
        .badge-admin { background-color: #27ae60; }
        .badge-user { background-color: #95a5a6; }
        .badge-active { background-color: #27ae60; }
        .badge-inactive { background-color: #e74c3c; }
        .btn-edit { background-color: #f39c12; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; transition: background-color 0.3s; text-decoration: none; display: inline-block; margin-top: 20px; }
        .btn-edit:hover { background-color: #e67e22; }
        .message-box { padding: 15px; border-radius: 4px; margin-bottom: 20px; font-weight: 600; }
        .message-box.error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
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
            <asp:Label ID="lblMessage" runat="server" CssClass="message-box"></asp:Label>

            <div class="profile-card">
                <div class="profile-header">
                    <h2><asp:Literal ID="litFullName" runat="server"></asp:Literal></h2>
                    <p>User Profile Information</p>
                </div>

                <div class="profile-section">
                    <h3>Account Information</h3>
                    <div class="profile-info">
                        <div class="info-item">
                            <div class="info-label">User ID</div>
                            <div class="info-value"><asp:Literal ID="litUserId" runat="server"></asp:Literal></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Full Name</div>
                            <div class="info-value"><asp:Literal ID="litProfileFullName" runat="server"></asp:Literal></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Role</div>
                            <div class="info-value"><asp:Literal ID="litRole" runat="server"></asp:Literal></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Account Status</div>
                            <div class="info-value"><asp:Literal ID="litStatus" runat="server"></asp:Literal></div>
                        </div>
                    </div>
                </div>

                <div class="profile-section">
                    <h3>Account Details</h3>
                    <div class="profile-info">
                        <div class="info-item">
                            <div class="info-label">Member Since</div>
                            <div class="info-value"><asp:Literal ID="litCreatedDate" runat="server"></asp:Literal></div>
                        </div>
                    </div>
                </div>

                <asp:HyperLink ID="hlEdit" runat="server" NavigateUrl="EditProfile.aspx" CssClass="btn-edit">Edit Profile</asp:HyperLink>
            </div>
        </div>
    </form>
</body>
</html>

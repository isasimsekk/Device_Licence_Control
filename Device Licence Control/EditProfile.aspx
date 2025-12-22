<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs" Inherits="Device_Licence_Control.EditProfile" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Profile - Device Control</title>
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
        .container { padding: 30px; max-width: 600px; margin: 0 auto; }
        .edit-card { background-color: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .edit-header { text-align: center; margin-bottom: 30px; border-bottom: 2px solid #ecf0f1; padding-bottom: 20px; }
        .edit-header h2 { color: #2c3e50; margin-bottom: 10px; font-size: 28px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; color: #2c3e50; font-weight: 600; margin-bottom: 8px; }
        .form-group input[type="text"],
        .form-group input[type="password"],
        .form-group input[type="email"] { width: 100%; padding: 12px; border: 1px solid #bdc3c7; border-radius: 4px; font-size: 14px; }
        .form-group input:focus { outline: none; border-color: #3498db; box-shadow: 0 0 5px rgba(52, 152, 219, 0.5); }
        .form-group .info-text { color: #7f8c8d; font-size: 12px; margin-top: 5px; }
        .button-group { display: flex; gap: 10px; margin-top: 30px; }
        .btn-save { background-color: #27ae60; color: white; padding: 12px 24px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; transition: background-color 0.3s; flex: 1; }
        .btn-save:hover { background-color: #229954; }
        .btn-cancel { background-color: #95a5a6; color: white; padding: 12px 24px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; transition: background-color 0.3s; flex: 1; }
        .btn-cancel:hover { background-color: #7f8c8d; }
        .message-box { padding: 15px; border-radius: 4px; margin-bottom: 20px; font-weight: 600; }
        .message-box.error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .message-box.success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
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

            <div class="edit-card">
                <div class="edit-header">
                    <h2>Edit Profile</h2>
                </div>

                <div class="form-group">
                    <label for="txtFullName">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" placeholder="Enter your full name"></asp:TextBox>
                    <div class="info-text">Your account name cannot be changed</div>
                </div>

                <div class="form-group">
                    <label for="txtCurrentPassword">Current Password</label>
                    <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" placeholder="Enter your current password"></asp:TextBox>
                    <div class="info-text">Required to confirm your identity</div>
                </div>

                <div class="form-group">
                    <label for="txtNewPassword">New Password (Optional)</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" placeholder="Leave blank to keep current password"></asp:TextBox>
                    <div class="info-text">Password must be at least 6 characters</div>
                </div>

                <div class="form-group">
                    <label for="txtConfirmPassword">Confirm New Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm your new password"></asp:TextBox>
                </div>

                <div class="button-group">
                    <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn-save" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cancel" OnClick="btnCancel_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>

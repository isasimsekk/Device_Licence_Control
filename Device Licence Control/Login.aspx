<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Device_Licence_Control.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - Device Licence Control</title>
    <style>
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh;
            margin: 0;
        }
        .login-container { 
            background-color: white; 
            padding: 40px; 
            border-radius: 8px; 
            box-shadow: 0 8px 32px rgba(0,0,0,0.1); 
            width: 350px;
            text-align: center; 
        }
        .login-container h2 {
            color: #333;
            margin-top: 0;
            font-size: 28px;
        }
        .login-container p {
            color: #999;
            margin-bottom: 30px;
        }
        .input-group { 
            margin-bottom: 20px; 
            text-align: left; 
        }
        .input-group label { 
            display: block; 
            margin-bottom: 8px; 
            color: #555;
            font-weight: 500;
            font-size: 14px;
        }
        .input-group input { 
            width: 100%; 
            padding: 10px 12px; 
            border: 1px solid #ddd; 
            border-radius: 4px; 
            box-sizing: border-box;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        .input-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-login { 
            width: 100%; 
            padding: 12px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 16px;
            font-weight: 600;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 10px;
        }
        .btn-login:hover { 
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .btn-login:active {
            transform: translateY(0);
        }
        
        /* Message styles - hidden by default */
        .message-box {
            font-size: 14px; 
            margin-top: 15px; 
            padding: 12px;
            border-radius: 4px;
            display: none; /* Hidden by default */
            border-left: 4px solid;
        }
        
        /* Error message style */
        .error-msg {
            color: #c0392b;
            background-color: #fadbd8;
            border-left-color: #e74c3c;
            display: block; /* Show only when there's an error */
        }
        
        /* Success message style */
        .success-msg {
            color: #27ae60;
            background-color: #d5f4e6;
            border-left-color: #27ae60;
        }
        
        /* Warning message style */
        .warning-msg {
            color: #d68910;
            background-color: #fdebd0;
            border-left-color: #f39c12;
        }
        
        .register-link { 
            margin-top: 20px; 
            display: block; 
            font-size: 14px;
            color: #667eea;
            text-decoration: none;
            border-top: 1px solid #eee;
            padding-top: 15px;
        }
        .register-link:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        .password-label {
            font-size: 12px;
            color: #999;
            display: block;
            margin-top: 4px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <h2>Device Licence Control</h2>
            <p>Login to your account</p>
            
            <div class="input-group">
                <label>Full Name</label>
                <asp:TextBox ID="txtFullName" runat="server" placeholder="Enter your name"></asp:TextBox>
            </div>

            <div class="input-group">
                <label>
                    Password
                    <span class="password-label">(Numeric PIN)</span>
                </label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter PIN"></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" />
            
            <!-- Message box - only shows when there's a message -->
            <asp:Label ID="lblMessage" runat="server" CssClass="message-box"></asp:Label>

            <!-- Link to register page -->
            <a href="Register.aspx" class="register-link">Don't have an account? Create one here</a>
        </div>
    </form>
</body>
</html>

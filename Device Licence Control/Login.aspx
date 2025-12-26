<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Device_Licence_Control.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - Device Licence Control</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        /* CORE RESET */
        * { box-sizing: border-box; }
        body { 
            margin: 0; 
            padding: 0; 
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; 
            height: 100vh;
            overflow: hidden; /* Prevent scroll on desktop */
        }

        /* LAYOUT: SPLIT SCREEN */
        .split-container {
            display: flex;
            height: 100%;
            width: 100%;
        }

        /* LEFT SIDE: BRANDING */
        .brand-side {
            width: 45%;
            background-color: #0f172a; /* Deep Navy */
            background-image: radial-gradient(circle at 10% 20%, #1e293b 0%, #0f172a 90%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px;
            color: white;
            position: relative;
        }

        .brand-side::before {
            /* Abstract tech decorative element */
            content: '';
            position: absolute;
            top: -100px;
            left: -100px;
            width: 300px;
            height: 300px;
            background: linear-gradient(45deg, #0ea5e9, #2dd4bf);
            border-radius: 50%;
            opacity: 0.1;
            filter: blur(60px);
        }

        .brand-heading {
            font-size: 3rem;
            font-weight: 700;
            line-height: 1.1;
            margin-bottom: 20px;
            z-index: 2;
        }
        .brand-subtext {
            font-size: 1.1rem;
            color: #94a3b8;
            line-height: 1.6;
            max-width: 80%;
            z-index: 2;
        }

        /* RIGHT SIDE: FORM */
        .form-side {
            width: 55%;
            background-color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
        }

        .form-wrapper {
            width: 100%;
            max-width: 400px;
        }

        .form-header {
            margin-bottom: 40px;
        }
        .form-header h2 {
            font-size: 24px;
            color: #334155;
            margin: 0 0 10px 0;
        }
        .form-header p {
            color: #64748b;
            margin: 0;
            font-size: 14px;
        }

        /* MODERN INPUTS */
        .input-group {
            position: relative;
            margin-bottom: 25px;
        }

        .input-group input {
            width: 100%;
            padding: 12px 0;
            font-size: 16px;
            color: #333;
            border: none;
            border-bottom: 2px solid #e2e8f0;
            outline: none;
            background: transparent;
            transition: border-color 0.3s;
        }

        .input-group label {
            position: absolute;
            top: 12px;
            left: 0;
            font-size: 16px;
            color: #94a3b8;
            pointer-events: none;
            transition: 0.3s ease all;
        }

        /* Floating Label Logic: Focus or Valid(filled) */
        .input-group input:focus,
        .input-group input:valid {
            border-bottom-color: #0f172a;
        }

        .input-group input:focus ~ label,
        .input-group input:not(:placeholder-shown) ~ label {
            top: -10px;
            font-size: 12px;
            color: #0f172a;
            font-weight: 600;
        }

        /* BUTTONS */
        .btn-login {
            width: 100%;
            padding: 15px;
            background-color: #0f172a;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s, transform 0.1s;
            margin-top: 10px;
        }
        .btn-login:hover {
            background-color: #1e293b;
            transform: translateY(-1px);
        }
        .btn-login:active {
            transform: translateY(1px);
        }

        /* LINKS */
        .register-link {
            display: block;
            text-align: center;
            margin-top: 25px;
            color: #64748b;
            text-decoration: none;
            font-size: 14px;
        }
        .register-link span {
            color: #0ea5e9;
            font-weight: 600;
        }

        /* MESSAGES */
        .message-box {
            display: block;
            margin-top: 20px;
            font-size: 14px;
            text-align: center;
            min-height: 20px;
        }
        
        /* RESPONSIVE */
        @media (max-width: 768px) {
            .split-container { flex-direction: column; }
            .brand-side { width: 100%; height: 30%; padding: 30px; }
            .brand-heading { font-size: 2rem; }
            .brand-subtext { display: none; }
            .form-side { width: 100%; height: 70%; align-items: flex-start; }
            .form-wrapper { margin-top: 20px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" style="height: 100%;">
        <div class="split-container">
            
            <div class="brand-side">
                <div class="brand-heading">System<br />Access.</div>
                <div class="brand-subtext">
                    Secure device license management portal. <br />
                    Please identify yourself to proceed.
                </div>
            </div>

            <div class="form-side">
                <div class="form-wrapper">
                    <div class="form-header">
                        <h2>Welcome Back</h2>
                        <p>Enter your credentials to access the dashboard.</p>
                    </div>

                    <div class="input-group">
                        <asp:TextBox ID="txtUserID" runat="server" placeholder=" " TextMode="Number"></asp:TextBox>
                        <label>User ID</label>
                    </div>

                    <div class="input-group">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder=" "></asp:TextBox>
                        <label>PIN Code</label>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn-login" OnClick="btnLogin_Click" />

                    <asp:Label ID="lblMessage" runat="server" CssClass="message-box"></asp:Label>

                    <a href="Register.aspx" class="register-link">
                        New user? <span>Create an account</span>
                    </a>
                </div>
            </div>

        </div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Device_Licence_Control.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register - Device Licence Control</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        /* CORE RESET & FONTS */
        * { box-sizing: border-box; }
        body { 
            margin: 0; 
            padding: 0; 
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; 
            height: 100vh;
            overflow: hidden; /* Main body hidden, inner sides scroll */
        }

        /* LAYOUT */
        .split-container {
            display: flex;
            height: 100%;
            width: 100%;
        }

        /* LEFT SIDE: BRANDING (Fixed) */
        .brand-side {
            width: 40%;
            background-color: #0f172a;
            background-image: radial-gradient(circle at 10% 20%, #1e293b 0%, #0f172a 90%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px;
            color: white;
            position: relative;
            z-index: 1;
        }

        .brand-side::before {
            content: '';
            position: absolute;
            bottom: -50px;
            right: -50px;
            width: 400px;
            height: 400px;
            background: linear-gradient(135deg, #0ea5e9, #2dd4bf);
            border-radius: 50%;
            opacity: 0.15;
            filter: blur(80px);
            z-index: -1;
        }

        .brand-heading {
            font-size: 3rem;
            font-weight: 700;
            line-height: 1.1;
            margin-bottom: 20px;
        }
        .brand-subtext {
            font-size: 1.1rem;
            color: #94a3b8;
            line-height: 1.6;
            max-width: 90%;
        }

        /* RIGHT SIDE: SCROLLABLE FORM */
        .form-side {
            width: 60%;
            background-color: #ffffff;
            height: 100vh;
            overflow-y: auto; /* Independent scrolling */
            padding: 60px 80px;
            display: flex;
            justify-content: center;
        }

        .form-wrapper {
            width: 100%;
            max-width: 550px;
        }

        .form-header { margin-bottom: 30px; }
        .form-header h2 {
            font-size: 28px;
            color: #0f172a;
            margin: 0 0 10px 0;
        }
        .form-header p {
            color: #64748b;
            margin: 0;
        }

        /* SECTION DIVIDERS */
        .section-title {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #0ea5e9; /* Teal/Blue accent */
            font-weight: 700;
            margin-top: 30px;
            margin-bottom: 20px;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 10px;
        }

        /* MODERN FLOATING INPUTS */
        .input-group {
            position: relative;
            margin-bottom: 25px;
        }

        .input-group input {
            width: 100%;
            padding: 12px 0;
            font-size: 15px;
            color: #333;
            border: none;
            border-bottom: 1px solid #cbd5e1;
            outline: none;
            background: transparent;
            transition: all 0.3s;
        }
        
        .input-group input:focus {
            border-bottom: 2px solid #0f172a;
        }

        .input-group label {
            position: absolute;
            top: 12px;
            left: 0;
            font-size: 15px;
            color: #94a3b8;
            pointer-events: none;
            transition: 0.3s ease all;
        }

        .input-group input:focus ~ label,
        .input-group input:not(:placeholder-shown) ~ label {
            top: -10px;
            font-size: 12px;
            color: #0f172a;
            font-weight: 600;
        }

        /* GRID FOR CITY/COUNTRY */
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .input-group { flex: 1; }

        /* DYNAMIC ADD SECTIONS (Email/Phone) */
        .add-row {
            display: flex;
            align-items: baseline;
            gap: 10px;
        }
        .add-row .input-group { flex: 1; margin-bottom: 0; }
        
        .btn-add {
            padding: 10px 20px;
            background-color: #f1f5f9;
            color: #0f172a;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            font-size: 13px;
            height: 40px; /* Align with input */
            transition: 0.2s;
        }
        .btn-add:hover {
            background-color: #e2e8f0;
            border-color: #cbd5e1;
        }

        /* CUSTOM SELECT FOR PHONE TYPE */
        .custom-select {
            padding: 10px;
            border: 1px solid #cbd5e1;
            border-radius: 4px;
            color: #334155;
            background: white;
            height: 40px;
            font-size: 14px;
            cursor: pointer;
        }
        .custom-select:focus { outline: 2px solid #0ea5e9; }

        /* ADDED ITEMS LIST (Repeater Style) */
        .added-items-list {
            margin-top: 15px;
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .added-item {
            display: flex;
            align-items: center;
            background: #f8fafc;
            padding: 10px 15px;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
            font-size: 14px;
        }

        .added-item span { flex: 1; color: #334155; }
        .added-item small { 
            color: #64748b; 
            margin-right: 15px; 
            text-transform: uppercase; 
            font-size: 11px; 
            font-weight: bold;
            background: #e2e8f0;
            padding: 2px 6px;
            border-radius: 4px;
        }

        .btn-remove {
            background: none;
            border: none;
            color: #ef4444; /* Red */
            font-weight: 600;
            font-size: 12px;
            cursor: pointer;
            padding: 5px 10px;
        }
        .btn-remove:hover { text-decoration: underline; background-color: #fee2e2; border-radius: 4px; }

        /* MAIN ACTION BUTTONS */
        .btn-register {
            width: 100%;
            padding: 16px;
            background-color: #0f172a;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 30px;
            transition: transform 0.1s, background 0.2s;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .btn-register:hover {
            background-color: #1e293b;
            transform: translateY(-2px);
        }

        .message-box {
            display: block;
            margin-top: 20px;
            font-size: 14px;
            text-align: center;
        }
        
        .login-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #64748b;
            text-decoration: none;
            font-size: 14px;
        }
        .login-link:hover { color: #0ea5e9; }

        /* RESPONSIVE */
        @media (max-width: 900px) {
            .split-container { flex-direction: column; overflow-y: auto; }
            .brand-side { width: 100%; min-height: 200px; padding: 40px; }
            .form-side { width: 100%; height: auto; overflow: visible; padding: 40px 20px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="split-container">
            
            <div class="brand-side">
                <div class="brand-heading">Join the<br />Network.</div>
                <div class="brand-subtext">
                    Create your profile to manage device licenses and monitor system status securely.
                </div>
            </div>

            <div class="form-side">
                <div class="form-wrapper">
                    <div class="form-header">
                        <h2>Create Account</h2>
                        <p>Please fill in your details below.</p>
                    </div>

                    <div class="section-title">01. Personal Info</div>
                    
                    <div class="input-group">
                        <asp:TextBox ID="txtFullName" runat="server" placeholder=" "></asp:TextBox>
                        <label>Full Name</label>
                    </div>

                    <div class="form-row">
                        <div class="input-group">
                            <asp:TextBox ID="txtCity" runat="server" placeholder=" "></asp:TextBox>
                            <label>City</label>
                        </div>
                        <div class="input-group">
                            <asp:TextBox ID="txtCountry" runat="server" placeholder=" "></asp:TextBox>
                            <label>Country</label>
                        </div>
                    </div>

                    <div class="section-title">02. Contact Details</div>
                    
                    <div class="add-row">
                        <div class="input-group">
                            <asp:TextBox ID="txtEmail1" runat="server" placeholder=" " TextMode="Email"></asp:TextBox>
                            <label>Email Address</label>
                        </div>
                        <asp:Button ID="btnAddEmail" runat="server" Text="+ Add" CssClass="btn-add" OnClick="btnAddEmail_Click" UseSubmitBehavior="false" />
                    </div>

                    <asp:Panel ID="pnlAdditionalEmails" runat="server" CssClass="added-items-list">
                        <asp:Repeater ID="rptEmails" runat="server" OnItemCommand="rptEmails_ItemCommand">
                            <ItemTemplate>
                                <div class="added-item">
                                    <small>Email</small>
                                    <span><%# Container.DataItem %></span>
                                    <asp:TextBox ID="txtEmail" runat="server" Text='<%# Container.DataItem %>' Visible="false"></asp:TextBox>
                                    <asp:LinkButton ID="btnRemoveEmail" runat="server" Text="Remove" CssClass="btn-remove" CommandArgument='<%# Container.ItemIndex %>' CommandName="RemoveEmail" UseSubmitBehavior="false" />
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </asp:Panel>

                    <div class="add-row" style="margin-top: 10px;">
                        <div class="input-group">
                            <asp:TextBox ID="txtPhone1" runat="server" placeholder=" "></asp:TextBox>
                            <label>Phone Number</label>
                        </div>
                        <select id="phoneType1" name="phoneType1" class="custom-select">
                            <option value="Mobile">Mobile</option>
                            <option value="Home">Home</option>
                            <option value="Work">Work</option>
                        </select>
                        <asp:Button ID="btnAddPhone" runat="server" Text="+ Add" CssClass="btn-add" OnClick="btnAddPhone_Click" UseSubmitBehavior="false" />
                    </div>

                    <asp:Panel ID="pnlAdditionalPhones" runat="server" CssClass="added-items-list">
                        <asp:Repeater ID="rptPhones" runat="server" OnItemCommand="rptPhones_ItemCommand">
                            <ItemTemplate>
                                <div class="added-item">
                                    <small><%# GetPhoneType(Container.DataItem) %></small>
                                    <span><%# GetPhoneNumber(Container.DataItem) %></span>
                                    <asp:TextBox ID="txtPhone" runat="server" Text='<%# GetPhoneNumber(Container.DataItem) %>' Visible="false"></asp:TextBox>
                                    <asp:LinkButton ID="btnRemovePhone" runat="server" Text="Remove" CssClass="btn-remove" CommandArgument='<%# Container.ItemIndex %>' CommandName="RemovePhone" UseSubmitBehavior="false" />
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </asp:Panel>

                    <div class="section-title">03. Security</div>

                    <div class="input-group">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder=" "></asp:TextBox>
                        <label>Numeric PIN</label>
                    </div>

                    <div class="input-group">
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder=" "></asp:TextBox>
                        <label>Confirm PIN</label>
                    </div>

                    <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn-register" OnClick="btnRegister_Click" />
                    
                    <asp:Label ID="lblMessage" runat="server" CssClass="message-box"></asp:Label>

                    <a href="Login.aspx" class="login-link">Already have an account? <b>Log In</b></a>
                    <br /><br />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
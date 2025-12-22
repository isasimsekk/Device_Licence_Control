<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Device_Licence_Control.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register - Device Licence Control</title>
    <style>
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex; 
            justify-content: center; 
            align-items: center; 
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }
        .register-container { 
            background-color: white; 
            padding: 40px; 
            border-radius: 8px; 
            box-shadow: 0 8px 32px rgba(0,0,0,0.1); 
            width: 100%;
            max-width: 500px;
            text-align: center; 
        }
        .register-container h2 {
            color: #333;
            margin-top: 0;
            font-size: 28px;
        }
        .register-container p {
            color: #999;
            margin-bottom: 30px;
            font-size: 14px;
        }
        .section-title {
            color: #667eea;
            font-size: 14px;
            font-weight: 600;
            margin-top: 25px;
            margin-bottom: 15px;
            text-align: left;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 10px;
        }
        .input-group { 
            margin-bottom: 15px; 
            text-align: left; 
        }
        .input-group label { 
            display: block; 
            margin-bottom: 8px; 
            color: #555;
            font-weight: 500;
            font-size: 14px;
        }
        .input-group input, 
        .input-group select { 
            width: 100%; 
            padding: 10px 12px; 
            border: 1px solid #ddd; 
            border-radius: 4px; 
            box-sizing: border-box;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        .input-group input:focus,
        .input-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        .form-row .input-group {
            margin-bottom: 0;
        }
        .dynamic-fields {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 4px;
            margin-top: 10px;
            margin-bottom: 15px;
            border: 1px solid #f0f0f0;
        }
        .field-row {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            align-items: flex-end;
        }
        .field-row .input-group {
            margin-bottom: 0;
            flex: 1;
        }
        .field-row select {
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .btn-add {
            padding: 8px 12px;
            background-color: #27ae60;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: background-color 0.2s;
            white-space: nowrap;
        }
        .btn-add:hover {
            background-color: #229954;
        }
        .btn-remove {
            padding: 8px 12px;
            background-color: #e74c3c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: background-color 0.2s;
            white-space: nowrap;
        }
        .btn-remove:hover {
            background-color: #c0392b;
        }
        .btn-register { 
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
        .btn-register:hover { 
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .btn-register:active {
            transform: translateY(0);
        }
        
        /* Message styles - hidden by default */
        .message-box {
            font-size: 14px; 
            margin-top: 15px; 
            padding: 12px;
            border-radius: 4px;
            display: none;
            border-left: 4px solid;
        }
        
        /* Error message style */
        .error-msg {
            color: #c0392b;
            background-color: #fadbd8;
            border-left-color: #e74c3c;
            display: block;
        }
        
        /* Success message style */
        .success-msg {
            color: #27ae60;
            background-color: #d5f4e6;
            border-left-color: #27ae60;
            display: block;
        }
        
        .login-link { 
            margin-top: 20px; 
            display: block; 
            font-size: 14px;
            color: #667eea;
            text-decoration: none;
            border-top: 1px solid #eee;
            padding-top: 15px;
        }
        .login-link:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        .password-label,
        .required-label {
            font-size: 12px;
            color: #999;
            display: block;
            margin-top: 4px;
        }
        .required {
            color: #e74c3c;
        }
        @media (max-width: 500px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            .field-row {
                flex-direction: column;
                align-items: stretch;
            }
            .field-row select {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-container">
            <h2>Create Account</h2>
            <p>Register to get started</p>
            
            <!-- BASIC INFORMATION SECTION -->
            <div class="section-title">Basic Information</div>
            
            <div class="input-group">
                <label>Full Name <span class="required">*</span></label>
                <asp:TextBox ID="txtFullName" runat="server" placeholder="Enter your full name"></asp:TextBox>
            </div>

            <div class="form-row">
                <div class="input-group">
                    <label>City</label>
                    <asp:TextBox ID="txtCity" runat="server" placeholder="Enter your city"></asp:TextBox>
                </div>

                <div class="input-group">
                    <label>Country</label>
                    <asp:TextBox ID="txtCountry" runat="server" placeholder="Enter your country"></asp:TextBox>
                </div>
            </div>

            <!-- EMAIL SECTION -->
            <div class="section-title">Email Address(es)</div>
            <div class="dynamic-fields">
                <div id="emailFields">
                    <div class="field-row">
                        <div class="input-group" style="flex: 1;">
                            <label>Email <span class="required">*</span></label>
                            <asp:TextBox ID="txtEmail1" runat="server" placeholder="Enter email address" TextMode="Email"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnAddEmail" runat="server" Text="Add Email" CssClass="btn-add" OnClick="btnAddEmail_Click" />
                    </div>
                </div>
                <asp:Panel ID="pnlAdditionalEmails" runat="server">
                    <asp:Repeater ID="rptEmails" runat="server" OnItemCommand="rptEmails_ItemCommand">
                        <ItemTemplate>
                            <div class="field-row">
                                <div class="input-group" style="flex: 1;">
                                    <asp:TextBox ID="txtEmail" runat="server" placeholder="Enter email address" TextMode="Email" Text='<%# (string)Container.DataItem %>' ReadOnly="true"></asp:TextBox>
                                </div>
                                <asp:LinkButton ID="btnRemoveEmail" runat="server" Text="Remove" CssClass="btn-remove" CommandArgument='<%# Container.ItemIndex %>' CommandName="RemoveEmail" />
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>
            </div>

            <!-- PHONE SECTION -->
            <div class="section-title">Phone Number(s)</div>
            <div class="dynamic-fields">
                <div id="phoneFields">
                    <div class="field-row">
                        <div class="input-group" style="flex: 1;">
                            <label>Phone Number <span class="required">*</span></label>
                            <asp:TextBox ID="txtPhone1" runat="server" placeholder="Enter phone number"></asp:TextBox>
                        </div>
                        <select id="phoneType1" style="width: 120px;">
                            <option value="Mobile">Mobile</option>
                            <option value="Home">Home</option>
                            <option value="Work">Work</option>
                        </select>
                        <asp:Button ID="btnAddPhone" runat="server" Text="Add Phone" CssClass="btn-add" OnClick="btnAddPhone_Click" />
                    </div>
                </div>
                <asp:Panel ID="pnlAdditionalPhones" runat="server">
                    <asp:Repeater ID="rptPhones" runat="server" OnItemCommand="rptPhones_ItemCommand">
                        <ItemTemplate>
                            <div class="field-row">
                                <div class="input-group" style="flex: 1;">
                                    <asp:TextBox ID="txtPhone" runat="server" placeholder="Enter phone number" Text='<%# GetPhoneNumber(Container.DataItem) %>' ReadOnly="true"></asp:TextBox>
                                </div>
                                <select style="width: 120px;" disabled="disabled">
                                    <option value="Mobile" <%# GetPhoneType(Container.DataItem) == "Mobile" ? "selected" : "" %>>Mobile</option>
                                    <option value="Home" <%# GetPhoneType(Container.DataItem) == "Home" ? "selected" : "" %>>Home</option>
                                    <option value="Work" <%# GetPhoneType(Container.DataItem) == "Work" ? "selected" : "" %>>Work</option>
                                </select>
                                <asp:LinkButton ID="btnRemovePhone" runat="server" Text="Remove" CssClass="btn-remove" CommandArgument='<%# Container.ItemIndex %>' CommandName="RemovePhone" />
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>
            </div>

            <!-- PASSWORD SECTION -->
            <div class="section-title">Security</div>
            
            <div class="input-group">
                <label>
                    Password
                    <span class="required-label">(Numeric PIN)</span>
                    <span class="required">*</span>
                </label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter numeric PIN"></asp:TextBox>
            </div>

            <div class="input-group">
                <label>
                    Confirm Password
                    <span class="required">*</span>
                </label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm numeric PIN"></asp:TextBox>
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn-register" OnClick="btnRegister_Click" />
            
            <asp:Label ID="lblMessage" runat="server" CssClass="message-box"></asp:Label>

            <a href="Login.aspx" class="login-link">Already have an account? Login here</a>
        </div>
    </form>
</body>
</html>

using System;

namespace Device_Licence_Control.Business
{
    public class AuthenticationBLL
    {
        private Data.UserDAL userDAL;

        public AuthenticationBLL()
        {
            userDAL = new Data.UserDAL();
        }

        /// <summary>
        /// Authenticate user with validation and return user details if successful
        /// Provides user-friendly error messages
        /// </summary>
        public Models.User AuthenticateUser(string fullName, string passwordInput, out string errorMessage)
        {
            errorMessage = string.Empty;

            // 1. Basic Validation
            if (string.IsNullOrWhiteSpace(fullName) || string.IsNullOrWhiteSpace(passwordInput))
            {
                if (string.IsNullOrWhiteSpace(fullName) && string.IsNullOrWhiteSpace(passwordInput))
                {
                    errorMessage = "Please enter both Full Name and Password.";
                }
                else if (string.IsNullOrWhiteSpace(fullName))
                {
                    errorMessage = "Please enter your Full Name.";
                }
                else
                {
                    errorMessage = "Please enter your Password.";
                }
                return null;
            }

            // 2. Validate that Password is a Number
            int passwordNumber;
            if (!int.TryParse(passwordInput, out passwordNumber))
            {
                errorMessage = "Password must contain only numbers (0-9).";
                return null;
            }

            // 3. Validate password length (basic check)
            if (passwordInput.Length < 1)
            {
                errorMessage = "Password cannot be empty.";
                return null;
            }

            // 4. Authenticate against database
            try
            {
                Models.User user = userDAL.AuthenticateUser(fullName.Trim(), passwordNumber);

                if (user == null)
                {
                    errorMessage = "Invalid Full Name or Password. Please try again.";
                    return null;
                }

                // 5. Check if user account is active
                if (!user.IsActive)
                {
                    errorMessage = "Your account is currently disabled. Please contact the system administrator for assistance.";
                    return null;
                }

                return user;
            }
            catch (Exception ex)
            {
                errorMessage = "An error occurred during login. Please try again later.";
                System.Diagnostics.Debug.WriteLine("Authentication Error: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("StackTrace: " + ex.StackTrace);
                return null;
            }
        }

        /// <summary>
        /// Validate user exists
        /// </summary>
        public bool ValidateUserExists(string fullName)
        {
            try
            {
                return userDAL.UserExists(fullName);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("User validation error: " + ex.Message);
                return false;
            }
        }
    }
}

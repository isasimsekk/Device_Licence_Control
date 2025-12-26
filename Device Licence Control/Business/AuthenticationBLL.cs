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

        public Models.User AuthenticateUser(int userID, string passwordInput, out string errorMessage)
        {
            errorMessage = string.Empty;

            if (userID <= 0 || string.IsNullOrWhiteSpace(passwordInput))
            {
                if (userID <= 0 && string.IsNullOrWhiteSpace(passwordInput))
                {
                    errorMessage = "Please enter both User ID and Password.";
                }
                else if (userID <= 0)
                {
                    errorMessage = "Please enter a valid User ID.";
                }
                else
                {
                    errorMessage = "Please enter your Password.";
                }
                return null;
            }

            int passwordNumber;
            if (!int.TryParse(passwordInput, out passwordNumber))
            {
                errorMessage = "Password must contain only numbers (0-9).";
                return null;
            }

            if (passwordInput.Length < 1)
            {
                errorMessage = "Password cannot be empty.";
                return null;
            }

            try
            {
                Models.User user = userDAL.AuthenticateUser(userID, passwordNumber);

                if (user == null)
                {
                    errorMessage = "Invalid User ID or Password. Please try again.";
                    return null;
                }

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

        public bool ValidateUserExists(int userID)
        {
            try
            {
                return userDAL.UserExists(userID);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("User validation error: " + ex.Message);
                return false;
            }
        }
    }
}

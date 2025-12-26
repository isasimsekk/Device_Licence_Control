using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Device_Licence_Control.Data
{
    public class UserDAL
    {
        private string connectionString;

        public UserDAL()
        {
            connectionString = ConfigurationManager.ConnectionStrings["conStr"].ConnectionString;
        }

        
        public bool TestConnection(out string errorMessage)
        {
            errorMessage = "";
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    con.Close();
                    return true;
                }
            }
            catch (Exception ex)
            {
                errorMessage = ex.Message;
                System.Diagnostics.Debug.WriteLine("Connection Test Failed: " + ex.Message);
                return false;
            }
        }

    
        public Models.User AuthenticateUser(int userID, int password)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    string query = "SELECT UserId, FullName, Password, IsActive, isAdmin, CreatedAt FROM [User] " +
                                   "WHERE UserId = @UserID AND Password = @Password";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    cmd.Parameters.AddWithValue("@Password", password);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.HasRows && reader.Read())
                    {
                        Models.User user = new Models.User
                        {
                            UserId = Convert.ToInt32(reader["UserId"]),
                            FullName = reader["FullName"].ToString(),
                            Password = Convert.ToInt32(reader["Password"]),
                            IsActive = Convert.ToBoolean(reader["IsActive"]),
                            IsAdmin = Convert.ToBoolean(reader["isAdmin"]), 
                            CreatedDate = Convert.ToDateTime(reader["CreatedAt"]) 
                        };

                        reader.Close();
                        return user;
                    }

                    reader.Close();
                    return null;
                }
            }
            catch (SqlException sqlEx)
            {
                System.Diagnostics.Debug.WriteLine("SQL Error: " + sqlEx.Message);
                System.Diagnostics.Debug.WriteLine("Connection String: " + connectionString);
                throw new Exception("Database error: " + sqlEx.Message, sqlEx);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("General Error: " + ex.Message);
                throw new Exception("Error authenticating user: " + ex.Message, ex);
            }
        }




        
        public bool UserExists(int userID)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    string query = "SELECT COUNT(*) FROM [User] WHERE UserId = @UserID";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@UserID", userID);

                    int count = (int)cmd.ExecuteScalar();

                    return count > 0;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error checking user existence: " + ex.Message, ex);
            }
        }
    }
}

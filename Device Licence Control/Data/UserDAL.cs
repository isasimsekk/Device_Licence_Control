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

        /// <summary>
        /// Test database connection
        /// </summary>
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

        /// <summary>
        /// Authenticate user with full name and password using parameterized query
        /// Uses exact column names from database: CreatedAt (datetime2) and isAdmin (lowercase)
        /// </summary>
        public Models.User AuthenticateUser(string fullName, int password)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Using exact column names from your database
                    string query = "SELECT UserId, FullName, Password, IsActive, isAdmin, CreatedAt FROM [User] " +
                                   "WHERE FullName = @FullName AND Password = @Password";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@FullName", fullName ?? "");
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
                            IsAdmin = Convert.ToBoolean(reader["isAdmin"]), // lowercase isAdmin from database
                            CreatedDate = Convert.ToDateTime(reader["CreatedAt"]) // Maps CreatedAt to CreatedDate
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

        /// <summary>
        /// Get user by full name
        /// </summary>
        public Models.User GetUserByFullName(string fullName)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Using exact column names from your database
                    string query = "SELECT UserId, FullName, Password, IsActive, isAdmin, CreatedAt FROM [User] " +
                                   "WHERE FullName = @FullName";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@FullName", fullName ?? "");

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.HasRows && reader.Read())
                    {
                        Models.User user = new Models.User
                        {
                            UserId = Convert.ToInt32(reader["UserId"]),
                            FullName = reader["FullName"].ToString(),
                            Password = Convert.ToInt32(reader["Password"]),
                            IsActive = Convert.ToBoolean(reader["IsActive"]),
                            IsAdmin = Convert.ToBoolean(reader["isAdmin"]), // lowercase isAdmin from database
                            CreatedDate = Convert.ToDateTime(reader["CreatedAt"]) // Maps CreatedAt to CreatedDate
                        };

                        reader.Close();
                        return user;
                    }

                    reader.Close();
                    return null;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving user: " + ex.Message, ex);
            }
        }

        /// <summary>
        /// Check if user exists by full name
        /// </summary>
        public bool UserExists(string fullName)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    string query = "SELECT COUNT(*) FROM [User] WHERE FullName = @FullName";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@FullName", fullName ?? "");

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

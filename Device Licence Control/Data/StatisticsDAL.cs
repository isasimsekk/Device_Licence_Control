using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Device_Licence_Control.Data
{
    public class StatisticsDAL
    {
        private string connectionString;

        public StatisticsDAL()
        {
            connectionString = ConfigurationManager.ConnectionStrings["conStr"].ConnectionString;
        }

        /// <summary>
        /// Get count of active users
        /// </summary>
        public int GetActiveUserCount()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    string query = "SELECT COUNT(*) FROM [User] WHERE IsActive = 1";

                    SqlCommand cmd = new SqlCommand(query, con);

                    int count = (int)cmd.ExecuteScalar();

                    return count;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error getting active user count: " + ex.Message);
                return 0;
            }
        }

        /// <summary>
        /// Get total count of registered devices
        /// </summary>
        public int GetTotalRegisteredDeviceCount()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    string query = "SELECT COUNT(*) FROM [dbo].[RegisteredDevice]";

                    SqlCommand cmd = new SqlCommand(query, con);

                    int count = (int)cmd.ExecuteScalar();

                    return count;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error getting registered device count: " + ex.Message);
                return 0;
            }
        }
    }
}

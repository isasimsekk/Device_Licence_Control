using System;
using System.Data;

namespace Device_Licence_Control.Data
{
    public class StatisticsDAL
    {
        public StatisticsDAL()
        {
        }

        public int GetActiveUserCount()
        {
            return GetCount("SELECT COUNT(*) FROM [User] WHERE IsActive = 1");
        }

        public int GetTotalRegisteredDeviceCount()
        {
            return GetCount("SELECT COUNT(*) FROM [dbo].[RegisteredDevice]");
        }

        public int GetTotalActivationKeysCount()
        {
            return GetCount("SELECT COUNT(*) FROM [dbo].[ActivationKey]");
        }

        public int GetUnassignedKeysCount()
        {
            return GetCount("SELECT COUNT(*) FROM [dbo].[ActivationKey] WHERE Status = 'not transferred'");
        }

        public int GetTotalAssignmentsCount()
        {
            return GetCount("SELECT COUNT(*) FROM [dbo].[KeyDeviceAssignment]");
        }

        private int GetCount(string query)
        {
            try
            {
                Device_Licence_Control.DBConnection db = new Device_Licence_Control.DBConnection();
                DataSet ds = db.getSelect(query);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    return Convert.ToInt32(ds.Tables[0].Rows[0][0]);
                }
                return 0;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error getting count: " + ex.Message);
                return 0;
            }
        }
    }
}

using System;

namespace Device_Licence_Control.Utils
{
    public static class SessionManager
    {
        public static void SetUserSession(System.Web.UI.Page page, Models.User user)
        {
            if (page.Session != null && user != null)
            {
                page.Session["UserId"] = user.UserId;
                page.Session["UserFullName"] = user.FullName;
                page.Session["IsAdmin"] = user.IsAdmin;
                page.Session["LoginTime"] = DateTime.Now;
            }
        }

        public static void ClearUserSession(System.Web.UI.Page page)
        {
            if (page.Session != null)
            {
                page.Session.Clear();
                page.Session.Abandon();
            }
        }

        public static bool IsUserLoggedIn(System.Web.UI.Page page)
        {
            return page.Session != null && page.Session["UserFullName"] != null;
        }

        public static string GetUserFullName(System.Web.UI.Page page)
        {
            if (page.Session != null && page.Session["UserFullName"] != null)
            {
                return page.Session["UserFullName"].ToString();
            }
            return string.Empty;
        }

        public static int GetUserId(System.Web.UI.Page page)
        {
            if (page.Session != null && page.Session["UserId"] != null)
            {
                return Convert.ToInt32(page.Session["UserId"]);
            }
            return 0;
        }

        public static bool IsUserAdmin(System.Web.UI.Page page)
        {
            if (page.Session != null && page.Session["IsAdmin"] != null)
            {
                return Convert.ToBoolean(page.Session["IsAdmin"]);
            }
            return false;
        }
    }
}

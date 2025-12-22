using System;

namespace Device_Licence_Control.Models
{
    public class User
    {
        public int UserId { get; set; }
        public string FullName { get; set; }
        public int Password { get; set; }
        public bool IsActive { get; set; }
        public bool IsAdmin { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}

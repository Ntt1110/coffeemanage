using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DTO
{
    public class Bill
    {
        public Bill(int id, DateTime? dateCheckin, DateTime? dateCheckOut, int status, int discount = 0)
        {
            this.ID = id;
            this.DateCheckIn = dateCheckin;
            this.DateCheckOut = dateCheckOut;
            this.Status = status;
            this.Discount = discount;
        }

        public Bill(DataRow row)
        {
            // Kiểm tra null khi ép kiểu các giá trị từ DataRow
            this.ID = row["id"] != DBNull.Value ? Convert.ToInt32(row["id"]) : 0;

            // Kiểm tra null cho trường ngày check-in
            this.DateCheckIn = row["dateCheckin"] != DBNull.Value ? (DateTime?)row["dateCheckin"] : null;

            // Kiểm tra null cho trường ngày check-out
            var dateCheckOutTemp = row["dateCheckOut"];
            if (dateCheckOutTemp != DBNull.Value)
            {
                this.DateCheckOut = (DateTime?)dateCheckOutTemp;
            }

            // Kiểm tra null cho trường status
            this.Status = row["status"] != DBNull.Value ? Convert.ToInt32(row["status"]) : 0;

            // Kiểm tra null cho trường discount
            this.Discount = row["discount"] != DBNull.Value ? Convert.ToInt32(row["discount"]) : 0;
        }

        public int ID { get; set; }
        public DateTime? DateCheckIn { get; set; }
        public DateTime? DateCheckOut { get; set; }
        public int Status { get; set; }
        public int Discount { get; set; }
    }

}

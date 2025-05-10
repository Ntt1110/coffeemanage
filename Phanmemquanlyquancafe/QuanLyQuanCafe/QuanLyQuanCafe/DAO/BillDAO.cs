using QuanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DAO
{
    public class BillDAO
    {
        private static BillDAO instance;

        public static BillDAO Instance
        {
            get { if (instance == null) instance = new BillDAO(); return BillDAO.instance; }
            private set { BillDAO.instance = value; }
        }

        private BillDAO() { }

        /// <summary>
        /// Thành công: bill ID
        /// thất bại: -1
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int GetUncheckBillIDByTableID(int id)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM dbo.Bill WHERE idTable = " + id +" AND status = 0");

            if (data.Rows.Count > 0)
            {
                Bill bill = new Bill(data.Rows[0]);
                return bill.ID;
            }

            return -1;
        }

        public void CheckOut(int id, int discount, float totalPrice)
        {
            string query = "UPDATE dbo.Bill SET dateCheckOut = GETDATE(), status = 1, discount = @discount, totalPrice = @totalPrice WHERE id = @id";
            DataProvider.Instance.ExecuteNonQuery(query, new object[] { discount, totalPrice, id });

            string updateTableQuery = "UPDATE TableFood SET Status = 0 WHERE ID = (SELECT idTable FROM dbo.Bill WHERE id = @id)";
            DataProvider.Instance.ExecuteNonQuery(updateTableQuery, new object[] { id });
        }

        public void InsertBill(int id)
        {
            // Gọi stored procedure thêm hóa đơn
            DataProvider.Instance.ExecuteNonQuery("exec USP_InsertBill @idTable", new object[] { id });

            // Cập nhật trạng thái bàn = 1 (có người)
            string query = "UPDATE TableFood SET status = 1 WHERE id = @idTable";
            DataProvider.Instance.ExecuteNonQuery(query, new object[] { id });
        }


        public DataTable GetBillListByDate(DateTime checkIn, DateTime checkOut)
        {
            return DataProvider.Instance.ExecuteQuery("exec USP_GetListBillByDate @checkIn , @checkOut", new object[] { checkIn, checkOut });
        }

        public DataTable GetBillListByDateAndPage(DateTime checkIn, DateTime checkOut, int pageNum)
        {
            return DataProvider.Instance.ExecuteQuery("exec USP_GetListBillByDateAndPage @checkIn , @checkOut , @page", new object[] { checkIn, checkOut, pageNum });
        }

        public int GetNumBillListByDate(DateTime checkIn, DateTime checkOut)
        {
            return (int)DataProvider.Instance.ExecuteScalar("exec USP_GetNumBillByDate @checkIn , @checkOut", new object[] { checkIn, checkOut });
        }

        public int GetMaxIDBill()
        {
            try
            {
                return (int)DataProvider.Instance.ExecuteScalar("SELECT MAX(id) FROM dbo.Bill");
            }
            catch
            {
                return 1;
            }
        }

        public void UpdateBillItem(int billID, int foodID, int newCount)
        {
            string query = "EXEC UpdateBillItem @BillID , @FoodID , @NewCount";
            DataProvider.Instance.ExecuteNonQuery(query, new object[] { billID, foodID, newCount });
        }

    }
}

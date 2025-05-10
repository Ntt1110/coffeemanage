using QuanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;

namespace QuanLyQuanCafe.DAO
{
    public class BillInfoDAO
    {
        private static BillInfoDAO instance;

        public static BillInfoDAO Instance
        {
            get { if (instance == null) instance = new BillInfoDAO(); return BillInfoDAO.instance; }
            private set { BillInfoDAO.instance = value; }
        }

        private BillInfoDAO() { }

        // Phương thức xóa món trong BillInfo theo FoodID
        public void DeleteBillInfoByFoodID(int id)
        {
            DataProvider.Instance.ExecuteQuery("DELETE FROM dbo.BillInfo WHERE idFood = @idFood", new object[] { id });
        }

        // Phương thức lấy danh sách món ăn trong BillInfo theo BillID
        public List<BillInfo> GetListBillInfo(int id)
        {
            List<BillInfo> listBillInfo = new List<BillInfo>();

            DataTable data = DataProvider.Instance.ExecuteQuery("SELECT * FROM dbo.BillInfo WHERE idBill = @idBill", new object[] { id });

            foreach (DataRow item in data.Rows)
            {
                BillInfo info = new BillInfo(item);
                listBillInfo.Add(info);
            }

            return listBillInfo;
        }

        // Phương thức thêm món vào BillInfo
        public void InsertBillInfo(int idBill, int idFood, int count)
        {
            DataProvider.Instance.ExecuteNonQuery("USP_InsertBillInfo @idBill , @idFood , @count", new object[] { idBill, idFood, count });
        }

        // Phương thức thanh toán và xóa dữ liệu trong BillInfo khi thanh toán
        public void PayBill(int billID)
        {
            // Xóa tất cả các món trong BillInfo liên quan đến billID
            DataProvider.Instance.ExecuteNonQuery("DELETE FROM dbo.BillInfo WHERE idBill = @billID", new object[] { billID });

            // Cập nhật trạng thái hóa đơn là đã thanh toán
            DataProvider.Instance.ExecuteNonQuery("UPDATE Bill SET Status = 1 WHERE ID = @billID", new object[] { billID });

            // Cập nhật trạng thái bàn là trống (Status = 0)
            DataProvider.Instance.ExecuteNonQuery("UPDATE TableFood SET Status = 0 WHERE ID = (SELECT TableID FROM Bill WHERE ID = @billID)", new object[] { billID });
        }

    }
}

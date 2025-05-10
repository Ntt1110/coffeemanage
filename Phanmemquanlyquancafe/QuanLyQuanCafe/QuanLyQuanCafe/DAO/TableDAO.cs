using QuanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DAO
{
    public class TableDAO
    {
        private static TableDAO instance;

        public static TableDAO Instance
        {
            get { if (instance == null) instance = new TableDAO(); return TableDAO.instance; }
            private set { TableDAO.instance = value; }
        }

        public static int TableWidth = 90;
        public static int TableHeight = 90;

        private TableDAO() { }

        public void SwitchTable(int id1, int id2)
        {
            // Thực thi query để chuyển bàn
            DataProvider.Instance.ExecuteQuery("USP_SwitchTable @idTable1 , @idTable2", new object[] { id1, id2 });

            // Cập nhật trạng thái bàn 1
            TableDAO.Instance.UpdateTableStatus(id1, "Có người ngồi");

            // Cập nhật trạng thái bàn 2
            TableDAO.Instance.UpdateTableStatus(id2, "Trống");
        }

        public void UpdateTableStatus(int tableID, string status)
        {
            string query = "UPDATE TableFood SET status = @status WHERE id = @id";
            DataProvider.Instance.ExecuteNonQuery(query, new object[] { status, tableID });
        }


        // Tải danh sách các bàn từ cơ sở dữ liệu
        public List<Table> LoadTableList()
        {
            List<Table> tableList = new List<Table>();

            // Thực thi truy vấn để lấy danh sách bàn
            DataTable data = DataProvider.Instance.ExecuteQuery("USP_GetTableList");

            foreach (DataRow item in data.Rows)
            {
                Table table = new Table(item);  // Tạo đối tượng bàn từ dữ liệu
                tableList.Add(table);
            }

            return tableList;
        }
    }
}

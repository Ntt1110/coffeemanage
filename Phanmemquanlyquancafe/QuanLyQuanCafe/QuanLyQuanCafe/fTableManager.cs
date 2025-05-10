using QuanLyQuanCafe.DAO;
using QuanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyQuanCafe
{
    public partial class fTableManager : Form
    {
        private Account loginAccount;

        public Account LoginAccount
        {
            get { return loginAccount; }
            set { loginAccount = value; ChangeAccount(loginAccount.Type); }
        }
        public fTableManager(Account acc)
        {
            InitializeComponent();

            this.LoginAccount = acc;

            LoadTable();
            LoadCategory();
            LoadComboboxTable(cbSwitchTable);
        }

        #region Method

        void ChangeAccount(int type)
        {
            adminToolStripMenuItem.Enabled = type == 1;
            thôngTinTàiKhoảnToolStripMenuItem.Text += " (" + LoginAccount.DisplayName + ")";
        }
        void LoadCategory()
        {
            List<Category> listCategory = CategoryDAO.Instance.GetListCategory();
            cbCategory.DataSource = listCategory;
            cbCategory.DisplayMember = "Name";
        }

        void LoadFoodListByCategoryID(int id)
        {
            List<Food> listFood = FoodDAO.Instance.GetFoodByCategoryID(id);
            cbFood.DataSource = listFood;
            cbFood.DisplayMember = "Name";
        }
        void LoadTable()
        {
            flpTable.Controls.Clear();  // Xóa các button cũ

            // Lấy danh sách các bàn
            List<Table> tableList = TableDAO.Instance.LoadTableList();

            // Lặp qua các bàn để tạo button tương ứng
            foreach (Table item in tableList)
            {
                Button btn = new Button()
                {
                    Width = TableDAO.TableWidth,
                    Height = TableDAO.TableHeight
                };

                // Hiển thị thông tin bàn
                btn.Text = $"{item.Name}{Environment.NewLine}{item.Status}";
                btn.Click += btn_Click;
                btn.Tag = item;

                // Cập nhật màu sắc của button dựa trên trạng thái của bàn
                btn.BackColor = GetTableColor(item.Status);

                // Thêm button vào bảng điều khiển (flpTable)
                flpTable.Controls.Add(btn);
            }
        }

        // Phương thức riêng để xác định màu sắc của bàn
        private Color GetTableColor(string status)
        {
            if (status == "Trống")
                return Color.Aqua;
            else
                return Color.LightPink;
        }


        void ShowBill(int id)
        {
            lsvBill.Items.Clear();
            List<QuanLyQuanCafe.DTO.Menu> listBillInfo = MenuDAO.Instance.GetListMenuByTable(id);
            float totalPrice = 0;

            // Kiểm tra nếu không có món ăn trong hóa đơn
            if (listBillInfo.Count == 0)
            {
                ListViewItem noItems = new ListViewItem("Chưa có món ăn");
                lsvBill.Items.Add(noItems);
                txbTotalPrice.Text = "0 VND"; // Hiển thị giá trị 0 nếu không có món
                return;
            }

            foreach (QuanLyQuanCafe.DTO.Menu item in listBillInfo)
            {
                ListViewItem lsvItem = new ListViewItem(item.FoodName);
                lsvItem.SubItems.Add(item.Count.ToString());
                lsvItem.SubItems.Add(item.Price.ToString("c", new CultureInfo("vi-VN")));
                lsvItem.SubItems.Add(item.TotalPrice.ToString("c", new CultureInfo("vi-VN")));

                totalPrice += item.TotalPrice;

                lsvItem.Tag = item;

                lsvBill.Items.Add(lsvItem);
            }

            CultureInfo culture = new CultureInfo("vi-VN");
            txbTotalPrice.Text = totalPrice.ToString("c", culture); // Định dạng tổng giá trị



        }

        void LoadComboboxTable(ComboBox cb)
        {
            cb.DataSource = TableDAO.Instance.LoadTableList();
            cb.DisplayMember = "Name";
        }

        #endregion


        #region Events

        private void thanhToánToolStripMenuItem_Click(object sender, EventArgs e)
        {
            btnCheckOut_Click(this, new EventArgs());
        }

        private void thêmMónToolStripMenuItem_Click(object sender, EventArgs e)
        {
            btnAddFood_Click(this, new EventArgs());
        }

        void btn_Click(object sender, EventArgs e)
        {
            int tableID = ((sender as Button).Tag as Table).ID;
            lsvBill.Tag = (sender as Button).Tag;
            ShowBill(tableID);
        }
        private void đăngXuấtToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void thôngTinCáNhânToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fAccountProfile f = new fAccountProfile(LoginAccount);
            f.UpdateAccount += f_UpdateAccount;
            f.ShowDialog();
        }

        void f_UpdateAccount(object sender, AccountEvent e)
        {
            thôngTinTàiKhoảnToolStripMenuItem.Text = "Thông tin tài khoản (" + e.Acc.DisplayName + ")";
        }

        private void adminToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fAdmin f = new fAdmin();
            f.loginAccount = LoginAccount;
            f.InsertFood += f_InsertFood;
            f.DeleteFood += f_DeleteFood;
            f.UpdateFood += f_UpdateFood;
            f.ShowDialog();
        }

        void f_UpdateFood(object sender, EventArgs e)
        {
            LoadFoodListByCategoryID((cbCategory.SelectedItem as Category).ID);
            if (lsvBill.Tag != null)
                ShowBill((lsvBill.Tag as Table).ID);
        }

        void f_DeleteFood(object sender, EventArgs e)
        {
            LoadFoodListByCategoryID((cbCategory.SelectedItem as Category).ID);
            if (lsvBill.Tag != null)
                ShowBill((lsvBill.Tag as Table).ID);
            LoadTable();
        }

        void f_InsertFood(object sender, EventArgs e)
        {
            LoadFoodListByCategoryID((cbCategory.SelectedItem as Category).ID);
            if (lsvBill.Tag != null)
                ShowBill((lsvBill.Tag as Table).ID);
        }

        private void cbCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            int id = 0;

            ComboBox cb = sender as ComboBox;

            if (cb.SelectedItem == null)
                return;

            Category selected = cb.SelectedItem as Category;
            id = selected.ID;

            LoadFoodListByCategoryID(id);
        }

        public void UpdateTableStatus(int tableID, string status)
        {
            string query = "UPDATE TableFood SET Status = @status WHERE ID = @tableID";
            DataProvider.Instance.ExecuteNonQuery(query, new object[] { status, tableID });
        }

        private void btnAddFood_Click(object sender, EventArgs e)
        {
            // Kiểm tra xem lsvBill.Tag có null không
            if (lsvBill.Tag == null)
            {
                MessageBox.Show("Lỗi: Không có thông tin bàn.");
                return;
            }

            Table table = lsvBill.Tag as Table;
            if (table == null)
            {
                MessageBox.Show("Lỗi: Dữ liệu bàn không hợp lệ.");
                return;
            }

            // Kiểm tra món ăn được chọn trong cbFood
            if (cbFood.SelectedItem == null)
            {
                MessageBox.Show("Hãy chọn món ăn.");
                return;
            }
            Food selectedFood = cbFood.SelectedItem as Food;
            int foodID = selectedFood.ID;
            int count = (int)nmFoodCount.Value;

            // Lấy ID hóa đơn chưa thanh toán của bàn
            int idBill = BillDAO.Instance.GetUncheckBillIDByTableID(table.ID);

            // Nếu không có hóa đơn, tạo hóa đơn mới
            if (idBill == -1)
            {
                BillDAO.Instance.InsertBill(table.ID);
                idBill = BillDAO.Instance.GetMaxIDBill(); // Lấy ID hóa đơn mới tạo
            }

            // Thêm món vào hóa đơn
            BillInfoDAO.Instance.InsertBillInfo(idBill, foodID, count);

            // Cập nhật trạng thái bàn sau khi thêm món
            TableDAO.Instance.UpdateTableStatus(table.ID, "Có người ngồi");

            // Cập nhật lại danh sách món ăn trong hóa đơn
            ShowBill(table.ID);

            // Làm mới danh sách bàn
            LoadTable();
        }

        private void btnCheckOut_Click(object sender, EventArgs e)
        {
            Table table = lsvBill.Tag as Table;

            if (table == null)
            {
                MessageBox.Show("Hãy chọn bàn để thanh toán.");
                return;
            }

            int idBill = BillDAO.Instance.GetUncheckBillIDByTableID(table.ID);
            int discount = (int)nmDisCount.Value;

            CultureInfo culture = new CultureInfo("vi-VN");
            double totalPrice = double.Parse(txbTotalPrice.Text, NumberStyles.Currency, culture);

            double finalTotalPrice = totalPrice - (totalPrice / 100) * discount;

            // Kiểm tra nếu có hóa đơn chưa thanh toán
            if (idBill != -1)
            {
                // Hiển thị thông báo cho người dùng xác nhận thanh toán
                if (MessageBox.Show(string.Format("Bạn có chắc thanh toán hóa đơn cho bàn {0}\nTổng tiền - (Tổng tiền / 100) x Giảm giá\n=> {1} - ({1} / 100) x {2} = {3}", table.Name, totalPrice, discount, finalTotalPrice), "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
                {
                    // Gọi phương thức thanh toán, thực hiện cập nhật hóa đơn và trạng thái bàn
                    BillDAO.Instance.CheckOut(idBill, discount, (float)finalTotalPrice);

                    // Hiển thị lại thông tin hóa đơn
                    ShowBill(table.ID);

                    // Cập nhật lại trạng thái của các bàn
                    LoadTable();
                }
            }
            else
            {
                MessageBox.Show("Không có hóa đơn để thanh toán.");
            }
            // Cập nhật trạng thái bàn trong SQL
            TableDAO.Instance.UpdateTableStatus(table.ID, "Trống");

            // Sau khi cập nhật xong, load lại bàn
            LoadTable();
        }

        private void btnSwitchTable_Click(object sender, EventArgs e)
        {
            // Lấy ID của bàn hiện tại
            int id1 = (lsvBill.Tag as Table).ID;

            // Lấy ID của bàn mục tiêu
            int id2 = (cbSwitchTable.SelectedItem as Table).ID;

            // Hiển thị thông báo xác nhận
            if (MessageBox.Show(string.Format("Bạn có thật sự muốn chuyển bàn {0} qua bàn {1}?",
                                              (lsvBill.Tag as Table).Name,
                                              (cbSwitchTable.SelectedItem as Table).Name),
                                "Thông báo", MessageBoxButtons.OKCancel) == System.Windows.Forms.DialogResult.OK)
            {
                // Gọi phương thức chuyển bàn
                TableDAO.Instance.SwitchTable(id1, id2);

                // Làm mới giao diện bàn
                LoadTable();
            }
        }


        #endregion

        private void flpTable_Paint(object sender, PaintEventArgs e)
        {

        }

        private void lsvBill_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}

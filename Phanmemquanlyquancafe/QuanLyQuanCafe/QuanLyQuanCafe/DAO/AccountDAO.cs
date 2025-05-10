using QuanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Security.Cryptography;
using System.Text;

namespace QuanLyQuanCafe.DAO
{
    public class AccountDAO
    {
        private static AccountDAO instance;

        public static AccountDAO Instance
        {
            get { if (instance == null) instance = new AccountDAO(); return instance; }
            private set { instance = value; }
        }

        private AccountDAO() { }

        private string EncryptMD5(string input)
        {
            byte[] temp = Encoding.ASCII.GetBytes(input);
            byte[] hashData = new MD5CryptoServiceProvider().ComputeHash(temp);
            return BitConverter.ToString(hashData).Replace("-", "").ToLower();
        }

        public bool Login(string userName, string passWord)
        {
            string hashPass = EncryptMD5(passWord);
            string query = "USP_Login @userName , @passWord";

            DataTable result = DataProvider.Instance.ExecuteQuery(query, new object[] { userName, hashPass });
            return result.Rows.Count > 0;
        }

        public bool UpdateAccount(string userName, string displayName, string pass, string newPass)
        {
            string hashPass = EncryptMD5(pass);
            string hashNewPass = EncryptMD5(newPass);

            int result = DataProvider.Instance.ExecuteNonQuery(
                "exec USP_UpdateAccount @userName , @displayName , @password , @newPassword",
                new object[] { userName, displayName, hashPass, hashNewPass });

            return result > 0;
        }

        public DataTable GetListAccount()
        {
            return DataProvider.Instance.ExecuteQuery("SELECT UserName, DisplayName, Type FROM dbo.Account");
        }

        public Account GetAccountByUserName(string userName)
        {
            string query = "SELECT * FROM Account WHERE UserName = @userName";
            DataTable data = DataProvider.Instance.ExecuteQuery(query, new object[] { userName });

            foreach (DataRow item in data.Rows)
            {
                return new Account(item);
            }

            return null;
        }

        public bool InsertAccount(string name, string displayName, int type)
        {
            string defaultPassword = EncryptMD5("123"); // or any default password
            string query = "INSERT INTO dbo.Account (UserName, DisplayName, Type, Password) VALUES (@name, @displayName, @type, @password)";
            int result = DataProvider.Instance.ExecuteNonQuery(query, new object[] { name, displayName, type, defaultPassword });

            return result > 0;
        }

        public bool UpdateAccount(string name, string displayName, int type)
        {
            string query = "UPDATE dbo.Account SET DisplayName = @displayName, Type = @type WHERE UserName = @userName";
            int result = DataProvider.Instance.ExecuteNonQuery(query, new object[] { displayName, type, name });

            return result > 0;
        }

        public bool DeleteAccount(string name)
        {
            string query = "DELETE FROM Account WHERE UserName = @userName";
            int result = DataProvider.Instance.ExecuteNonQuery(query, new object[] { name });

            return result > 0;
        }

        public bool ResetPassword(string name)
        {
            string defaultPassword = EncryptMD5("123");
            string query = "UPDATE Account SET Password = @password WHERE UserName = @userName";
            int result = DataProvider.Instance.ExecuteNonQuery(query, new object[] { defaultPassword, name });

            return result > 0;
        }
    }
}
